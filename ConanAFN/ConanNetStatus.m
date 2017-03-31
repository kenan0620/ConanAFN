//
//  ConanNetStatus.m
//  ConanAfn
//
//  Created by 柯南 on 2016/12/5.
//  Copyright © 2016年 柯南集团. All rights reserved.
//

#import "ConanNetStatus.h"

#import "ConanMacroDefine.h"


@implementation ConanNetStatus

static ConanNetStatus *conanNetSington;

+(ConanNetStatus *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        conanNetSington = [[ConanNetStatus alloc]init];
    });
    
    return conanNetSington;
}

- (void)listening
{
    [GLobalRealReachability startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:kRealReachabilityChangedNotification
                                               object:nil];
}

+ (ConanNetWorkType )currentReachabilityStatus
{
    ConanNetWorkType netType = ConanNet_UNKNOW;
    ReachabilityStatus status =[[RealReachability sharedInstance] currentReachabilityStatus];
    
    if (status == RealStatusNotReachable)
    {
        netType =ConanNet_UNKNOW;
        ConanLog(@"ConanNet_UNKNOW");
    }
    
    if (status == RealStatusViaWiFi)
    {
        netType =ConanNet_WIFI;
        ConanLog(@"ConanNet_WIFI");
    }
    
//    if (status == RealStatusViaWWAN)
//    {
//        netType =ConanNet_WWAN;
//        ConanLog(@"ConanNet_WWAN");
//    }
    
    WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
    
    if (status == RealStatusViaWWAN)
    {
        if (accessType == WWANType2G)
        {
            netType =ConanNet_2G;
            ConanLog(@"ConanNet_2G");
        }
        else if (accessType == WWANType3G)
        {
            netType = ConanNet_3G;
            ConanLog(@"ConanNet_3G");
        }
        else if (accessType == WWANType4G)
        {
            netType =ConanNet_4G;
            ConanLog(@"ConanNet_4G");
        }
        else
        {
            netType =ConanNet_UNKNOW;
            ConanLog(@"ConanNet_UNKNOW");
        }
    }

    return  netType;
}


- (void)networkChanged:(NSNotification *)notification
{
    RealReachability *reachability = (RealReachability *)notification.object;
    
    
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    ReachabilityStatus previousStatus = [reachability previousReachabilityStatus];
    NSLog(@"networkChanged, currentStatus:%@, previousStatus:%@", @(status), @(previousStatus));
    
    if (status == RealStatusNotReachable)
    {
        [self ConanNetUnknow];
    }
    
    if (status == RealStatusViaWiFi)
    {
        [self ConanNetIsChange:@"RealStatusViaWiFi"];
    }
    
    if (status == RealStatusViaWWAN)
    {
    }
    
    WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
    
    if (status == RealStatusViaWWAN)
    {
        if (accessType == WWANType2G)
        {
            [self ConanNetIsChange:@"RealReachabilityStatus2G"];
        }
        else if (accessType == WWANType3G)
        {
            [self ConanNetIsChange:@"RealReachabilityStatus3G"];
        }
        else if (accessType == WWANType4G)
        {
            [self ConanNetIsChange:@"RealReachabilityStatus4G"];
        }
        else
        {
            [self ConanNetUnknow];
        }
    }
}

-(void)ConanNetUnknow
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kNetDisAppear" object:nil];
}


-(void)ConanNetIsChange:(NSString *)net
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kNetAppear" object:nil];
}

-(void)dealloc
{
    [GLobalRealReachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
