//
//  WalletAddVthoNodeVC.m
//  walletSDKDemo
//
//  Created by VeChain on 2019/1/30.
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



#import "WalletAddVthoNodeVC.h"
#import "WalletMBProgressShower.h"
#import "WalletUtils.h"

@interface WalletAddVthoNodeVC ()

@property (weak, nonatomic) IBOutlet UITextField *customNameTextFild;   /*  It is used to input the custom node environment name */
@property (weak, nonatomic) IBOutlet UITextView *customNodeTextView;     /*  It is used to input the custom node environment URL */

@end

@implementation WalletAddVthoNodeVC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Add Custom Node";
}


/**
*  Set and save custom node environment.
*/
- (IBAction)setCustomNodeEnvironment:(id)sender{
    
    NSString *nodeName = self.customNameTextFild.text;
    NSString *nodeUrl = self.customNodeTextView.text;
    
    
    /* Check your input node name and node URL that can not be blank. */
    if (nodeName.length == 0 || nodeUrl.length == 0 ){
        
        [WalletMBProgressShower showMulLineTextIn:self.view
                                             Text:@"The input cannot be blank."
                                           During:1.5];
        return;
    }
    
    
    /* Check your URL is available */
    NSURL *URL = [NSURL URLWithString:nodeUrl];
    if (![[UIApplication sharedApplication] canOpenURL:URL]) {
        
        [WalletMBProgressShower showMulLineTextIn:self.view
                                             Text:@"The URL is not available."
                                           During:1.5];
        return;
    }
    
    
    NSArray *oldList = [[NSUserDefaults standardUserDefaults] objectForKey:@"nodeList"];
    NSMutableArray *newList = [NSMutableArray arrayWithArray:oldList];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:nodeName forKey:@"nodeName"];
    [dict setObject:nodeUrl forKey:@"nodeUrl"];
    [newList addObject:dict];
    
    [[NSUserDefaults standardUserDefaults] setObject:newList forKey:@"nodeList"];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"currentNode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [WalletUtils setNodeUrl:nodeUrl];

    [self.navigationController popViewControllerAnimated:YES];
}


/**
*  Just hidden the keyboard.
*/
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
