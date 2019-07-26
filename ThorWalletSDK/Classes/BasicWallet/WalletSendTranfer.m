//
//  WalletSendTranfer.m
//  Wallet
//
//  Copyright © 2019 VeChain. All rights reserved.
//

// This code is distributed under the terms and conditions of the MIT license.

/**
 Copyright (c) 2019 VeChain <support@vechain.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 **/

#import "WalletSendTranfer.h"
#import "Transaction.h"
#import "WalletTransactionParameter.h"
#import "SecureData.h"
#import "WalletTools.h"
#import "Account.h"
#import "WalletTransactionApi.h"
#import "WalletDAppGasCalculateHandle.h"

@implementation WalletSendTranfer


//Initiate a transaction

+ (void)signAndSendTransfer:(WalletTransactionParameter *)paramModel
                    keystore:(NSString *)keystore
                    password:(NSString *)password
                    callback:(void(^)(NSString *txId))callback
{
    [self transfer:paramModel keystore:keystore password:password isSend:YES callback:callback];
}

+ (void)signTransfer:(WalletTransactionParameter *)paramModel
            keystore:(NSString *)keystore
            password:(NSString *)password
            callback:(void(^)(NSString *txId))callback
{
    [self transfer:paramModel keystore:keystore password:password isSend:NO callback:callback];
}


+ (void)transfer:(WalletTransactionParameter *)paramModel
        keystore:(NSString *)keystore
        password:(NSString *)password
          isSend:(BOOL)isSend
        callback:(void(^)(NSString *txId))callback
{
    Transaction *transaction = [[Transaction alloc] init];

    NSString *decimalNoce = [BigNumber bigNumberWithHexString:paramModel.nonce].decimalString;
    transaction.nonce = decimalNoce.integerValue;

    transaction.Expiration = paramModel.expiration.integerValue;
    transaction.gasPrice  = [BigNumber bigNumberWithInteger:paramModel.gasPriceCoef.integerValue];
    
    if (paramModel.dependsOn.length == 0 || paramModel.dependsOn == nil) {
            transaction.dependsOn = [NSData data];
    }else{
        transaction.dependsOn = [SecureData hexStringToData:paramModel.dependsOn];
    }

    transaction.ChainTag = [BigNumber bigNumberWithHexString:paramModel.chainTag];

    transaction.BlockRef = [BigNumber bigNumberWithHexString:paramModel.blockRef];

    [self packageClausesData:transaction paramModel:paramModel];

    if (paramModel.gas == nil || paramModel.gas.integerValue == 0) {
        
        NSString *strClause = [paramModel.clauses yy_modelToJSONString];
        NSArray *clauseList = (NSArray *)[NSJSONSerialization dictionaryWithJsonString:strClause];
        [WalletDAppGasCalculateHandle simulateGas:clauseList
                                           from:[WalletUtils getAddressWithKeystore:keystore]
                                          block:^(NSString * _Nonnull gas)
         {
             transaction.gasLimit = [BigNumber bigNumberWithInteger:gas.integerValue];
             [self sign:transaction paramModel:paramModel keystore:keystore password:password callback:callback isSend:isSend];
        }];
        
    }else{
        transaction.gasLimit = [BigNumber bigNumberWithInteger:paramModel.gas.integerValue];
        [self sign:transaction paramModel:paramModel keystore:keystore password:password callback:callback isSend:isSend];
    }    
}

//Organize the clause data
+ (void)packageClausesData:(Transaction *)transaction
                paramModel:(WalletTransactionParameter *)paramModel
{
    NSMutableArray *clauseList = [NSMutableArray array];
    
    for (ClauseModel *model in paramModel.clauses) {
        
        NSMutableArray *clauseSingle = [NSMutableArray array];
        NSData *to = nil;
        NSData *value = nil;
        NSData *data = nil;
        
        BigNumber *subValue;
        NSDecimalNumber *amountF = nil;
        if ([WalletTools checkDecimalStr:model.value]) {
            subValue = [BigNumber bigNumberWithDecimalString:model.value];
            amountF = [NSDecimalNumber decimalNumberWithString:model.value];
        }else{
            subValue = [BigNumber bigNumberWithHexString:model.value];
            amountF = [NSDecimalNumber decimalNumberWithString:subValue.decimalString];
        }
        
        if (amountF.doubleValue == 0.0
            && [subValue lessThanEqualTo:[BigNumber constantZero]]) {
            value = [NSData data];
        } else {
            value = subValue.data;
        }
        
        if (model.to.length ==  0) {
            to = [NSData data];
        }else{
            to = [SecureData hexStringToData:model.to];
        }
        
        if (model.data.length == 0) {
            data = [NSData data];
            
        }else{
            data = [SecureData hexStringToData:model.data];
        }
        [clauseSingle addObject:to];
        [clauseSingle addObject:value];
        [clauseSingle addObject:data];
        
        [clauseList addObject:clauseSingle];
    }
    
    transaction.Clauses = clauseList;
}

+ (void)sign:(Transaction *)transaction
  paramModel:(WalletTransactionParameter *)paramModel
    keystore:(NSString *)keystore
    password:(NSString *)password
    callback:(void(^)(NSString *txId))callback
      isSend:(BOOL)isSend

{
    // Try user password to decrypt keystore
    @weakify(self)
    [Account decryptSecretStorageJSON:keystore
                             password:password
                             callback:^(Account *account, NSError *NSError)
     {
         @strongify(self)
         if (!account) {
             
             callback(@"");
             NSLog(@"wrong password");
             return;
         }
         
         //Sign with private key
         [account sign:transaction];
         
         //Signature fails if v is 2 or 3
         if (transaction.signature.v == 2
             || transaction.signature.v == 3) {
             
             callback(@"");
             
         }else{
             
             [self account:account transaction:transaction callback:callback isSend:isSend];
         }
     }];
}

+ (void)account:(Account *)account transaction:(Transaction *)transaction callback:(void(^)(NSString *txId))callback
        isSend:(BOOL)isSend
{
    NSString *txId = [transaction txID:account];
    NSString *raw = [SecureData dataToHexString: [transaction serialize]];
    
    if (isSend) {
        [self sendRaw:raw callback:callback txId:txId];
        
    }else{
        callback(raw);
    }
}

+ (void)sendRaw:(NSString *)raw callback:(void(^)(NSString *txId))callback txId:(NSString *)txId
{
    // Send transaction
    WalletTransactionApi *transationApi = [[WalletTransactionApi alloc]initWithRaw:raw];
    [transationApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        
        callback(finishApi.resultDict[@"id"]);
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        callback(txId);
    }];
}

@end
