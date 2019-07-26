//
//  WalletModelFetcher.m
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



#import "WalletModelFetcher.h"
#import "AFNetworking.h"
#import "NSMutableDictionary+Helpers.h"

@interface WalletModelFetcher()

@end

@implementation WalletModelFetcher

+ (void)requestGetWithUrl:(NSString*)aUrl
                   params:(NSMutableDictionary*)dict
            responseBlock:(responseBlock)block
{
    NSString *urlString = [NSString stringWithString:aUrl];
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    httpManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [httpManager GET:urlString parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *headerFields = [(NSHTTPURLResponse *)task.response allHeaderFields];

        block(responseObject,headerFields,nil);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSDictionary *headerFields = [(NSHTTPURLResponse *)task.response allHeaderFields];
        block(nil,headerFields,error);
    }];
}

+ (void)requestPostWithUrl:(NSString*)aUrl
                    params:(NSMutableDictionary*)dict
             responseBlock:(responseBlock)block
{
    NSString *urlString = [NSString stringWithString:aUrl];
    
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    httpManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;

    [WalletModelFetcher setHeaderInfo:httpManager];
    
    [httpManager POST:urlString parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *headerFields = [(NSHTTPURLResponse *)task.response allHeaderFields];
        block(responseObject,headerFields,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *headerFields = [(NSHTTPURLResponse *)task.response allHeaderFields];
        block(nil,headerFields,error);
    }];
}


+ (void)setHeaderInfo:(AFHTTPSessionManager *)httpManager
{
    [httpManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
}


@end
