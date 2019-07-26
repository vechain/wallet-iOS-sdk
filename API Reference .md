# The wallet function is implemented by calling class: WalletUtils

## SDK initialization

SDK initialization
Inherit the AppDelegate class and implement the following methods:
```obj-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //Set it as a main net environment
    [WalletUtils setNodeUrl:Main_Node];
    
    //Or if you have a corresponding node url, you can change it to your own node url:
    //[WalletUtils setNodeUrl:@"https://www.yourCustomUrl.com"]; //your custom node url
    
    //Switching test net url:
    //[WalletUtils setNodeUrl:Test_Node];
    
    //If nodeUrl is not set, the default value is main net
    
    ...
    
    return YES;
}
```

##  Set node url   
>
>  
> Node: Any form of server in a block chain network.
> 
> Node url: Unified resource location address for participating block chain servers.
>
```obj-c
/*
 *  @param nodelUrl : node url
 */ 
+ (void)setNodeUrl:(NSString *)nodelUrl;
```

Eg:
```obj-c
 //Set it as a main net environment
 [WalletUtils setNodeUrl:Main_Node];

 //Or if you have a corresponding node url, you can change it to your own node url:
 [WalletUtils setNodeUrl:@"https://www.yourCustomUrl.com"]; //your custom node Url
            
 //Switching test net url:
 [WalletUtils setNodeUrl:Test_Node];

 //If nodeUrl is not set, the default value is main net
 
```   




##  Get node url   
### If nodeUrl is not set, the default value is Main_Node.
```obj-c
+ (NSString *)getNodeUrl;
 ```
Eg:
```obj-c
 NSString *nodeUrl = [WalletUtils getNodeUrl];

```


##  Create wallet   
After entering the wallet password, the user can create the wallet through the following methods:


```obj-c
/*
 *  @param password : Wallet password
 *  @param callback : Callback after the end;The attributes of a class has mnemonicPhras , address, privateKey, keystore
 */
+ (void)createWalletWithPassword:(NSString *)password  
                        callback:(void(^)(WalletAccountModel *account,NSError *error))callback;
```

Eg:
```obj-c
 //Create a wallet with your password.
 [WalletUtils createWalletWithPassword:password
                              callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error)

 {
       if(error == nil){
    
            NSString *mnemonic = [account.words componentsJoinedByString:@" "];
            NSString *address = account.address;
            NSString *privateKey = account.privatekey;
            NSString *keystore = account.keystore;
        
             //Keystore is saved in files or databases
             
        }else{
            //fail
        }
 }];
    
```



## Create wallet with mnemonic words  
When the user has mnemonic words, enter the mnemonic words and the password of the keystore of the wallet to import the wallet. The method of using the mnemonic words as follows:


```obj-c
/*
 *  @param mnemonicWords :Mnemonic Words
 *  @param password : Wallet password
 *  @param callback : Callback after the end;The attributes of a class has mnemonicPhras , address, privateKey, keystore
 */
+ (void)createWalletWithMnemonicWords:(NSArray<NSString *> *)mnemonicWords
                            password:(NSString *)password
                            callback:(void(^)(WalletAccountModel *account,NSError *error))callback;

```

Eg:
```obj-c
 // Create a wallet with your password and mnemonic words.
 [WalletUtils createWalletWithMnemonicWords:mnemonicWords
                                   password:self.password.text
                                   callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error)
 {
        if(error == nil){
            
            NSString *address = account.address;
            NSString *privateKey = account.privatekey;
            NSString *keystore = account.keystore;

            //Keystore is saved in files or databases
            
        }else{
            //fail
        }
 }];

```

##  Verify the mnemonic words    

```obj-c
/*
 *  @param mnemonicWords : Mnemonic words,Number of mnemonic words : 12, 15, 18, 21 and 24.
 *  @return result
 */
+ (BOOL)isValidMnemonicWords:(NSArray<NSString *> *)mnemonicWords;
```

Eg:
```obj-c
 NSString *mnemonicWords = @"admit mad dream stable scrub rubber cabbage exist maple excuse copper month";
 BOOL isValid = [WalletUtils isValidMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "]];
 // isValid is YES
```
##  Verify keystore format   



