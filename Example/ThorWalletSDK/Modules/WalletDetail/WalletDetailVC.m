//
//  WalletDetailVC.m
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


#import "WalletDetailVC.h"
#import "AFNetworking.h"
#import "WalletTransferVC.h"
#import "WalletMoreInfoVC.h"
#import "DAppWebViewVC.h"
#import "WalletChooseNodeView.h"
#import "WalletNodeDetailVC.h"
#import "WalletAddVthoNodeVC.h"
#import "WalletDemoMacro.h"
#import "WalletUtils.h"

@interface WalletDetailVC ()<UISearchBarDelegate>
{
    NSString *_blockHost;  /* The main Node environment of block */
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstrant;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;       /* The wallet address that you created */
@property (weak, nonatomic) IBOutlet UILabel *vetAmountLabel;     /* The VET label */
@property (weak, nonatomic) IBOutlet UILabel *vthoAmountLabel;    /* The VTHO label */
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;      /* Search bar control */

@end

@implementation WalletDetailVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNodeEnvironmentHost];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
    
}


/**
*  Config subviews and load it.
*/
- (void)initView {
   
    /* Set right bar buttonItem */
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"host_select_txt", nil)
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(selectTheMainNodeEnvironment)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    /* Set UI */
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    if (systemVersion.doubleValue < 11.0) {
        self.topConstrant.constant = 70.0;
        
    } else {
        self.topConstrant.constant = 16.0;
    }
    
    self.searchBar.delegate = self;
    self.searchBar.text = @"https://bc66.github.io/lucky-airdrop/#/";
    
    /* Set the VET and VTHO logo */
    [self.vetImageView setImage:[UIImage imageNamed:@"VET"]];
    [self.vthoImageView setImage:[UIImage imageNamed:@"VTHO"]];
    
    
    /* Show the wallet address you created */
    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];
    self.addressLabel.text = currentWallet[@"address"];
    
    /* Set font adjust the the form */
    self.vetAmountLabel.adjustsFontSizeToFitWidth = YES;
    self.vthoAmountLabel.adjustsFontSizeToFitWidth = YES;

}



/**
*  Displays a selection of Node controls，then you can change the main Node environment
*  or add what you custom Node environment.
*/
- (void)selectTheMainNodeEnvironment {
    
    [self.view endEditing:YES];
    
    WalletChooseNodeView *chooseNodeView = [self.view viewWithTag:90];
    if (!chooseNodeView) {
        chooseNodeView = [[WalletChooseNodeView alloc] initWithFrame:self.view.frame];
        chooseNodeView.tag = 90;
        [self.view addSubview:chooseNodeView];
        @weakify(self)
        chooseNodeView.block = ^(NSString *nodeName, NSString *nodeUrl) {
            @strongify(self);
            if (nodeUrl.length == 0) {
                WalletAddVthoNodeVC *detailVC = [[WalletAddVthoNodeVC alloc]init];
                [self.navigationController pushViewController:detailVC animated:YES];
                
            }else{
                self.title = nodeName;
                
                [WalletUtils setNodeUrl:nodeUrl];
                
                WalletNodeDetailVC *detailVC = [[WalletNodeDetailVC alloc]init];
                [detailVC nodeName:nodeName nodeUrl:nodeUrl];
                [self.navigationController pushViewController:detailVC animated:YES];
            }
        };
    }
}


/**
*  Change the main node environment or add what you custom Node environment.
*/
- (void)setNodeEnvironmentHost{
    
    [self.searchBar resignFirstResponder]; /* The searchBar resign the first responder. */
    
    NSDictionary *dictCurrentNode = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentNode"];
    
    if (dictCurrentNode) { /* Set to the main node of your choice. */
        NSString *customServerUrl = dictCurrentNode[@"nodeUrl"];
        if (customServerUrl.length > 0 ) {
            _blockHost = customServerUrl;
            self.title = dictCurrentNode[@"nodeName"];
        }
    }
    
    if (_blockHost.length == 0) {  /* THe default block Host. */
        _blockHost = Main_Node;
        self.title = NSLocalizedString(@"item0", nil);
        
        NSMutableDictionary *serverDict = [NSMutableDictionary dictionary];
        [serverDict setObject:_blockHost forKey:@"nodeUrl"];
        [serverDict setObject:self.title forKey:@"nodeName"];
    }
    
    
    [WalletUtils setNodeUrl:_blockHost];
    
    self.vthoAmountLabel.text = @"0.00";
    self.vetAmountLabel.text = @"0.00";
    
    [self getVETBalance];
    [self getVTHOBalance];
}


