//
//  ThorTest.m
//  ThorWalletSDK_Example
//
//  Created by VeChain on 2019/5/27.
//  Copyright © 2019 VeChain. All rights reserved.
//

#import "ThorTest.h"
#import "WalletUtils.h"

@implementation ThorTest

// mnemonic recovery wallet
/* Mnemonic correct */
- (void)createWallet{
    NSArray *mnemonicWords = @[@"admit", @"mad", @"dream" ,@"stable", @"scrub" ,@"rubber" ,@"cabbage", @"exist" ,@"maple" ,@"excuse" ,@"copper", @"month"];
    [WalletUtils createWalletWithMnemonicWords:mnemonicWords password:@"123" callback:^(WalletAccountModel *account, NSError *error) {
        NSLog(@"Mnemonic correct");
//        NSAssert(account != NULL, @"Mnemonic correct");
    }];
}

- (void)createWallet1{

    NSArray *mnemonicWords = @[@"admit", @"mad", @"dream" ,@"stable", @"scrub" ,@"rubber" ,@"cabbage", @"exist" ,@"maple" ,@"excuse" ,@"copper", @"month"];

    [WalletUtils createWalletWithMnemonicWords:mnemonicWords password:@"123" callback:^(WalletAccountModel *account, NSError *error) {
        NSLog(@"Mnemonic=null, Wrong result %@", [error localizedDescription]);
//        NSAssert([error code]== -101, @"The error code is -101");
//        NSAssert([error.localizedDescription isEqualToString: @"mnemonicWords is invaild"], @"Error message");
    }];
}
/* Mnemonic is an empty string */
- (void)createWallet2{
    NSArray *mnemonicWords = @[];
    [WalletUtils createWalletWithMnemonicWords:mnemonicWords password:@"123" callback:^(WalletAccountModel *account, NSError *error) {
        NSLog(@"Mnemonic is an empty string, wrong result %@", [error localizedDescription]);
//        NSAssert([error code]== -101, @"The error code is -101");
//        NSAssert([error.localizedDescription isEqualToString: @"mnemonicWords is invaild"], @"Error message");
    }];
}
/*The mnemonic is 13 */
- (void)createWallet3{
    NSArray *mnemonicWords = @[@"admit", @"mad", @"dream" ,@"stable", @"scrub" ,@"rubber" ,@"cabbage", @"exist" ,@"maple" ,@"excuse" ,@"copper", @"month", @"month"];
    [WalletUtils createWalletWithMnemonicWords:mnemonicWords password:@"123" callback:^(WalletAccountModel *account, NSError *error) {
        NSLog(@"Assistive words are 13, wrong results %@", [error localizedDescription]);
//        NSAssert([error code]== -101, @"The error code is -101");
//        NSAssert([error.localizedDescription isEqualToString: @"mnemonicWords is invaild"], @"Error message");
    }];
}
/* The mnemonic is 11 */
- (void)createWallet4{
    NSArray *mnemonicWords = @[@"admit", @"mad", @"dream" ,@"stable", @"scrub" ,@"rubber" ,@"cabbage", @"exist" ,@"maple" ,@"excuse" ,@"copper"];
    [WalletUtils createWalletWithMnemonicWords:mnemonicWords password:@"123" callback:^(WalletAccountModel *account, NSError *error) {
        NSLog(@" The mnemonic is 11, wrong result %@", [error localizedDescription]);
//        NSAssert([error code]== -101, @"The error code is -101");
//        NSAssert([error.localizedDescription isEqualToString: @"mnemonicWords is invaild"], @"Error message");
    }];
}
/* Mnemonic error*/
- (void)createWallet5{
    NSString *mnemonicWords = @"admit mad dream stable scrub rubber cabbage exist maple excuse copper exist";
    [WalletUtils createWalletWithMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "] password:@"123" callback:^(WalletAccountModel *account, NSError *error) {
        NSLog(@"Mnemonic error, wrong result %@", [error localizedDescription]);
//        NSAssert([error code]== -101, @"The error code is -101");
//        NSAssert([error.localizedDescription isEqualToString: @"mnemonicWords is invaild"], @"Error message");
    }];
}
/* Mnemonic correct, password = null */
- (void)createWallet6{
    NSString *mnemonicWords = @"admit mad dream stable scrub rubber cabbage exist maple excuse copper month";
    [WalletUtils createWalletWithMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "] password:NULL callback:^(WalletAccountModel *account, NSError *error) {
        NSLog(@"Mnemonic correct, password = null, wrong result %@", [error localizedDescription]);
//        NSAssert(account != NULL, @"Mnemonic correct, password = null");
    }];
}
/* Mnemonic correct, password = @"" */
- (void)createWallet7{
    NSString *mnemonicWords = @"admit mad dream stable scrub rubber cabbage exist maple excuse copper month";
    [WalletUtils createWalletWithMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "] password:@"" callback:^(WalletAccountModel *account, NSError *error) {
        NSLog(@"Mnemonic correct, password = empty string");
//        NSAssert(account != NULL, @"Mnemonic correct, password = empty string");
    }];
}
/* The mnemonic is correct, the password is correct, and the mnemonic separator is null. */
- (void)createWallet8{
    NSArray *mnemonicWords = @[@"admit", @"mad", @"dream" ,@"stable", @"scrub" ,@"rubber" ,@"cabbage", @"exist" ,@"maple" ,@"excuse" ,@"copper", @"month"];
    [WalletUtils createWalletWithMnemonicWords:mnemonicWords password:@"123" callback:^(WalletAccountModel *account, NSError *error) {
        NSLog(@"Mnemonic correct, password = empty string");
//        NSAssert(account == NULL, @"Mnemonic correct, password = empty string");
    }];
}
/*------------------------------------------------------------------------------------------------------------------*/
//Create a wallet
/* pw=NULL */
- (void)createWallet9{
    [WalletUtils createWalletWithPassword:NULL callback:^(WalletAccountModel *account, NSError *error) {
        NSLog(@"Password=NULL, wrong result %@", error.localizedDescription);
//        NSAssert([error code]== -101, @"The error code is -101");
//        NSAssert([error.localizedDescription isEqualToString: @"password is invaild"], @"Create wallet password for nil creation failed");
    }];
}
/*Password is an empty string""*/
- (void)createWallet10{
    [WalletUtils createWalletWithPassword:@"" callback:^(WalletAccountModel *account, NSError *error) {
        NSLog(@"Password = empty string, wrong result %@", error.localizedDescription);
//        NSAssert([error code]== -101, @"The error code is -101");
//        NSAssert([error.localizedDescription isEqualToString: @"password is invaild"], @"Create wallet password for nil creation failed");
    }];
}
/*------------------------------------------------------------------------------------------------------------------*/
//Verify that the mnemonic is legal
/*mnemonic=NULL*/
- (void)isValidMnemonicWords1{
    NSString *mnemonicWords = NULL;
    BOOL isValidMnemonicWords = [WalletUtils isValidMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "]];
//    NSAssert(isValidMnemonicWords== false, @"isValidMnemonicWords is false");
}
/*Mnemonic = empty string*/
- (void)isValidMnemonicWords2{
    NSString *mnemonicWords = @"";
    BOOL isValidMnemonicWords = [WalletUtils isValidMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "]];
//    NSAssert(isValidMnemonicWords== false, @"isValidMnemonicWords is false");
}
/*The mnemonic is 13*/
- (void)isValidMnemonicWords3{
    NSString *mnemonicWords = @"admit mad dream stable scrub rubber cabbage exist maple excuse copper month dream";
    BOOL isValidMnemonicWords = [WalletUtils isValidMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "]];
//    NSAssert(isValidMnemonicWords== false, @"isValidMnemonicWords is false");
}
/*The mnemonic is 11*/
- (void)isValidMnemonicWords4{
    NSString *mnemonicWords = @"admit mad dream stable scrub rubber cabbage exist maple excuse copper";
    BOOL isValidMnemonicWords = [WalletUtils isValidMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "]];
//    NSAssert(isValidMnemonicWords== false, @"isValidMnemonicWords is false");
}
/*Mnemonic error*/
- (void)isValidMnemonicWords5{
    NSString *mnemonicWords = @"admit mad dream stable scrub rubber cabbage exist maple excuse copper exist";
    BOOL isValidMnemonicWords = [WalletUtils isValidMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "]];
//    NSAssert(isValidMnemonicWords== false, @"isValidMnemonicWords is false");
}
/*Mnemonic case sensitivity*/
- (void)isValidMnemonicWords6{
    NSString *mnemonicWords = @"admit mad dream stable Scrub rubber cabbage exist maple excuse copper month";
    BOOL isValidMnemonicWords = [WalletUtils isValidMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "]];
//    NSAssert(isValidMnemonicWords== false, @"isValidMnemonicWords is false");
}

/*------------------------------------------------------------------------------------------------------------------*/
// Get checksum address
/* Address is all lowercase */
- (void)getChecksumAddress{
    NSString *address = @"0x7567d83b7b8d80addcb281a71d54fc7b3364ffed";
    NSString *checksumAddress = [WalletUtils getChecksumAddress:address];
//    NSAssert([checksumAddress isEqualToString: @"0x7567D83b7b8d80ADdCb281A71d54Fc7B3364ffed"], @"Get the checksum address");
    NSLog(@"checksumAddress= %@", checksumAddress);
}
/*address=null*/
- (void)getChecksumAddress1{
    NSString *address = NULL;
    NSString *checksumAddress = [WalletUtils getChecksumAddress:address];
//    NSAssert(checksumAddress == NULL, @"Get the checksum address");
}
/*address=""*/
- (void)getChecksumAddress2{
    NSString *address = @"";
    NSString *checksumAddress = [WalletUtils getChecksumAddress:address];
//    NSAssert([checksumAddress isEqualToString:@""], @"Get the checksum address");
}
/*Address length = 43 */
- (void)getChecksumAddress3{
    NSString *address = @"0x7567d83b7b8d80addcb281a71d54fc7b3364ffed1";
    NSString *checksumAddress = [WalletUtils getChecksumAddress:address];
//    NSAssert([checksumAddress isEqualToString:@""], @"Get empty string checksum address");
    NSLog(@"Wrong result %@", checksumAddress);
}
/*Address length =41*/
- (void)getChecksumAddress4{
    NSString *address = @"0x7567d83b7b8d80addcb281a71d54fc7b3364ffe";
    NSString *checksumAddress = [WalletUtils getChecksumAddress:address];
//    NSAssert([checksumAddress isEqualToString:@""], @"Get empty string checksum address");
    NSLog(@"Wrong result %@", checksumAddress);
}
/*Address is not hexadecimal*/
- (void)getChecksumAddress5{
    NSString *address = @"0x7567d83b7b8d80addcb281a71d54fc7b3364ffeg";
    NSString *checksumAddress = [WalletUtils getChecksumAddress:address];
//    NSAssert([checksumAddress isEqualToString:@""], @"Get empty string checksum address");
    NSLog(@"Wrong result %@", checksumAddress);
}
/*------------------------------------------------------------------------------------------------------------------*/
// Verify keystore format
/*keystore=null*/
- (void)isValidKeystore1{
    NSString *keystore = NULL;
    BOOL isOKKestore = [WalletUtils isValidKeystore:keystore];
//    NSAssert(isOKKestore == false, @"keystore=null");
}
/*keystore=”“*/
- (void)isValidKeystore2{
    NSString *keystore = @"";
    BOOL isOKKestore = [WalletUtils isValidKeystore:keystore];
//    NSAssert(isOKKestore == false, @"Keystore=empty string");
}
/*keystore=”true“*/
- (void)isValidKeystore3{
    NSString *keystore = @"true";
    BOOL isOKKestore = [WalletUtils isValidKeystore:keystore];
//    NSAssert(isOKKestore == false, @"keystore=Non-json format string");
}
/*------------------------------------------------------------------------------------------------------------------*/
//Get the address through the keystore
/*keystore=null*/
- (void)getAddress1{
    NSString *keystore = NULL;
    NSString *getAddress = [WalletUtils getAddressWithKeystore:keystore];
//    NSAssert([getAddress isEqualToString:@""], @"Get the address through the keystore, keystore=null");
}
/*keystore=”“*/
- (void)getAddress2{
    NSString *keystore = @"";
    NSString *getAddress = [WalletUtils getAddressWithKeystore:keystore];
//    NSAssert([getAddress isEqualToString:@""], @"Get the address through the keystore, keystore=null");
}
/*keystore=”true“*/
- (void)getAddress3{
    NSString *keystore = @"true";
    NSString *getAddress = [WalletUtils getAddressWithKeystore:keystore];
//    NSAssert([getAddress isEqualToString:@""], @"Get the address through keystore, keystore=string in non-json format");
}
/*------------------------------------------------------------------------------------------------------------------*/
//Data signature
/*keystore=null*/
- (void)sign1{
    NSString *keystore = NULL;
    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    [WalletUtils signWithMessage:messageData
                        keystore:keystore
                        password:@"123456"
                        callback:^(NSData *signatureData)
     {
//         NSAssert([error code]== -1, @"sign1");
//         NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -1.)"], @"sign1");
     }];
}
/*keystore=""*/
- (void)sign2{
    NSString *keystore = @"";
    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    [WalletUtils signWithMessage:messageData
                        keystore:keystore
                        password:@"123456"
                        callback:^(NSData *signatureData)
     {
//         NSAssert([error code]== -1, @"sign2");
//         NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -1.)"], @"sign2");
     }];
}
/*keystore="true"*/
- (void)sign3{
    NSString *keystore = @"true";
    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    [WalletUtils signWithMessage:messageData
                        keystore:keystore
                        password:@"123456"
                        callback:^(NSData *signatureData)
     {
//         NSAssert([error code]== -1, @"sign3");
//         NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -1.)"], @"sign3");
     }];
}
/*The keystore is correct and the password is =null*/
- (void)sign4{
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    [WalletUtils signWithMessage:messageData
                        keystore:keystore
                        password:NULL
                        callback:^(NSData *signatureData)
     {
//         NSLog(error.localizedDescription);
//         NSAssert([error code]== -10, @"sign4");
//         NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -10.)"], @"sign4");
     }];
}
/*The keystore is correct, the password is = ""*/
- (void)sign5{
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    [WalletUtils signWithMessage:messageData
                        keystore:keystore
                        password:@""
                        callback:^(NSData *signatureData)
     {
//         NSLog(error.localizedDescription);
//         NSAssert([error code]== -10, @"sign4");
//         NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -10.)"], @"sign4");
     }];
}
/*Keystore is correct, password is wrong*/
- (void)sign6{
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    [WalletUtils signWithMessage:messageData
                        keystore:keystore
                        password:@"1"
                        callback:^(NSData *signatureData)
     {
//         NSLog(error.localizedDescription);
//         NSAssert([error code]== -10, @"sign4");
//         NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -10.)"], @"sign4");
     }];
}
/*The keystore password is correct and the signature is empty.*/
- (void)sign7{
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    
    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    [WalletUtils signWithMessage:NULL
                        keystore:keystore
                        password:@"123456"
                        callback:^(NSData *signatureData)
     {
         //签名信息，恢复地址
         //         NSString *address = [WalletUtils recoverAddressFromMessage:messageData signatureData:signatureData];
//         NSLog(@"address == %@",error.localizedDescription);
     }];
}
/*The keystore password is correct, signature = ""*/
- (void)sign8{
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    
    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    [WalletUtils signWithMessage:@""
                        keystore:keystore
                        password:@"123456"
                        callback:^(NSData *signatureData)
     {
         //签名信息，恢复地址
         //         NSString *address = [WalletUtils recoverAddressFromMessage:messageData signatureData:signatureData];
//         NSLog(@"address == %@",error.localizedDescription);
     }];
}
/*------------------------------------------------------------------------------------------------------------------*/
// Signature information, recovery address
/*Signature information=null*/
- (void)recoverAddress1{
    NSData *messageData = [@"test" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *address = [WalletUtils recoverAddressFromMessage:messageData signatureData:NULL];
//    NSAssert(address == NULL, @"recoverAddress1");
}
/*Signature information=""*/
- (void)recoverAddress2{
    NSData *messageData = [@"test" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *address = [WalletUtils recoverAddressFromMessage:messageData signatureData:@""];
//    NSAssert(address == NULL, @"recoverAddress1");
}
/*messageData=null*/
- (void)recoverAddress3{
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    
    NSData *messageData = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    [WalletUtils signWithMessage:messageData
                        keystore:keystore
                        password:@"123456"
                        callback:^(NSData *signatureData)
     {
         
         //Signature information, recovery address
         NSString *address = [WalletUtils recoverAddressFromMessage:NULL signatureData:signatureData];
         NSLog(@"address == %@",address);
         //         NSAssert([address isEqualToString:@"0x7567D83b7b8d80ADdCb281A71d54Fc7B3364ffed"], @"错误码 is -1");
     }];
}
/*------------------------------------------------------------------------------------------------------------------*/
//change Password
/*keystore=null*/
- (void)modifyKeystorePassword1{
    NSString *keystore = NULL;
    [WalletUtils modifyKeystore:keystore newPassword:@"123" oldPassword:@"123456" callback:^(NSString *newKeystore) {
        NSLog(@"newKeystore.length=%ld", newKeystore.length);
//        NSAssert(newKeystore.length == 0, @"modifyKeystorePassword1");
    }];
}
/*keystore=""*/
- (void)modifyKeystorePassword2{
    NSString *keystore = @"";
    [WalletUtils modifyKeystore:keystore newPassword:@"123" oldPassword:@"123456" callback:^(NSString *newKeystore) {
        NSLog(@"newKeystore.length=%ld", newKeystore.length);
//        NSAssert(newKeystore.length == 0, @"modifyKeystorePassword2");
    }];
}
/*keystore="true"*/
- (void)modifyKeystorePassword3{
    NSString *keystore = @"true";
    [WalletUtils modifyKeystore:keystore newPassword:@"123" oldPassword:@"123456" callback:^(NSString *newKeystore) {
        NSLog(@"newKeystore.length=%ld", newKeystore.length);
//        NSAssert(newKeystore.length == 0, @"modifyKeystorePassword3");
    }];
}
/*Keystore is correct, old password = null*/
- (void)modifyKeystorePassword4{
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    [WalletUtils modifyKeystore:keystore newPassword:@"123" oldPassword:NULL callback:^(NSString *newKeystore) {
        NSLog(@"newKeystore.length=%ld", newKeystore.length);
//        NSAssert(newKeystore.length == 0, @"modifyKeystorePassword4");
    }];
}
/*Keystore is correct, old password = ""*/
- (void)modifyKeystorePassword5{
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    [WalletUtils modifyKeystore:keystore newPassword:@"123" oldPassword:@"" callback:^(NSString *newKeystore) {
        NSLog(@"newKeystore.length=%ld", newKeystore.length);
//        NSAssert(newKeystore.length == 0, @"modifyKeystorePassword5");
    }];
}
/*Keystore is correct, old password is wrong*/
- (void)modifyKeystorePassword6{
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    [WalletUtils modifyKeystore:keystore newPassword:@"123" oldPassword:@"1" callback:^(NSString *newKeystore) {
        NSLog(@"newKeystore.length=%ld", newKeystore.length);
//        NSAssert(newKeystore.length == 0, @"modifyKeystorePassword6");
    }];
}
/*Keystore old password is correct, new password = null*/
- (void)modifyKeystorePassword7{
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    [WalletUtils modifyKeystore:keystore newPassword:NULL oldPassword:@"123456" callback:^(NSString *newKeystore) {
        NSString *getAddress = [WalletUtils getAddressWithKeystore:newKeystore];
        NSLog(@"newKeystore.length=%ld, getAddress=%@", newKeystore.length, getAddress);
//        NSAssert(newKeystore.length != 0, @"modifyKeystorePassword7");
//        NSAssert([getAddress isEqualToString:@"0x36D7189625587D7C4c806E0856b6926Af8d36FEa"], @"modifyKeystorePassword7");
    }];
    
    
}
/*Keystore old password is correct, new password=""*/
- (void)modifyKeystorePassword8{
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    [WalletUtils modifyKeystore:keystore newPassword:@"123" oldPassword:@"123456" callback:^(NSString *newKeystore) {
        NSString *getAddress = [WalletUtils getAddressWithKeystore:newKeystore];
        NSLog(@"newKeystore.length=%ld, getAddress=%@", newKeystore.length, getAddress);
//        NSAssert([getAddress isEqualToString:@"0x36D7189625587D7C4c806E0856b6926Af8d36FEa"], @"modifyKeystorePassword8");
    }];
}

/*------------------------------------------------------------------------------------------------------------------*/
// Verify that the keystore password is correct
/*keystore=null*/
- (void)verifyKeystorePassword1{
    NSString *keystore = NULL;
    [WalletUtils verifyKeystore:keystore password:@"123456" callback:^(BOOL result) {
//        NSAssert(result == false, @"verifyKeystorePassword1");
    }];
}
/*keystore=”“*/
- (void)verifyKeystorePassword2{
    NSString *keystore = @"";
    [WalletUtils verifyKeystore:keystore password:@"123456" callback:^(BOOL result) {
//        NSAssert(result == false, @"verifyKeystorePassword2");
    }];
}
/*keystore=”trur“*/
- (void)verifyKeystorePassword3{
    NSString *keystore = @"true";
    [WalletUtils verifyKeystore:keystore password:@"123456" callback:^(BOOL result) {
//        NSAssert(result == false, @"verifyKeystorePassword3");
    }];
}
/*Keystore is correct, password = null*/
- (void)verifyKeystorePassword4{
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    [WalletUtils verifyKeystore:keystore password:NULL callback:^(BOOL result) {
//        NSAssert(result == false, @"verifyKeystorePassword4");
    }];
}
/*Keystore is correct, password = ""*/
- (void)verifyKeystorePassword5{
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    [WalletUtils verifyKeystore:keystore password:@"" callback:^(BOOL result) {
//        NSAssert(result == false, @"verifyKeystorePassword4");
    }];
}
/*Keystore is correct, password is wrong*/
- (void)verifyKeystorePassword6{
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    [WalletUtils verifyKeystore:keystore password:@"a" callback:^(BOOL result) {
//        NSAssert(result == false, @"verifyKeystorePassword4");
    }];
}
/*------------------------------------------------------------------------------------------------------------------*/
// Get the private key through the keystore
/*keystore=null*/
- (void)decryptKeystore1{
    NSString *keystore = NULL;
    [WalletUtils decryptKeystore:keystore password:@"123456" callback:^(NSString *privatekey, NSError *error) {
//        NSAssert([error code]== -1, @"decryptKeystore1");
//        NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -1.)"], @"decryptKeystore1");
    }];
}
/*keystore=""*/
- (void)decryptKeystore2{
    NSString *keystore = @"";
    [WalletUtils decryptKeystore:keystore password:@"123456" callback:^(NSString *privatekey, NSError *error) {
//        NSAssert([error code]== -1, @"decryptKeystore2");
//        NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -1.)"], @"decryptKeystore2");
    }];
}
/*keystore="true"*/
- (void)decryptKeystore3{
    NSString *keystore = @"true";
    [WalletUtils decryptKeystore:keystore password:@"123456" callback:^(NSString *privatekey, NSError *error) {
//        NSAssert([error code]== -1, @"decryptKeystore3");
//        NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -1.)"], @"decryptKeystore3");
    }];
}
/*Keystore is correct, password = null*/
- (void)decryptKeystore4{
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    [WalletUtils decryptKeystore:keystore password:NULL callback:^(NSString *privatekey, NSError *error) {
//        NSAssert([error code]== -10, @"decryptKeystore4");
//        NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -10.)"], @"decryptKeystore4");
    }];
}
/*Keystore is correct, password=""*/
- (void)decryptKeystore5{
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    [WalletUtils decryptKeystore:keystore password:@"" callback:^(NSString *privatekey, NSError *error) {
//        NSAssert([error code]== -10, @"decryptKeystore4");
//        NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -10.)"], @"decryptKeystore4");
    }];
}

/*Keystore is correct, password is wrong*/
- (void)decryptKeystore6{
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    [WalletUtils decryptKeystore:keystore password:@"a" callback:^(NSString *privatekey, NSError *error) {
//        NSAssert([error code]== -10, @"decryptKeystore4");
//        NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -10.)"], @"decryptKeystore4");
    }];
}
/*------------------------------------------------------------------------------------------------------------------*/
//Private key to keystore
/*privatekey=null*/
- (void)encryptPrivateKey1{
    NSString *privatekey = NULL;
    [WalletUtils encryptPrivateKeyWithPassword:@"123" privateKey:privatekey callback:^(NSString *keystoreJson) {
        NSLog(@"keystoreJson=%@", keystoreJson);
//        NSAssert(keystoreJson.length == 0, @"encryptPrivateKey1");
    }];
}
/*privatekey=""*/
- (void)encryptPrivateKey2{
    NSString *privatekey = @"";
    [WalletUtils encryptPrivateKeyWithPassword:@"123" privateKey:privatekey callback:^(NSString *keystoreJson) {
        NSLog(@"keystoreJson=%@", keystoreJson);
//        NSAssert(keystoreJson.length == 0, @"encryptPrivateKey2");
    }];
    

}
/*Privatekey=non-hexadecimal*/
- (void)encryptPrivateKey3{
    NSString *privatekey = @"0xbc9fe2428a8faec37674412c113f4a9a66b2e40076014547bfe7bbdc2c5a85eg";
    [WalletUtils encryptPrivateKeyWithPassword:@"123" privateKey:privatekey callback:^(NSString *keystoreJson) {
        NSLog(@"keystoreJson=%@", keystoreJson);
//        NSAssert(keystoreJson.length == 0, @"encryptPrivateKey3");
    }];
}
/*65 after privatekey 0x*/
- (void)encryptPrivateKey4{
    NSString *privatekey = @"0xbc9fe2428a8faec37674412c113f4a9a66b2e40076014547bfe7bbdc2c5a85eee";
    [WalletUtils encryptPrivateKeyWithPassword:@"123" privateKey:privatekey callback:^(NSString *keystoreJson) {
        NSLog(@"keystoreJson=%@", keystoreJson);
//        NSAssert(keystoreJson.length == 0, @"encryptPrivateKey4");
    }];
}
/*63 after privatekey 0x*/
- (void)encryptPrivateKey5{
    NSString *privatekey = @"0xbc9fe2428a8faec37674412c113f4a9a66b2e40076014547bfe7bbdc2c5a85e";
    [WalletUtils encryptPrivateKeyWithPassword:@"123" privateKey:privatekey callback:^(NSString *keystoreJson) {
        NSLog(@"keystoreJson=%@", keystoreJson);
//        NSAssert(keystoreJson.length == 0, @"encryptPrivateKey5");
    }];
}
/*Privatekey is correct, password is null*/
- (void)encryptPrivateKey6{
    NSString *privatekey = @"0xbc9fe2428a8faec37674412c113f4a9a66b2e40076014547bfe7bbdc2c5a85ee";
    [WalletUtils encryptPrivateKeyWithPassword:NULL privateKey:privatekey callback:^(NSString *keystoreJson) {
        NSLog(@"keystoreJson=%@ %ld", keystoreJson, keystoreJson.length);
//        NSAssert(keystoreJson.length == 491, @"encryptPrivateKey6");
    }];
}
/*Privatekey is correct, password is ""*/
- (void)encryptPrivateKey7{
    NSString *privatekey = @"0xbc9fe2428a8faec37674412c113f4a9a66b2e40076014547bfe7bbdc2c5a85ee";
    [WalletUtils encryptPrivateKeyWithPassword:@"" privateKey:privatekey callback:^(NSString *keystoreJson) {
        NSLog(@"keystoreJson=%@ %ld", keystoreJson, keystoreJson.length);
//        NSAssert(keystoreJson.length == 491, @"encryptPrivateKey7");
    }];
}

// signTransfer
/* keystore=null */
- (void)signTransfer1{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
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
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString *chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockRef:^(NSString *blockRef) {
            
            NSLog(@"blockRef == %@",blockRef);
            //If the blockRef is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter createTransactionParameter:^(TransactionParameterBuiler *builder) {
                
                builder.chainTag = chainTag;
                builder.blockRef = blockRef;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString *errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signWithParameter:transactionModel
                                      keystore:NULL
                                      password:@"123456"
                                      callback:^(NSString *txId)
                 {
                     NSLog(@"\n txId: %@", txId);
//                     NSAssert(txId == NULL, @"signTransfer1");
                 }];
            }
        }];
    }];
}
/* keystore="" */
- (void)signTransfer2{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
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
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString *chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockRef:^(NSString *blockRef) {
            
            NSLog(@"blockRef == %@",blockRef);
            //If the blockRef is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter createTransactionParameter:^(TransactionParameterBuiler *builder) {
                
                builder.chainTag = chainTag;
                builder.blockRef = blockRef;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString *errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signWithParameter:transactionModel
                                      keystore:@""
                                      password:@"123456"
                                      callback:^(NSString *txId)
                 {
                     NSLog(@"\n txId: %@", txId);
//                     NSAssert(txId == NULL, @"signTransfer1");
                 }];
            }
        }];
    }];
}
/* keystore="true" */
- (void)signTransfer3{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
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
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString *chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockRef:^(NSString *blockRef) {
            
            NSLog(@"blockRef == %@",blockRef);
            //If the blockRef is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter createTransactionParameter:^(TransactionParameterBuiler *builder) {
                
                builder.chainTag = chainTag;
                builder.blockRef = blockRef;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString *errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signWithParameter:transactionModel
                                      keystore:@"true"
                                      password:@"123456"
                                      callback:^(NSString *txId)
                 {
                     NSLog(@"\n txId: %@", txId);
//                     NSAssert(txId == NULL, @"signTransfer1");
                 }];
            }
        }];
    }];
}
/*Keystore is correct, password = null*/
- (void)signTransfer4{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
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
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString *chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockRef:^(NSString *blockRef) {
            
            NSLog(@"blockRef == %@",blockRef);
            //If the blockRef is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter createTransactionParameter:^(TransactionParameterBuiler *builder) {
                
                builder.chainTag = chainTag;
                builder.blockRef = blockRef;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString *errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signWithParameter:transactionModel
                                      keystore:keystore
                                      password:NULL
                                      callback:^(NSString *txId)
                 {
                     NSLog(@"\n txId: %@", txId);
//                     NSAssert(txId == NULL, @"signTransfer1");
                 }];
            }
        }];
    }];
}
/*Keystore is correct, password=""*/
- (void)signTransfer5{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
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
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString *chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockRef:^(NSString *blockRef) {
            
            NSLog(@"blockRef == %@",blockRef);
            //If the blockRef is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter createTransactionParameter:^(TransactionParameterBuiler *builder) {
                
                builder.chainTag = chainTag;
                builder.blockRef = blockRef;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString *errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signWithParameter:transactionModel
                                      keystore:keystore
                                      password:@""
                                      callback:^(NSString *txId)
                 {
                     NSLog(@"\n txId: %@", txId);
//                     NSAssert(txId == NULL, @"signTransfer1");
                 }];
            }
        }];
    }];
}
/*Keystore is correct, password is wrong*/
- (void)signTransfer6{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
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
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString *chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockRef:^(NSString *blockRef) {
            
            NSLog(@"blockRef == %@",blockRef);
            //If the blockRef is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter createTransactionParameter:^(TransactionParameterBuiler *builder) {
                
                builder.chainTag = chainTag;
                builder.blockRef = blockRef;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString *errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signWithParameter:transactionModel
                                      keystore:keystore
                                      password:@"1"
                                      callback:^(NSString *txId)
                 {
                     NSLog(@"\n txId: %@", txId);
//                     NSAssert(txId == NULL, @"signTransfer1");
                 }];
            }
        }];
    }];
}
/*Keystore password is correct, transactionModel=null*/
- (void)signTransfer7{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
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
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString *chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockRef:^(NSString *blockRef) {
            
            NSLog(@"blockRef == %@",blockRef);
            //If the blockRef is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter createTransactionParameter:^(TransactionParameterBuiler *builder) {
                
                builder.chainTag = chainTag;
                builder.blockRef = blockRef;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString *errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signWithParameter:NULL
                                      keystore:keystore
                                      password:@"123456"
                                      callback:^(NSString *txId)
                 {
                     NSLog(@"\n txId: %@", txId);
//                     NSAssert(txId == NULL, @"signTransfer1");
                 }];
                
            }
        }];
    }];
}
/*------------------------------------------------------------------------------------------------------------------*/
//signAndSendTransfer
/* keystore=null */
- (void)signAndSendTransfer1
{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
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
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString *chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockRef:^(NSString *blockRef) {
            
            NSLog(@"blockRef == %@",blockRef);
            //If the blockRef is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter createTransactionParameter:^(TransactionParameterBuiler *builder) {
                
                builder.chainTag = chainTag;
                builder.blockRef = blockRef;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString *errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signAndSendTransferWithParameter:transactionModel
                                                     keystore:NULL
                                                     password:@"123456"
                                                     callback:^(NSString *txId)
                 {
                     //Developers can use txid to query the status of data packaged on the chain
                     NSLog(@"\n txId: %@", txId);
//                     NSAssert(txId == NULL, @"signTransfer1");
                 }];
            }
        }];
    }];
}
/* keystore="" */
- (void)signAndSendTransfer2
{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
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
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString *chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockRef:^(NSString *blockRef) {
            
            NSLog(@"blockRef == %@",blockRef);
            //If the blockRef is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter createTransactionParameter:^(TransactionParameterBuiler *builder) {
                
                builder.chainTag = chainTag;
                builder.blockRef = blockRef;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString *errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signAndSendTransferWithParameter:transactionModel
                                                     keystore:@""
                                                     password:@"123456"
                                                     callback:^(NSString *txId)
                 {
                     //Developers can use txid to query the status of data packaged on the chain
                     NSLog(@"\n txId: %@", txId);
//                     NSAssert(txId == NULL, @"signTransfer1");
                 }];
            }
        }];
    }];
}
/* keystore="true" */
- (void)signAndSendTransfer3
{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
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
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString *chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockRef:^(NSString *blockRef) {
            
            NSLog(@"blockRef == %@",blockRef);
            //If the blockRef is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter createTransactionParameter:^(TransactionParameterBuiler *builder) {
                
                builder.chainTag = chainTag;
                builder.blockRef = blockRef;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString *errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signAndSendTransferWithParameter:transactionModel
                                                     keystore:@"true"
                                                     password:@"123456"
                                                     callback:^(NSString *txId)
                 {
                     //Developers can use txid to query the status of data packaged on the chain
                     NSLog(@"\n txId: %@", txId);
//                     NSAssert(txId == NULL, @"signTransfer1");
                 }];
            }
        }];
    }];
}
/* Keystore is correct, password = null */
- (void)signAndSendTransfer4
{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
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
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString *chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockRef:^(NSString *blockRef) {
            
            NSLog(@"blockRef == %@",blockRef);
            //If the blockRef is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter createTransactionParameter:^(TransactionParameterBuiler *builder) {
                
                builder.chainTag = chainTag;
                builder.blockRef = blockRef;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString *errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signAndSendTransferWithParameter:transactionModel
                                                     keystore:keystore
                                                     password:NULL
                                                     callback:^(NSString *txId)
                 {
                     //Developers can use txid to query the status of data packaged on the chain
                     NSLog(@"\n txId: %@", txId);
//                     NSAssert(txId == NULL, @"signTransfer1");
                 }];
            }
        }];
    }];
}
/* Keystore is correct, password="" */
- (void)signAndSendTransfer5
{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
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
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString *chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockRef:^(NSString *blockRef) {
            
            NSLog(@"blockRef == %@",blockRef);
            //If the blockRef is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter createTransactionParameter:^(TransactionParameterBuiler *builder) {
                
                builder.chainTag = chainTag;
                builder.blockRef = blockRef;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString *errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signAndSendTransferWithParameter:transactionModel
                                                     keystore:keystore
                                                     password:@""
                                                     callback:^(NSString *txId)
                 {
                     //Developers can use txid to query the status of data packaged on the chain
                     NSLog(@"\n txId: %@", txId);
//                     NSAssert(txId == NULL, @"signTransfer1");
                 }];
            }
        }];
    }];
}
/* Keystore is correct, password is incorrect transactionModel=null*/
- (void)signAndSendTransfer6
{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
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
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString *chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockRef:^(NSString *blockRef) {
            
            NSLog(@"blockRef == %@",blockRef);
            //If the blockRef is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter createTransactionParameter:^(TransactionParameterBuiler *builder) {
                
                builder.chainTag = chainTag;
                builder.blockRef = blockRef;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString *errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signAndSendTransferWithParameter:transactionModel
                                                     keystore:keystore
                                                     password:@"a"
                                                     callback:^(NSString *txId)
                 {
                     //Developers can use txid to query the status of data packaged on the chain
                     NSLog(@"\n txId: %@", txId);
//                     NSAssert(txId == NULL, @"signTransfer1");
                 }];
            }
        }];
    }];
}
/* The keystore is correct and the password is correct.*/
- (void)signAndSendTransfer7
{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
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
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString *chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockRef:^(NSString *blockRef) {
            
            NSLog(@"blockRef == %@",blockRef);
            //If the blockRef is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter createTransactionParameter:^(TransactionParameterBuiler *builder) {
                
                builder.chainTag = chainTag;
                builder.blockRef = blockRef;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString *errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                

                [WalletUtils signAndSendTransferWithParameter:nil
                                                     keystore:keystore
                                                     password:@"123456"
                                                     callback:^(NSString *txId)
                 {
                     //Developers can use txid to query the status of data packaged on the chain
                     NSLog(@"\n txId: %@", txId);
//                     NSAssert(txId == NULL, @"signTransfer1");
                 }];
            }
        }];
    }];
}
/*------------------------------------------------------------------------------------------------------------------*/