```obj-c
/*
 *  @param keystoreJson :Keystore JSON encryption format for user wallet private key
 *  @return verification result
 */
+ (BOOL)isValidKeystore:(NSString *)keystoreJson;
```
Eg:
```obj-c
 NSString *keystore = @"{\"version\":3,\"id\":\"1150C15C-2E20-462B-8A88-EDF8A0E4DB71\",\n \"crypto\":{\"ciphertext\":\"1cf8d74d31b1ec2568f903fc2c84d215c0401cbb710b7b3de081af1449ae2a89\",\"cipherparams\":{\"iv\":\"03ccae46eff93b3d9bdf2b21739d7205\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"r\":8,\"p\":1,\"n\":262144,\"dklen\":32,\"salt\":\"a71ecee9a1c33f0311e46f7da7da8d218a8c5b3d1067716a9bcdb767785d8e83\"},\"mac\":\"82b20c61854621f35b4d60ffb795655258356f310cdffa587f7db68a1789de75\",\"cipher\":\"aes-128-ctr\"},\"address\":\"cc2b456b2c9399b4b68ef632cf6a1aeabe67b417\"}";
 BOOL isValid = [WalletUtils isValidKeystore:keystore];
 // isValid is YES
    
```





## Verify the keystore with a password   

 ```obj-c
 /*
  *  @param keystoreJson :  Keystore JSON encryption format for user wallet private key
  *  @param password :  Wallet password
  *  @param callback : Callback after the end
  */
+ (void)verifyKeystore:(NSString *)keystoreJson
              password:(NSString *)password
              callback:(void (^)(BOOL result))callback;
```

Eg:
 ```obj-c
 //Verification keystore
 [WalletUtils verifyKeystore:keystore password:password callback:^(BOOL result) {
        if (result) {
            //success
            
            //Keystore is saved in files or databases
        }else{ //fail
            
        }
  }];
    
```

## Modify password of keystore

 ```obj-c
 /*
  *  @param oldPassword : old password for wallet.
  *  @param newPassword : new password for wallet.
  *  @param keystoreJson :  Keystore JSON encryption format for user wallet private key
  *  @param callback : Callback after the end
  */
+ (void)modifyKeystore:(NSString *)keystoreJson
           newPassword:(NSString *)newPassword
           oldPassword:(NSString *)oldPassword
              callback:(void (^)(NSString *newKeystore))callback;
```

Eg:
 ```obj-c
 //change Password
 [WalletUtils modifyKeystore:keystore 
                 newPassword:newPassword 
                 oldPassword:oldPassword 
                    callback:^(NSString * _Nonnull newKeystore) {

        if (newKeystore.length > 0) {
            //success
            //Keystore is saved in files or databases
        }else {
            //fail
        }
 }];
    
```

##  Decrypt keystore
 ```obj-c
 /*
  *  @param keystoreJson : Keystore JSON encryption format for user wallet private key
  *  @param password : Wallet password
  *  @param callback : Callback after the end. Callback after the end;The attributes of a class has mnemonicPhras , address, privateKey, keystore
  */
+ (void)decryptkeystore:(NSString *)keystoreJson
               password:(NSString *)password
               callback:(void(^)(WalletAccountModel *account,NSError *error))callback;
```

Eg:
 ```obj-c
 //Get the private key through the keystore
 NSString *keystoreJson = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";

 [WalletUtils decryptKeystore:keystoreJson
                     password:@"123456" 
                     callback:^(NSString * _Nonnull privatekey, NSError * _Nonnull error) {
        
        if (!error) {
            //success
            
            //privateKey:0xbc9fe2428a8faec37674412c113f4a9a66b2e40076014547bfe7bbdc2c5a85ee

        }else //fail
        {
            
        }
 }];
 
```
## Encrypted private key

