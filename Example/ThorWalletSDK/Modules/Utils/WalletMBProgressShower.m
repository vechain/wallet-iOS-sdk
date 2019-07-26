//
//  WalletMBProgressShower.m
//  VeChain
//
//  Created by VeChain on 18/4/7.
//  Copyright © 2019 VeChain. All rights reserved.
//

#import "WalletMBProgressShower.h"

const NSInteger kFFBMSHudTag = 12345;

@implementation WalletMBProgressShower

+(MBProgressHUD*)showCircleIn:(UIView*)view{
    MBProgressHUD *org_hud = [view viewWithTag:kFFBMSHudTag];
    if(org_hud){
        [org_hud hideAnimated:NO];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view
                                              animated:YES];
    hud.tag = kFFBMSHudTag;
    return hud;
}

+(MBProgressHUD*)showTextIn:(UIView*)view Text:(NSString*)text{
    MBProgressHUD *org_hud = [view viewWithTag:kFFBMSHudTag];
    if(org_hud){
        [org_hud hideAnimated:NO];
        
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view
                                              animated:YES];
    hud.tag = kFFBMSHudTag;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;

    return hud;
}

+(MBProgressHUD*)showMulLineTextIn:(UIView*)view Text:(NSString*)text{
    MBProgressHUD *org_hud = [view viewWithTag:kFFBMSHudTag];
    if(org_hud){
        [org_hud hideAnimated:NO];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view
                                              animated:YES];
    hud.tag = kFFBMSHudTag;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = text;
    return hud;
}

+(void)showTextIn:(UIView*)view Text:(NSString*)text During:(NSTimeInterval)time{
    if (text.length == 0) {
        
        MBProgressHUD *org_hud = [view viewWithTag:kFFBMSHudTag];
        if(org_hud){
            [org_hud hideAnimated:NO];
        }
        return;
    }
    
    MBProgressHUD *org_hud = [view viewWithTag:kFFBMSHudTag];
    if(org_hud){
        [org_hud hideAnimated:NO];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view
                                              animated:YES];
    hud.tag = kFFBMSHudTag;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text =  text;

    [hud hideAnimated:NO afterDelay:time];
}

+(void)showMulLineTextIn:(UIView*)view Text:(NSString*)text During:(NSTimeInterval)time{
    if (text.length == 0) {
        MBProgressHUD *org_hud = [view viewWithTag:kFFBMSHudTag];
        if(org_hud){
            [org_hud hideAnimated:NO];
        }
        return;
    }
    
    MBProgressHUD *org_hud = [view viewWithTag:kFFBMSHudTag];
    if(org_hud){
        [org_hud hideAnimated:YES];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view
                                              animated:YES];
    hud.tag = kFFBMSHudTag;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text =  text;

    [hud hideAnimated:YES afterDelay:time];
}

+ (MBProgressHUD*)showLoadData:(UIView*)view Text:(NSString*)text
{
    MBProgressHUD *org_hud = [view viewWithTag:kFFBMSHudTag];
    if(org_hud){
        [org_hud hideAnimated:YES];
        [org_hud removeFromSuperview];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.tag = kFFBMSHudTag;
    hud.label.text = text;
    // Set the details label text. Let's make it multiline this time
    return hud;
}


+(void)hide:(UIView*)view{
    MBProgressHUD* hud = [view viewWithTag:kFFBMSHudTag];
    if(hud){
      [hud hideAnimated:YES];
    }
}


@end
