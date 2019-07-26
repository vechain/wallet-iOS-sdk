//
//  WalletDAppHandle+connexJS.m
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



#import "WalletDAppHandle+connexJS.h"
#import "WalletGenesisBlockInfoApi.h"
#import "WalletVETBalanceApi.h"
#import <WebKit/WebKit.h>
#import "WalletAccountCodeApi.h"
#import "WalletBlockApi.h"
#import "WalletTransantionsReceiptApi.h"
#import "WalletManageModel.h"
#import "WalletDAppPeersApi.h"
#import "WalletBestBlockInfoApi.h"
#import "WalletDAppPeerModel.h"
#import "WalletDAppTransferDetailApi.h"
#import "SocketRocketUtility.h"
#import "WalletGetStorageApi.h"
#import "WalletDappLogEventApi.h"
#import "WalletDappSimulateMultiAccountApi.h"
#import "WalletDappSimulateAccountApi.h"
#import "WalletDAppHandle+transfer.h"

#define nullString @"nu&*ll"

@implementation WalletDAppHandle (connexJS)

//Get the genesis block information
-(void)getGenesisBlock:(WalletJSCallbackModel *)callbackModel
     completionHandler:(void (^)(NSString * __nullable result))completionHandler
               webView:(WKWebView *)webView
{
    WalletGenesisBlockInfoApi *genesisBlock = [WalletGenesisBlockInfoApi new];
    [genesisBlock loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        
        NSDictionary *resultDict = [WalletTools packageWithRequestId:callbackModel.requestId
                                                               data:finishApi.resultDict
                                                               code:OK
                                                            message:@""];
        completionHandler([resultDict yy_modelToJSONString]);
        return;
    }failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        NSDictionary *resultDict = [WalletTools packageWithRequestId:callbackModel.requestId
                                                               data:@""
                                                               code:ERROR_NETWORK
                                                            message:ERROR_NETWORK_MSG];
        completionHandler([resultDict yy_modelToJSONString]);
    }];
}

//Get block status
-(void)getStatus:(WalletJSCallbackModel *)callbackModel
completionHandler:(void (^)(NSString * __nullable result))completionHandler
         webView:(WKWebView *)webView
{
    if (self.strStatus.length > 0) {
        NSDictionary *dictStatus = [NSJSONSerialization dictionaryWithJsonString:self.strStatus];
        NSDictionary *resultDict = [WalletTools packageWithRequestId:callbackModel.requestId
                                                                data:dictStatus
                                                                code:OK
                                                             message:@""];
        completionHandler([resultDict yy_modelToJSONString]);
        
    }else{
        // open websocket
        [self openWebSocket];
        [self requestStatus:callbackModel completionHandler:completionHandler webView:webView];
    }
}

- (void)requestStatus:(WalletJSCallbackModel *)callbackModel
    completionHandler:(void (^)(NSString * result))completionHandler
              webView:(WKWebView *)webView
{
    WalletDAppPeersApi *peersApi = [[WalletDAppPeersApi alloc]init];
    [peersApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        
        NSString *blockNum = @"";
        NSArray *list = (NSArray *)finishApi.resultDict;
        
        for (NSDictionary *dict in list) {
            NSString *bestBlockNum = [dict[@"bestBlockID"] substringToIndex:10];
            BigNumber *bigBestBlockNum = [BigNumber bigNumberWithHexString:bestBlockNum];
            BigNumber *bigBlockNum = [BigNumber bigNumberWithHexString:blockNum];
            NSDecimalNumber *decBestBlockNum = [NSDecimalNumber decimalNumberWithString:bigBestBlockNum.decimalString];
            NSDecimalNumber *decBlockNum = [NSDecimalNumber decimalNumberWithString:bigBlockNum.decimalString];
            
            if ([decBestBlockNum compare:decBlockNum] == NSOrderedDescending) { //
                blockNum = bestBlockNum;
            }
        }
        
        // Get best block info
        [self statusBlockNum:blockNum callbackModel:callbackModel completionHandler:completionHandler];
        
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        
        NSDictionary *resultDict = [WalletTools packageWithRequestId:callbackModel.requestId
                                                                data:@""
                                                                code:ERROR_NETWORK
                                                             message:ERROR_NETWORK_MSG];
        completionHandler([resultDict yy_modelToJSONString]);
        
    }];
}

