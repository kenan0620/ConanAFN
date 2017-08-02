//
//  AFNConanNetworkManager.h
//  ConanAFN
//
//  Created by Conan on 2017/8/2.
//  Copyright © 2017年 Conan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , AFNConanNetWorkType) {
    AFNConanNetWorkType_UNKNOW = 0,    // 未知,无网络
    AFNConanNetWorkType_WIFI    = 1,    // WIFI
    AFNConanNetWorkType_WWAN    = 2,    // 移动网络
    AFNConanNetWorkType_2G      = 3,    // 2G
    AFNConanNetWorkType_3G      = 4,    // 3G
    AFNConanNetWorkType_4G      = 5,    // 4G
};
@interface AFNConanNetworkManager : NSObject

+(AFNConanNetworkManager *)sharedInstance;

/**
 *  网络实时监听
 */
- (void)listening;

/**
 *  判断当前网络状态
 *
 *  @return 网络状态
 */
+ (AFNConanNetWorkType )currentReachabilityStatus;

@end
