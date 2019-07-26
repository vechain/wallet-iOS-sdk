//
//  WalletUtils.m
//
//  Created by VeChain on 2018/8/12.
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



#import "WalletUtils.h"
#import "WalletDAppHandle.h"
#import "WalletTools.h"
#import "WalletDAppHeader.h"
#import "Account.h"
#import "WalletGenesisBlockInfoApi.h"
#import "WalletBestBlockInfoApi.h"
#import "WalletDAppHandle+transfer.h"
#import "AFNetworking.h"
#import "WalletSendTranfer.h"

@interface WalletUtils()

@property (nonatomic, strong)WalletDAppHandle *dAppHandle;

@end

@implementation WalletUtils


+ (void)createWalletWithPassword:(NSString *)password
                       callback:(void(^)(WalletAccountModel *accountModel,NSError *error))callback
{
    NSString *domain = @"com.wallet.ErrorDomain";
    NSString *desc = @"password is invaild";
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
    
    NSError *error = [NSError errorWithDomain:domain
                                         code:-101
                                     userInfo:userInfo];
    
    if (password.length == 0 || password == nil) {
        
        if (callback) {
            callback(nil,error);
        }
        return;
    }
    
    __block Account *account = [Account randomMnemonicAccount];
    
    [account encryptSecretStorageJSON:password callback:^(NSString *json) {
        
         account.keystore = json;
        if (json.length == 0) {
            NSString *domain = @"com.wallet.ErrorDomain";
            NSString *desc = @"Failed to generate keystore";
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
            
            NSError *error = [NSError errorWithDomain:domain
                                                 code:-102
                                             userInfo:userInfo];
            if (callback) {
                callback(nil,error);
            }
            return ;
        }else{
            if (callback) {
                WalletAccountModel *accountModel = [[WalletAccountModel alloc]init];
                accountModel.keystore = json;
                accountModel.privatekey = [SecureData dataToHexString:account.privateKey];
                accountModel.address = account.address.checksumAddress;
                accountModel.words = [account.mnemonicPhrase componentsSeparatedByString:@" "];
                
                callback(accountModel,nil);
            }
        }
    }];
}