- (void)statusBlockNum:(NSString *)blockNum
         callbackModel:(WalletJSCallbackModel *)callbackModel
     completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    WalletBestBlockInfoApi *bestApi = [[WalletBestBlockInfoApi alloc]init];
    [bestApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        
        WalletBlockInfoModel *blockModel = finishApi.resultModel;
        BigNumber *peerNum = [BigNumber bigNumberWithHexString:blockNum];
        CGFloat progress = peerNum.decimalString.floatValue/blockModel.number.floatValue;
        
        NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
        [dictParam setValueIfNotNil:@(progress) forKey:@"progress"];
        
        NSMutableDictionary *subDict = [NSMutableDictionary dictionary];
        [subDict setValueIfNotNil:blockModel.id         forKey:@"id"];
        [subDict setValueIfNotNil:@(blockModel.number.integerValue) forKey:@"number"];
        [subDict setValueIfNotNil:@(blockModel.timestamp.integerValue) forKey:@"timestamp"];
        [subDict setValueIfNotNil:blockModel.parentID    forKey:@"parentID"];
        
        [dictParam setValueIfNotNil:subDict forKey:@"head"];
        
        self.strStatus = [dictParam yy_modelToJSONString];
        
        if (completionHandler && callbackModel) {
            NSDictionary *resultDict = [WalletTools packageWithRequestId:callbackModel.requestId
                                                                    data:dictParam
                                                                    code:OK
                                                                 message:@""];
            completionHandler([resultDict yy_modelToJSONString]);
        }
        
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        NSDictionary *resultDict = [WalletTools packageWithRequestId:callbackModel.requestId
                                                                data:@""
                                                                code:ERROR_NETWORK
                                                             message:ERROR_NETWORK_MSG];
        completionHandler([resultDict yy_modelToJSONString]);
        
    }];
}

- (void)methodAsCall:(WalletJSCallbackModel *)callbackModel
   completionHandler:(void (^)(NSString * __nullable result))completionHandler
             webView:(WKWebView *)webView
{
    completionHandler(@"{}");

    NSString *revision        = callbackModel.params[@"revision"];
    NSDictionary *dictOpts    = callbackModel.params[@"opts"];
    NSDictionary *dictclause  = callbackModel.params[@"clause"];
    
    WalletDappSimulateAccountApi *accountApi = [[WalletDappSimulateAccountApi alloc]initClause:dictclause opts:dictOpts revision:revision];
    accountApi.supportOtherDataFormat = YES;
    [accountApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        
        if (finishApi.resultDict) {
            [WalletTools callbackWithrequestId:callbackModel.requestId
                                       webView:webView
                                          data:finishApi.resultDict
                                    callbackId:callbackModel.callbackId
                                          code:OK];
        }else{
            // The server returns an empty payment and needs to be changed to null.
            [WalletTools callbackWithrequestId:callbackModel.requestId
                                       webView:webView
                                          data:nullString
                                    callbackId:callbackModel.callbackId
                                          code:OK];
        }
        
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackModel.callbackId
                                      code:ERROR_NETWORK];
    }];
}

