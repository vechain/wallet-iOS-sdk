//
//  WalletDemoTool.m
//  ThorWalletSDK_Example
//
//  Created by VeChain on 2019/6/10.
//  Copyright © 2019 VeChain. All rights reserved.
//

#import "WalletDemoTool.h"

@implementation WalletDemoTool

+ (void)alertCurrentVC:(UIViewController *)currentVC message:(NSString *)message actionWithTitle:(NSString *)actionWithTitle callback:(void(^)(NSString *input))callback
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:([UIAlertAction actionWithTitle: actionWithTitle
                                                         style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                 {
                                     if (callback) {
                                         UITextField *textF =  alertController.textFields.lastObject;

                                         callback(textF.text);
                                     }
                                     
                                 }])];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.secureTextEntry = YES;
        textField.placeholder = @"Please enter the wallet password";
    }];
    
    [currentVC presentViewController:alertController animated:YES completion:nil];
    
}
@end
