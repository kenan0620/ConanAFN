//
//  ConanAfnResourceRequest.m
//  ConanAfn
//
//  Created by Conan on 2017/2/23.
//  Copyright © 2017年 柯南集团. All rights reserved.
//

#import "ConanAfnResourceRequest.h"
static ConanAfnResourceRequest *conanAfnResourceRequest;
@implementation ConanAfnResourceRequest
/*
 *资源网络请求管理单例
 */
+(ConanAfnResourceRequest *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        conanAfnResourceRequest =[[ConanAfnResourceRequest alloc]initWithBaseURL:nil];
        
    });
    return conanAfnResourceRequest;
}


-(ConanURLSessionTask *)UpLoadFileWithURL:(ConanAfnRequestMethodType )requestType
                                      Url:(NSString *)url
                                 FilePath:(NSString *)filePath
                           UploadProgress:(ConanUploadProgress *)upLProgress
                             SuccessBlock:(ConanResponseSuccess )successBlock
                             FailureBlock:(ConanResponseFail )failBlock
                                  ShowHUB:(ConanShowHUDType)showHUB
                              ShowMessage:(NSString *)message
{
    switch (requestType) {
        case ConanAfnRequestMethodTypeGET:
            return nil;
            break;
        case ConanAfnRequestMethodTypePOST:
            return [self PostUpLoadFileWithURL:ConanAfnRequestMethodTypePOST Url:url FilePath:filePath UploadProgress:upLProgress SuccessBlock:^(id returnData) {
                if (successBlock) {
                    successBlock(returnData);
                }
            } FailureBlock:^(NSError *error) {
                if (failBlock) {
                    failBlock(error);
                }
            } ShowHUB:showHUB ShowMessage:message];
            break;
            
        default:
            return nil;
            break;
    }

}

-(ConanURLSessionTask *)PostUpLoadFileWithURL:(ConanAfnRequestMethodType )requestType
                                          Url:(NSString *)url
                                     FilePath:(NSString *)filePath
                               UploadProgress:(ConanUploadProgress *)upLProgress
                                 SuccessBlock:(ConanResponseSuccess )successBlock
                                 FailureBlock:(ConanResponseFail )failBlock
                                      ShowHUB:(ConanShowHUDType)showHUB
                                  ShowMessage:(NSString *)message
{
    NSURL *Url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]];
    
    NSURLRequest *requestUrl = [NSURLRequest requestWithURL:Url];
    
    NSURL *filePathUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",filePath]];
    
    AFHTTPSessionManager *manager=[ConanAfnBase manager];
    
    ConanURLSessionTask *conanSessionTask = nil;
    
    [manager uploadTaskWithRequest:requestUrl fromFile:filePathUrl progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        [[ConanAfnBase AllTasks] removeObject:conanSessionTask];
        [ConanAfnBase SuccessResponse:responseObject Callback:successBlock];
        
    }];
    
    if (conanSessionTask) {
        [[ConanAfnBase AllTasks] addObject:conanSessionTask];
    }
    
    return conanSessionTask;
}


-(ConanURLSessionTask *)DownloadFileWithURL:(ConanAfnRequestMethodType )requestType
                                        Url:(NSString *)url
                                     Params:(NSDictionary *)senDic
                               SaveFileName:(NSString *)fileName
                              SaveFileCtype:(NSString *)ctype
                               SaveFileType:(NSString *)type
                               SaveFilePath:(ConanCacheFilePathType )filePathType
                                   Progress:(ConanDownloadProgress )progressBlock
                               SuccessBlock:(ConanResponseDownloadSuccess )successBlock
                               FailureBlock:(ConanResponseFail )failBlock
                                    ShowHUD:(ConanShowHUDType )showType
                                ShowMessage:(NSString *)message
{
    switch (requestType) {
        case ConanAfnRequestMethodTypeGET:
            return [self GetDownloadFileWithURL:requestType Url:url Params:senDic SaveFileName:fileName SaveFileCtype:ctype SaveFileType:type SaveFilePath:filePathType Progress:^(int64_t bytesRead, int64_t totalBytesRead, int64_t totalBytesExpectedToRead) {
                if (progressBlock) {
                    progressBlock(bytesRead,totalBytesRead,totalBytesExpectedToRead);
                }
            } SuccessBlock:^(id returnData, NSString *filePath) {
                if(successBlock)
                {
                    successBlock(returnData,filePath);
                }
            } FailureBlock:^(NSError *error) {
                if (failBlock) {
                    failBlock(error);
                }
            } ShowHUD:showType ShowMessage:message];
            
            break;
        case ConanAfnRequestMethodTypePOST:
            return [self PostDownloadFileWithURL:requestType Url:url Params:senDic SaveFileName:fileName SaveFileCtype:ctype SaveFileType:type SaveFilePath:filePathType Progress:^(int64_t bytesRead, int64_t totalBytesRead, int64_t totalBytesExpectedToRead) {
                if (progressBlock) {
                    progressBlock(bytesRead,totalBytesRead,totalBytesExpectedToRead);
                }
            } SuccessBlock:^(id returnData, NSString *filePath) {
                if(successBlock)
                {
                    successBlock(returnData,filePath);
                }
            } FailureBlock:^(NSError *error) {
                if (failBlock) {
                    failBlock(error);
                }
            } ShowHUD:showType ShowMessage:message];
            
            break;
            
        default:
            return nil;
            break;
    }

}


