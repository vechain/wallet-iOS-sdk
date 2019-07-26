//
//  WalletBaseApi.m
//  Wallet
//
//  Created by VeChain on 18/4/7.
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



#import "WalletBaseApi.h"
#import "WalletModelFetcher.h"
#import "NSObject+LKModel.h"
#import "WalletHeader.h"
#import "YYModel.h"

@implementation WalletBaseApi


- (id)init
{
    if (self  = [super init]) {
        self.httpAddress = @"";
        self.requestMethod = RequestGetMethod;
    }
    return self;
}


/**
 *  Obj attribute return type
 */
- (Class)expectedJsonObjClass
{
    return [NSDictionary class];
}

/**
 *  Obj attribute value type
 */
- (Class)expectedModelClass
{
    return [self expectedJsonObjClass];
}

- (void)convertJsonResultToModel:(NSDictionary *)jsonDict
{
    if ([self expectedModelClass] == nil ||
        [self expectedModelClass] == [self expectedJsonObjClass]) {
        self.resultModel = jsonDict;
    } else {
        self.resultModel = [[self expectedModelClass] yy_modelWithDictionary:jsonDict];
    }
}

- (NSMutableDictionary *)buildRequestDict
{
    if (!_requestParmas) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        _requestParmas = dict;
    }
    return _requestParmas;
}


-(void)loadDataAsyncWithSuccess:(WalletLoadSuccessBlock)success
                        failure:(WalletLoadFailBlock)failure
{
    self.successBlock = success;
    self.failBlock = failure;
    if ( _httpAddress == nil) {
        self.failBlock(self,@"");
        return;
    }
    
    NSMutableDictionary *postDict = [self buildRequestDict];
    switch (_requestMethod) {
        case RequestGetMethod:
        {
            [WalletModelFetcher requestGetWithUrl:_httpAddress
                                          params:postDict
                                   responseBlock:^(NSDictionary *responseDict, NSDictionary *responseHeaderFields, NSError *error)
            {
               [self analyseResponseInfo:responseDict
                            headerFileds:responseHeaderFields
                                   error:error];
            }];
        }
            break;
        
        case RequestPostMethod:
        {
            [WalletModelFetcher requestPostWithUrl:_httpAddress
                                           params:postDict
                                    responseBlock:^(NSDictionary *responseDict, NSDictionary *responseHeaderFields, NSError *error)
            {
                [self analyseResponseInfo:responseDict
                             headerFileds:responseHeaderFields
                                    error:error];
                
            }];
        }
            break;
                    
        default:
            break;
    }
}

- (void)analyseResponseInfo:(NSDictionary *)responseData
               headerFileds:(NSDictionary *)headerFields
                      error:(NSError *)error {

    NSNumber *errCode = nil;
    NSString *errMsg = nil;
    self.resultModel = responseData;
    
    if (responseData != nil) {
        NSDictionary *dict = responseData;
        errCode = [dict valueForKey:@"code"];
        errMsg = [dict valueForKey:@"message"];
        self.resultDict = dict;
        
        if ([responseData isKindOfClass:[NSArray class]]) {
            self.status = RequestSuccess;
            [self convertJsonResultToModel:responseData];
            self.resultModel = responseData;
            self.successBlock(self);
            return;
        }
        
        if ((errCode != nil && [errCode integerValue] == 1) || (errCode.integerValue == 0)) {
        
            id objDict = nil;
            NSDictionary *dictEntity = [dict objectForKey:@"data"];
            if (_specialRequest) {
                objDict = responseData;
            }else if(dictEntity != nil && dictEntity != (NSDictionary *)[NSNull null]) {
                objDict = dictEntity;
            }else{
                objDict = responseData;
            }
            
            if(objDict && [objDict isKindOfClass:[NSDictionary class]]){  // The return may not be dict
                
                self.status = RequestSuccess;
                [self convertJsonResultToModel:objDict];
                
            }else{
                self.status = RequestSuccess;
                self.resultModel = objDict;
            }
            self.status = RequestSuccess;
            self.successBlock(self);
            return;
            
        } else {
            self.status = RequestFailed;
        }
        
    } else {
        if (self.supportOtherDataFormat) {
            if (error.code == 3840) {
                self.resultDict = nil;
                self.status = RequestSuccess;
                self.successBlock(self);
                return;
            }else{
                self.status = RequestFailed;
            }
        }else{
            self.status = RequestFailed;
        }
    }
    
    [self buildErrorInfoWithRequestError:error
                       responseErrorCode:errCode
                        responseErrorMsg:errMsg];
    
}

- (void)buildErrorInfoWithRequestError:(NSError *)error
                     responseErrorCode:(NSNumber *)errCode
                      responseErrorMsg:(NSString *)errMsg
{
    if (error) {
        // An error occurred while sending the request, and now the default is that the network is unavailable.
        NSData *errorData = error.userInfo[@"response.error.data"];
        NSString *errorInfo = [[NSString alloc]initWithData:errorData encoding:NSUTF8StringEncoding];
        
        NSDictionary *dictError = [NSJSONSerialization dictionaryWithJsonString:errorInfo];
        
        NSString *temp = dictError[@"message"];
        errMsg = temp.length > 0 ? temp : @"no network";
        errCode = dictError[@"code"];
        
        self.lastError = [NSError errorWithDomain:@"Wallet"
                                             code:errCode.integerValue
                                         userInfo:@{NSLocalizedFailureReasonErrorKey: errMsg.length > 0 ? errMsg : @"no network"}];
        
    }
    else if (nil == errCode || [errCode intValue] != 1) {
        
        if ([errMsg isEqual:[NSNull null]]) {
            errMsg = @"Unknown error";
        }else{
            errMsg = [errMsg length] ? errMsg : @"Unknown error";
        }
        
        self.lastError = [NSError errorWithDomain:@"Wallet"
                                             code:[errCode integerValue]
                                         userInfo:@{NSLocalizedFailureReasonErrorKey:errMsg}];
    } else {
        self.lastError = nil;
    }
    if (self.status == RequestFailed) {
        if (self.failBlock) {
            self.failBlock(self,errMsg);
        }
    }
}


@end
