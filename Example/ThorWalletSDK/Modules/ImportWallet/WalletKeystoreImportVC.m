//
//  WalletKeystoreImportVC.m
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



#import "WalletKeystoreImportVC.h"
#import "WalletDetailVC.h"
#import "WalletMBProgressShower.h"
#import "WalletUtils.h"

@interface WalletKeystoreImportVC ()

@property (weak, nonatomic) IBOutlet UITextView *keystoreTextView;   /* It is used to input the wallet keystore */
@property (weak, nonatomic) IBOutlet UITextField *password;          /* The wallet new password that you want to create */

@end

@implementation WalletKeystoreImportVC


/**
*  Keystore is a json string. Its file structure is as follows:
*
*  — — — — — — — — — — — — — — — — — — — — — — — — — — ——
*      {
*          "version": 3,
*          "id": "F56FDA19-FB1B-4752-8EF6-E2F50A93BFB8",
*          "kdf": "scrypt",
*          "mac": "9a1a1db3b2735c36015a3893402b361d151b4d2152770f4a51729e3ac416d79f",
*          "cipher": "aes-128-ctr"
*          "address": "ea8a62180562ab3eac1e55ed6300ea7b786fb27d"
*          "crypto": {
*                      "ciphertext": "d2820582d2434751b83c2b4ba9e2e61d50fa9a8c9bb6af64564fc6df2661f4e0",
*                      "cipherparams": {
*                                          "iv": "769ef3174114a270f4a2678f6726653d"
*                                      },
*                      "kdfparams": {
*                              "r": 8,
*                              "p": 1,
*                              "n": 262144,
*                              "dklen": 32,
*                              "salt": "67b84c3b75f9c0bdf863ea8be1ac8ab830698dd75056b8133350f0f6f7a20590"
*                      },
*          },
*      }
*
*  — — — — — — — — — — — — — — — — — — — — — — — — — — ——
*  Field description:
*          version: This is a version information, when you decryption, you should use the same version.
*          id: You can ignore. It is just a UUIDString.
*          Kdf: This is a encryption function.
*          mac: This is the mac device information.
*          cipher: Describes the encryption algorithm used.
*          address：The wallet address.
*          crypto: This section is the main encryption area.
*
*  If you want to recover a wallet by keystore, you should have the correct password.
*
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.keystoreTextView.text = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    
    self.password.secureTextEntry = YES;
    self.password.text = @"123456";
}
/**
*  Recover a wallet by your keystore.
*/
- (IBAction)recoverWalletByKeystore:(id)sender{
    [self.view endEditing:YES];

    /*
     Please note that you should do more judges according to what your demand is.
     Here, We just do some simple judges. This is just a demo that tell you how to recover a wallet by keystore.
     */
    
    /* Check your input password and keystore that can not be blank. */
    if (self.password.text.length == 0 || self.keystoreTextView.text.length == 0) {
       
        [WalletMBProgressShower showMulLineTextIn:self.view
                                             Text:NSLocalizedString(@"input_empty", nil)
                                           During:1.5];
        return;
    }
    
    /* show loading state */
    [WalletMBProgressShower showTextIn:self.view Text:NSLocalizedString(@"wait", nil)];
    /*
     Please note that this is just a demo that tell you how to recover a wallet by keystore.
     We save the wallet keystore and addrss in the Sandbox by the class 'NSUserDefaults'. It is not a safety way.
     We do not recommend it. You can use some more better way to save it, like as Sqlite、CoreData and so on.
     In general, we recommend that you use some way of secure encryption.
     */
    
    /* Create a wallet with your password and keystore. */
    
    @weakify(self);
    [WalletUtils verifyKeystore:self.keystoreTextView.text.lowercaseString password:self.password.text callback:^(BOOL result) {
        @strongify(self);
        [WalletMBProgressShower hide:self.view];
        if (result) {
            
            NSString *address = [WalletUtils getAddressWithKeystore:self.keystoreTextView.text];
            NSMutableDictionary *walletDict = [[NSMutableDictionary alloc]init];
            [walletDict setObject:address forKey:@"address"];
            [walletDict setObject:self.keystoreTextView.text forKey:@"keystore"];
            [[NSUserDefaults standardUserDefaults]setObject:walletDict forKey:@"currentWallet"];
                        
            [self.navigationController popToRootViewControllerAnimated:NO];
            
            WalletDetailVC *detailVC = [[WalletDetailVC alloc]init];
            [self.navigationController pushViewController:detailVC animated:YES];
        }else{
            
            [WalletMBProgressShower showMulLineTextIn:self.view
                                                 Text:NSLocalizedString(@"Check_right", nil)
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


@end
