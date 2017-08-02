//
//  AFNConanEncryption.h
//  ConanAFN
//
//  Created by Conan on 2017/7/21.
//  Copyright © 2017年 Conan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface AFNConanEncryption : NSObject
/**
 字符串Md5加密
 
 @param string 需要加密的字符串
 @return 字符串MD5
 */
+ (NSString *)ConanMd5EncryptionStr:(NSString *)string;

/**
 字符串Sha1加密
 
 @param string 需要加密的字符串
 @return 字符串Sha1
 */
+ (NSString *)ConanSha1EncryptionStr:(NSString *)string;

/**
 图片MD5加密
 
 @param image 需要加密的UIImage的MD5
 @return 图片MD5
 */
+ (NSString *)ConanMd5EncryptionImage:(UIImage *)image;

/**
 文件Md5加密
 
 @param filePath 需要加密的文件路径
 @return 文件MD5
 */
+ (NSString *)ConanMd5HashOfFileAtPath:(NSString *)filePath;

/**
 文件Sha1加密
 
 @param filePath 需要加密的文件路径
 @return 文件Sha1
 */
+ (NSString *)ConanSha1HashOfFileAtPath:(NSString *)filePath;

/**
 文件Sha256加密
 
 @param filePath 需要加密的文件路径
 @return 文件Sha256
 */
+ (NSString *)ConanSha256HashOfFileAtPath:(NSString *)filePath;

/**
 文件Sha512加密
 
 @param filePath 需要加密的文件路径
 @return 文件Sha512
 */
+ (NSString *)ConanSha512HashOfFileAtPath:(NSString *)filePath;

@end
