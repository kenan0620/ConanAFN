//
//  AFNConanDownloadRequeset.h
//  ConanAFN
//
//  Created by Conan on 2017/7/21.
//  Copyright © 2017年 Conan. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "AFNConanEnumType.h"
#import "AFNConanBlockType.h"

@interface AFNConanDownloadRequeset : AFHTTPSessionManager
+ (AFNConanDownloadRequeset *)ShareInstance;

/**
 AFN资源下载
 
 @param apiUrl api地址
 @param downloadList 下载的文件标示码集合
 @param requestType 请求方式
 @param directoryType 保存的文件目录（Document、Library、Cache）
 @param fileType 保存的文件类型(图片、视频、音频)
 @param successBlock 下载成功的回调
 @param failureBlock 下载失败的回调
 */

- (void)AFNConanDownloadFileWithUrl:(NSString *)apiUrl
                           FileList:(NSArray *)downloadList
                        RequestTyep:(AFNConanRequestMethodType)requestType
             CacheFileDirectoryType:(AFNConanCacheFileDirectoryType )directoryType
                      CacheFileType:(AFNConanCacheFileType )fileType
               ResponseSuccessBlock:(AFNConanResponseDownloadFileSuccess)successBlock
               ResponseFailureBlock:(AFNConanResponseFailure)failureBlock;
@end
