//
//  WalletTransactionParameter.m
//  Wallet
//
//  Created by VeChain on 2019/4/7.
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



#import "WalletTransactionParameter.h"
#import "YYModel.h"
#import "WalletHeader.h"

@implementation WalletTransactionParameter

- (void)checkParameter:(void(^)(NSString *error,bool result))callback
{
    NSString *errorMsg = @"";
    for (ClauseModel * clauseModel in self.clauses) {
        
        NSString *to = clauseModel.to;
        if (![self checkTo:&to errorMsg:&errorMsg]) {
            if (callback) {
                callback(errorMsg,NO);
            }
            return ;
        }
        clauseModel.to = to;
        
        NSString *value = clauseModel.value;
        if (![self checkValue:&value errorMsg:&errorMsg]) {
            if (callback) {
                callback(errorMsg,NO);
            }
            return ;
        }
        clauseModel.value = value;
        
        NSString *data = clauseModel.data;
        if (![self checkData:&data errorMsg:&errorMsg]) {
            if (callback) {
                callback(errorMsg,NO);
            }
            return ;
        }
        clauseModel.data = data;
        
    }
    
    NSString *gas = self.gas;
    if (![self checkGas:&gas errorMsg:&errorMsg]) {
        if (callback) {
            callback(errorMsg,NO);
        }
        return ;
    }
    self.gas = gas;
    
    
    if (![self checkChainTag:self.chainTag errorMsg:&errorMsg]) {
        if (callback) {
            callback(errorMsg,NO);
        }
        return ;
    }
    
    if (![self checkBlockRef:self.blockRef errorMsg:&errorMsg]) {
        if (callback) {
            callback(errorMsg,NO);
        }
        return ;
    }
    
    if (![self checkNoce:self.nonce errorMsg:&errorMsg]) {
        if (callback) {
            callback(errorMsg,NO);
        }
        return ;
    }
    
    NSString *gasPriceCoef = self.gasPriceCoef;
    if (![self checkGasPriceCoef:&(gasPriceCoef) errorMsg:&errorMsg]) {
        if (callback) {
            callback(errorMsg,NO);
        }
        return ;
    }
    
    self.gasPriceCoef = gasPriceCoef;
    
    NSString *expiration = self.expiration;
    
    if (![self checkExpiration:&expiration errorMsg:&errorMsg]) {
        if (callback) {
            callback(errorMsg,NO);
        }
        return ;
    }
    self.expiration = expiration;
    
    
    if (![self checkDependsOn:self.dependsOn errorMsg:&errorMsg]) {
        if (callback) {
            callback(errorMsg,NO);
        }
        return ;
    }
    
    callback(@"",YES);
    
}

- (BOOL)checkDependsOn:(NSString *)dependsOn errorMsg:(NSString **)errorMsg
{
    if ([WalletTools isEmpty:dependsOn]) {
        
        return YES;
    }
    
    if ([WalletTools checkHEXStr:dependsOn]) {
        return YES;
    }else
    {
        *errorMsg = @"dependsOn should be hex string";
        return NO;
    }
    
}

- (BOOL)checkChainTag:(NSString *)chainTag errorMsg:(NSString **)errorMsg
{
    if (chainTag.length != 4) {
        *errorMsg = @"chainTag is not the right length";
        
        return NO;
    }
    
    if (![WalletTools checkHEXStr:chainTag] ) {
        *errorMsg = @"chainTag should be hex string";
        
        return NO;
    }
    return YES;
}

- (BOOL)checkBlockRef:(NSString *)blockRef errorMsg:(NSString **)errorMsg
{
    if (blockRef.length != 18) {
        *errorMsg = @"blockRef is not the right length";
        
        return NO;
    }
    
    if (![WalletTools checkHEXStr:blockRef] ) {
        *errorMsg = @"blockRef should be hex string";
        
        return NO;
    }
    return YES;
}

