//
//  AFNConanResourcePathUrl.m
//  ConanAFN
//
//  Created by Conan on 2017/8/2.
//  Copyright © 2017年 Conan. All rights reserved.
//

#import "AFNConanResourcePathUrl.h"
#import "AFNConanMacroDefine.h"
@implementation AFNConanResourcePathUrl
+ (NSURL *)resourceDirectory:(AFNConanCacheFileDirectoryType)directoryType{
    NSURL *resourceDirectoryUrl = nil;
    switch (directoryType) {
        case AFNConanCacheFilePathDirectoryTypeDocuments:{
            resourceDirectoryUrl = [AFNConanFileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
        }
            break;
        case AFNConanCacheFilePathDirectoryTypeLibrary:{
            resourceDirectoryUrl = [AFNConanFileManager URLForDirectory:NSLibraryDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
        }
            break;
        case AFNConanCacheFilePathDirectoryTypeCaches:{
            resourceDirectoryUrl = [AFNConanFileManager URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
        }
            break;
            
        default:{
            resourceDirectoryUrl = [AFNConanFileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
        }
            break;
    }
    return resourceDirectoryUrl;
}


+ (NSURL *)resourceFile:(AFNConanCacheFileType)cacheFileType Directory:(NSURL *)directoryUrl{
    NSURL *resourceFileUrl = nil;
    switch (cacheFileType) {
        case AFNConanCacheFileTypePictures:{
            NSString *fileTypeStr = [[directoryUrl path] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",@"Pictures"]];
            resourceFileUrl = [NSURL fileURLWithPath:fileTypeStr isDirectory:YES];
        }
            break;
        case AFNConanCacheFileTypeMusic:{
            resourceFileUrl = [directoryUrl URLByAppendingPathComponent:@"Music" isDirectory:YES];
        }
            break;
        case AFNConanCacheFileTypeMovies:{
            resourceFileUrl = [directoryUrl URLByAppendingPathComponent:@"Movies" isDirectory:YES];
        }
            break;
        default:{
            resourceFileUrl = [directoryUrl URLByAppendingPathComponent:@"Other" isDirectory:YES];
        }
            break;
    }
    
    if (![AFNConanFileManager createDirectoryAtURL:resourceFileUrl withIntermediateDirectories:true attributes:nil error:nil]) {
        NSLog(@"Could not create directory at path: %@", resourceFileUrl);
    }
    return resourceFileUrl;
}
@end
