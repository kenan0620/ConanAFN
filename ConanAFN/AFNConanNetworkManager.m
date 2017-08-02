//
//  AFNConanNetworkManager.m
//  ConanAFN
//
//  Created by Conan on 2017/8/2.
//  Copyright © 2017年 Conan. All rights reserved.
//

#import "AFNConanNetworkManager.h"
#import "AFNConanMBProgressHUD+Event.h"
#import <RealReachability/LocalConnection.h>
#import "AFNConanTheCurrentVC.h"
@implementation AFNConanNetworkManager

static AFNConanNetworkManager *conanNetSington;

+(AFNConanNetworkManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        conanNetSington = [[AFNConanNetworkManager alloc]init];
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

+ (AFNConanNetWorkType )currentReachabilityStatus
{
    AFNConanNetWorkType netType = AFNConanNetWorkType_UNKNOW;
    ReachabilityStatus status =[[RealReachability sharedInstance] currentReachabilityStatus];
    
    if (status == RealStatusNotReachable)
    {
        
        netType = AFNConanNetWorkType_UNKNOW;
    }
    
    if (status == RealStatusViaWiFi)
    {
        netType = AFNConanNetWorkType_WIFI;
    }
    
    if (status == RealStatusViaWWAN)
    {
        netType = AFNConanNetWorkType_WWAN;
    }
    
    WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
    
    if (status == RealStatusViaWWAN)
    {
        if (accessType == WWANType2G)
        {
            netType = AFNConanNetWorkType_2G;
        }
        else if (accessType == WWANType3G)
        {
            netType = AFNConanNetWorkType_3G;
        }
        else if (accessType == WWANType4G)
        {
            netType = AFNConanNetWorkType_4G;
        }
        else
        {
            netType = AFNConanNetWorkType_UNKNOW;
        }
    }
    
    
    return  netType;
}


- (void)networkChanged:(NSNotification *)notification
{
    RealReachability *reachability = (RealReachability *)notification.object;

    ReachabilityStatus status = [reachability currentReachabilityStatus];

    WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
    
    switch (status) {
        case RealStatusUnknown:{
            [AFNConanMBProgressHUD show:@"未知网络，请检查网络连接情况。" icon:nil view:[AFNConanTheCurrentVC getCurrentVC].view];
            [self ConanNetUnknow];
        }
            break;
        case RealStatusNotReachable:{
            [AFNConanMBProgressHUD show:@"无网络，请检查网络连通情况。" icon:nil view:[AFNConanTheCurrentVC getCurrentVC].view];
            [self ConanNetUnknow];
        }
            break;
        case RealStatusViaWWAN:{
            switch (accessType) {
                case WWANTypeUnknown:{// maybe iOS6
                    [AFNConanMBProgressHUD show:@"未知网络，请检查网络连接情况。" icon:nil view:[AFNConanTheCurrentVC getCurrentVC].view];
                    [self ConanNetUnknow];
                }
                    break;
                case WWANType2G:{
                    [self ConanNetIsChange:@"RealReachabilityStatus2G"];
                }
                    break;
                case WWANType3G:{
                    [self ConanNetIsChange:@"RealReachabilityStatus3G"];
                }
                    break;
                case WWANType4G:{
                    [self ConanNetIsChange:@"RealReachabilityStatus4G"];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case RealStatusViaWiFi:{
//            [AFNConanMBProgressHUD show:@"WiFi网络。" icon:nil view:[AFNConanTheCurrentVC getCurrentVC].view];
            [self ConanNetIsChange:@"RealStatusViaWiFi"];
        }
            break;
            
        default:
            break;
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
