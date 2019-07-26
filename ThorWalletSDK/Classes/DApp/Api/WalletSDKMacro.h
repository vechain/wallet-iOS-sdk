//
//  WalletMacro.h
//  Wallet
//
//  Created by VeChain on 2019/5/20.
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



#ifndef WalletSDKMacro_h
#define WalletSDKMacro_h

#define SDKVersion  @"1.0.0"

#define AppId @"5c50bb8d9736b60f1f0f4f5c56604326"

#define AppId_Test @"27a7898b733ce99d90ec5338de5ced52"

#define     Test_Node      @"https://vethor-node-test.digonchain.com"      /* The test Node environment of block chain */
#define     Main_Node      @"https://vethor-node.digonchain.com"           /* The main Node environment of block chain*/

#if DEBUG
#else
#define NSlog(...) {}
#endif

#endif /* WalletSDKMacro_h */
