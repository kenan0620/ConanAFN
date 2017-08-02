//
//  AFNConanMacroDefine.h
//  ConanAFN
//
//  Created by Conan on 2017/7/21.
//  Copyright © 2017年 Conan. All rights reserved.
//

#ifndef AFNConanMacroDefine_h
#define AFNConanMacroDefine_h

#pragma mark ============ 宏定义 =================

#pragma mark Log

#ifdef DEBUG

#define AFNConanLog(format, ...) printf("\n{\n柯南:\nDate:%s\nTime:%s\nClass:%s\nLine:(%d)\nMethod: %s\n\nLog:%s\n}\n",__DATE__,__TIME__, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )

#else

#define AFNConanLog(format, ...)

#endif

#define AFNConanFileManager  [NSFileManager defaultManager]

// 生成字符串长度
#define kRandomLength 16
// 随机字符表
static const NSString *kRandomAlphabet = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

#endif /* AFNConanMacroDefine_h */
