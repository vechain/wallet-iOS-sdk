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
//  TransferVC.m
//  walletSDKDemo
//
//  Created by VeChain on 2018/12/27.
//  Copyright © 2019 VeChain. All rights reserved.
//

#import "WalletTransferVC.h"
#import "WalletUtils.h"
#import "WalletDemoMacro.h"
#import "WalletMBProgressShower.h"
#import "WalletDemoTool.h"

@interface WalletTransferVC ()<UITextFieldDelegate>
{
    NSString *_toAddress;
    NSString *_tokenContractAddress;
    NSString *_blockHost;
}

@property (weak, nonatomic) IBOutlet UITextView *receiveAddressTextView;
@property (weak, nonatomic) IBOutlet UITextField *transferAmountTextField;
@property (weak, nonatomic) IBOutlet UILabel *balanceAmountLabel;


@property (weak, nonatomic) IBOutlet UILabel *symobl;
@property (weak, nonatomic) IBOutlet UIImageView *coinIcon;
@property (nonatomic, strong) UITextField *pwTextField;

@end

@implementation WalletTransferVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.transferAmountTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    _blockHost = [WalletUtils getNodeUrl];
    
    if (!_isVET) {
        // vtho contract address
        _tokenContractAddress = vthoTokenAddress;
        [self.coinIcon setImage:[UIImage imageNamed:@"VTHO"]];
        self.symobl.text = @"VTHO";
        
    }else{
        [self.coinIcon setImage:[UIImage imageNamed:@"VET"]];
        self.symobl.text = @"VET";
    }        

    self.receiveAddressTextView.textContainerInset = UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
    
    self.balanceAmountLabel.text = self.coinAmount;
    self.receiveAddressTextView.text = @"0x1231231231231231231212131231231231231231";
}


- (IBAction)transfer:(id)sender{
    [self.view endEditing:YES];

     if (![self checkEnoughCoinBalance:self.coinAmount transferAmount:self.transferAmountTextField.text]) {
         NSLog(@"The balance is not enough to pay");
        
         [WalletMBProgressShower showMulLineTextIn:self.view
                                              Text:@"The balance is not enough to pay"
                                            During:1.5];
         return;
     }
    NSDictionary *currentWalletDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];
    NSString *from = currentWalletDict[@"address"];
    
    NSMutableArray *walletList = [NSMutableArray array];
    if (currentWalletDict) {
        [walletList addObject:currentWalletDict];
    }
    
    NSString *keystore = currentWalletDict[@"keystore"];
    
    //Custom password input box
    @weakify(self);
    [WalletDemoTool alertCurrentVC:self
                           message:@"Please enter the wallet password"
                   actionWithTitle:@"Confirm"
                          callback:^(NSString * input)
    {
        NSString *password = input;
        [WalletMBProgressShower showCircleIn:self.view];
        [WalletUtils verifyKeystore:keystore password:password callback:^(BOOL result) {
            @strongify(self);
            if (result) {
                
                [self transfer:from keystore:keystore password:password];
                
            }else{
                NSLog(@"The password is wrong");
                [WalletMBProgressShower hide:self.view];
            }
        }];
    }];
}

- (void)transfer:(NSString *)from keystore:(NSString *)keystore password:(NSString *)password
{
    if (self.isVET) {
        [self vetTransfer:from keystore:keystore password:password];
    }else{
        [self tokenTransfer:from keystore:keystore password:password];
    }
}


- (void)vetTransfer:(NSString *)from keystore:(NSString *)keystore  password:(NSString *)password{
    
    if (self.receiveAddressTextView.text.length == 0
        || self.transferAmountTextField.text.length == 0) {
        
        [WalletMBProgressShower showMulLineTextIn:self.view
                                             Text:NSLocalizedString(@"input_empty", nil)
                                           During:1.5];
        [WalletMBProgressShower hide:self.view];

        return;
    }
    
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:self.transferAmountTextField.text dicimals:18];
    
    //The random number is 8 bytes
    NSMutableData* randomData = [[NSMutableData alloc]initWithCapacity:8];
    randomData.length = 8;
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
        return ;
    }
    //nonce: hex string
    NSString *nonce = [BigNumber bigNumberWithData:randomData].hexString;
    
    NSMutableArray *clauseList = [NSMutableArray array];
    ClauseModel *clauseModel = [[ClauseModel alloc]init];
    clauseModel.to    = self.receiveAddressTextView.text;//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];

    [self packageTranstionModelClauseList:clauseList    //Clauses is an array
                                    nonce:nonce         //nonce: hex string
                                      gas:@"21000"      //Set maximum gas allowed for call, decimalstring
                               expiration:@"720"        //Expiration relative to blockRef
                             gasPriceCoef:@"0"          // Coefficient used to calculate the final gas price (0 - 255)
     
                                 keystore:keystore
                                 password:password];
}


