//
//  WalletMoreInfoVC.m
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



#import "WalletMoreInfoVC.h"
#import "WalletChangePWVC.h"
#import "WalletUtils.h"

@interface WalletMoreInfoVC ()

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;         /* The wallet address that you created */
@property (weak, nonatomic) IBOutlet UITextView *keystoreTextView;  /* It is used to show the wallet keystore that you exported */

@end

@implementation WalletMoreInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
}


/**
*  Config subviews and load it.
*/
- (void)initView{
    
    self.keystoreTextView.layer.borderWidth = 1.0;
    self.keystoreTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentWallet"];
    self.addressLabel.text = currentWallet[@"address"];
    self.addressLabel.adjustsFontSizeToFitWidth = YES;
}


/**
*  Enter the change password ViewControll.
*/
- (IBAction)changeWalletPassWord:(id)sender {
    WalletChangePWVC *changeVC = [[WalletChangePWVC alloc]init];
    [self.navigationController pushViewController:changeVC animated:YES];
}


/**
*  Export the wallet keystore.
*/
- (IBAction)exportWalletKeystore:(id)sender {
    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentWallet"];
    NSString *keystore = currentWallet[@"keystore"];
    self.keystoreTextView.text = keystore;
}


/**
*  Delete the current wallet by the class 'NSUserDefaults'.
*  Please note that this is just a demo, We save the wallet information in your SandBox by the class 'NSUserDefaults'.
*  You should think about the safety and operation, then get a better way to save your wallet information.
*/
- (IBAction)delCurrentWallet:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentWallet"];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
