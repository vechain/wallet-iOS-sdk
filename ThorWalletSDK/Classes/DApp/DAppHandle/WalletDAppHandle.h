//
//  WalletDAppHandle.h
//  Wallet
//
//  Created by VeChain on 2019/1/11.
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




#import <UIKit/UIKit.h>
#import "WalletUtils.h"

NS_ASSUME_NONNULL_BEGIN
@protocol WalletDAppHandleDelegate <NSObject>

#pragma mark setDelegate

/**
 *  @abstract
 *  App developer implementation when dapp calls transaction function
 *  delegate function that must be implemented to support the DApp environment
 *
 *  @param clauses : Clause model list
 *  @param gas : Set maximum gas allowed for call
 *  @param signer : Enforces the specified address to sign the transaction.May be  nil
 *  @param completionHandler : Callback after the end. txId:Transaction identifier; signer:Signer address
 *
 */
- (void)onWillTransfer:(NSArray<ClauseModel *> *)clauses
                signer:(NSString *)signer
                   gas:(NSString *)gas
     completionHandler:(void(^)(NSString *txId ,NSString *signer))completionHandler;

/**
 *  @abstract
 *   App developer implementation when dapp calls get address function
 *   delegate function that must be implemented to support the DApp environment
 *
 *  @param callback : Callback after the end
 *
 */
- (void)onGetWalletAddress:(void(^)(NSArray<NSString *> *addressList))callback;

/**
 *  @abstract
 *   App developer implementation when dapp calls authentication function
 *   delegate function that must be implemented to support the DApp environment
 *
 *  @param certificateMessage : string to be signed,form dapp
 *  @param signer : Enforces the specified address to sign the certificate.May be  nil
 *  @param completionHandler : Callback after the end.signer: Signer address; signatureData : Signature is 65 bytes
 *
 */
- (void)onWillCertificate:(NSString *)certificateMessage
                   signer:(NSString *)signer
        completionHandler:(void(^)(NSString *signer, NSData *signatureData))completionHandler;


/*
 *  @abstract
 *   App developer implementation when dapp calls checkOwn address function
 *   delegate function that must be implemented to support the DApp environment
 *
 *  @param address : Address from dapp
 *  @param callback : Callback after the end
 *
 */
- (void)onCheckOwnAddress:(NSString *)address callback:(void(^)(BOOL result))callback;

@end

@interface WalletDAppHandle : NSObject

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *strStatus; //Save status data


/**
 *  @abstract
 *  Set delegate to SDK
 *
 */
@property (nonatomic, weak) id<WalletDAppHandleDelegate> delegate;

/*! @abstract
 *  Displays a JavaScript text input panel.
 *
 *  @param webView : The web view invoking the delegate method.
 *  @param defaultText : The initial text to display in the text entry field.
 *  @param completionHandler : The completion handler to call after the text
 input panel has been dismissed. Pass the entered text if the user chose
 OK, otherwise nil.
 */
- (void)webView:(WKWebView *)webView
    defaultText:(NSString *)defaultText
completionHandler:(void (^)(NSString *result))completionHandler;

/**
 *  @abstract
 *  Inject js into webview
 *
 *  @param config : Developer generated WKWebViewConfiguration object
 *
 */
- (void)injectJSWithConfig:(WKWebViewConfiguration *)config;

/**
 *  @abstract
 *  Release the singleton of dapp
 *
 *  Call this method when exiting the contrller where dapp is located
 *
 */
- (void)deallocDApp;

@end

NS_ASSUME_NONNULL_END
