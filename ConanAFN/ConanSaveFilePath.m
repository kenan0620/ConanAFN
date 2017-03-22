//
//  ConanSaveFilePath.m
//  ConanAfn
//
//  Created by 柯南 on 2016/12/24.
//  Copyright © 2016年 柯南集团. All rights reserved.
//

#import "ConanSaveFilePath.h"
#import "ConanMacroDefine.h"
@implementation ConanSaveFilePath
+(NSString *)ConanConanSaveFilePath:(ConanCacheFilePathType )filePathType
                           FileType:(NSString *)type
                           FileName:(NSString *)fileName
                          FileCtype:(NSString *)cType
{

    NSString *path = nil;
    
    NSArray  *DocumentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *SavedocPath = [DocumentPaths lastObject];

    NSArray *LibraryPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    
    NSString *SaveLibraryPath = [LibraryPaths lastObject];

    NSArray *CachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *SaveCachePaths = [CachePaths lastObject];
    
    NSString *SaveTempPath = NSTemporaryDirectory( );
    
    NSString *SaveHomePath = NSHomeDirectory();
    
    switch (filePathType) {
        case ConanCacheFilePathTypeDocuments:
          
            path = [[SavedocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",type]] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",fileName,cType]];
            break;
            
        case ConanCacheFilePathTypeLibrary:
            path = [[SaveLibraryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",type]] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",fileName,cType]];
            break;
            
        case ConanCacheFilePathTypeCaches:
            path = [[SaveCachePaths stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",type]] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",fileName,cType]];
            break;
            
        case ConanCacheFilePathTypeTemp:
            path = [[SaveTempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",type]] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",fileName,cType]];
            break;
        case ConanCacheFilePathTypeHome:
            path = [[SaveHomePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",type]] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",fileName,cType]];
            break;
            
        default:
            path = [[SaveTempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",type]] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",fileName,cType]];
            break;
    }

    return path;
}

@end
