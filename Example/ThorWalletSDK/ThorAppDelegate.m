//
//  ThorAppDelegate.m
//  ThorWalletSDK
//
//  Created by VeChain on 05/21/2019.
//  Copyright (c) 2019 VeChain. All rights reserved.
//

#import "ThorAppDelegate.h"
#import "ThorViewController.h"
#import "WalletUtils.h"

@implementation ThorAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    ThorViewController *vc = [[ThorViewController alloc] init];
    UINavigationController *nVC = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nVC;
    
    [self.window makeKeyAndVisible];
    
    //Set it as a main net environment
    [WalletUtils setNodeUrl:Main_Node];
    
    //Or if you have a custom node url, you can change it to your own node url:
    //[WalletUtils setNodeUrl:@"https://www.yourCustomNodeUrl.com"]; //your custom node Url
    
    //Set it as a test net environment:
    //[WalletUtils setNodeUrl:Test_Node];
    
    //If nodeUrl is not set, the default value is main net
   
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