- (void)startTest
{
//    [self createWallet];
//    [self createWallet1];
//    [self createWallet2];
//    [self createWallet3];
//    [self createWallet4];
//    [self createWallet5];
//    [self createWallet6];
//    [self createWallet7];
//    [self createWallet8];
//    [self createWallet9];
//    [self createWallet10];

    
//    [self isValidMnemonicWords1];
//    [self isValidMnemonicWords2];
//    [self isValidMnemonicWords3];
//    [self isValidMnemonicWords4];
//    [self isValidMnemonicWords5];
//    [self isValidMnemonicWords6];
//
//    [self getChecksumAddress];
//    [self getChecksumAddress1];
//    [self getChecksumAddress2];
//    [self getChecksumAddress3];
//    [self getChecksumAddress4];
//    [self getChecksumAddress5];
    
    
    
//    [self isValidKeystore1];
//    [self isValidKeystore2];
//    [self isValidKeystore3];
//
//    [self getAddress1];
//    [self getAddress2];
//    [self getAddress3];
//
//    [self sign1];
//    [self sign2];
//    [self sign3];
//    [self sign4];
//    [self sign5];
//    [self sign6];
//    [self sign7];
//    [self sign8];
//
//    [self recoverAddress1];
//    [self recoverAddress2];
//    [self recoverAddress3];
    
//    [self modifyKeystorePassword1];
//    [self modifyKeystorePassword2];
//    [self modifyKeystorePassword3];
//    [self modifyKeystorePassword4];
//    [self modifyKeystorePassword5];
//    [self modifyKeystorePassword6];
//    [self modifyKeystorePassword7];
//    [self modifyKeystorePassword8];
//
//    [self verifyKeystorePassword1];
//    [self verifyKeystorePassword2];
//    [self verifyKeystorePassword3];
//    [self verifyKeystorePassword4];
//    [self verifyKeystorePassword5];
//    [self verifyKeystorePassword6];
//
//    [self decryptKeystore1];
//    [self decryptKeystore2];
//    [self decryptKeystore3];
//    [self decryptKeystore4];
//    [self decryptKeystore5];
//    [self decryptKeystore6];
    
//    [self encryptPrivateKey1];
//    [self encryptPrivateKey2];
//    [self encryptPrivateKey3];
//    [self encryptPrivateKey4];
//    [self encryptPrivateKey5];
//    [self encryptPrivateKey6];
//    [self encryptPrivateKey7];
//
//    [self signTransfer1];
//    [self signTransfer2];
//    [self signTransfer3];
//    [self signTransfer4];
//    [self signTransfer5];
//    [self signTransfer6];
//    [self signTransfer7];
    
//    [self signAndSendTransfer1];
//    [self signAndSendTransfer2];
//    [self signAndSendTransfer3];
//    [self signAndSendTransfer4];
//    [self signAndSendTransfer5];
//    [self signAndSendTransfer6];
//    [self signAndSendTransfer7];
//
//    [self signAndSend];
//    [self sign];
    
}


