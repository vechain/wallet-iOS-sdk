//
//  WalletMnemonicImportVC.m
//  walletSDKDemo
//
//  Created by VeChain on 2018/12/26.
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



#import "WalletMnemonicImportVC.h"
#import "WalletDetailVC.h"
#import "WalletMBProgressShower.h"
#import "WalletUtils.h"


@interface WalletMnemonicImportVC ()

@property (weak, nonatomic) IBOutlet UITextView *importMnemonicWords;   /* It is used to input the wallet mnemonic words */
@property (weak, nonatomic) IBOutlet UITextField *password;             /* The wallet new password that you want to create */

@end

@implementation WalletMnemonicImportVC

/**
*  Mnemonic words are taken from a fixed thesaurus, and the number of mnemonic words generated is different in different dimensions.
*  This demo uses 12 english mnemonic words. Like as follows:
*  — — — — — — — — — — — — — — — — — — — — — — — — — — ——
*    since scrub way wheel omit flush shield remove idea recipe behind mesh
*  — — — — — — — — — — — — — — — — — — — — — — — — — — ——
*  Please note that:
*          1、Every Mnemonic word is a correct word.
*          2、Mnemonic words are separated by Spaces.Do not use other separator.
*          3、Mnemonic words are strictly case-limited and all are lowercase.
*          4、Mnemonic words are fastidious about correct spelling.
*          5、Do not cotain any other special character，such as "" 、; 、: and so on.
*
*  When you recovered a wallet by Mnemonic words, then you should take care of your Mnemonic words and password.
*  Because once you lose it, it means you lose your crypto assets, and you can't get it back.
*
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.importMnemonicWords.text = @"enact again rate alone congress scheme solid theory flush length twenty head";
    
    self.password.secureTextEntry = YES;
    self.password.text = @"123456";
}
/**
*  Recover a wallet by your mnemonic words.
*/
- (IBAction)recoverWalletByMnemonicWords:(id)sender{
    [self.view endEditing:YES];
    
    /*
     Please note that you should do more judges according to what your demand is.
     Here, We just do some simple judges. This is just a demo that tell you how to recover a wallet by mnemonic words.
     */
    
    
    /* Removing the string both ends the whitespace and newline characters. */
    NSString *string = self.importMnemonicWords.text;
    NSString *mnemonicWords = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    /* Check your input password and mnemonic words that can not be blank. */
    if (self.password.text.length == 0 || mnemonicWords.length == 0){
      
        [WalletMBProgressShower showMulLineTextIn:self.view
                                             Text:NSLocalizedString(@"input_empty", nil)
                                           During:1.5];
        return;
    }
    
    /* Check your input mnemonic words are available. */
    NSArray *arr = [mnemonicWords componentsSeparatedByString:@" "];
    if (![WalletUtils isValidMnemonicWords:arr]) {
        
        [WalletMBProgressShower showMulLineTextIn:self.view
                                             Text:NSLocalizedString(@"mnemonic_not_available", nil)
                                           During:1.5];
        return;
    }
    
    /* show loading state */
   
    [WalletMBProgressShower showTextIn:self.view Text:NSLocalizedString(@"wait", nil)];

    
    /* Create a wallet with your password and mnemonic words. */
    [WalletUtils createWalletWithMnemonicWords:arr
                                password:self.password.text
                                callback:^(WalletAccountModel *account, NSError *error)
     {
         [WalletMBProgressShower hide:self.view];
         
         if (error) {
             NSLog(@"error：%@", error);
             return ;
         }
         
         [self.navigationController popToRootViewControllerAnimated:NO];
         
         WalletDetailVC *detailVC = [[WalletDetailVC alloc]init];
         [self.navigationController pushViewController:detailVC animated:YES];
         
         
         /*
          Please note that this is just a demo that tell you how to recover a wallet by mnemonic words.
          We save the wallet keystore and addrss in the Sandbox by the class 'NSUserDefaults'. It is not a safety way.
          We do not recommend it. You can use some more better way to save it, like as Sqlite、CoreData and so on.
          In general, we recommend that you use some way of secure encryption.
          */
         NSMutableDictionary *walletDict = [[NSMutableDictionary alloc]init];
         [walletDict setObject:account.address forKey:@"address"];
         [walletDict setObject:account.keystore forKey:@"keystore"];
         [[NSUserDefaults standardUserDefaults]setObject:walletDict forKey:@"currentWallet"];
     }];
}


/**
 *  Just hidden the keyboard.
 */
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
