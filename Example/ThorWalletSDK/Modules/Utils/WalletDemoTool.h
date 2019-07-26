//
//  WalletDemoTool.h
//  ThorWalletSDK_Example
//
//  Created by VeChain on 2019/6/10.
//  Copyright © 2019 VeChain. All rights reserved.
//
#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletDemoTool : NSObject

+ (void)alertCurrentVC:(UIViewController *)currentVC message:(NSString *)message actionWithTitle:(NSString *)actionWithTitle callback:(void(^)(NSString *input))callback;

@end

NS_ASSUME_NONNULL_END