```obj-c
/*
 *  @param password : Wallet password
 *  @param privateKey : PrivateKey
 *  @param callback : Callback after the end. keystoreJson : Keystore in json format
 */
+ (void)encryptPrivateKeyWithPassword:(NSString *)password
                           privateKey:(NSString *)privateKey
                             callback:(void (^)(NSString *keystoreJson))callback;

```
Eg:
```obj-c
 //Private key to keystore
 NSString *privatekey = @"0xbc9fe2428a8faec37674412c113f4a9a66b2e40076014547bfe7bbdc2c5a85ee";
 [WalletUtils encryptPrivateKeyWithPassword:@"123"
                                 privateKey:privatekey
                                   callback:^(NSString * _Nonnull keystoreJson) {
                                          
                                          NSString *address = [WalletUtils getAddressWithKeystore:keystoreJson];
                                          //address:0x36D7189625587D7C4c806E0856b6926Af8d36FEa
                                      }];
```

##  Get checksum address    

```obj-c
/*
 *  @param address :Wallet address
 *  @return checksum address
 */
+ (NSString *)getChecksumAddress:(NSString *)address;
```
Eg:
```obj-c
 //Get checksum address
 NSString *address = @"0x36d7189625587d7c4c806e0856b6926af8d36fea";
 NSString *checksumAddress = [WalletUtils getChecksumAddress:address];
 //checkSumAddress:0x36D7189625587D7C4c806E0856b6926Af8d36FEa
```
##  Get address from keystore   

 ```obj-c
 /*
  *  @param keystoreJson :  Keystore JSON encryption format for user wallet private key
  */
+ (NSString *)getAddressWithKeystore:(NSString *)keystoreJson;
 ```
Eg:
 ```obj-c
 //Get the address through the keystore
 NSString *keystoreJson = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    
 NSString *address = [WalletUtils getAddressWithKeystore:keystoreJson];
 //address:0x36D7189625587D7C4c806E0856b6926Af8d36FEa
 
```



 ##  Get chainTag of block chain 

 ```obj-c
 /*
  *  @param callback : Callback after the end
  */
+ (void)getChainTag:(void (^)(NSString *chainTag))callback;
    
```
Eg:
 ```obj-c
 //Get the chain tag of the block chain
 [WalletUtils getChainTag:^(NSString * _Nonnull chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        
        //Main_Node chainTag:0x4a
        //Test_Node chainTag:0x27
 }];
    
```
 ## Get the blockRef  
 >  @param callback : Callback after the end.    
 >
 >
 ```obj-c
 /*
  *  @param callback : Callback after the end
  */
+ (void)getBlockRef:(void (^)(NSString *blockRef))callback;
 ```
Eg:
 ```obj-c
 //Get the blockRef  
 [WalletUtils getBlockRef:^(NSString * _Nonnull blockRef) {
            NSLog(@"blockRef == %@",blockRef);
 }];

```
 


##   Sign and send transaction

```obj-c
/*
 *  @param parameter : Signature parameters
 *  @param keystoreJson :  Keystore JSON encryption format for user wallet private key
 *  @param password : Wallet password
 *  @param callback : Callback after the end
 */
+ (void)signAndSendTransferWithParameter:(TransactionParameter *)parameter
                                keystore:(NSString*)keystoreJson
                                password:(NSString *)password
                                callback:(void(^)(NSString *txId))callback;
```
Eg:
```obj-c
 [WalletUtils signAndSendTransferWithParameter:transactionModel
                                      keystore:keystore
                                      password:password
                                      callback:^(NSString * _Nonnull txId)
                     {
                         //Developers can use txid to query the status of data packaged on the chain

                         NSLog(@"\n txId: %@", txid);
                         
                         // Pass txid and signature address back to dapp webview
                         NSString *singerAddress = [WalletUtils getAddressWithKeystore:keystore];
                         callback(txid,singerAddress.lowercaseString);
                         
                     }];

```
TransactionParameter attribute description：

- clauses : NSArry<Clause> - Multi-transaction information

- gas : NSString  - Miner Fee Parameters for Packing

- chainTag : NSString - Genesis block ID last byte hexadecimal.[WalletUtils getChainTag]

- blockRef : NSString - Refer to the last 8 bytes of blockId in hexadecimal.[WalletUtils getBlockRef]

