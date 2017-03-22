//
//  ConanMD5.m
//  ConanAfn
//
//  Created by 柯南 on 2016/12/7.
//  Copyright © 2016年 柯南集团. All rights reserved.
//

#import "ConanMD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ConanMD5
/*
 *对字符串进行md5加密
 */

+ (NSString *)conan_md5Str:(NSString *)string{
    if (string == nil || [string length] == 0) {
        return nil;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([string UTF8String], (int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02X", (int)(digest[i])];
    }
    return [ms copy];
}
@end
