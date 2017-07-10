//
//  ConanMacroDefine.h
//  ConanAfn
//
//  Created by 柯南 on 2016/12/12.
//  Copyright © 2016年 柯南集团. All rights reserved.
//

#ifndef ConanMacroDefine_h
#define ConanMacroDefine_h

#pragma mark ============ 宏定义 =================

#pragma mark Log

#ifdef DEBUG
#define ConanLog(format, ...) printf("\n{\n柯南:\nDate:%s\nTime:%s\nClass:%s\nLine:(%d)\nMethod: %s\n\nLog:%s\n}\n",__DATE__,__TIME__, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define ConanLog(format, ...)
#endif


#define ConanFileManager  [NSFileManager defaultManager]

#define SaveFilePath(fileName) [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:fileName]

#define TempFilePath(fileName) [[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"]stringByAppendingPathComponent:fileName]

#define FileArc4 1000000000000+arc4random() % 9999999999999

#endif /* ConanMacroDefine_h */
