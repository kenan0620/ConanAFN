//
//  AFNConanTheCurrentVC.m
//  ConanAFN
//
//  Created by Conan on 2017/8/2.
//  Copyright © 2017年 Conan. All rights reserved.
//

#import "AFNConanTheCurrentVC.h"

@implementation AFNConanTheCurrentVC

+ (UIViewController *)getCurrentVC{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}

@end
