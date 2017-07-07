//
//  ConanSaveFilePath.h
//  ConanAfn
//
//  Created by 柯南 on 2016/12/24.
//  Copyright © 2016年 柯南集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConanAfnEnumType.h"
@interface ConanSaveFilePath : NSObject
/*
 *选择保存文件位置的类型，返回路径
 *@param filePathType 文件位置的类型
 *@param type 文件类型
 *@param fileName 文件名
 *@return path文件位置
 */
+(NSString *)ConanConanSaveFilePath:(ConanCacheFilePathType )filePathType
                           FileType:(NSString *)type
                           FileName:(NSString *)fileName;

@end
