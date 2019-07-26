//
//  WalletDAppHandle+web3JSHardle.m
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



#import "WalletDAppHandle+web3JS.h"
#import "WalletVETBalanceApi.h"
#import "WalletGenesisBlockInfoApi.h"
#import "WalletVETBalanceApi.h"
#import <WebKit/WebKit.h>
#import "WalletAccountCodeApi.h"
#import "WalletBlockApi.h"
#import "WalletTransantionsReceiptApi.h"
#import "WalletManageModel.h"
#import "WalletDAppHandle+connexJS.h"
#import "WalletDAppHandle+transfer.h"

@implementation WalletDAppHandle (web3JS)

// Get VET balance
- (void)getBalance:(WalletJSCallbackModel *)callbackModel
 completionHandler:(void (^)(NSString * __nullable result))completionHandler
           webView:(WKWebView *)webView
{
    WalletVETBalanceApi *vetBalanceApi = [[WalletVETBalanceApi alloc]initWith:callbackModel.params[@"address"]];
    [vetBalanceApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        WalletBalanceModel *balanceModel = finishApi.resultModel;
        
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                  webView:webView 
                                     data:balanceModel.balance
                               callbackId:callbackModel.callbackId
                                     code:OK];
        
        completionHandler(@"{}");

    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                  webView:webView 
                                     data:@""
                               callbackId:callbackModel.callbackId
                                     code:ERROR_NETWORK];
        completionHandler(@"{}");

    }];
}

//Get NodeUrl
- (void)getNodeUrl:(WalletJSCallbackModel *)callbackModel
 completionHandler:(void (^)(NSString * __nullable result))completionHandler
           webView:(WKWebView *)webView
{
    NSDictionary *dict = [WalletTools packageWithRequestId:callbackModel.requestId
                                                       data:[WalletUserDefaultManager getBlockUrl]
                                                       code:OK
                                                    message:@""];
    completionHandler([dict yy_modelToJSONString]);
}


//Get the local wallet address
-(void)getAccounts:(WalletJSCallbackModel *)callbackModel
 completionHandler:(void (^)(NSString * __nullable result))completionHandler
           webView:(WKWebView *)webView
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onGetWalletAddress:)]) {
        
        [self.delegate onGetWalletAddress:^(NSArray *addressList) {
            
            [WalletTools callbackWithrequestId:callbackModel.requestId
                                       webView:webView
                                          data:addressList
                                    callbackId:callbackModel.callbackId
                                          code:OK];
            
            completionHandler(@"{}");

        }];
        
        
    }else{
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackModel.callbackId
                                      code:ERROR_REJECTED];
        completionHandler(@"{}");

    }
}

- (void)send:(WalletJSCallbackModel *)callbackModel completionHandler:(void (^)(NSString * __nullable result))completionHandler webView:(WKWebView *)webView
{
    completionHandler(@"{}");
    [self transferCallback:callbackModel connex:NO];
}

@end
