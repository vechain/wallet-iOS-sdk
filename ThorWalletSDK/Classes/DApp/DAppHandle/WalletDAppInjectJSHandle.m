//
//  WalletDAppInjectJSHandle.m
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

#import "WalletCheckVersionApi.h"
#import "WalletDAppInjectJSHandle.h"
#import "WalletVersionModel.h"

@implementation WalletDAppInjectJSHandle

+ (void)checkVersion:(void (^)(WalletVersionModel *versionModel))callback
{
    
    // Check sdk version
    WalletCheckVersionApi *checkApi = [[WalletCheckVersionApi alloc]initWithLanguage:[self getLanuage]];
    [checkApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        
        NSDictionary *dataDict = finishApi.resultDict[@"data"];
       
       WalletVersionModel *versionModel = [WalletVersionModel yy_modelWithDictionary:dataDict];
    
        callback(versionModel);
        
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        
    }];
}

+ (BOOL)analyzeVersion:(WalletVersionModel *)versionModel
{
    if (versionModel == nil) {
        return NO;
    }
    NSString *update        = versionModel.update;
    NSString *latestVersion = versionModel.latestVersion;
    NSString *description   = versionModel.pdescription;
    NSString *timeStampString = versionModel.releasets;
    
    NSTimeInterval interval    =[timeStampString doubleValue];
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    
    //Update = 1 : forced upgrade
    if (update.boolValue) {
        NSLog(@"\n Wallet SDK must update version url:%@ \n Current version:%@ \n Latest version:%@ \n WHAT'S NEW:%@ \n Updated:%@",versionModel.url,SDKVersion,latestVersion,description,dateString);
    }else{
        if (![SDKVersion isEqualToString:latestVersion]) {
            NSLog(@"\n Wallet SDK update version url:%@ \n Current version:%@ \n Latest version:%@ \n WHAT'S NEW:%@ \n Updated:%@",versionModel.url,SDKVersion,latestVersion,description,dateString);
        }
    }
    
    return update.boolValue;
}

+ (void)inject:(WKWebViewConfiguration *)config
{
    NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath
                            stringByAppendingPathComponent:@"/ThorWalletSDKBundle.bundle"];
    
    
    if(!bundlePath){
        NSLog(@"Injecting js failed");
        return ;
    }
    NSString *path = [bundlePath stringByAppendingString:@"/connex.js"];
    NSString *connex_js = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    connex_js = [connex_js stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    WKUserScript* userScriptConnex = [[WKUserScript alloc] initWithSource:connex_js
                                                            injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                         forMainFrameOnly:YES];
    [config.userContentController addUserScript:userScriptConnex];
    
    
    //Inject web3 js
    NSString *web3Path = [bundlePath stringByAppendingString:@"/web3.js"];
    NSString *web3js = [NSString stringWithContentsOfFile:web3Path encoding:NSUTF8StringEncoding error:nil];
    web3js = [web3js stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    WKUserScript* userScriptWeb3 = [[WKUserScript alloc] initWithSource:web3js
                                                          injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                       forMainFrameOnly:YES];
    [config.userContentController addUserScript:userScriptWeb3];
}

// Get phone language
+(NSString *)getLanuage
{
    NSString *language = @"";
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *localeLanguageCode = [appLanguages objectAtIndex:0];
    
    if ([localeLanguageCode containsString:@"zh"]) {
        language = @"zh-Hans";
        
    }else{
        language = @"en";
    }
    
    return language;
}

@end