- (void)signAndSend
{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
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
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString *chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockRef:^(NSString *blockRef) {
            
            NSLog(@"blockRef == %@",blockRef);
            //If the blockRef is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter createTransactionParameter:^(TransactionParameterBuiler *builder) {
                
                builder.chainTag = chainTag;
                builder.blockRef = blockRef;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString *errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signAndSendTransferWithParameter:transactionModel
                                                     keystore:keystore
                                                     password:@"123456"
                                                     callback:^(NSString *txId)
                 {
                     //Developers can use txid to query the status of data packaged on the chain
                     
                     NSLog(@"\n txId: %@", txId);
                 }];
            }
        }];
    }];
}

- (void)sign
{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
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
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString *chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockRef:^(NSString *blockRef) {
            
            NSLog(@"blockRef == %@",blockRef);
            //If the blockRef is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter createTransactionParameter:^(TransactionParameterBuiler *builder) {
                
                builder.chainTag = chainTag;
                builder.blockRef = blockRef;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString *errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signWithParameter:transactionModel
                                      keystore:keystore
                                      password:@"123456"
                                      callback:^(NSString *txId)
                 {
                     //Developers can use txid to query the status of data packaged on the chain
                     
                     NSLog(@"\n txId: %@", txId);
                 }];
            }
        }];
    }];
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

@end