- (void)getAccountStorage:(WalletJSCallbackModel *)callbackModel
        completionHandler:(void (^)(NSString * __nullable result))completionHandler
                  webView:(WKWebView *)webView
{
    completionHandler(@"{}");

    NSString *key = callbackModel.params[@"key"];
    NSString *address = callbackModel.params[@"address"];
    
    WalletGetStorageApi *vetBalanceApi = [[WalletGetStorageApi alloc]initWithkey:key address:address];
    vetBalanceApi.supportOtherDataFormat = YES;
    [vetBalanceApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        
        if (finishApi.resultDict) {
            [WalletTools callbackWithrequestId:callbackModel.requestId
                                       webView:webView
                                          data:finishApi.resultDict
                                    callbackId:callbackModel.callbackId
                                          code:OK];
        }else{
            // The server returns an empty payment and needs to be changed to null.
            [WalletTools callbackWithrequestId:callbackModel.requestId
                                       webView:webView
                                          data:nullString
                                    callbackId:callbackModel.callbackId
                                          code:OK];
        }
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackModel.callbackId
                                      code:ERROR_NETWORK];
    }];

}

//Get VET balance
- (void)getAccount:(WalletJSCallbackModel *)callbackModel
          completionHandler:(void (^)(NSString * __nullable result))completionHandler
                    webView:(WKWebView *)webView
{
    completionHandler(@"{}");

    if (![WalletTools errorAddressAlert:callbackModel.params[@"address"]]) {
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackModel.callbackId
                                      code:ERROR_REJECTED];
        return;
    }
    
    WalletVETBalanceApi *vetBalanceApi = [[WalletVETBalanceApi alloc]initWith:callbackModel.params[@"address"]];
    vetBalanceApi.supportOtherDataFormat = YES;
    [vetBalanceApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        
        if (finishApi.resultDict) {
            [WalletTools callbackWithrequestId:callbackModel.requestId
                                       webView:webView
                                          data:finishApi.resultDict
                                    callbackId:callbackModel.callbackId
                                          code:OK];
        }else{
            // The server returns an empty payment and needs to be changed to null.
            [WalletTools callbackWithrequestId:callbackModel.requestId
                                       webView:webView
                                          data:nullString
                                    callbackId:callbackModel.callbackId
                                          code:OK];
        }
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackModel.callbackId
                                      code:ERROR_NETWORK];
    }];
}

- (void)getAccountCode:(WalletJSCallbackModel *)callbackModel
     completionHandler:(void (^)(NSString * __nullable result))completionHandler
               webView:(WKWebView *)webView
{
    completionHandler(@"{}");

    if (![WalletTools errorAddressAlert:callbackModel.params[@"address"]]) {
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackModel.callbackId
                                      code:ERROR_REJECTED];
        return;
    }
    
    WalletAccountCodeApi *vetBalanceApi = [[WalletAccountCodeApi alloc]initWithAddress:callbackModel.params[@"address"]];
    [vetBalanceApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        
        if (finishApi.resultDict) {
            [WalletTools callbackWithrequestId:callbackModel.requestId
                                       webView:webView
                                          data:finishApi.resultDict
                                    callbackId:callbackModel.callbackId
                                          code:OK];
        }else{
            // The server returns an empty payment and needs to be changed to null.
            [WalletTools callbackWithrequestId:callbackModel.requestId
                                       webView:webView
                                          data:nullString
                                    callbackId:callbackModel.callbackId
                                          code:OK];
        }
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackModel.callbackId
                                      code:ERROR_NETWORK];
    }];
}

- (void)getBlock:(WalletJSCallbackModel *)callbackModel
completionHandler:(void (^)(NSString * __nullable result))completionHandler
         webView:(WKWebView *)webView
{
    completionHandler(@"{}");

    if (![self checkStatusParams:callbackModel webView:webView]) {
        
        return;
    }
    
    NSString *revision = callbackModel.params[@"revision"];
    WalletBlockApi *vetBalanceApi = [[WalletBlockApi alloc]initWithRevision:revision];
    vetBalanceApi.supportOtherDataFormat = YES;
    [vetBalanceApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        
        if (finishApi.resultDict) {
            [WalletTools callbackWithrequestId:callbackModel.requestId
                                       webView:webView
                                          data:finishApi.resultDict
                                    callbackId:callbackModel.callbackId
                                          code:OK];
            
        }else {
            // The server returns an empty payment and needs to be changed to null.
            [WalletTools callbackWithrequestId:callbackModel.requestId
                                       webView:webView
                                          data:nullString
                                    callbackId:callbackModel.callbackId
                                          code:OK];
        }
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackModel.callbackId
                                      code:ERROR_NETWORK];
    }];
}

