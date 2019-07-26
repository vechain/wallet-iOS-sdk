
//  WalletBaseApi.h
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


#import <Foundation/Foundation.h>
#import "WalletBaseApi.h"
#import "WalletHeader.h"
#import "WalletHeader.h"

typedef NS_ENUM(NSInteger, WalletRequestStatus){
    NotAvailable = 1,
    RequestSuccess = 2,
    RequestFailed = 4,
};

typedef NS_ENUM(NSInteger,RequestMethod)
{
    RequestPostMethod = 1,      //post
    RequestGetMethod = 2,       //get
};

@class WalletBaseApi;
typedef void(^WalletLoadSuccessBlock) (WalletBaseApi *finishApi);
typedef void(^WalletLoadFailBlock) (WalletBaseApi *finishApi,NSString *errMsg);

typedef void (^requestBlock)(NSDictionary *requestDict,NSError *error);

@interface WalletBaseApi : NSObject
{
    
    
}

@property (nonatomic, copy) WalletLoadSuccessBlock successBlock;
@property (nonatomic, copy) WalletLoadFailBlock failBlock;
@property (nonatomic, copy) NSString *httpAddress; // Request address
@property (nonatomic, strong) NSMutableDictionary *requestParmas;
@property (nonatomic, strong) NSError *lastError;
@property (nonatomic, assign) BOOL specialRequest; // Special request return processing
@property (nonatomic, assign) WalletRequestStatus status;
@property (nonatomic, assign) RequestMethod requestMethod;
/**
 *  Requested final data model
 */
@property (strong, nonatomic) id resultModel;
/**
 *  All data requested
 */
@property (strong, nonatomic) NSDictionary *resultDict;

/**
 *  Whether the request supports other data types. The default value of NO means that it is not supported. Only JSON is supported.
 */
@property (assign, nonatomic) BOOL supportOtherDataFormat;


/**

 *  Request parameters and fields
 *
 */
- (NSMutableDictionary *)buildRequestDict;

/**
 *  失败信息
 *
 *  @param error   Error obj
 *  @param errCode Fail code
 *  @param errMsg  Failed message
 */
- (void)buildErrorInfoWithRequestError:(NSError *)error
                     responseErrorCode:(NSNumber *)errCode
                      responseErrorMsg:(NSString *)errMsg;



/**
 *  Expected obj data type
 *
 */
- (Class)expectedJsonObjClass;

/**
 *  Expected to return the Model type, the subclass needs to override this method, the default is expectedJsonObjClass
 *
 */
- (Class)expectedModelClass;

/**
 *  Convert the data in obj to Model, the default call yy_modelWithDictionary conversion
 *
 */
- (void)convertJsonResultToModel:(NSDictionary *)jsonDict;

/**
 *  Initiate a network request
 *
 *  @param success  block
 *  @param failure  block
 */
- (void)loadDataAsyncWithSuccess:(WalletLoadSuccessBlock)success
                         failure:(WalletLoadFailBlock)failure;

/**
 *  Analyze error messages
 *
 *  @param requestDict Server returns data
 *  @param error       Error message
 */
- (void)analyseResponseInfo:(NSDictionary *)requestDict
               headerFileds:(NSDictionary *)headerFields
                      error:(NSError *)error;

@end
