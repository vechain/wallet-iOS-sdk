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
//
//  DAppWebViewVC.m
//  walletSDKDemo
//
//  Created by VeChain on 2019/1/29.
//  Copyright © 2019 VeChain. All rights reserved.
//

#import "DAppWebViewVC.h"
#import <WebKit/WebKit.h>
#import "WalletDemoMacro.h"
#import "WalletUtils.h"
#import "WalletDemoTool.h"
#import "WalletMBProgressShower.h"

@interface DAppWebViewVC ()<WKNavigationDelegate,WKUIDelegate,WalletDAppHandleDelegate>
{
    NSURL *_URL;
    WKWebView *_webView;  /* It is a 'WKWebView' object that used to interact with dapp. */
    WalletDAppHandle *_dAppHandle;
}

@end

@implementation DAppWebViewVC

- (instancetype)initWithURL:(NSURL *)URL{
    self = [super init];
    if (self) {
        _URL = URL;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Generate WalletDAppHandle object
    _dAppHandle = [[WalletDAppHandle alloc]init];
    // Set delegate
    _dAppHandle.delegate = self;
    /*
     Please note that, This is a 'WKWebView' object, does not support a "UIWebView" object.
     */
    
    WKWebViewConfiguration* configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [[WKUserContentController alloc] init];
    
    //inject js to wkwebview
    [_dAppHandle injectJSWithConfig:configuration];
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) configuration:configuration];
    _webView.UIDelegate = self;             /* set UIDelegate */
    _webView.navigationDelegate = self;     /* set navigationDelegate */
    
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:_URL
                                                              cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                          timeoutInterval:30.0];
    [_webView loadRequest:theRequest];
    [self.view addSubview:_webView];    
}


#pragma mark -- WKUIDelegate

/**
* You must implement this method that is used to response js feedback。
*/
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    /* This method can be called if you want to display js call information. This is optional. */
    [self alertMessage:message];
    
    completionHandler();
}


/**
* Show the js call information.
*/
- (void)alertMessage:(NSString *)message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:message?:@""
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:([UIAlertAction actionWithTitle: @"Confirm"
                                                         style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                         }])];
    [self presentViewController:alertController animated:YES completion:nil];
}


/**
* You must implement this delegate method to call js.
*/
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
        
    /*
     You must call this method. It is used to response web3 or connex operations.
     */
    [_dAppHandle webView:webView  defaultText:defaultText completionHandler:completionHandler];
}

- (void)clickBackBtnClick {
    if (_webView.canGoBack) {
        [_webView goBack];
        
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)onWillTransfer:(NSArray<ClauseModel *> *)clauses
            signer:(NSString *)signer
               gas:(NSString *)gas
 completionHandler:(void(^)(NSString *txId ,NSString *signer))completionHandler
{
   //Get the local keystore
    NSDictionary *currentWalletDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];
    NSString *keystore = currentWalletDict[@"keystore"];
    
    NSString *address = [WalletUtils getAddressWithKeystore:keystore];
    
    //Specified signature address
    if (signer.length > 0
        && ![address.lowercaseString isEqualToString:signer.lowercaseString]) {
        
        completionHandler(@"",signer.lowercaseString);
        return;
    }
    
    //Custom password input box
    @weakify(self);
    [WalletDemoTool alertCurrentVC:self
                           message:@"Please enter the wallet password"
                   actionWithTitle:@"Confirm"
                          callback:^(NSString * input)
     {
         [WalletMBProgressShower showCircleIn:self.view];
         
         NSString *password = input;
         [WalletUtils verifyKeystore:keystore password:password callback:^(BOOL result) {
             @strongify(self);
             if (result) {
                 
                 [self packageParameter:clauses gas:gas keystore:keystore password:password completionHandler:completionHandler] ;
             }else{
                 NSLog(@"password is wrong");
                 [WalletMBProgressShower hide:self.view];
             }
         }];
     }];
}

