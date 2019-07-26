//
//  WalletDAppHandle+transfer.m
//  Wallet
//
//  Created by VeChain on 2019/4/2.
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

#import "YYModel.h"
#import <WebKit/WebKit.h>
#import "WalletDAppHeader.h"
#import "WalletTransactionApi.h"
#import "WalletDAppHandle+transfer.h"

@implementation WalletDAppHandle (transfer)

- (void)transferCallback:(WalletJSCallbackModel *)callbackModel
                  connex:(BOOL)bConnex
{
    
    NSString *kind = callbackModel.params[@"kind"];
    
    if ([kind isEqualToString:@"cert"]) { // Cert type signature
        
        NSString *from = callbackModel.params[@"options"][@"signer"];
        [self certTransfer:callbackModel from:from webView:self.webView];
        return ;
    }
    
    __block NSString *gas      = @"";
    __block NSString *signer   = @"";
    __block NSString *gasPrice = @"";
    
    NSMutableArray *clauseModelList = [[NSMutableArray alloc]init];
    
    [self packgetDatabConnex:bConnex
             clauseModelList:clauseModelList
                         gas:&gas
                    gasPrice:&gasPrice
                      signer:&signer
              callbackParams:callbackModel.params];
    
    [self callbackClauseList:clauseModelList gas:gas signer:signer bConnex:bConnex callbackModel:callbackModel];
}

- (void)packgetDatabConnex:(BOOL)bConnex clauseModelList:(NSMutableArray *)clauseModelList gas:(NSString **)gas gasPrice:(NSString **)gasPrice signer:(NSString **)signer callbackParams:(NSDictionary *)callbackParams
{
    if (bConnex) { // Connex
        
        NSArray *clauseList = callbackParams[@"clauses"];
        
        for (NSDictionary *clauseDict in clauseList) {
            
            ClauseModel *clauseModel = [[ClauseModel alloc]init];
            clauseModel.to    = clauseDict[@"to"];
            clauseModel.value = clauseDict[@"value"];
            clauseModel.data  = clauseDict[@"data"];
            
            [clauseModelList addObject:clauseModel];
        }
        
        *gas        = callbackParams[@"options"][@"gas"];
        
        *signer       = callbackParams[@"options"][@"signer"];
        
    }else{ // Web3
        
        ClauseModel *clauseModel = [[ClauseModel alloc]init];
        clauseModel.to    = callbackParams[@"to"];
        clauseModel.value = callbackParams[@"value"];
        clauseModel.data  = callbackParams[@"data"];
        
        *gas        = callbackParams[@"gas"];
        *gasPrice   = callbackParams[@"gasPrice"];
        *signer     = callbackParams[@"from"];
        
        [clauseModelList addObject:clauseModel];
    }
}

- (void)callbackClauseList:(NSArray *)clauseModelList gas:(NSString *)gas signer:(NSString *)signer bConnex:(BOOL)bConnex callbackModel:(WalletJSCallbackModel *)callbackModel
{
    id delegate = self.delegate;

    if (delegate) {
        if ([delegate respondsToSelector:@selector(onWillTransfer: signer: gas: completionHandler:)]) {
            @weakify(self)
            [delegate onWillTransfer:clauseModelList signer:signer gas:gas completionHandler:^(NSString * txId,NSString *signer)
             {
                 @strongify(self);
                 [self callbackToWebView:txId
                                  signer:signer
                                 bConnex:bConnex
                                 webView:self.webView
                           callbackModel:callbackModel];
                 
             }];
        }else{
            [WalletTools callbackWithrequestId:callbackModel.requestId
                                       webView:self.webView
                                          data:@""
                                    callbackId:callbackModel.callbackId
                                          code:ERROR_REJECTED];
        }
    }
}

//Call back to dapp webview
- (void)callbackToWebView:(NSString *)txid signer:(NSString *)signer bConnex:(BOOL)bConnex  webView:(WKWebView *)webView callbackModel:(WalletJSCallbackModel *)callbackModel
{
    if (txid.length != 0) {
        id data = nil;
        if (bConnex) {
            
            NSMutableDictionary *dictData = [NSMutableDictionary dictionary];
            [dictData setValueIfNotNil:txid forKey:@"txid"];
            [dictData setValueIfNotNil:signer.lowercaseString forKey:@"signer"];
            
            data = dictData;
        }else{
            data = txid;
        }
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                   webView:webView
                                      data:data
                                callbackId:callbackModel.callbackId
                                      code:OK];
    }else{
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackModel.callbackId
                                      code:ERROR_NETWORK];
    }
}

- (void)paramsErrorCallbackModel:(WalletJSCallbackModel *)callbackModel webView:(WKWebView *)webView
{
    [WalletTools callbackWithrequestId:callbackModel.requestId webView:webView data:@"" callbackId:callbackModel.callbackId code:ERROR_NETWORK];
}




@end
