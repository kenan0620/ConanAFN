//
//  ConanMD5.h
//  ConanAfn
//
//  Created by 柯南 on 2016/12/7.
//  Copyright © 2016年 柯南集团. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConanMD5 : NSObject

/*
 *对字符串进行md5加密
 */
+ (NSString *)conan_md5Str:(NSString *)string;

@end