- (BOOL)checkStatusParams:(WalletJSCallbackModel *)callbackModel
                  webView:(WKWebView *)webView
{
    NSString *revision = [NSString stringWithFormat:@"%@", callbackModel.params[@"revision"]];
    
    if ([WalletTools isEmpty:revision]) {
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackModel.callbackId
                                      code:ERROR_REJECTED];
        return NO;
    }
    return YES;
}


- (void)getTransaction:(WalletJSCallbackModel *)callbackModel
     completionHandler:(void (^)(NSString * __nullable result))completionHandler
               webView:(WKWebView *)webView
{
    completionHandler(@"{}");

    NSString *txId = callbackModel.params[@"id"];
    if (txId == nil || ![WalletTools checkHEXStr:txId] || txId.length != 66) {
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackModel.callbackId
                                      code:ERROR_REJECTED];
        return;
    }
    
    WalletDAppTransferDetailApi *vetBalanceApi = [[WalletDAppTransferDetailApi alloc]initWithTxid:txId];
    vetBalanceApi.supportOtherDataFormat = YES;
    [vetBalanceApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        
        if (finishApi.resultDict) {
            NSDictionary *balanceModel = finishApi.resultDict;
            
            [WalletTools callbackWithrequestId:callbackModel.requestId
                                       webView:webView
                                          data:balanceModel
                                    callbackId:callbackModel.callbackId
                                          code:OK];
        }else{
            // The server returns an empty payment and needs to be changed to null.
            [WalletTools callbackWithrequestId:callbackModel.requestId
                                       webView:webView
                                          data:nullString
                                    callbackId:callbackModel.callbackId
                                          code:OK];
        }
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackModel.callbackId
                                      code:ERROR_NETWORK];
    }];
}

- (void)getTransactionReceipt:(WalletJSCallbackModel *)callbackModel
            completionHandler:(void (^)(NSString * __nullable result))completionHandler
                      webView:(WKWebView *)webView
{
    completionHandler(@"{}");

    NSString *txId = callbackModel.params[@"id"];

    if (txId == nil || ![WalletTools checkHEXStr:txId] || txId.length != 66) {
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackModel.callbackId
                                      code:ERROR_REJECTED];
        return;
    }
    
    WalletTransantionsReceiptApi *vetBalanceApi = [[WalletTransantionsReceiptApi alloc]initWithTxid:txId];
    vetBalanceApi.supportOtherDataFormat = YES;
    [vetBalanceApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        
        if (finishApi.resultDict) {
            [WalletTools callbackWithrequestId:callbackModel.requestId
                                       webView:webView
                                          data:finishApi.resultDict
                                    callbackId:callbackModel.callbackId
                                          code:OK];
        }else{
            // The server returns an empty payment and needs to be changed to null.
            [WalletTools callbackWithrequestId:callbackModel.requestId
                                       webView:webView
                                          data:nullString
                                    callbackId:callbackModel.callbackId
                                          code:OK];
        }
        
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackModel.callbackId
                                      code:ERROR_NETWORK];
    }];
}

- (void)tickerNext:(WalletJSCallbackModel *)callbackModel
          completionHandler:(void (^)(NSString * __nullable result))completionHandler
                    webView:(WKWebView *)webView
{
    NSString *url = [[WalletUserDefaultManager getBlockUrl] stringByAppendingString:@"/subscriptions/block"];
    
    // Open web socket
    SocketRocketUtility *socket = [SocketRocketUtility instance];
    
    socket.requestId = callbackModel.requestId;
    socket.callbackId = callbackModel.callbackId;
    [socket SRWebSocketOpenWithURLString:url];
    completionHandler(@"{}");
}