- (void)tokenTransfer:(NSString *)from keystore:(NSString *)keystore  password:(NSString *)password{
    
    if (self.receiveAddressTextView.text.length == 0
        || self.transferAmountTextField.text.length == 0) {
        
        [WalletMBProgressShower showMulLineTextIn:self.view
                                             Text:NSLocalizedString(@"input_empty", nil)
                                           During:1.5];
        [WalletMBProgressShower hide:self.view];

        return;
    }
    
    //The random number is 8 bytes
    NSMutableData* randomData = [[NSMutableData alloc]initWithCapacity:8];
    randomData.length = 8;
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
        [WalletMBProgressShower hide:self.view];

        return ;
    }
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:self.transferAmountTextField.text dicimals:18];
    //nonce: hex string
    NSString *nonce = [BigNumber bigNumberWithData:randomData].hexString;

    NSMutableArray *clauseList = [NSMutableArray array];
    ClauseModel *clauseModel = [[ClauseModel alloc]init];
    clauseModel.to    = _tokenContractAddress;//Contract address of token
    clauseModel.value = @""; //vip 180 transaction token, value is an empty string
    clauseModel.data  = [self calculatenTokenTransferClauseData:self.receiveAddressTextView.text value:amountBig.hexString];
    [clauseList addObject:clauseModel];

    
    [self packageTranstionModelClauseList:clauseList
                                    nonce:nonce     //nonce: hex string
                                      gas:@"600000" //Set maximum gas allowed for call, decimalstring
                               expiration:@"720"    //Expiration relative to blockRef
                             gasPriceCoef:@"0"      // Coefficient used to calculate the final gas price (0 - 255)
     
                                 keystore:keystore
                                 password:password];
}

/**
* address: Accept the address of the account
* value: Token transfer amount
*/
- (NSString *)calculatenTokenTransferClauseData:(NSString *)address
                                     value:(NSString *)value{
    NSString *head = @"0xa9059cbb"; // method id
    NSString *newAddrss = [NSString stringWithFormat:@"000000000000000000000000%@",[address substringFromIndex:2]];
    NSInteger t = 64 - [value substringFromIndex:2].length;
    NSMutableString *zero = [NSMutableString new];
    for (int i = 0; i < t; i++) {
        [zero appendString:@"0"];
    }
    NSString *newValue = [NSString stringWithFormat:@"%@%@",zero,[value substringFromIndex:2]];
    NSString *result = [NSString stringWithFormat:@"%@%@%@",head,newAddrss,newValue];
    return  result;
}

- (void)packageTranstionModelClauseList:(NSArray *)clauseList
                               nonce:(NSString *)nonce
                                 gas:(NSString *)gas
                          expiration:(NSString *)expiration
                        gasPriceCoef:(NSString *)gasPriceCoef
                            keystore:(NSString *)keystore
                            password:(NSString *)password
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
                         blockRef:blockRef];
            
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
             //Developers can use txid to query the status of data packaged on the chain
             
             NSLog(@"\n txId: %@", txId);
             [WalletMBProgressShower hide:self.view];
         }];
    }else{
        [WalletMBProgressShower hide:self.view];
    }
}

/**
* splice clause data
*/
- (NSString *)contractMethodId:(NSString *)methodId params:(NSArray *)params{
    NSString *clauseData = methodId;
    for (NSString *param in params) {
        NSInteger t = 64 - [param substringFromIndex:2].length;
        NSMutableString *zero = [NSMutableString new];
        for (int i = 0; i < t; i++) {
            [zero appendString:@"0"];
        }
        NSString *newValue = [NSString stringWithFormat:@"%@%@",zero,[param substringFromIndex:2]];
        
        clauseData = [clauseData stringByAppendingString:newValue];
    }
    return clauseData;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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

- (BigNumber *)amountConvertWei:(NSString *)amount dicimals:(NSInteger )dicimals
{
    NSDecimalNumber *amountNumber = [NSDecimalNumber decimalNumberWithString:amount];
    NSDecimalNumber *dicimalNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",pow(10, dicimals)]];
    NSDecimalNumber *weiNumber = [amountNumber decimalNumberByMultiplyingBy:dicimalNumber];
    
    return [BigNumber bigNumberWithNumber:weiNumber];
}

- (BOOL)checkEnoughCoinBalance:(NSString *)coinBalance transferAmount:(NSString *)transferAmount
{
    NSDecimalNumber *coinBalanceNumber = [NSDecimalNumber decimalNumberWithString:coinBalance];
    NSDecimalNumber *transferAmounttnumber = [NSDecimalNumber decimalNumberWithString:transferAmount];
    
    if ([coinBalanceNumber compare:transferAmounttnumber] == NSOrderedAscending) {
        return NO;
    }
    return YES;
}

- (void)dealloc
{
//    [WalletUtils deallocDApp];
}

@end
