//
//  WalletDAppHandle.m
//  Wallet
//
//  Created by VeChain on 2019/1/11.
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

#define DAppPrefix  @"wallet://"

@interface WalletDAppHandle ()<WKNavigationDelegate,WKUIDelegate>
{

}
@property (nonatomic, strong)WalletVersionModel *versionModel;

@end

@implementation WalletDAppHandle


-(instancetype)init
{
    self = [super init];
    if (self ) {
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        
        //Add web socket NSNotification
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(websocket:) name:kWebSocketdidReceiveMessageNote object:nil];
    }
    return self;
}

//Analyze data from Dapp
- (void)webView:(WKWebView *)webView defaultText:( NSString *)defaultText completionHandler:(void (^)(NSString * result))completionHandler
{
    if ([self mismatch:defaultText]) {
        
        completionHandler(@"{}");
        return;
    }
    
    _webView = webView;
    
    //Whether the scheme conforms to the dapp response
    NSString *result = [defaultText stringByReplacingOccurrencesOfString:DAppPrefix withString:@""];
    NSDictionary *dict = [NSJSONSerialization dictionaryWithJsonString:result];
    
    WalletJSCallbackModel *callbackModel = [WalletJSCallbackModel yy_modelWithDictionary:dict];
    NSString *requestId  = callbackModel.requestId;
    NSString *method     = callbackModel.method;

    NSString *strSEL = [self methodNameWithSEL][method];
    if (strSEL) {
     
        [self invocationMethod:strSEL callbackModel:callbackModel completionHandler:completionHandler];
    }else{
        //No matching methodId found
        NSDictionary *noMethodDict = [WalletTools packageWithRequestId:requestId
                                                                  data:@""
                                                                  code:ERROR_REJECTED
                                                               message:ERROR_REJECTED_MSG];
        completionHandler([noMethodDict yy_modelToJSONString]);
        
        return ;
    }
}

- (BOOL)mismatch:(NSString *)defaultText
{
    if (![defaultText hasPrefix:DAppPrefix]
        || [WalletDAppInjectJSHandle analyzeVersion:_versionModel]) {
        
        return YES;
    }else{
        return NO;
    }
}

- (NSDictionary *)methodNameWithSEL
{
    NSArray *methodList = @[@"getStatus",
                            @"getGenesisBlock",
                            @"getAccount",
                            @"getAccountCode",
                            @"getBlock",
                            @"getTransaction",
                            @"getTransactionReceipt",
                            @"methodAsCall",
                            @"getAccounts",
                            @"getAccountStorage",
                            @"tickerNext",
                            @"sign",
                            @"getBalance",
                            @"getNodeUrl",
                            @"send",
                            @"filterApply",
                            @"explain",
                            @"owned"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    for (NSString *methodName in methodList) {
        NSString *strSEL = [NSString stringWithFormat:@"%@:completionHandler:webView:",methodName];
        [dict setValueIfNotNil:strSEL forKey:methodName];
    }
    return dict;
}

- (void)invocationMethod:(NSString *)strSEL callbackModel:(WalletJSCallbackModel *)callbackModel completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    SEL myMethod =  NSSelectorFromString(strSEL);
    
    NSMethodSignature*signature = [[self class] instanceMethodSignatureForSelector:myMethod];
    NSInvocation*invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = myMethod;
    
    [invocation setArgument:&callbackModel atIndex:2];
    [invocation setArgument:&completionHandler atIndex:3];
    [invocation setArgument:&_webView atIndex:4];
    
    [invocation invoke];
}

//Websocket notification
- (void)websocket:(NSNotification *)sender
{
    NSDictionary *dict = sender.object;
    NSString *requestId = dict[@"requestId"];
    NSString *callbackId = dict[@"callbackId"];
    
    if (requestId.length > 0 && callbackId.length > 0) {
         [WalletTools callbackWithrequestId:requestId webView:_webView data:nil callbackId:callbackId code:OK];
    }
    //update status
    [self requestStatus:nil completionHandler:nil webView:nil];
}

- (void)injectJSWithConfig:(WKWebViewConfiguration *)config
{
    [WalletDAppInjectJSHandle inject:config];
    
    @weakify(self);
    [WalletDAppInjectJSHandle checkVersion:^(WalletVersionModel * _Nonnull versionModel)
    {
        @strongify(self);
        self.versionModel = versionModel;
    }];
}

- (void)deallocDApp
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kWebSocketdidReceiveMessageNote object:nil];
    // Close websocket
    [[SocketRocketUtility instance] SRWebSocketClose];
}


@end