- (void)openWebSocket
{
    NSString *url = [[WalletUserDefaultManager getBlockUrl] stringByAppendingString:@"/subscriptions/block"];
    
    // Open web socket
    SocketRocketUtility *socket = [SocketRocketUtility instance];
    [socket SRWebSocketOpenWithURLString:url];
}

// Certification signature
- (void)certTransfer:(WalletJSCallbackModel *)callbackModel
                from:(NSString *)from
            webView:(WKWebView *)webView
{
    NSDictionary *clauses = callbackModel.params[@"clauses"];
    
    if (![clauses isKindOfClass:[NSDictionary class]]) {
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackModel.callbackId
                                      code:ERROR_REJECTED];
        return;
    }
    // Get the timestamp of the block
    WalletBestBlockInfoApi *bestApi = [[WalletBestBlockInfoApi alloc]init];
    [bestApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        
        WalletBlockInfoModel *blockModel = finishApi.resultModel;
        NSNumber *timestamp = (NSNumber *)blockModel.timestamp;
        
        NSString *time = [NSString stringWithFormat:@"%.0ld",(long)timestamp.integerValue];
        NSString *domain  = webView.URL.host;
        
        NSMutableDictionary *dictSignParam = [NSMutableDictionary dictionaryWithDictionary:clauses];
        
        [dictSignParam setValueIfNotNil:@(time.integerValue) forKey:@"timestamp"];
        [dictSignParam setValueIfNotNil:domain forKey:@"domain"];
        [dictSignParam setValueIfNotNil:from.lowercaseString forKey:@"signer"];

        NSString *strParams = [dictSignParam yy_modelToJSONString];
        if (self.delegate && [self.delegate respondsToSelector:@selector(onWillCertificate:signer:completionHandler:)]) {
            
            [self certTransferCallback:strParams dictSignParam:dictSignParam callbackModel:callbackModel from:from webView:webView];
        }else{
            [WalletTools callbackWithrequestId:callbackModel.requestId
                                       webView:webView
                                          data:@""
                                    callbackId:callbackModel.callbackId
                                          code:ERROR_REJECTED];
        }
    }failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackModel.callbackId
                                      code:ERROR_NETWORK];
    }];
}

- (void)certTransferCallback:(NSString *)strParams
               dictSignParam:(NSMutableDictionary *)dictSignParam
               callbackModel:(WalletJSCallbackModel *)callbackModel
                        from:(NSString *)from
                     webView:(WKWebView *)webView
{
    [self.delegate onWillCertificate:strParams
                              signer:from
                   completionHandler:^(NSString *signer, NSData *signature)
     {
         if (signature == nil) {
             [WalletTools callbackWithrequestId:callbackModel.requestId
                                        webView:webView
                                           data:@""
                                     callbackId:callbackModel.callbackId
                                           code:ERROR_REJECTED];
             return ;
         }
         NSString *hashSignture = [SecureData dataToHexString:signature];
         
         NSMutableDictionary *dictSub = [NSMutableDictionary dictionary];
         
         [dictSub setValueIfNotNil:dictSignParam[@"domain"] forKey:@"domain"];
         [dictSub setValueIfNotNil:signer.lowercaseString forKey:@"signer"];
         [dictSub setValueIfNotNil:dictSignParam[@"timestamp"] forKey:@"timestamp"];
         
         NSMutableDictionary *dict = [NSMutableDictionary dictionary];
         [dict setValueIfNotNil:dictSub forKey:@"annex"];
         [dict setValueIfNotNil:hashSignture forKey:@"signature"];
         
         [WalletTools callbackWithrequestId:callbackModel.requestId
                                    webView:webView
                                       data:dict
                                 callbackId:callbackModel.callbackId
                                       code:OK];
     }];
}

