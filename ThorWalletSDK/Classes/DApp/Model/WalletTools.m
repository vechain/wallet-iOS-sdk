//
//  WalletTools.m
//  Wallet
//
//  Created by VeChain on 18/4/26.
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



#import "WalletTools.h"
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <dlfcn.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "WalletUtils.h"
#import "NSMutableDictionary+Helpers.h"
#import "AFNetworkReachabilityManager.h"
#import "WalletDAppHeader.h"
#import "NSJSONSerialization+NilDataParameter.h"
#import "YYModel.h"

@implementation WalletTools


+ (UIViewController*)getCurrentVC {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

+ (NSString *)checksumAddress:(NSString *)inputAddress
{
    Address *a = [Address addressWithString:inputAddress.lowercaseString];
    if (a) {
        return a.checksumAddress;
    }
    return inputAddress;
}

+ (NSMutableDictionary *)packageWithRequestId:(NSString *)requestId
                                         data:(id )data
                                         code:(NSInteger)code
                                      message:(NSString *)message
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValueIfNotNil:@(code) forKey:@"code"];
    [paramDict setValueIfNotNil:data forKey:@"data"];
    if (requestId.length > 0) {
        [paramDict setValueIfNotNil:requestId forKey:@"requestId"];
    }
    [paramDict setValueIfNotNil:message forKey:@"message"];
    return paramDict;
}


+ (void)callbackWithrequestId:(NSString *)requestId
                      webView:(WKWebView *)webView
                         data:(id)data
                   callbackId:(NSString *)callbackId
                         code:(NSInteger)code
{
    NSString *message = [self errorMessageWith:code];
    NSDictionary *packageDict = [WalletTools packageWithRequestId:requestId
                                                            data:data
                                                            code:code
                                                         message:message];
    NSString *newCallbackId = [NSString stringWithFormat:@"%@%@",callbackId,requestId];
    NSString *injectJS = [NSString stringWithFormat:@"%@('%@')",newCallbackId,[packageDict yy_modelToJSONString]];

    injectJS = [injectJS stringByReplacingOccurrencesOfString:@"\"nu&*ll\"" withString:@"null"];
//    NSLog(@"injectJS == %@",injectJS);
    
    [webView evaluateJavaScript:injectJS completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        if (error) {
//            NSLog(@"injectJS error == %@",error);
        }else {
//            NSLog(@"injectJS success");
        }
    }];
    
}

+ (NSString *)errorMessageWith:(NSInteger)code
{
    switch (code) {
        case 400:
            return ERROR_REJECTED_MSG;
            break;
        case 500:
            return ERROR_NETWORK_MSG;
            break;
            
        default:
            break;
    }
   return @"";
}

+ (BOOL)checkHEXStr:(NSString *)hex
{
    if (![hex isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if (hex.length == 0) {
        return NO;
    }
    if ([hex.lowercaseString hasPrefix:@"0x"] && hex.length >= 2) {
        NSString *regex =@"[0-9a-fA-F]*";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        return [predicate evaluateWithObject:[hex substringFromIndex:2]];
    }else{
       
        return NO;
    }
}

+ (BOOL)checkDecimalStr:(NSString *)decimalString
{
    if (![decimalString isKindOfClass:[NSString class]]) {
        return NO;
    }
    if (decimalString.length == 0) {
        return NO;
    }
    NSString *regex =@"[0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:decimalString];
}

+ (BOOL)errorAddressAlert:(NSString *)toAddress
{
    if ([toAddress isKindOfClass:[NSNull class]]) {
        return NO;
    }
    
    if (![toAddress isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if (toAddress.length != 42) {
        return NO;
        
    }else if (![toAddress hasPrefix:@"0x"]) {
        return NO;
        
    }else if ([[toAddress substringFromIndex:2].lowercaseString isEqualToString:[toAddress substringFromIndex:2]]) {
        
    }else{ //Not all lowercase, verify checksum
        NSString *checksumAddress = [WalletTools checksumAddress:toAddress.lowercaseString];
        if (![[toAddress substringFromIndex:2] isEqualToString:[checksumAddress substringFromIndex:2]]) {
            return NO;
        }
        return YES;
    }
    
    NSString *regex = @"^(0x){1}[0-9A-Fa-f]{40}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL allAreValidChar = [predicate evaluateWithObject:toAddress];
    if (!allAreValidChar) {
        
        return NO;
    }
    return YES;
}

+ (BOOL)checkKeystore:(NSString *)keystore
{
    if (keystore.length == 0) {
        return NO;
    }
    NSDictionary *dictKS = [NSJSONSerialization dictionaryWithJsonString:[keystore lowercaseString]];
    
    NSString *_id        = dictKS[@"id"];
    NSString *version    = dictKS[@"version"];
    NSDictionary *crypto = dictKS[@"crypto"];

    BOOL isOK = NO;
    if ( crypto && _id && version) {
        if ([crypto isKindOfClass:[NSDictionary class]]) {
            
            NSString *cipher           = crypto[@"cipher"];
            NSString *kdf              = crypto[@"kdf"];
            NSString *mac              = crypto[@"mac"];
            NSString *ciphertext       = crypto[@"ciphertext"];
            NSDictionary *kdfparams    = crypto[@"kdfparams"];
            NSDictionary *cipherparams = crypto[@"cipherparams"];

            if (cipher && ciphertext && cipherparams && kdf && kdfparams && mac) {
                if ([cipherparams isKindOfClass:[NSDictionary class]] && [kdfparams isKindOfClass:[NSDictionary class]]) {
                    isOK = YES;
                }
            }
        }else{
        }
    }
    return isOK;
}

+ (BOOL)isEmpty:(id )input
{
    if ([input isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if (input == nil) {
        return YES;
    }
    
    if ([input isKindOfClass:[NSString class]] ) {
        NSString *tempInput = (NSString *)input;
        
        if ([tempInput length] == 0) {
            return YES;
        }
        
        if ([tempInput isEqualToString:@"(null)"]) {
            return YES;
        }
    }
    
    return NO;
}

+ (NSString *)packageCertParam:(NSDictionary *)param
{
    NSMutableDictionary *dictOrigin = [NSMutableDictionary dictionaryWithDictionary:param];
    
    NSArray *keys = [dictOrigin allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSMutableArray *keyAndValueList = [NSMutableArray array];
    for (NSString *key in sortedArray) {
        NSString *value = dictOrigin[key];
        NSString *keyValue = nil;
        if ([value isKindOfClass:[NSNumber class]]) {
            NSNumber *num = (NSNumber *)value;
            value = ((NSNumber *)num).stringValue;
            
            keyValue = [NSString stringWithFormat:@"\"%@\":%@",key,value];
        }else if([value isKindOfClass:[NSDictionary class]])
        {
            keyValue = [NSString stringWithFormat:@"\"%@\":%@",key, [self packageCertParam:(NSDictionary *)value]];
        }else{
            keyValue = [NSString stringWithFormat:@"\"%@\":\"%@\"",key,value];
        }
        
        [keyAndValueList addObject:keyValue];
        
    }
    return [NSString stringWithFormat:@"{%@}",[keyAndValueList componentsJoinedByString:@","]];
}
@end
