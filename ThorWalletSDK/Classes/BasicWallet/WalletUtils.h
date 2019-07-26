//
//  WalletUtils.h
//
//  Created by VeChain on 2018/8/12.
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



#import <Foundation/Foundation.h>
#import "WalletTransactionParameter.h"
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WalletAccountModel.h"
#import "BigNumber.h"
#import "WalletSDKMacro.h"
#import "SecureData.h"
#import "WalletDAppHandle.h"


@interface WalletUtils : NSObject

/**
 *  @abstract
 *  Set node url
 *
 *  @param nodelUrl : node url
 *
 */
+ (void)setNodeUrl:(NSString *)nodelUrl;

/**
 *  @abstract
 *  Get node url
 *
 */
+ (NSString *)getNodeUrl;

/**
 *  @abstract
 *  Create wallet
 *
 *  @param password : Wallet password
 *  @param callback : Callback after the end;The attributes of a class has mnemonicPhras , address, privateKey, keystore
 *
 */
+ (void)createWalletWithPassword:(NSString *)password
                       callback:(void(^)(WalletAccountModel *account,NSError *error))callback;

/**
 *  @abstract
 *  Create wallet with mnemonic words
 *
 *  @param mnemonicWords :Mnemonic Words
 *  @param password : Wallet password
 *  @param callback : Callback after the end;The attributes of a class has mnemonicPhras , address, privateKey, keystore
 */

+ (void)createWalletWithMnemonicWords:(NSArray<NSString *> *)mnemonicWords
                            password:(NSString *)password
                            callback:(void(^)(WalletAccountModel *account,NSError *error))callback;

/**
 *  @abstract
 *  Verify mnemonic words
 *
 *  @param mnemonicWords : Mnemonic words,Number of mnemonic words : 12, 15, 18, 21 and 24.
 *  @return result
 */
+ (BOOL)isValidMnemonicWords:(NSArray<NSString *> *)mnemonicWords;

/**
 *  @abstract
 *  Get checksum address
 *
 *  @param address :Wallet address
 *
 *  @return checksum address
 */
+ (NSString *)getChecksumAddress:(NSString *)address;

/**
 *  @abstract
 *  Recover address
 *
 *  @param message : Data to be signed
 *  @param signatureData : Signature is 65 bytes
 *
 *  @return address
 */
+ (NSString *)recoverAddressFromMessage:(NSData*)message
                          signatureData:(NSData*)signatureData;

/**
 *  @abstract
 *  Verify keystore format
 *
 *  @param keystoreJson :Keystore JSON encryption format for user wallet private key
 *
 *  @return verification result
 */
+ (BOOL)isValidKeystore:(NSString *)keystoreJson;


/**
 *  @abstract
 *  Get address from keystore
 *
 *  @param keystoreJson :  Keystore JSON encryption format for user wallet private key
 *
 */
+ (NSString *)getAddressWithKeystore:(NSString *)keystoreJson;

/**
 *  @abstract
 *  Change Wallet password
 *
 *  @param oldPassword : old password for wallet.
 *  @param newPassword : new password for wallet.
 *  @param keystoreJson :  Keystore JSON encryption format for user wallet private key
 *  @param callback : Callback after the end
 *
 */
+ (void)modifyKeystore:(NSString *)keystoreJson
           newPassword:(NSString *)newPassword
           oldPassword:(NSString *)oldPassword
              callback:(void (^)(NSString *newKeystore))callback;;

/**
 *  @abstract
 *  Verify the keystore with a password
 *
 *  @param keystoreJson :  Keystore JSON encryption format for user wallet private key
 *  @param password :  Wallet password
 *  @param callback : Callback after the end
 *
 */
+ (void)verifyKeystore:(NSString *)keystoreJson
              password:(NSString *)password
              callback:(void (^)(BOOL result))callback;
/**
 *  @abstract
 *  Decrypt keystore
 *
 *  @param keystoreJson : Keystore JSON encryption format for user wallet private key
 *  @param password : Wallet password
 *  @param callback : Callback after the end. Callback after the end;The attributes of a class has mnemonicPhras , address, privateKey, keystore
 *
 */
+ (void)decryptKeystore:(NSString*)keystoreJson
               password:(NSString*)password
               callback:(void(^)(NSString *privateKey,NSError *error))callback;


/**
 *  @abstract
 *  Encrypted private key
 *
 *  @param password : Wallet password
 *  @param privateKey : PrivateKey
 *  @param callback : Callback after the end. keystoreJson : Keystore in json format
 *
 */
+ (void)encryptPrivateKeyWithPassword:(NSString*)password
                           privateKey:(NSString *)privateKey
                            callback:(void (^)(NSString *keystoreJson))callback;

/**
 *  @abstract
 *   Get chainTag of block chain
 *
 *  @param callback : Callback after the end
 *
 */
+ (void)getChainTag:(void (^)(NSString *chainTag))callback;

/**
 *  @abstract
 *   Get reference of block chain
 *  @param callback : Callback after the end
 *
 */
+ (void)getBlockRef:(void (^)(NSString *blockRef))callback;


/**
 *  @abstract
 *   Signed transaction
 *
 *  @param parameter : Transaction parameters
 *  @param keystoreJson :  Keystore JSON encryption format for user wallet private key
 *  @param password : Wallet password
 *  @param callback :  Callback after the end. raw: RLP encode data and signature
 *
 */
+ (void)signWithParameter:(WalletTransactionParameter *)parameter
                 keystore:(NSString*)keystoreJson
                 password:(NSString*)password
                 callback:(void(^)(NSString *raw))callback;

/**
 *  @abstract
 *  Sign message
 *
 *  @param message : Prepare the data to be signed
 *  @param keystoreJson :  Keystore JSON encryption format for user wallet private key
 *  @param password : Wallet password
 *  @param callback : Callback after the end
 *
 */
+ (void)signWithMessage:(NSData *)message
               keystore:(NSString*)keystoreJson
               password:(NSString*)password
               callback:(void (^)(NSData *signatureData))callback;

/**
 *  @abstract
 *  Add the signature address to the authentication signature data
 *
 *  @param signer : Enforces the specified address to sign the certificate
 *  @param message : Authentication signature data
 */
+ (NSString *)addSignerToCertMessage:(NSString *)signer message:(NSString *)message;

/**
 *  @abstract
 *  Sign and send
 *
 *  @param parameter : Signature parameters
 *  @param keystoreJson :  Keystore JSON encryption format for user wallet private key
 *  @param password : Wallet password
 *  @param callback : Callback after the end
 *
 */
+ (void)signAndSendTransferWithParameter:(WalletTransactionParameter *)parameter
                            keystore:(NSString*)keystoreJson
                            password:(NSString *)password
                            callback:(void(^)(NSString *txId))callback;




@end
