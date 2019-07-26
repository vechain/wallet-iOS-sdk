//
//  WalletDappSimulateMultiAccountApi.m
//  Wallet
//
//  Created by VeChain on 2019/4/11.
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



#import "WalletDappSimulateMultiAccountApi.h"
#import "YYModel.h"

@implementation WalletDappSimulateMultiAccountApi
{
    NSArray *_clauseList;
    NSDictionary *_opts;
}

-(instancetype)initClause:(NSArray *)clauseList opts:(NSDictionary *)opts  revision:(NSString *)revision
{
    self = [super init];
    if (self){
        self.requestMethod = RequestPostMethod;
        _clauseList = clauseList;
        _opts = opts;
        
         self.httpAddress =  [NSString stringWithFormat:@"%@/accounts/*",[WalletUserDefaultManager getBlockUrl]];
        if (revision.length > 0) {
            NSString *temp = [NSString stringWithFormat:@"?revision=%@",revision];
            self.httpAddress = [self.httpAddress stringByAppendingString:temp];
        }
    }
    
    return self;
}

-(NSMutableDictionary*)buildRequestDict
{
    // increase the parameter
    NSMutableDictionary* dict = [super buildRequestDict];
    
    NSMutableArray *clauseList = [NSMutableArray array];
    
    for (id clause in _clauseList) {
        if ([clause isKindOfClass:[ClauseModel class]]) {
            
            NSString *strClause = [clause yy_modelToJSONString];
            NSDictionary *dictClause = [NSJSONSerialization dictionaryWithJsonString:strClause];
            [clauseList addObject:dictClause];
        }else{
            [clauseList addObject:clause];
        }
    }
    
    [dict setValueIfNotNil:clauseList           forKey:@"clauses"];
    [dict setValueIfNotNil:_opts[@"gas"]        forKey:@"gas"];
    [dict setValueIfNotNil:_opts[@"gasPrice"]   forKey:@"gasPrice"];
    [dict setValueIfNotNil:_opts[@"caller"]     forKey:@"caller"];
    
    return dict;
}


-(Class)expectedModelClass
{
    return [NSDictionary class];
}

@end
