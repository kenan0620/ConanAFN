//
//  AFNConanDownloadRequeset.m
//  ConanAFN
//
//  Created by Conan on 2017/7/21.
//  Copyright © 2017年 Conan. All rights reserved.
//

#import "AFNConanDownloadRequeset.h"
#import "AFNConanMBProgressHUD+Event.h"
#import "AFNConanEncryption.h"
#import "AFNConanMacroDefine.h"
#import "AFNConanResourcePathUrl.h"
#import "AFNConanTheCurrentVC.h"
@implementation AFNConanDownloadRequeset
+ (AFNConanDownloadRequeset *)ShareInstance{
    static AFNConanDownloadRequeset *sessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionManager = [[AFNConanDownloadRequeset alloc]init];
    });
    return sessionManager;
}

- (void)AFNConanDownloadFileWithUrl:(NSString *)apiUrl
                           FileList:(NSArray *)downloadList
                        RequestTyep:(AFNConanRequestMethodType)requestType
             CacheFileDirectoryType:(AFNConanCacheFileDirectoryType )directoryType
                      CacheFileType:(AFNConanCacheFileType )fileType
               ResponseSuccessBlock:(AFNConanResponseDownloadFileSuccess)successBlock
               ResponseFailureBlock:(AFNConanResponseFailure)failureBlock{
    switch (requestType) {
        case AFNConanRequestMethodTypeGET:{
            [self GetDownloadFileWithURL:apiUrl FileList:downloadList CacheFileDirectoryType:directoryType CacheFileType:fileType Progress:^(int64_t bytesRead, int64_t totalBytesRead, int64_t totalBytesExpectedToRead) {
                
            } SuccessBlock:^(NSMutableDictionary *downloadFilePathManager) {
                if (successBlock) {
                    successBlock(downloadFilePathManager);
                }
            } FailureBlock:^(NSError *error) {
                if (failureBlock) {
                    failureBlock(error);
                }
            }];
        }
            break;
        case AFNConanRequestMethodTypePOST:{
            
        }
            break;
        default:
            break;
    }
}

#pragma mark -----Download-----

-(AFNConanURLSessionTask *)GetDownloadFileWithURL:(NSString *)apiUrl
                                         FileList:(NSArray *)downloadList
                          CacheFileDirectoryType:(AFNConanCacheFileDirectoryType )directoryType
                                    CacheFileType:(AFNConanCacheFileType )fileType
                                         Progress:(AFNConanDownloadProgress )progressBlock
                                     SuccessBlock:(AFNConanResponseDownloadFileSuccess )successBlock
                                     FailureBlock:(AFNConanResponseFailure )failBlock{
    
    AFNConanURLSessionTask *conanSessionTask = nil;

    AFNConanLog(@"-----Download-----%ld,%ld",(long)directoryType,(long)fileType);
    if (!downloadList) {
        [AFNConanMBProgressHUD show:[NSString stringWithFormat:@"暂无资源下载!"] icon:@"" view:[AFNConanTheCurrentVC getCurrentVC].view];
        return  conanSessionTask;
    }else{
        NSMutableDictionary *filePathCacheDic = [NSMutableDictionary dictionary];

        dispatch_group_t downGroupTask = dispatch_group_create();
        
        for (int i = 0; i < downloadList.count; i++) {
             dispatch_group_enter(downGroupTask);
            NSURL *directoryUrl = [AFNConanResourcePathUrl resourceDirectory:directoryType];
            NSURL *filePathUrl = [AFNConanResourcePathUrl resourceFile:fileType Directory:directoryUrl];
            NSURL *fileURL = [filePathUrl URLByAppendingPathComponent:downloadList[i]];
            
            if (![AFNConanFileManager fileExistsAtPath:[fileURL path]]) {
                conanSessionTask = [self downloadTaskWithUrl:apiUrl Parameters:downloadList[i] CacheFileDirectoryType:directoryType CacheFileType:fileType completionHandler:^(NSURLResponse *response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                    AFNConanLog(@"第%ld张开始下载了~~",(long)i + 1);
                    if (error) {
                        AFNConanLog(@"第 %d 张图片下载失败: %@", (int)i + 1, error);
                        dispatch_group_leave(downGroupTask);
                    } else {
                        AFNConanLog(@"第 %d 张图片下载成功。", (int)i + 1);
                        @synchronized (filePathCacheDic) { // NSMutableArray 是线程不安全的，所以加个同步锁
                            NSString *fileMd5 = [AFNConanEncryption ConanMd5HashOfFileAtPath:[filePath path]];
                            AFNConanLog(@"fileMd5%@~\n~%@",fileMd5,downloadList[i]);
                            [filePathCacheDic setObject:filePath forKey:downloadList[i]];
                            
                            if (![fileMd5 isEqualToString:downloadList[i]]) {
                                [AFNConanFileManager removeItemAtURL:filePath error:nil];
                            }
                        }
                        dispatch_group_leave(downGroupTask);
                    }
                }];
            
            } else {
                @synchronized (filePathCacheDic) { // NSMutableArray 是线程不安全的，所以加个同步锁
                    NSLog(@"文件存在，本地获取%d",i);
                    [filePathCacheDic setObject:fileURL forKey:downloadList[i]];
                    dispatch_group_leave(downGroupTask);

                }
            }
        }
        
        dispatch_group_notify(downGroupTask, dispatch_get_main_queue(), ^{
            AFNConanLog(@"下载完成");
            if (successBlock) {
                successBlock(filePathCacheDic);
            }
        });
        return  conanSessionTask;
    }
}

- (NSURLSessionDownloadTask *)downloadTaskWithUrl:(NSString *)apiUrl
                                       Parameters:(NSString *)fileName
                           CacheFileDirectoryType:(AFNConanCacheFileDirectoryType )directoryType
                                    CacheFileType:(AFNConanCacheFileType )cacheFileType
                                completionHandler:(nullable void (^)(NSURLResponse *response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler{
    if (!fileName) {
        return nil;
    }
    NSDictionary *sendDic =@{@"MD5":fileName};
    NSError* __autoreleasing *errorData = NULL;
    
    NSURLRequest *downLoadRequest = [[AFHTTPRequestSerializer serializer]requestWithMethod:@"GET" URLString:apiUrl parameters:sendDic error:errorData];
    
    NSURLSessionDownloadTask *downloadTask = [self downloadTaskWithRequest:downLoadRequest progress:^(NSProgress *downloadProgress){
        NSLog(@"下载进度:%lld",downloadProgress.completedUnitCount);
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *directoryUrl = [AFNConanResourcePathUrl resourceDirectory:directoryType];
        NSURL *cacheFileUrl = [AFNConanResourcePathUrl resourceFile:cacheFileType Directory:directoryUrl];
        NSURL *fileURL = [cacheFileUrl URLByAppendingPathComponent:sendDic[@"MD5"]];
        NSLog(@"fileURL:%@",[fileURL absoluteString]);
        return fileURL;
    } completionHandler:completionHandler];
    [downloadTask resume];
    
    return downloadTask;
}

@end