- (void)filterApply:(WalletJSCallbackModel *)callbackModel
      completionHandler:(void (^)(NSString * __nullable result))completionHandler
                webView:(WKWebView *)webView
{
    completionHandler(@"{}");

    WalletDappLogEventApi *eventApi = [[WalletDappLogEventApi alloc]initWithKind:callbackModel.params[@"kind"]];
    eventApi.dictRange          = callbackModel.params[@"filterBody"][@"range"];;
    eventApi.dictOptions        = callbackModel.params[@"filterBody"][@"options"];
    eventApi.dictCriteriaSet    = callbackModel.params[@"filterBody"][@"criteriaSet"];
    eventApi.order              = callbackModel.params[@"filterBody"][@"order"];
    
    [eventApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                   webView:webView
                                      data:finishApi.resultDict
                                callbackId:callbackModel.callbackId
                                      code:OK];
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackModel.callbackId
                                      code:ERROR_NETWORK];
    }];

}

- (void)explain:(WalletJSCallbackModel *)callbackModel
completionHandler:(void (^)(NSString * __nullable result))completionHandler
        webView:(WKWebView *)webView
{
    completionHandler(@"{}");

    NSArray *clauses = callbackModel.params[@"clauses"];
    NSDictionary *options = callbackModel.params[@"options"];
    NSString *rev = callbackModel.params[@"rev"];
    
    if ([WalletTools isEmpty:clauses] ) {
        
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackModel.callbackId
                                      code:ERROR_REJECTED];
        
        return;
    }
    
    WalletDappSimulateMultiAccountApi *multiApi = [[WalletDappSimulateMultiAccountApi alloc]initClause:clauses opts:options revision:rev];
    [multiApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                   webView:webView
                                      data:finishApi.resultDict
                                callbackId:callbackModel.callbackId
                                      code:OK];
        
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackModel.callbackId
                                      code:ERROR_NETWORK];
    }];
}

- (void)owned:(WalletJSCallbackModel *)callbackModel
completionHandler:(void (^)(NSString * __nullable result))completionHandler
        webView:(WKWebView *)webView
{
    if (self.delegate
        &&[self.delegate respondsToSelector:@selector(onCheckOwnAddress:callback:)]) {
        [self.delegate onCheckOwnAddress:callbackModel.params[@"address"] callback:^(BOOL result) {
            
            [self ownedCallback:result callbackModel:callbackModel completionHandler:completionHandler];
        }];
    }else{
        completionHandler(@"{}");
    }
}

- (void)ownedCallback:(BOOL)result
        callbackModel:(WalletJSCallbackModel *)callbackModel
    completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    if (result) {
        
        NSDictionary *resultDict = [WalletTools packageWithRequestId:callbackModel.requestId
                                                                data:@"true"
                                                                code:OK
                                                             message:@""];
        NSString *injectJS = [resultDict yy_modelToJSONString];
        
        //Remove "
        injectJS = [injectJS stringByReplacingOccurrencesOfString:@"\"true\"" withString:@"true"];
        completionHandler(injectJS);
        
    }else{
        
        NSDictionary *resultDict = [WalletTools packageWithRequestId:callbackModel.requestId
                                                                data:@"false"
                                                                code:OK
                                                             message:@""];
        NSString *injectJS = [resultDict yy_modelToJSONString];
        
        //Remove "
        injectJS = [injectJS stringByReplacingOccurrencesOfString:@"\"false\"" withString:@"false"];
        
        completionHandler(injectJS);
    }
}

- (void)sign:(WalletJSCallbackModel *)callbackModel completionHandler:(void (^)(NSString * __nullable result))completionHandler webView:(WKWebView *)webView
{
    completionHandler(@"{}");
    [self transferCallback:callbackModel connex:YES];
}



@end
