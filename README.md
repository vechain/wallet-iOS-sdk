# Vechain ThorWallet SDK    


## Introduction

Vechain wallet SDK provides a series of functional interface can help the iOS developers, for example: quickly create the wallet, the private key signature, call the vechain block interface, put data in the vechain block, and support dapp development environment.

#### Features:

##### Setting
- Set node url
- Get node url

##### Manage Wallet
- Create wallet
- Create wallet with mnemonic words
- Get checksum address
- Change Wallet password
- Verify mnemonic words
- Verify keystore

##### Sign
- Sign transaction
- Sign and send transaction

##### Support DApp development environment
- 100% support for the [connex.](https://github.com/vechain/connex/blob/master/docs/api.md/)
- Support for web3 features :getNodeUrl, getAccounts,sign,getBalance


## Get Started 

####  Requires iOS 10

#### Latest version 1.0.0


#### Support installation with CocoaPods
 
 ```obj-c
    pod 'ThorWalletSDK', '~>  1.0.0'
 ```





#### Set up the node environment. (```Test_Node environment``` , ```Main_Node environment``` and custom node environment)

```obj-c
#import "WalletUtils.h"
```
```obj-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
   //Set it as a main net environment
    [WalletUtils setNodeUrl:Main_Node];
    
    //Or if you have a custom node url, you can change it to your own node url:
    //[WalletUtils setNodeUrl:@"https://www.yourCustomNodeUrl.com"]; //your custom node Url
    
    //Set it as a test net environment:
    //[WalletUtils setNodeUrl:Test_Node];
    
    //If nodeUrl is not set, the default value is main net
    
    ...
    
    return YES;
}
````

#### How to run simple demo 

 - Double click on the ThorWalletSDK.xcworkspace 
 - command + R,
 - run

## API Reference：

+ [API Reference](https://github.com/vechain/wallet-iOS-sdk/blob/master/API%20Reference%20.md) for VeChain app developers

## License

Vechain Wallet SDK is licensed under the ```MIT LICENSE```, also included
in *LICENSE* file in the repository.

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


