//
//  ConanNetStatus.h
//  ConanAfn
//
//  Created by 柯南 on 2016/12/5.
//  Copyright © 2016年 柯南集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RealReachability.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , ConanNetWorkType) {
    ConanNet_UNKNOW = 0,    // 未知,无网络
    ConanNet_WIFI    = 1,    // WIFI
    ConanNet_WWAN    = 2,    // 移动网络
    ConanNet_2G      = 3,    // 2G
    ConanNet_3G      = 4,    // 3G
    ConanNet_4G      = 5,    // 4G
};

@interface ConanNetStatus : NSObject<UIAlertViewDelegate>

+(ConanNetStatus *)sharedInstance;

/**
 *  网络实时监听
 */
- (void)listening;

/**
 *  判断当前网络状态
 *
 *  @return 网络状态
 */
+ (ConanNetWorkType )currentReachabilityStatus;

@end
