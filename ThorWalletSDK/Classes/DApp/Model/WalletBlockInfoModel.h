//
//  WalletBlockInfoModel.h
//  Wallet
//
//  Created by VeChain on 2018/5/10.
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



#import "WalletBaseModel.h"

@interface WalletBlockInfoModel : WalletBaseModel

@property (nonatomic, copy)NSString *number;
@property (nonatomic, copy)NSString *id;
@property (nonatomic, copy)NSString *size;
@property (nonatomic, copy)NSString *parentID;
@property (nonatomic, copy)NSString *timestamp;
@property (nonatomic, copy)NSString *gasLimit;
@property (nonatomic, copy)NSString *beneficiary;
@property (nonatomic, copy)NSString *gasUsed;
@property (nonatomic, copy)NSString *totalScore;
@property (nonatomic, copy)NSString *txsRoot;
@property (nonatomic, copy)NSString *stateRoot;
@property (nonatomic, copy)NSString *receiptsRoot;
@property (nonatomic, copy)NSString *signer;
@property (nonatomic, copy)NSString *transactions;


@end