- (BOOL)checkNoce:(NSString *)nonce errorMsg:(NSString **)errorMsg
{
    if (nonce.length != 18) {
        *errorMsg = @"nonce is not the right length";
        
        return NO;
    }
    if (![WalletTools checkHEXStr:nonce] ) {
        *errorMsg = @"nonce should be hex string";
        
        return NO;
    }
    return YES;
}

- (BOOL)checkGasPriceCoef:(NSString **)gasPriceCoef errorMsg:(NSString **)errorMsg
{
    if ([WalletTools isEmpty:*gasPriceCoef]) {
        *gasPriceCoef = @"0";
        return YES;
    }
    
    *gasPriceCoef = [NSString stringWithFormat:@"%@",*gasPriceCoef];
    
    if ([WalletTools checkDecimalStr:*gasPriceCoef]) {
        
    }else if ([WalletTools checkHEXStr:*gasPriceCoef])
    {
        *gasPriceCoef = [BigNumber bigNumberWithHexString:*gasPriceCoef].decimalString;
    }else{
        *errorMsg = @"gasPriceCoef should be Decima string or hex string";
        return NO;
    }
    
    NSInteger intGasPriceCoef = (*gasPriceCoef).integerValue;
    if (intGasPriceCoef >= 0 && intGasPriceCoef <= 255) {
        return YES;
    }else{
        *errorMsg = @"gasPriceCoef is an integer type from 0 to 255";
        
        return NO;
    }
}

- (BOOL)checkExpiration:(NSString **)expiration errorMsg:(NSString **)errorMsg
{
    *expiration = [NSString stringWithFormat:@"%@",*expiration];
    
    if ([WalletTools isEmpty:*expiration]) {
        *expiration = @"720";
        return YES;
    }
    
    if (![WalletTools checkDecimalStr:(*expiration)]) {
        *errorMsg = @"expiration should be decimal string";
        
        return NO;
    }
    return YES;
}


- (BOOL)checkTo:(NSString **)to errorMsg:(NSString **)errorMsg
{
    if ([WalletTools isEmpty:*to]) {
        *to = @"";
        return YES;
    }
    
    if ([*to isKindOfClass:[NSString class]]) {
        
        if (![WalletTools errorAddressAlert:*to]) { //check address
            *errorMsg = @"to is invild";
            return NO;
        }
    }else{
        *errorMsg = @"to should be NSString";
        return NO;
    }
    return YES;
}

- (BOOL)checkValue:(NSString **)value errorMsg:(NSString **)errorMsg
{
    if ([WalletTools isEmpty:*value]) {
        *value = @"0";
        return YES;
    }
    // value maybe string or number
    
    if (![*value isKindOfClass:[NSString class]]
        && ![*value isKindOfClass:[NSNumber class]]) {
        
        *errorMsg = @"value should be NSString or NSNumber";
        return NO;
        
    }else if ([self checkNumberOriginBool:*value])
    {
        *errorMsg = @"value should be NSString or NSNumber";
        return NO;
        
    }else{
        
        return [self rightValue:&*value errorMsg:&*errorMsg];
    }
    
    return YES;
}

- (BOOL)rightValue:(NSString **)value errorMsg:(NSString **)errorMsg
{
    if ([(*value) isEqualToString:@"0x"]) { // 0x
        *value = @"0";
        return YES;
    }
    
    if ([WalletTools checkDecimalStr:*value]) {//Is a decimal
        return YES;
        
    }else if ([WalletTools checkHEXStr:*value]){// Hex
        *value = [BigNumber bigNumberWithHexString:*value].decimalString;
        return YES;
        
    }else{ //Neither decimal nor hexadecimal
        *errorMsg = @"value should be NSString or NSNumber";
        return NO;
    }
}

- (BOOL)checkData:(NSString **)data errorMsg:(NSString **)errorMsg
{
    if ([WalletTools isEmpty:*data]) {
        *data = @"";
        return YES;
    }
    
    if (![*data isKindOfClass:[NSString class]]) {
        
        *errorMsg = @"data should be hex string";
        return NO;
        
    }else if ([WalletTools checkHEXStr:*data]){
        
        return YES;
        
    }else{
        
        *errorMsg = @"data should be hex string";
        return NO;
    }
    
    return YES;
}