- (void)packageParameter:(NSArray *)clauses gas:(NSString *)gas keystore:(NSString *)keystore password:(NSString *)password completionHandler:(void(^)(NSString *txId ,NSString *signer))completionHandler
{
    NSMutableData* randomData = [[NSMutableData alloc]initWithCapacity:8];
    randomData.length = 8;
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
        [WalletMBProgressShower hide:self.view];
        return ;
    }
    
    //nonce: hex string
    NSString *nonce = [BigNumber bigNumberWithData:randomData].hexString;

    [self packageTranstionModelClauseList:clauses
                                    nonce:nonce  //nonce: hex string
                                      gas:[NSString stringWithFormat:@"%@",gas]
                               expiration:@"720" //Expiration relative to blockRef
                             gasPriceCoef:@"0"   // Coefficient used to calculate the final gas price (0 - 255)
                                 keystore:keystore
                                 password:password
                        completionHandler:completionHandler];
}

- (void)packageTranstionModelClauseList:(NSArray *)clauseList
                                  nonce:(NSString *)nonce
                                    gas:(NSString *)gas
                             expiration:(NSString *)expiration
                           gasPriceCoef:(NSString *)gasPriceCoef
                               keystore:(NSString *)keystore
                               password:(NSString *)password
                      completionHandler:(void(^)(NSString *txId ,NSString *signer))completionHandler
{
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString *chainTag) {
        
        NSLog(@"chainTag == %@",chainTag);
        if (chainTag.length == 0) {
            
            NSLog(@"get chainTag fail");
            return ;
        }
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockRef:^(NSString *blockRef) {
            
            NSLog(@"blockRef == %@",blockRef);
            if (blockRef.length == 0) {
                
                NSLog(@"get blockRef fail");
                return ;
            }
            //If the blockRef is nil, then the acquisition fails, you can prompt alert
            
            [self signAndSendClauseList:clauseList
                                  nonce:nonce
                                    gas:gas
                             expiration:expiration
                           gasPriceCoef:gasPriceCoef
                               keystore:keystore
                               password:password
                               chainTag:chainTag
                         blockRef:blockRef
                      completionHandler:completionHandler
];
        }];
    }];
}

- (void)signAndSendClauseList:(NSArray *)clauseList
                        nonce:(NSString *)nonce
                          gas:(NSString *)gas
                   expiration:(NSString *)expiration
                 gasPriceCoef:(NSString *)gasPriceCoef
                     keystore:(NSString *)keystore
                     password:(NSString *)password
                     chainTag:(NSString *)chainTag
               blockRef:(NSString *)blockRef
            completionHandler:(void(^)(NSString *txId ,NSString *signer))completionHandler

{
    WalletTransactionParameter *transactionModel = [WalletTransactionParameter createTransactionParameter:^(TransactionParameterBuiler *builder) {
        
        builder.chainTag = chainTag;
        builder.blockRef = blockRef;
        builder.nonce = nonce;
        builder.clauses = clauseList;
        builder.gas = gas;
        builder.expiration = expiration;
        builder.gasPriceCoef = gasPriceCoef;
        
    } checkParams:^(NSString *errorMsg) {
        NSLog(@"errorMsg == %@",errorMsg);
    }];
    
    
    if (transactionModel != nil) {
        
        [WalletUtils signAndSendTransferWithParameter:transactionModel
                                             keystore:keystore
                                             password:password
                                             callback:^(NSString *txId)
         {
             [WalletMBProgressShower hide:self.view];

             //Developers can use txid to query the status of data packaged on the chain
             NSString *signAddress = [WalletUtils getAddressWithKeystore:keystore];
             NSLog(@"\n txId: %@", txId);
             completionHandler(txId,signAddress);
         }];
    }else{
        [WalletMBProgressShower hide:self.view];
    }
}

