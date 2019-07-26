//
//  ThorViewController.m
//  ThorWalletSDK_Example
//
//  Created by VeChain on 2019/5/22.
//  Copyright © 2019 VeChain. All rights reserved.
//

#import "ThorViewController.h"
#import "YYModel.h"
#import "DAppWebViewVC.h"
#import "WalletCreateVC.h"
#import "WalletRecoverMainVC.h"
#import "WalletDetailVC.h"
#import "ThorTest.h"

@interface ThorViewController ()
{
    ThorTest *test;
}
@end

@implementation ThorViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /* Read the local cache information and decide whether to go to the detail ViewController */
    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentWallet"];;
    
    if (currentWallet) {
        
        WalletDetailVC *detailVC = [[WalletDetailVC alloc]init];
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:detailVC];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController presentViewController:nav animated:YES completion:NULL];
        });
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    test = [[ThorTest alloc]init];
    [test startTest];
}

/**
 *  Enter the Create Or Import ViewController to generate a wallet.
 */
- (IBAction)clickCreateOrImportWalletEvent:(UIButton *)sender{
    switch (sender.tag) {
        
        case 10:{
            WalletCreateVC *create = [[WalletCreateVC alloc] init];
            [self.navigationController pushViewController:create animated:YES];
        }break;
        
        case 11:{
            WalletRecoverMainVC *recoverVC = [[WalletRecoverMainVC alloc] init];
            [self.navigationController pushViewController:recoverVC animated:YES];
        }break;
        
        default:break;
    }
}



@end
