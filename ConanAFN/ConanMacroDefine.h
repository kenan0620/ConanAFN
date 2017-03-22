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

//log 输出
#ifdef DEBUG
#define ConanLog(format, ...) printf("\n\n\n类名：～～%s～～(第%d行) \n方法名: %s \n\n%s\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define ConanLog(format, ...)
#endif

#define SHOW_ALERT(_msg_)  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"小依休提示" message:_msg_ delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];\
[alert show];


#define ConanFileManager [NSFileManager defaultManager]
#endif /* ConanMacroDefine_h */
