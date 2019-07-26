//
//  WalletCheckVersionApi.m
//  Wallet
//
//  Created by VeChain on 2019/5/9.
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



#import "WalletCheckVersionApi.h"
#import "WalletDAppHeader.h"

@implementation WalletCheckVersionApi
{
    NSString *_language;
}
-(instancetype)initWithLanguage:(NSString *)language
{
    self = [super init];
    if (self){
        _language = language;
        
        self.requestMethod = RequestPostMethod;
        if ([[WalletUserDefaultManager getBlockUrl] isEqualToString: Test_Node]) {
            self.httpAddress = @"https://version-management-test.vechaindev.com/api/v1/version/";

        }else{
            self.httpAddress = @"https://version-management.vechain.com/api/v1/version/";
        }
    }
    return self;
}

-(NSMutableDictionary*)buildRequestDict
{
    // increase the parameter
    NSMutableDictionary* dict = [super buildRequestDict];
    [dict setValueIfNotNil:@"iOS" forKey:@"platformType"];
    [dict setValueIfNotNil:SDKVersion forKey:@"softwareVersion"];
    [dict setValueIfNotNil:_language forKey:@"language"];
    [dict setValueIfNotNil:@"appstore" forKey:@"channel"];
 
    if ([[WalletUserDefaultManager getBlockUrl] isEqualToString: Test_Node]) {
        [dict setValueIfNotNil:AppId_Test forKey:@"appid"];

     }else{
         [dict setValueIfNotNil:AppId forKey:@"appid"];
     }

    return dict;
}


-(Class)expectedModelClass
{
    return [NSDictionary class];
}
@end
