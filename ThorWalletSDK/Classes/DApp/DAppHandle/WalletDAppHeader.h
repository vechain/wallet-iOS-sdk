//
//  WalletDAppHeader.h
//  Wallet
//
//  Created by VeChain on 2019/1/23.
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



#ifndef  WalletDAppHeader_h
#define  WalletDAppHeader_h

#import "Payment.h"
#import "SecureData.h"
#import "Account.h"
#import "Transaction.h"
#import "WalletSDKMacro.h"
#import "WalletDAppHandle+web3JS.h"
#import "WalletDAppHandle+connexJS.h"
#import "WalletJSCallbackModel.h"
#import "SocketRocketUtility.h"
#import "WalletCheckVersionApi.h"
#import "WalletVersionModel.h"
#import "WalletDappSimulateMultiAccountApi.h"
#import "WalletDAppGasCalculateHandle.h"
#import "WalletGenesisBlockInfoApi.h"
#import "WalletDAppInjectJSHandle.h"


static int OK = 1;
static int ERROR_NETWORK = 500;
static int ERROR_REJECTED  = 400;

static NSString *ERROR_NETWORK_MSG = @"NetError";
static NSString *ERROR_REJECTED_MSG  = @"Rejected";


#endif /*  WalletDAppHeader_h */