- (BOOL)checkGas:(NSString **)gas errorMsg:(NSString **)errorMsg
{
    if ([WalletTools isEmpty:*gas]) {
       
        return YES;
    }
    
    // gas maybe string or number
    if (![*gas isKindOfClass:[NSString class]]
        && ![*gas isKindOfClass:[NSNumber class]]) {
        
        *errorMsg = @"gas should be NSString or NSNumber";
        return NO;
    
    }else if ([self checkNumberOriginBool:*gas])
    {
        *errorMsg = @"gas should be NSString or NSNumber";
        return NO;
    
    }else{
        *gas = [NSString stringWithFormat:@"%@",*gas];
        
        if ([WalletTools checkDecimalStr:*gas]) {
            return YES ;
        }else if ([WalletTools checkHEXStr:*gas])
        {
            *gas = [BigNumber bigNumberWithHexString:*gas].decimalString;
            return YES;
        }else{
            *errorMsg = @"gas should be decimal string or hex string";
            return NO;
        }
    }
    return YES;
}


- (BOOL)checkNumberOriginBool:(id)data {
    
    if ([data isKindOfClass:[NSNumber class]]) {
        const char * pObjCType = [((NSNumber*)data) objCType];
        
        if (strcmp(pObjCType, @encode(_Bool)) == 0
            || strcmp([data objCType], @encode(char)) == 0) {
            return YES;
        }
        return NO;
    }
    return NO;
}

- (void)setGas:(NSString *)gas
{
    _gas = gas;
}

- (void)setGasPriceCoef:(NSString * _Nonnull)gasPriceCoef
{
    _gasPriceCoef = gasPriceCoef;
}

- (void)setExpiration:(NSString * _Nonnull)expiration
{
    _expiration = expiration;
}

- (void)setChainTag:(NSString * _Nonnull)chainTag
{
    _chainTag = chainTag;
}

- (void)setBlockRef:(NSString * _Nonnull)blockRef
{
    _blockRef = blockRef;
}

- (void)setNonce:(NSString * _Nonnull)nonce
{
    _nonce = nonce;
}

- (void)setClauses:(NSArray * _Nonnull)clauses
{
    _clauses = clauses;
}

- (void)setDependsOn:(NSString * _Nonnull)dependsOn
{
    _dependsOn = dependsOn;
}

- (void)setReserveds:(NSArray<NSData *> * _Nonnull)reserveds
{
    _reserveds = reserveds;
}

+ (WalletTransactionParameter *)createTransactionParameter:(void(^)(TransactionParameterBuiler *builder))callback checkParams:(void(^)(NSString *errorMsg))checkParamsCallback
{
    TransactionParameterBuiler *builder = [[TransactionParameterBuiler alloc]init];

    callback(builder);
    
    WalletTransactionParameter *transactionModel = [builder build];
    __block BOOL hasError = NO;
    [transactionModel checkParameter:^(NSString *error, bool result) {
        
        checkParamsCallback(error);
        if (!result) {
            hasError = YES;
        }
    }];
    
    return hasError ? nil : transactionModel;
}

@end

@implementation ClauseModel

@end


@implementation TransactionParameterBuiler

- (WalletTransactionParameter *)build
 {
     WalletTransactionParameter *transactionModel = [[WalletTransactionParameter alloc] init];
     
     transactionModel.chainTag          = self.chainTag;
     transactionModel.blockRef          = self.blockRef;
     transactionModel.nonce             = self.nonce;
     transactionModel.clauses           = self.clauses;
     transactionModel.gas               = self.gas;
     transactionModel.expiration        = self.expiration;
     transactionModel.gasPriceCoef      = self.gasPriceCoef;
     
     // Not mandatory
     transactionModel.dependsOn = self.dependsOn;
     transactionModel.reserveds = self.reserveds;
     
     return transactionModel;
 }

@end