- nonce : NSString  - The random number of trading entities. Changing Nonce can make the transaction have different IDs, which can be used to accelerate the trader.

- gasPriceCoef : NSString - This value adjusts the priority of the transaction, and the current value range is between 0 and 255 (decimal),The default value is "0"

- expiration : NSString - Deal expiration/expiration time in blocks,The default value is "720"

- dependsOn :NSString - The ID of the dependent transaction. If the field is not empty, the transaction will be executed only if the transaction specified by it already exists.The default value is null.

- reserveds: List  -  Currently empty, reserve fields. Reserved fields for backward compatibility,The default value is null

```obj-c

    NSMutableData* randomData = [[NSMutableData alloc]initWithCapacity:8];
    randomData.length = 8;
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
       
        return ;
    }
    //nonce: hex string
    NSString *nonce = [BigNumber bigNumberWithData:randomData].hexString;

    TransactionParameter *transactionModel = [TransactionParameterBuiler creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
                builder.chainTag        = chainTag;
                builder.blockRef  = blockRef;
                builder.nonce           = nonce;
                builder.clauses         = clauseList;
                builder.gas             = gas;
                builder.expiration      = expiration;
                builder.gasPriceCoef    = gasPriceCoef;
                
            } checkParams:^(NSString * _Nonnull errorMsg) {
               
            }];
    }];
    
```

##   Sign transaction
```obj-c
/*
 *  @param parameter : Transaction parameters
 *  @param keystoreJson :  Keystore JSON encryption format for user wallet private key
 *  @param password : Wallet password
 *  @param callback :  Callback after the end. raw: RLP encode data and signature
 */
+ (void)signWithParameter:(TransactionParameter *)parameter
                 keystore:(NSString*)keystoreJson
                 password:(NSString*)password
                 callback:(void(^)(NSString *raw))callback;
```
Eg:
```obj-c
 [WalletUtils signWithParameter:transactionModel
                       keystore:keystore
                       password:password
                       callback:^(NSString * _Nonnull raw)
                     {

                         NSLog(@"\n raw: %@", raw);
                         
                     }];
                     
```




