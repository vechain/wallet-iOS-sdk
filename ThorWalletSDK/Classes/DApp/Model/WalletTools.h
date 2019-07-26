//
//  WalletTools.h
//  Wallet
//
//  Created by VeChain on 18/4/26.
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



#import <Foundation/Foundation.h>
#import "WalletUtils.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHPhotoLibrary.h>
#import <WebKit/WebKit.h>
#import "BigNumber.h"
#import "WalletHeader.h"

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

@interface WalletTools : NSObject

+ (UIViewController*)getCurrentVC;

+ (NSString *)checksumAddress:(NSString *)inputAddress;

+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController;

//dapp store package
+ (NSMutableDictionary *)packageWithRequestId:(NSString *)requestId
                                         data:(id )data
                                         code:(NSInteger)code
                                      message:(NSString *)message;

+ (void)callbackWithrequestId:(NSString *)requestId
                      webView:(WKWebView *)webView
                         data:(id)data
                   callbackId:(NSString *)callbackId
                         code:(NSInteger)code;



+ (BOOL)errorAddressAlert:(NSString *)toAddress;

+ (BOOL)checkKeystore:(NSString *)keystore;

+ (BOOL)checkHEXStr:(NSString *)hex;

+ (BOOL)checkDecimalStr:(NSString *)decimalString;

+ (BOOL)isEmpty:(id )input;

+ (NSString *)packageCertParam:(NSDictionary *)param;

@end





