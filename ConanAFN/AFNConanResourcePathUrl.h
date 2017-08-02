//
//  AFNConanResourcePathUrl.h
//  ConanAFN
//
//  Created by Conan on 2017/8/2.
//  Copyright © 2017年 Conan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNConanEnumType.h"
@interface AFNConanResourcePathUrl : NSObject

/**
 生成资源存储目录
 @param directoryType 目录类型
 @return 目录路径
 */

+ (NSURL *)resourceDirectory:(AFNConanCacheFileDirectoryType)directoryType;

/**
 生成资源存储路径
 @param cacheFileType 存储类型
 @param directoryUrl 目录类型
 @return 存储路径
 */
+ (NSURL *)resourceFile:(AFNConanCacheFileType)cacheFileType Directory:(NSURL *)directoryUrl;
@end