/**
*  Get the VET balance from Node environment, '_blockHost' is a Node variable. Which Node environment
*  they work in depends on how you set it up.
*/
- (void)getVETBalance {
    NSString *urlString = [NSString stringWithFormat:@"%@/accounts/%@", _blockHost, self.addressLabel.text];
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [httpManager GET:urlString
          parameters:nil
            progress:^(NSProgress * _Nonnull uploadProgress) {
                
            }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
                 
         NSDictionary *dictResponse = (NSDictionary *)responseObject;
         NSString *amount = dictResponse[@"balance"];
         BigNumber *bigNumberCount = [BigNumber bigNumberWithHexString:amount];
         
         NSString *coinAmount = @"0.00";
         coinAmount = [self weiConvertAmount:bigNumberCount
                                          dicimals:18]; //coin decimals]
         self.vetAmountLabel.text = coinAmount;
                 
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"Get VET balance failure. error: %@", error);
    }];
}


/**
*  Get the VTHO balance from Node environment, '_blockHost' is a Node variable . Which Node environment
*  they work in depends on how you set it up.
*  'vthoTokenAddress' is a fixed contract address. It is declarationed in the file of 'WalletDemoMacro.h'.
*  vthoTokenAddress : '0x0000000000000000000000000000456e65726779'
*/
- (void)getVTHOBalance {
    NSString *contractAddress = [NSString stringWithFormat:@"/accounts/%@", vthoTokenAddress];
    NSString *urlString = [_blockHost stringByAppendingString:contractAddress];

    NSMutableDictionary *dictParm = [NSMutableDictionary dictionary];
    [dictParm setObject:[self tokenBalanceData:self.addressLabel.text] forKey:@"data"];
    [dictParm setObject:@"0x0" forKey:@"value"];
    
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [httpManager POST:urlString
           parameters:dictParm
             progress:^(NSProgress * _Nonnull uploadProgress) {
                 
             }
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
        NSDictionary *dictResponse = (NSDictionary *)responseObject;
        NSString *amount = dictResponse[@"data"];
        BigNumber *bigNumberCount = [BigNumber bigNumberWithHexString:amount];

        NSString *coinAmount = [self weiConvertAmount:bigNumberCount dicimals:18];
        self.vthoAmountLabel.text = coinAmount;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Get VTHO balance failure. error: %@", error);
    }];
}


/**
*  This method is used to splicing header information.
*  The total length of the header is 34 and the rule is: 0x + methodID + twentyfour 0's.
*  MethodID is an 8-length hex string , used to access methods on a contract.
*/
- (NSString *)tokenBalanceData:(NSString *)toAddress {
    if ([[toAddress lowercaseString] hasPrefix:@"0x"]) {
        toAddress = [toAddress stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    }
    NSString *head = @"0x70a08231000000000000000000000000";
    NSString *data = [NSString stringWithFormat:@"%@%@",head,toAddress];
    return data;
}


#pragma mark -- UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSURL *URL = [NSURL URLWithString: searchBar.text];
    
    if([[UIApplication sharedApplication] canOpenURL:URL]){
        
        DAppWebViewVC *webVC = [[DAppWebViewVC alloc] initWithURL:URL];
        [self.navigationController pushViewController:webVC animated:YES];
        
    }else {
        NSLog(@"error: The url is invalid.");
    }
}



#define click event

/**
*  Enter the address detail ViewControll and see more information.
*/
- (IBAction)enterMoreInfo:(id)sender {
    WalletMoreInfoVC *moreInfoVC = [[WalletMoreInfoVC alloc] init];
    [self.navigationController pushViewController:moreInfoVC animated:YES];
}


/**
*  Enter the transfer ViewControll and do some transactions.
*/
- (IBAction)enterTransfer:(id)sender {
    [self.searchBar resignFirstResponder];
    
    WalletTransferVC *transfer = [[WalletTransferVC alloc] init];
    
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 10) { /* vet transfer */
        transfer.isVET = YES;
        transfer.coinAmount = [self.vetAmountLabel.text stringByReplacingOccurrencesOfString:@"," withString:@""];
        
    }else if (btn.tag == 20){ /* vtho transfer */
        transfer.isVET = NO;
        transfer.coinAmount = [self.vthoAmountLabel.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    
    [self.navigationController pushViewController:transfer animated:YES];
}


/**
*  Just hidden the keyboard.
*/
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (NSString *)weiConvertAmount:(BigNumber *)wei dicimals:(NSInteger )dicimals
{
    NSDecimalNumber *amountNumber = [NSDecimalNumber decimalNumberWithString:wei.decimalString];
    NSDecimalNumber *dicimalNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",pow(10, dicimals)]];
    NSDecimalNumber *weiNumber = [amountNumber decimalNumberByDividingBy:dicimalNumber];
    
    return weiNumber.stringValue;
}

@end