#  Support DApp development environment in Webview by calling class: WalletDAppHandle
To support the Dapp function, WebView needs the following initialization before opening Dapp.
Initialization is mainly JS injected into connex and web3.
[connex reference.](https://github.com/vechain/connex/blob/master/docs/api.md/)

###  Set delegate to SDK

```obj-c

@property (nonatomic, weak) id<WalletDAppHandleDelegate> delegate;

```
Eg:
```obj-c

 // Set delegate
 @interface DemoWebViewVC ()<WKNavigationDelegate,WKUIDelegate,WalletDAppHandleDelegate>
...
 _dAppHandle = [[WalletDAppHandle alloc]init];
 _dAppHandle.delegate = self;

```


##   Inject js into webview   

```obj-c
/*
 *  @param config : Developer generated WKWebViewConfiguration object
 */
- (void)injectJSWithConfig:(WKWebViewConfiguration *)config;  
```

Eg:
```obj-c
 // Please note that, This is a 'WKWebView' object, does not support a "UIWebView" object.

 WKWebViewConfiguration* configuration = [[WKWebViewConfiguration alloc] init];
 configuration.userContentController = [[WKUserContentController alloc] init];
    
 //inject js to wkwebview
 
 [_dAppHandle injectJSWithConfig:configuration];

```

##  Parsing data in webview's callback method runJavaScriptTextInputPanelWithPrompt

```obj-c
/*
 *  @param webView : The web view invoking the delegate method.
 *  @param defaultText : The initial text to display in the text entry field.
 *  @param completionHandler : The completion handler to call after the text
input panel has been dismissed. Pass the entered text if the user chose
OK, otherwise nil.
*/
- (void)webView:(WKWebView *)webView 
    defaultText:(NSString *)defaultText 
completionHandler:(void (^)(NSString *result))completionHandler;
```

Eg:
```obj-c
/*
* You must implement this delegate method to call js.
*/
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
        
    /*
     You must call this method. It is used to response web3 or connex operations.
     */
    [_dAppHandle webView:webView  defaultText:defaultText completionHandler:completionHandler];
}

```


 ## Memory Recycling to Prevent Memory Leakage  

 ```obj-c
 /**
 *  Call this method when exiting the contrller where dapp is located
 */
- (void)deallocDApp;
```
Eg:
 ```obj-c
/**
 * You must implement this method to free memory, otherwise there may be a memory overflow or leak.
 */
- (void)dealloc{
    [_dAppHandle deallocDApp];
}
```

 

 ##  App developer implementation when DApp calls transaction function  

 ```obj-c
 /*
  *  Delegate function that must be implemented to support the DApp environment
  *
  *  @param clauses : Clause model list
  *  @param gas : Set maximum gas allowed for call
  *  @param signer : Enforces the specified address to sign the transaction.May be  nil
  *  @param callback : Callback after the end. txId:Transaction identifier; signer:Signer address
  *
  */
- (void)onWillTransfer:(NSArray<ClauseModel *> *)clauses
                signer:(NSString *)signer
                   gas:(NSString *)gas
     completionHandler:(void(^)(NSString *txId ,NSString *signer))completionHandler;
 ```

Eg:
 ```obj-c
- (void)onWillTransfer:(NSArray<ClauseModel *> *)clauses
                signer:(NSString *)signer
                   gas:(NSString *)gas
     completionHandler:(void(^)(NSString *txid ,NSString *signer))completionHandler
{
    
   //Get the local keystore
    
    NSString *address = [WalletUtils getAddressWithKeystore:keystore];
    
    //Specified signature address
    if (signer.length > 0 && ![address.lowercaseString isEqualToString:signer.lowercaseString]) {
        
        completionHandler(@"",signer.lowercaseString);
        return;
    }


    ... Preparation parameters
    ... Assembly transactionParameter
    ... Verify parameters
    ... Initiate a transaction

[WalletUtils signAndSendTransferWithParameter:transactionModel
                                     keystore:keystore
                                     password:password
                                     callback:^(NSString * _Nonnull txId)
                     {
                         //Developers can use txid to query the status of data packaged on the chain

                         NSLog(@"\n txId: %@", txid);
                         
                         // Pass txid and signature address back to dapp webview
                         NSString *singerAddress = [WalletUtils getAddressWithKeystore:keystore];
                         completionHandler(txId,singerAddress.lowercaseString);
                         
                     }];


}

 ```


 ##  App developer implementation when DApp calls get address function    
 
 
```obj-c
/*
 *  Delegate function that must be implemented to support the DApp environment
 *  @param callback : Callback after the end
 */
- (void)onGetWalletAddress:(void(^)(NSArray<NSString *> *addressList))callback;
```
Eg:
```obj-c
- (void)onGetWalletAddress:(void (^)(NSArray<NSString *> * _Nonnull))callback
{
    //Get the wallet address from local database or file cache

    //Callback to webview
    callback(@[address]);
}
```



 ##   App developer implementation when dapp calls authentication function   

  
 ```obj-c
 /*
  *   Delegate function that must be implemented to support the DApp environment
  *
  *  @param certificateMessage : string to be signed,form dapp
  *  @param signer : Enforces the specified address to sign the certificate.May be nil
  *  @param callback : Callback after the end.signer: Signer address; signatureData : Signature is 65 bytes
 */
- (void)onWillCertificate:(NSString *)certificateMessage 
                   signer:(NSString *)signer 
        completionHandler:(void(^)(NSString *signer, NSData *signatureData))completionHandler;
 ```
 
Eg:
 ```obj-c
- (void)onWillCertificate:(NSString *)certificateMessage 
                   signer:(NSString *)signer 
        completionHandler:(void (^)(NSString * signer, NSData *  signatureData))completionHandler
{
   
    
    if (signer.length > 0) { //Specified signature address
       
        if ([address.lowercaseString isEqualToString:signer.lowercaseString]) {
            
            //Add the signature address to the authentication signature data  
            NSString *strMessage = [WalletUtils addSignerToCertMessage:signer.lowercaseString message:certificateMessage];
            [self signCert:strMessage signer:address.lowercaseString keystore:keystore callback:callback];
        }else{
            //Cusmtom alert error
            completionHandler(@"",nil);
        }
    }else{
        
        //Add the signature address to the authentication signature data  
        NSString *strMessage = [WalletUtils addSignerToCertMessage:address.lowercaseString message:certificateMessage];
        [self signCert:strMessage signer:address.lowercaseString keystore:keystore callback:callback];
    }


    ... Verify password

                                    
  NSData *dataMessage = [strMessage dataUsingEncoding:NSUTF8StringEncoding];

 [WalletUtils signWithMessage:dataMessage
                     keystore:keystore 
                     password:password
                     callback:^(NSData * _Nonnull signatureData, NSError * _Nonnull error) {
                                         
                                         if (!error) {
                                             completionHandler(signer,signatureData);
                                         }else{
                                                                          
                                             completionHandler(signer,nil);

                                             NSLog(@"error == %@",error.userInfo);
                                         }
                                     }];

}

 ```



 ##    App developer implementation when dapp calls checkOwnaddress function   
 

  
```obj-c
/*
 *  Delegate function that must be implemented to support the DApp environment
 *  @param address : Address from dapp
 *  @param callback : Callback after the end
 */
- (void)onCheckOwnAddress:(NSString *)address callback:(void(^)(BOOL result))callback;
```
Eg:
```obj-c
- (void)onCheckOwnAddress:(NSString *)address callback:(void(^)(BOOL result))callback
{
    if ([localAddrss.lowercaseString isEqualToString:address.lowercaseString]) {
        callback(YES);
    }else{
        callback(NO);
    }
}

```
## Tips

Before the release of DApp, it is recommended that different versions of WebView be adapted to ensure the reliable and stable operation of HTML 5 pages.

## Several main data structures

### keystore
```obj-c
/**
*  Keystore is a json string. Its file structure is as follows:
*
*  — — — — — — — — — — — — — — — — — — — — — — — — — — ——
*      {
*          "version": 3,
*          "id": "F56FDA19-FB1B-4752-8EF6-E2F50A93BFB8",
*          "kdf": "scrypt",
*          "mac": "9a1a1db3b2735c36015a3893402b361d151b4d2152770f4a51729e3ac416d79f",
*          "cipher": "aes-128-ctr"
*          "address": "ea8a62180562ab3eac1e55ed6300ea7b786fb27d"
*          "crypto": {
*                      "ciphertext": "d2820582d2434751b83c2b4ba9e2e61d50fa9a8c9bb6af64564fc6df2661f4e0",
*                      "cipherparams": {
*                                          "iv": "769ef3174114a270f4a2678f6726653d"
*                                      },
*                      "kdfparams": {
*                              "r": 8,
*                              "p": 1,
*                              "n": 262144,
*                              "dklen": 32,
*                              "salt": "67b84c3b75f9c0bdf863ea8be1ac8ab830698dd75056b8133350f0f6f7a20590"
*                      },
*          },
*      }
*
*  — — — — — — — — — — — — — — — — — — — — — — — — — — ——
*  Field description:
*          version: This is a version information, when you decryption, you should use the same version.
*          id: You can ignore. It is just a UUIDString.
*          Kdf: This is a encryption function.
*          mac: This is the mac device information.
*          cipher: Describes the encryption algorithm used.
*          address：The wallet address.
*          crypto: This section is the main encryption area.
*
*  If you want to recover a wallet by keystore, you should have the correct password.
*
*/
```
### Hexadecimal must start with 0x.

### Address : 20 bytes hex string and start with 0x.

### Availabel DApp List
```
https://vechainstats.com
https://oceanex.pro/reg/v190528
https://connex.vexchange.io/swap
https://bmac.vecha.in/generate
https://bc66.github.io/lucky-airdrop/#/
https://explore.veforge.com/
https://laalaguer.github.io/vechain-token-transfer/
https://doc.vechainworld.io/docs
https://vechainstore.com/ide
https://vepress.org/
https://inspector.vecha.in/
https://insight.vecha.in
https://vechaininsider.com/
```


