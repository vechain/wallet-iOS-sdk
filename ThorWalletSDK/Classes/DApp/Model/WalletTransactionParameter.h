//
//  WalletTransactionParameter.h
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


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TransactionParameterBuiler;

@interface WalletTransactionParameter : NSObject


@property (nonatomic, readonly)NSString *gas;       //Set maximum gas allowed for call(deciaml string)

@property (nonatomic, readonly)NSString *chainTag;  //Get the chain tag of the block chain

@property (nonatomic, readonly)NSString *blockRef;  //Get the blockRef

@property (nonatomic, readonly)NSString *nonce;     // 8 bytes of random number,hex string

@property (nonatomic, readonly)NSString *dependsOn;     // txid depends other transfer

@property (nonatomic, readonly)NSString *gasPriceCoef; //Coefficient used to calculate the final gas price

@property (nonatomic, readonly)NSString *expiration;    //  Expiration relative to blockRef
@property (nonatomic, readonly)NSArray *clauses;    //clause list

@property (nonatomic, readonly)NSArray<NSData *> *reserveds;

+ (WalletTransactionParameter *)createTransactionParameter:(void(^)(TransactionParameterBuiler *builder))callback checkParams:(void(^)(NSString *errorMsg))checkParamsCallback;

@end


@interface TransactionParameterBuiler : NSObject

@property (nonatomic, copy)NSString *gas;   //Set maximum gas allowed for call(deciaml string)

@property (nonatomic, copy)NSString *chainTag;  //Get the chain tag of the block chain

@property (nonatomic, copy)NSString *blockRef;  //Get the reference of the block chain

@property (nonatomic, copy)NSString *nonce;// 8 bytes of random number,hex string

@property (nonatomic, copy)NSString *dependsOn; // txid depends other transfer

@property (nonatomic, copy)NSString *gasPriceCoef; //Coefficient used to calculate the final gas price

@property (nonatomic, copy)NSString *expiration; //  Expiration relative to blockRef
@property (nonatomic, copy)NSArray *clauses; //clause list

@property (nonatomic, copy)NSArray<NSData *> *reserveds;


- (WalletTransactionParameter *)build;

@end

@interface ClauseModel : NSObject

@property (nonatomic, copy)NSString *to;    //The destination address of the message, null for a contract-creation transaction
@property (nonatomic, copy)NSString *value; //The value, with a unit of wei, transferred through the transaction. Specifically, it plays the role of endowment when the transaction is contract-creation type
@property (nonatomic, copy)NSString *data;  //Either the ABI byte string containing the data of the function call on a contract or the initialization code of a contract-creation transaction
@end


NS_ASSUME_NONNULL_END
