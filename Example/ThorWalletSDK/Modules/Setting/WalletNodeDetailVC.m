//
//  WalletNodeDetailVC.m
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



#import "WalletNodeDetailVC.h"
#import "WalletMBProgressShower.h"
#import "WalletDemoMacro.h"
#import "WalletUtils.h"

@interface WalletNodeDetailVC ()
{
    NSString *_nodeNameText;   /*  It‘s a temp variable that used to save node environment name */
    NSString *_nodeUrlText;    /*  It‘s a temp variable that used to save node environment URL */
}
@property (weak, nonatomic) IBOutlet UILabel *nodeName;   /* It's used to show node environment name */
@property (weak, nonatomic) IBOutlet UILabel *nodeUrl;    /* It's used to show node environment URL */

@end

@implementation WalletNodeDetailVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _nodeName.text = _nodeNameText;
    _nodeUrl.text = _nodeUrlText;
}


/**
*  Just save the node environment URL and name.
*/
- (void)nodeName:(NSString *)nodeName nodeUrl:(NSString *)nodeUrl{
    _nodeNameText = nodeName;
    _nodeUrlText = nodeUrl;
}


/**
*  Delete the you custom node environment.
*/
- (IBAction)deleteCustomNewWork:(id)sender {
    
    NSArray *oldList = [[NSUserDefaults standardUserDefaults] objectForKey:@"nodeList"];
    
    if (oldList.count == 0) {
        
        [WalletMBProgressShower showMulLineTextIn:self.view
                                             Text:@"It's not a custom node."
                                           During:1.5];
        
        return;
    }
    
    NSMutableArray *newList1 = [NSMutableArray arrayWithArray:oldList];
    NSMutableArray *newList2 = [NSMutableArray arrayWithArray:oldList];
    
    BOOL isEqual = NO;
    for (NSDictionary *dic in newList1) {
        NSString *tempUrl = dic[@"nodeUrl"];
        if ([_nodeUrlText isEqualToString:tempUrl]) {
            [newList2 removeObject:dic];
            isEqual = YES;
            break;
        }
    }
    
    if (isEqual) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:NSLocalizedString(@"item1", nil) forKey:@"nodeName"];
        [dict setObject:Test_Node forKey:@"nodeUrl"];
        
        [[NSUserDefaults standardUserDefaults] setObject:newList2 forKey:@"nodeList"];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"currentNode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [WalletUtils setNodeUrl:Test_Node];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        
        [WalletMBProgressShower showMulLineTextIn:self.view
                                             Text:@"It's not a custom node."
                                           During:1.5];
    }
}


@end
