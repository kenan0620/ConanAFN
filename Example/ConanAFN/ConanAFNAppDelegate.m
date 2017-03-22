//
//  ConanAFNAppDelegate.m
//  ConanAFN
//
//  Created by acct<blob>=<NULL> on 03/20/2017.
//  Copyright (c) 2017 acct<blob>=<NULL>. All rights reserved.
//

#import "ConanAFNAppDelegate.h"
#import <ConanAFN/ConanAfnBase.h>
#import <ConanAFN/ConanAfnAPI.h>

@implementation ConanAFNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self ConanAfnSetup];
    return YES;
}

-(void)ConanAfnSetup
{
    //设置请求数据类型、返回数据类型
    [ConanAfnBase ConfigRequestType:ConanAfnRequestSendDataTypeJSON ResponseDataType:ConanAfnResponseDataTypeJSON];
    //设置请求超时时间、最大并发数
    [ConanAfnBase ConfigConanAfnTimeOut:20.0f MaxConcurrentOperationCount:3];
    //设置请求API域名(或者根目录)
    NSString * url= @"https://baidu/api/";
    [ConanAfnAPI ConfigConanAfnBaseUrl:url];
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
