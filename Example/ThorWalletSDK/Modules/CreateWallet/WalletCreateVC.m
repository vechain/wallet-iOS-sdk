//
//  WalletCreateVC.m
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



#import "WalletCreateVC.h"
#import "WalletUtils.h"
#import "WalletMBProgressShower.h"

@interface WalletCreateVC ()

@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;    /* It is used to input the wallet password */

@property (weak, nonatomic) IBOutlet UITextView *mnemonicTextView;  /* It is used to show the wallet mnemonic words when you create success */
@property (weak, nonatomic) IBOutlet UITextView *keystoreTextVeiw;  /* It is used to show the wallet keystore when you create success */
@property (weak, nonatomic) IBOutlet UITextView *addressLabel;      /* It is used to show the wallet address when you create success */

@property (weak, nonatomic) IBOutlet UIView *topCoverView;          /* Base view control */
@property (weak, nonatomic) IBOutlet UIView *bottomCoverView;       /* Base view control */

@end

@implementation WalletCreateVC

- (void)viewDidLoad
{
    self.passwordLabel.secureTextEntry = YES;
}

/**
* Create a wallet.
*/
- (IBAction)createWallet:(id)sender{
    [self.view endEditing:YES];
   
//    [self signAndRecover];
    /*
     Please note that you should do more judges according to what your demand is.
     Here, We just do some simple judges. This is just a demo that tell you how to create a wallet.
     */
    
    
    /* Check the password can not be blank. */
    if (self.passwordLabel.text.length  == 0) {
        [WalletMBProgressShower showMulLineTextIn:self.view
                                             Text:NSLocalizedString(@"input_empty", nil)
                                           During:1.5];
        return;
    }
    
    
    /* show loading state. */
   
    [WalletMBProgressShower showTextIn:self.view Text:NSLocalizedString(@"wait", nil)];

    
    /* Create a wallet with your password. */
    [WalletUtils createWalletWithPassword:self.passwordLabel.text
                                 callback:^(WalletAccountModel *account, NSError *error)

    {
        [WalletMBProgressShower hide:self.view];
        
        self.bottomCoverView.hidden = YES;
        self.topCoverView.hidden = NO;
        
        self.mnemonicTextView.text = [account.words componentsJoinedByString:@" "];
        self.addressLabel.text = account.address;
        NSString *privateKey = account.privatekey;
        self.keystoreTextVeiw.text = account.keystore;
        
        NSLog(@"\n **********\n mnemonic words = %@\n wallet address = %@\n wallet privateKey = %@\n keystore = %@\n **********", self.mnemonicTextView.text, self.addressLabel.text, privateKey, self.keystoreTextVeiw.text);
        
        /*
           Please note that this is just a demo that tell you how to create a wallet. We save the wallet
           keystore and addrss in the Sandbox by the class 'NSUserDefaults'. It is not a safety way.
           We do not recommend it. You can use some more better way to save it, like as Sqlite、CoreData and so on.
           In general, we recommend that you use some way of secure encryption.
         */
        NSMutableDictionary *currentDict = [NSMutableDictionary dictionary];
        [currentDict setObject:account.keystore forKey:@"keystore"];
        [currentDict setObject:account.address forKey:@"address"];
        [[NSUserDefaults standardUserDefaults]setObject:currentDict forKey:@"currentWallet"];
    }];
}


/**
* Just hidden the keyboard.
*/
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)signAndRecover
{
    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    
    [WalletUtils signWithMessage:messageData
                        keystore:keystore
                        password:@"123456"
                        callback:^(NSData *signatureData)
    {
        NSString *address = [WalletUtils recoverAddressFromMessage:messageData signatureData:signatureData];
        NSLog(@"address == %@",address);
    }];
}

- (void)checkMnemonicWords
{
    NSString *test = @"admit mad dream stable scrub rubber cabbage exist maple excuse copper month";
    BOOL result = [WalletUtils isValidMnemonicWords:[test componentsSeparatedByString:@" "]];
}

- (void)checkKeystore
{
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    BOOL result = [WalletUtils isValidKeystore:keystore];
    
    
    
}


@end