-(ConanURLSessionTask *)GetDownloadFileWithURL:(ConanAfnRequestMethodType )requestType
                                           Url:(NSString *)url
                                        Params:(NSDictionary *)senDic
                                  SaveFileName:(NSString *)fileName
                                 SaveFileCtype:(NSString *)ctype
                                  SaveFileType:(NSString *)type
                                  SaveFilePath:(ConanCacheFilePathType )filePathType
                                      Progress:(ConanDownloadProgress )progressBlock
                                  SuccessBlock:(ConanResponseDownloadSuccess )successBlock
                                  FailureBlock:(ConanResponseFail )failBlock
                                       ShowHUD:(ConanShowHUDType )showType
                                   ShowMessage:(NSString *)message{
    
    AFHTTPSessionManager *manager=[ConanAfnBase manager];
    //增加Serializer设置，文件下载，以防止下载失败
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *filePath = [ConanSaveFilePath ConanConanSaveFilePath:filePathType FileType:type FileName:fileName FileCtype:ctype];
    
    NSString *file = [ConanSaveFilePath ConanConanSaveFilePath:filePathType FileType:type FileName:@"" FileCtype:@""];
    
    BOOL isExist = [ConanFileManager fileExistsAtPath:file];
    
    if (!isExist)
    {
        [ConanFileManager createDirectoryAtPath:file withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    ConanURLSessionTask *conanSessionTask = nil;
    
    [manager GET:url parameters:senDic progress:^(NSProgress * _Nonnull downloadProgress) {
        ConanLog(@"304NSProgress~~%lld%%",100*downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        if (progressBlock) {
            progressBlock(downloadProgress.completedUnitCount,downloadProgress.totalUnitCount,downloadProgress.totalUnitCount-downloadProgress.completedUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ConanLog(@"请求地址：\n%@;\n请求参数：\n%@\n返回路径filePath：\n%@",url,senDic,filePath);
        if (successBlock) {
            NSData *fileData =responseObject;
            BOOL wroteToFileIsSuccess = [fileData writeToFile:filePath atomically:YES];
            
            if (wroteToFileIsSuccess) {
                NSLog(@"wroteToFileIsSuccess~~success");
                successBlock(responseObject,filePath);
            } else {
                NSLog(@"wroteToFileIsSuccess~~failure");
                successBlock(responseObject,@"");
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ConanLog(@"332error~~%@",error);
        if (failBlock) {
            failBlock(error);
        }
    }];
    
    [conanSessionTask resume];
    return conanSessionTask;
}

-(ConanURLSessionTask *)PostDownloadFileWithURL:(ConanAfnRequestMethodType )requestType
                                            Url:(NSString *)url
                                         Params:(NSDictionary *)senDic
                                   SaveFileName:(NSString *)fileName
                                  SaveFileCtype:(NSString *)ctype
                                   SaveFileType:(NSString *)type
                                   SaveFilePath:(ConanCacheFilePathType )filePathType
                                       Progress:(ConanDownloadProgress )progressBlock
                                   SuccessBlock:(ConanResponseDownloadSuccess )successBlock
                                   FailureBlock:(ConanResponseFail )failBlock
                                        ShowHUD:(ConanShowHUDType )showType
                                    ShowMessage:(NSString *)message{
    
    AFHTTPSessionManager *manager=[ConanAfnBase manager];
    //增加Serializer设置，文件下载，以防止下载失败
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *filePath = [ConanSaveFilePath ConanConanSaveFilePath:filePathType FileType:type FileName:fileName FileCtype:ctype];
    
    NSString *file = [ConanSaveFilePath ConanConanSaveFilePath:filePathType FileType:type FileName:@"" FileCtype:@""];
    
    BOOL isExist = [ConanFileManager fileExistsAtPath:file];
    
    if (!isExist)
    {
        [ConanFileManager createDirectoryAtPath:file withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    ConanURLSessionTask *conanSessionTask = nil;
    
    conanSessionTask = [manager POST:url parameters:senDic progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progressBlock) {
            progressBlock(uploadProgress.completedUnitCount,uploadProgress.totalUnitCount,uploadProgress.totalUnitCount-uploadProgress.completedUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ConanLog(@"请求地址：\n%@;\n请求参数：\n%@\n返回路径filePath：\n%@",url,senDic,filePath);
        if (successBlock) {
            NSData *fileData =responseObject;
            BOOL wroteToFileIsSuccess = [fileData writeToFile:filePath atomically:YES];
            
            if (wroteToFileIsSuccess) {
                NSLog(@"wroteToFileIsSuccess~~success");
                successBlock(responseObject,filePath);
            } else {
                NSLog(@"wroteToFileIsSuccess~~failure");
                successBlock(responseObject,@"");
            }
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failBlock) {
            failBlock(error);
        }
    }];
    
    [conanSessionTask resume];
    return conanSessionTask;
}


@end