- (BigNumber *)amountConvertWei:(NSString *)amount dicimals:(NSInteger )dicimals
{
    NSDecimalNumber *amountNumber = [NSDecimalNumber decimalNumberWithString:amount];
    NSDecimalNumber *dicimalNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",pow(10, dicimals)]];
    NSDecimalNumber *weiNumber = [amountNumber decimalNumberByMultiplyingBy:dicimalNumber];
    
    return [BigNumber bigNumberWithNumber:weiNumber];
}

- (void)onGetWalletAddress:(void (^)(NSArray<NSString *> * _Nonnull))callback
{
    //Get the wallet address from local database or file cache
    
    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];
    
    NSString *address = [WalletUtils getAddressWithKeystore:currentWallet[@"keystore"]];
    
    //Callback to webview
    callback(@[address.lowercaseString]);
}

- (void)onCheckOwnAddress:(NSString *)address callback:(void(^)(BOOL result))callback
{
    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];
    
    NSString *localAddrss = [WalletUtils getAddressWithKeystore:currentWallet[@"keystore"]];
    if ([localAddrss.lowercaseString isEqualToString:address.lowercaseString]) {
        callback(YES);
    }else{
        callback(NO);
    }
}

- (void)onWillCertificate:(NSString *)certificateMessage
                   signer:(NSString *)signer
        completionHandler:(void (^)(NSString * signer, NSData * signatureData))completionHandler
{
    NSDictionary *currentWalletDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];
    NSString *keystore = currentWalletDict[@"keystore"];
    
    NSString *address = [WalletUtils getAddressWithKeystore:keystore];
    
    if (signer.length == 0) {
        NSString *strMessage = [WalletUtils addSignerToCertMessage:address.lowercaseString
                                                           message:certificateMessage];
        
        [self signCert:strMessage signer:address.lowercaseString keystore:keystore completionHandler:completionHandler];
    
    }else if ([address.lowercaseString isEqualToString:signer.lowercaseString]){
        
        NSString *strMessage = [WalletUtils addSignerToCertMessage:signer.lowercaseString
                                                           message:certificateMessage];
        
        [self signCert:strMessage signer:address.lowercaseString keystore:keystore completionHandler:completionHandler];
        
    }else{
        //Cusmtom alert error
        completionHandler(@"",nil);
        [WalletMBProgressShower hide:self.view];

    }
}

- (void)signCert:(NSString *)message
          signer:(NSString *)signer
        keystore:(NSString *)keystore
completionHandler:(void (^)(NSString *signer, NSData *signatureData))completionHandler
{
    //Custom password input box
    [WalletDemoTool alertCurrentVC:self
                           message:@"Certificate Authority"
                   actionWithTitle:@"Confirm"
                          callback:^(NSString * input)
     {
        [WalletMBProgressShower showCircleIn:self.view];
         
        //Escape the signature data 
        NSString *escapeString = [self escapeMessageString:message];
        NSData *dataMessage = [escapeString dataUsingEncoding:NSUTF8StringEncoding];
         [WalletUtils signWithMessage:dataMessage
                             keystore:keystore
                             password:input
                             callback:^(NSData *signatureData)
          {
              if (signatureData) {
                  completionHandler(signer,signatureData);
              }else{
                  completionHandler(signer,nil);
              }
              [WalletMBProgressShower hide:self.view];
          }];
     }];
}

- (NSString *)escapeMessageString:(NSString *)inputStr
{
    inputStr = [inputStr stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    inputStr = [inputStr stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    inputStr = [inputStr stringByReplacingOccurrencesOfString:@"\a" withString:@"\\a"];
    inputStr = [inputStr stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    inputStr = [inputStr stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"];
    inputStr = [inputStr stringByReplacingOccurrencesOfString:@"\'" withString:@"\\'"];
    inputStr = [inputStr stringByReplacingOccurrencesOfString:@"\?" withString:@"\\?"];
    inputStr = [inputStr stringByReplacingOccurrencesOfString:@"\0" withString:@"\\0"];
    
    return inputStr;
}


/**
 * You must implement this method to free memory, otherwise there may be a memory overflow or leak.
 */
- (void)dealloc{
    [_dAppHandle deallocDApp];
}

@end