// MnemonicWords count 12,15,18,21,24
+ (void)createWalletWithMnemonicWords:(NSArray<NSString *> *)mnemonicWords
                            password:(NSString *)password
                            callback:(void(^)(WalletAccountModel *account,NSError *error))callback
{
    
    NSString *domain = @"com.wallet.ErrorDomain";
    NSString *desc = @"mnemonicWords is invaild";
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
    
    NSError *error = [NSError errorWithDomain:domain
                                         code:-101
                                     userInfo:userInfo];
    
    
    if (![WalletUtils  isValidMnemonicWords:mnemonicWords]) {
        
        NSLog(@"mnemonicWords is invaild");
        if (callback) {
            callback(nil, error);
        }
        return;
    }
    
    if (password.length == 0 || password == nil) {
        NSLog(@"password is invaild");
        if (callback) {
            callback(nil, error);
        }
        return;
    }
    
    NSMutableArray *trimeList = [NSMutableArray array];
    for (NSString * word in mnemonicWords) {
        if (word.length == 0) {
            if (callback) {
                callback(nil, error);
            }
            return;
        }else{
            NSString *trimeWord = [word stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [trimeList addObject:trimeWord];
        }
    }
    
    __block Account *account = [Account accountWithMnemonicPhrase:[trimeList componentsJoinedByString:@" "]];
    
    if (!account) {
        if (callback) {

            callback(nil, error);
        }
        return;
    }
    
    [account encryptSecretStorageJSON:password callback:^(NSString *json) {
        
        account.keystore = json;
        if (json.length == 0) {
            if (callback) {
                callback(nil, error);
            }
            
        }else{
            if (callback) {
                
                WalletAccountModel *accountModel = [[WalletAccountModel alloc]init];
                accountModel.keystore = json;
                accountModel.privatekey = [SecureData dataToHexString:account.privateKey];
                accountModel.address = account.address.checksumAddress;
                accountModel.words = [account.mnemonicPhrase componentsSeparatedByString:@" "];
                
                callback(accountModel, nil);
            }
        }
    }];
}

+ (BOOL)isValidMnemonicWords:(NSArray<NSString *> *)mnemonicWords;
{
    if (mnemonicWords.count < 12 || mnemonicWords.count > 24) {
        return NO;
    }
    
    NSMutableArray *trimeList = [NSMutableArray array];
    for (NSString * word in mnemonicWords) {
        if (word.length == 0) {
            return NO;
        }else{
            NSString *trimeWord = [word stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [trimeList addObject:trimeWord];
        }
    }
    return [Account isValidMnemonicPhrase:[mnemonicWords componentsJoinedByString:@" "]];
}

+ (void)decryptKeystore:(NSString*)keystoreJson
               password:(NSString*)password
               callback:(void(^)(NSString *privateKey,NSError *error))callback
{
    if (keystoreJson == nil
        || password == nil
        || keystoreJson.length == 0
        || password.length == 0 ) {
        if (callback) {
            callback(nil, nil);
        }
        return;
    }
    [Account decryptSecretStorageJSON:keystoreJson password:password callback:^(Account *account, NSError *decryptError) {
        
        if (decryptError == nil) {
            
            if (callback) {
                NSString *privateKey = [SecureData dataToHexString:account.privateKey];
                callback(privateKey,nil);
            }
        }else{
            if (callback) {
                callback(nil, decryptError);
            }
        }
    }];
}

+ (void)encryptPrivateKeyWithPassword:(NSString*)password
                           privateKey:(NSString *)privateKey
                             callback:(void (^)(NSString *keystoreJson))callback
{
    if (![WalletTools checkHEXStr:privateKey]) {
        if (callback) {
            callback(nil);
        }
        return;
    }
    
    if (privateKey.length != 66) {
        if (callback) {
            callback(nil);
        }
        return;
    }
    if ( password == nil || privateKey == nil || privateKey.length == 0 || password.length == 0 ) {
        if (callback) {
            callback(nil);
        }
        return;
    }
    NSData *dataPrivate = [SecureData hexStringToData:privateKey];
    Account *ethAccount = [Account accountWithPrivateKey:dataPrivate];
    [ethAccount encryptSecretStorageJSON:password
                                callback:^(NSString *json)
     {
         if (json.length > 0) {
             if (callback) {
                 callback(json);
             }
         }else{
             if (callback) {
                 callback(nil);
             }
         }
     }];
}


+ (NSString *)recoverAddressFromMessage:(NSData*)message
                signatureData:(NSData *)signatureData
{
    if (message == nil || signatureData == nil) {
        return @"";
    }
    SecureData *digest = [SecureData BLAKE2B:message];
    Signature *signature = [Signature signatureWithData:signatureData];
    return [Account verifyMessage:digest.data signature:signature].checksumAddress;
}



+ (void)signAndSendTransferWithParameter:(WalletTransactionParameter *)parameter
                            keystore:(NSString*)keystoreJson
                            password:(NSString *)password
                            callback:(void(^)(NSString *txId))callback
{
    // Check keystore format
    if (![WalletTools checkKeystore:keystoreJson]) {
        
        if (callback) {
            callback(nil);
        }
        return;
    }
    
    if (parameter == nil
        || keystoreJson == nil
        || password == nil
        || keystoreJson.length == 0
        || password.length == 0) {
        
        if (callback) {
            callback(nil);
        }
        return;
    }
    
    [WalletUtils signTransfer:parameter keystore:keystoreJson password:password isSend:YES  completionHandler:callback];
    
}

+ (void)signWithParameter:(WalletTransactionParameter *)parameter
                 keystore:(NSString*)keystoreJson
                 password:(NSString*)password
                 callback:(void(^)(NSString *raw))callback
{
    // Check keystore format
    if (![WalletTools checkKeystore:keystoreJson]) {
        
        if (callback) {
            callback(nil);
        }
        return;
    }
    
   if (parameter == nil || keystoreJson == nil || password == nil || keystoreJson.length == 0|| password.length == 0) {
        if (callback) {
            callback(nil);
        }
        return;
    }
    
    [WalletUtils signTransfer:parameter keystore:keystoreJson password:password isSend:NO completionHandler:callback];
    
}

+ (void)signWithMessage:(NSData *)message
               keystore:(NSString*)keystoreJson
               password:(NSString*)password
               callback:(void (^)(NSData *signatureData))callback
{
    if ( ![message isKindOfClass:[NSData class]]) {
        
        if (callback) {
            callback(nil);
        }
        return;
    }
    
    if (message == nil
        || keystoreJson == nil
        || password == nil
        || keystoreJson.length == 0
        || password.length == 0) {
       
        if (callback) {
            callback(nil);
        }
        return;
    }
    [Account decryptSecretStorageJSON:keystoreJson
                             password:password
                             callback:^(Account *account, NSError *error)
     {
         // Signature trading
         if (error == nil) {
             SecureData *data = [SecureData BLAKE2B:message];
             Signature *signature = [account signDigest:data.data];
             if (callback) {
                 SecureData *vData = [[SecureData alloc]init];
                 [vData appendByte:signature.v];
                 
                 NSString *s = [SecureData dataToHexString:signature.s];
                 NSString *r = [SecureData dataToHexString:signature.r];
                 
                 NSString *hashStr = [NSString stringWithFormat:@"0x%@%@%@",
                                      [r substringFromIndex:2],
                                      [s substringFromIndex:2],
                                      [vData.hexString substringFromIndex:2]];
                 
                 //Signature fails if v is 2 or 3
                 if (signature.v == 2
                     || signature.v == 3) {
                     
                     if (callback) {
                         callback(nil);
                     }
                 }else{
                     if (callback) {
                         callback([SecureData hexStringToData:hashStr]);
                     }
                 }
             }
         }else{
             if (callback) {
                 callback(nil);
             }
         }
     }];
}

+ (BOOL)isValidKeystore:(NSString *)keystoreJson
{
   return [WalletTools checkKeystore:keystoreJson];
}

+ (NSString *)getChecksumAddress:(NSString *)address
{
    if (![WalletTools checkHEXStr:address] || address.length != 42) {
        return @"";
    }
    return [WalletTools checksumAddress:address];
}

+ (void)setNodeUrl:(NSString *)nodelUrl
{
    if (nodelUrl.length == 0) {
        return;
    }
    //Turn on network monitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [WalletUserDefaultManager setBlockUrl:nodelUrl];
}

+ (NSString *)getNodeUrl
{
    return [WalletUserDefaultManager getBlockUrl];
}


+ (void)modifyKeystore:(NSString *)keystoreJson
           newPassword:(NSString *)newPassword
           oldPassword:(NSString *)oldPassword
              callback:(void (^)(NSString *newKeystore))callback
{
    if (keystoreJson == nil
        || newPassword == nil
        || oldPassword == nil
        || keystoreJson.length == 0
        || newPassword.length == 0
        || oldPassword.length == 0) {
        
        if (callback) {
            callback(nil);
        }
        return ;
    }
    
    [WalletUtils decryptKeystore:keystoreJson password:oldPassword callback:^(NSString *privatekey, NSError *error) {
        
        if (error) {
            if (callback) {
                callback(nil);
            }
            
            return ;
        }else{
            [WalletUtils encryptPrivateKeyWithPassword:newPassword privateKey:privatekey callback:^(NSString *keystoreJson) {
                
                if (callback) {
                    callback(keystoreJson);
                }
            }];
        }
    }];
}

+ (void)verifyKeystore:(NSString *)keystore
                      password:(NSString *)password
                      callback:(void (^)(BOOL result))callback
{
    if (keystore == nil
        || password == nil
        || keystore.length == 0
        || password.length == 0 ) {
        
        if (callback) {
            callback(nil);
        }
        return ;
    }
    [WalletUtils decryptKeystore:keystore password:password callback:^(NSString *privatekey, NSError *error){
        
        if (privatekey) {
            callback(YES);
        }else{
            callback(NO);
        }
    }];
}

+ (void)getChainTag:(void (^)(NSString *chainTag))callback
{
    WalletGenesisBlockInfoApi *genesisBlock = [WalletGenesisBlockInfoApi new];
    [genesisBlock loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        WalletBlockInfoModel *genesisblockModel = finishApi.resultModel;
        NSString *blockID = genesisblockModel.id;
        NSString *chainTag = [NSString stringWithFormat:@"0x%@", [blockID substringFromIndex:blockID.length-2]];
        
        if (callback) {
            callback(chainTag);
        }
        
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        if (callback) {
            callback(nil);
        }
    }];
}

+ (void)getBlockRef:(void (^)(NSString *blockRef))callback
{
    // Get the latest block ID first 8bytes as blockRef
    WalletBestBlockInfoApi *bestBlockApi = [[WalletBestBlockInfoApi alloc] init];
    [bestBlockApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        WalletBlockInfoModel *blockModel = finishApi.resultModel;
        
        NSString *blockRef = [[blockModel.id substringFromIndex:2] substringToIndex:16];
        callback ([@"0x" stringByAppendingString:blockRef]);
        
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        callback(nil);
    }];
}

