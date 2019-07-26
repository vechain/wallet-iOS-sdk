//
//  WalletDAppHandle+connexJS.h
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



#import "WalletDAppHandle.h"
#import <WebKit/WebKit.h>
#import "WalletDAppHeader.h"
#import "WalletJSCallbackModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WalletDAppHandle (connexJS)


//Get the genesis block information
-(void)getGenesisBlock:(WalletJSCallbackModel *)callbackModel
     completionHandler:(void (^)(NSString * __nullable result))completionHandler
               webView:(WKWebView *)webView;
//Get block status
-(void)getStatus:(WalletJSCallbackModel *)callbackModel
completionHandler:(void (^)(NSString * __nullable result))completionHandler
         webView:(WKWebView *)webView;

- (void)requestStatus:(WalletJSCallbackModel *)callbackModel
    completionHandler:(void (^)(NSString * result))completionHandler
              webView:(WKWebView *)webView;

//Get VET balance
- (void)getAccount:(WalletJSCallbackModel *)callbackModel
          completionHandler:(void (^)(NSString * __nullable result))completionHandler
                    webView:(WKWebView *)webView;

//Get account code
- (void)getAccountCode:(WalletJSCallbackModel *)callbackModel
     completionHandler:(void (^)(NSString * __nullable result))completionHandler
               webView:(WKWebView *)webView;

//Get account storge
- (void)getAccountStorage:(WalletJSCallbackModel *)callbackModel
        completionHandler:(void (^)(NSString * __nullable result))completionHandler
                  webView:(WKWebView *)webView;


//Get information about a block
- (void)getBlock:(WalletJSCallbackModel *)callbackModel
completionHandler:(void (^)(NSString * __nullable result))completionHandler
         webView:(WKWebView *)webView;

//Get transaction details
- (void)getTransaction:(WalletJSCallbackModel *)callbackModel
     completionHandler:(void (^)(NSString * __nullable result))completionHandler
               webView:(WKWebView *)webView;

//Get transaction receipt
- (void)getTransactionReceipt:(WalletJSCallbackModel *)callbackModel
            completionHandler:(void (^)(NSString * __nullable result))completionHandler
                      webView:(WKWebView *)webView;

//Open ticker next
- (void)tickerNext:(WalletJSCallbackModel *)callbackModel
 completionHandler:(void (^)(NSString * __nullable result))completionHandler
           webView:(WKWebView *)webView;
//Open WebSocket
- (void)openWebSocket;

//Simulate a single transaction
- (void)methodAsCall:(WalletJSCallbackModel *)callbackModel
   completionHandler:(void (^)(NSString * __nullable result))completionHandler
             webView:(WKWebView *)webView;

//Filter by condition
- (void)filterApply:(WalletJSCallbackModel *)callbackModel
  completionHandler:(void (^)(NSString * __nullable result))completionHandler
            webView:(WKWebView *)webView;

//Simulate multiple transactions
- (void)explain:(WalletJSCallbackModel *)callbackModel
completionHandler:(void (^)(NSString * __nullable result))completionHandler
        webView:(WKWebView *)webView;

//Determine if the local wallet has this address
- (void)owned:(WalletJSCallbackModel *)callbackModel
completionHandler:(void (^)(NSString * __nullable result))completionHandler
      webView:(WKWebView *)webView;

//Certification signature
- (void)certTransfer:(WalletJSCallbackModel *)callbackModel
                from:(NSString *)from
             webView:(WKWebView *)webView;

- (void)sign:(WalletJSCallbackModel *)callbackModel completionHandler:(void (^)(NSString * __nullable result))completionHandler webView:(WKWebView *)webView;



@end

NS_ASSUME_NONNULL_END
