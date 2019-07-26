//
//  WalletChangePWVC.m
//  walletSDKDemo
//
//  Created by VeChain on 2018/12/29.
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



#import "WalletChangePWVC.h"
#import "WalletUtils.h"
#import "WalletMBProgressShower.h"

@interface WalletChangePWVC ()

@property (weak, nonatomic) IBOutlet UITextField *oldPWTextField;     /* The wallet current password that you created */
@property (weak, nonatomic) IBOutlet UITextField *nextPWTextField;    /* The wallet new password that you want to create */
@property (weak, nonatomic) IBOutlet UITextField *makeSureTextField;  /* Check the new password */

@end

@implementation WalletChangePWVC


/**
*  Change wallet password.
*/
- (IBAction)changeTheWalletPassword:(id)sender{
    [self.view endEditing:YES];
    
    /*
      Please note that you should do more judges according to what your demand is.
      Here, We just do some simple judges. This is just a demo that tell you how to change the password.
     */
    
    /* Check your input password that can not be blank. */
    if (_oldPWTextField.text.length == 0 || _nextPWTextField.text.length == 0 || _makeSureTextField.text.length == 0) {
        
        [WalletMBProgressShower showMulLineTextIn:self.view
                                             Text:NSLocalizedString(@"input_empty", nil)
                                           During:1.5];
        return;
    }
    
    /*  Check the new password is correct. */
    if (![_nextPWTextField.text isEqualToString:_makeSureTextField.text]) {
        
        [WalletMBProgressShower showMulLineTextIn:self.view
                                             Text:NSLocalizedString(@"modify_password_new_error", nil)
                                           During:1.5];
        return;
    }
    
    /* show loading state */

    
    [WalletMBProgressShower showTextIn:self.view Text:NSLocalizedString(@"wait", nil)];
    
    /* Read the keystore and check the old password is vailable. */
    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentWallet"];
    NSString *keystore = currentWallet[@"keystore"];
    NSString *address = currentWallet[@"address"];
    
    
    [WalletUtils modifyKeystore:keystore newPassword:self.nextPWTextField.text oldPassword:_oldPWTextField.text callback:^(NSString *newKeystore) {
        
        [WalletMBProgressShower hide:self.view];

        if (newKeystore.length > 0) {
            NSMutableDictionary *currentDict = [NSMutableDictionary dictionary];
            [currentDict setObject:address forKey:@"address"];
            [currentDict setObject:newKeystore forKey:@"keystore"];
            
            [[NSUserDefaults standardUserDefaults]setObject:currentDict forKey:@"currentWallet"];;
            
            
            
            [WalletMBProgressShower showMulLineTextIn:self.view
                                                 Text:NSLocalizedString(@"modify_password_success", nil)
                                               During:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else {
            
            [WalletMBProgressShower showMulLineTextIn:self.view
                                                 Text:NSLocalizedString(@"modify_password_fail", nil)
                                               During:1.5];
        }
    }];
}


/**
*  Just hidden the keyboard.
*/
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


/**
 *  Just hidden the keyboard.
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

@end