+ (void)signTransfer:(WalletTransactionParameter *)paramModel keystore:(NSString *)keystore password:(NSString *)password isSend:(BOOL)isSend completionHandler:(void(^)(NSString *txId))completionHandler
{
    if (isSend) {
        [WalletSendTranfer signAndSendTransfer:paramModel keystore:keystore password:password callback:completionHandler];
    }else{
        [WalletSendTranfer signTransfer:paramModel keystore:keystore password:password  callback:completionHandler];
    }
}

+ (NSString *)getAddressWithKeystore:(NSString *)keystore
{
    if (keystore.length == 0 || keystore == nil) {
        return @"";
    }
    NSDictionary *dictKeystore = [NSJSONSerialization dictionaryWithJsonString:keystore];
    NSString *address = dictKeystore[@"address"];
    
    //Check 0x at the beginning
    if (![address hasPrefix:@"0x"]) {
        if (address.length > 0) {
            address = [@"0x" stringByAppendingString:address];
            return [WalletUtils getChecksumAddress:address];
            
        } else {
            return @"";
        }
    }else{
        return [WalletUtils getChecksumAddress:address];
    }
}

+ (NSString *)addSignerToCertMessage:(NSString *)signer message:(NSString *)message
{
    
    NSMutableDictionary *newMessage = [NSMutableDictionary dictionaryWithDictionary:[NSJSONSerialization dictionaryWithJsonString:message]];
    [newMessage setValueIfNotNil:signer forKey:@"signer"];
    
   return  [WalletTools packageCertParam:newMessage];
}


@end
