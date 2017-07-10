//
//  ConanAfnManager.m
//  ConanAfn
//
//  Created by 柯南 on 2016/12/6.
//  Copyright © 2016年 柯南集团. All rights reserved.
//

#import "ConanAfnManager.h"

#import "ConanAfnBase.h"
#import "ConanSaveFilePath.h"
#import "ConanEncryption.h"
#import "ConanMacroDefine.h"
#import "XYXMBProgressHUD+Event.h"
static ConanAfnManager *conanAfn;


@implementation ConanAfnManager

+(ConanAfnManager *)sharedInstance
{
    [[ConanNetStatus sharedInstance] listening];
    switch ([ConanNetStatus currentReachabilityStatus]) {
        case 0:
            ConanLog(@"无网");
            break;
        case 1:
            ConanLog(@"WI-FI");
            break;
        case 2:
            ConanLog(@"移动");
            break;
        case 3:
            ConanLog(@"2G");
            break;
        case 4:
            ConanLog(@"3G");
            break;
        case 5:
            ConanLog(@"4G");
            break;
            
        default:
            ConanLog(@"无网");

            break;
    }

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        conanAfn =[[ConanAfnManager alloc]initWithBaseURL:nil];
        
    });
    return conanAfn;
}

#pragma mark ============ 数据请求 =================
-(void)RequestWithURL:(ConanAfnRequestMethodType )requestType
                  Url:(NSString *)url
               Params:(NSDictionary *)senDic
         SuccessBlock:(ConanResponseSuccess )successBlock
         FailureBlock:(ConanResponseFail )failBlock
              ShowHUB:(ConanShowHUDType)showHUB
          ShowMessage:(NSString *)message
{
    switch (requestType) {
        case ConanAfnRequestMethodTypeGET://GET
            
            [self GETWithURL:url Params:senDic SuccessBlock:successBlock FailureBlock:failBlock ShowHUB:showHUB ShowMessage:message];
            break;
        case ConanAfnRequestMethodTypePOST://POST
            [self POSTWithURL:url Params:senDic SuccessBlock:successBlock FailureBlock:failBlock ShowHUB:showHUB ShowMessage:message];
            break;
            
        default:
            break;
    }
}

/*
 *GET网络请求,通过Block回调结果
 */
-(void)GETWithURL:(NSString *)url
           Params:(NSDictionary *)senDic
     SuccessBlock:(ConanResponseSuccess )successBlock
     FailureBlock:(ConanResponseFail )failBlock
          ShowHUB:(ConanShowHUDType)showHUB
      ShowMessage:(NSString *)message
{
    NSURLSessionTask *GETsessionTask = nil;
    
    AFHTTPSessionManager *manager=[ConanAfnBase manager];
    
   GETsessionTask= [manager GET:url parameters:senDic progress:^(NSProgress * _Nonnull downloadProgress) {

   } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        

        ConanLog(@"请求地址：%@;\n\n请求参数：%@··\n\n返回结果：%@。\n\n",url,senDic,responseObject);
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        if (failBlock) {
            failBlock(error);
        }
    }];
    
    [GETsessionTask resume];
}

/*
 *POST网络请求,通过Block回调结果
 */
-(void)POSTWithURL:(NSString *)url
            Params:(NSDictionary *)senDic
      SuccessBlock:(ConanResponseSuccess )successBlock
      FailureBlock:(ConanResponseFail )failBlock
           ShowHUB:(ConanShowHUDType)showHUB
       ShowMessage:(NSString *)message
{
    NSURLSessionTask *POSTsessionTask = nil;

    AFHTTPSessionManager *manager=[ConanAfnBase manager];
   POSTsessionTask= [manager POST:url parameters:senDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        ConanLog(@"请求地址：%@;\n请求参数：%@··\n返回结果：%@。\n",url,senDic,responseObject);
        if (successBlock) {
            successBlock(responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        if (failBlock) {
            failBlock(error);
        }
    }];
    
    [POSTsessionTask resume];
}
#pragma mark ============ 文件上传和下载 =================
- (void)UploadPhotoURL:(NSString *)url ImageList:(NSArray *)uploadImageList showUploadResult:(BOOL)show{
    
    if (uploadImageList.count<1) {
        [XYXMBProgressHUD showSuccess:[NSString stringWithFormat:@"请至少选择一张图片再进行上传!"]];
        return;
    }
    
    // 准备保存结果的数组，元素个数与上传的图片个数相同，先用 NSNull 占位
    NSMutableArray* result = [NSMutableArray array];
    
    for (int i =0; i<uploadImageList.count; i++) {
        [result addObject:[NSNull null]];
    }
    
    dispatch_group_t group = dispatch_group_create();
    
    for (NSInteger i = 0; i < uploadImageList.count; i++) {
        
        dispatch_group_enter(group);
        
        NSURLSessionUploadTask* uploadTask = [self uploadTaskWithImageUrl:url Image:uploadImageList[i] completion:^(NSURLResponse *response, NSDictionary* responseObject, NSError *error) {
            ConanLog(@"第%ld张开始上传了~~",(long)i + 1);
            if (error) {
                ConanLog(@"第 %d 张图片上传失败: %@", (int)i + 1, error);
                dispatch_group_leave(group);
            } else {
                ConanLog(@"第 %d 张图片上传成功: %@", (int)i + 1, responseObject);
                @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
                    result[i] = responseObject;
                }
                dispatch_group_leave(group);
            }
        }];
        [uploadTask resume];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (show) {
            [XYXMBProgressHUD showSuccess:[NSString stringWithFormat:@"图片上传完成!"]];
        }
        
//        for (int i = 0; i <result.count; i++) {
//            id responseResult = result[i];
//            ConanLog(@"%@", responseResult);
//        }
        
    });
}

- (NSURLSessionUploadTask*)uploadTaskWithImageUrl:(NSString *)url Image:(UIImage*)image completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock {
    // 构造 NSURLRequest
    NSData *imageData = nil;
    if (UIImagePNGRepresentation(image) == nil) {
        
        imageData = UIImageJPEGRepresentation(image, 1.0);
        
    } else {
        
        imageData = UIImagePNGRepresentation(image);
    }
    
    NSString *fileName = [ConanEncryption ConanMd5EncryptionStr:[NSString stringWithFormat:@"%ld",arc4random() % 9999999999999]];
    
    NSString *tmpFilePath =[NSString stringWithFormat:@"%@",TempFilePath(fileName)];
    
    NSFileManager *fileMana = [NSFileManager defaultManager];
    
    
    if ([fileMana fileExistsAtPath:tmpFilePath]) {
        [fileMana createDirectoryAtPath:tmpFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    BOOL write =[imageData writeToFile:tmpFilePath atomically:YES];
    
    if (!write) {
        BOOL writeAgain = [imageData writeToFile:tmpFilePath atomically:YES];
        if (!writeAgain) {
            [imageData writeToFile:tmpFilePath atomically:YES];
        }
    }
    NSString *storageFilePath = SaveFilePath([ConanEncryption ConanMd5HashOfFileAtPath:tmpFilePath]);
    
    if (![fileMana fileExistsAtPath:storageFilePath]) {
        [fileMana createDirectoryAtPath:[storageFilePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];                                                   NSError *error;
        
        BOOL moveFile = [fileMana moveItemAtPath:tmpFilePath toPath:storageFilePath error:&error];
        
        if (!moveFile) {
            BOOL moveFileAgain = [fileMana moveItemAtPath:tmpFilePath toPath:storageFilePath error:&error];
            if (!moveFileAgain) {
                [fileMana moveItemAtPath:tmpFilePath toPath:storageFilePath error:&error];
            }
        }
    }else{
        ConanLog(@"文件已存在，秒移成功");
    }
    
    NSDictionary *sendDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"", @"file",
                             [ConanEncryption ConanMd5HashOfFileAtPath:storageFilePath], @"MD5",
                             [ConanEncryption ConanSha1HashOfFileAtPath:storageFilePath], @"SHA1",
                             @"1", @"Type",
                             @"png", @"ExtensionName",
                             @"",@"PlayTime",
                             nil];
    NSError* error = NULL;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:sendDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:[ConanEncryption ConanMd5HashOfFileAtPath:storageFilePath] mimeType:@"image/jpg/png/jpeg"];
        
    } error:&error];
    
    // 可在此处配置验证信息
    //    [request setValue:@"" forHTTPHeaderField:@""];
    // 将 NSURLRequest 与 completionBlock 包装为 NSURLSessionUploadTask
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
    } completionHandler:completionBlock];
    
    return uploadTask;
}


-(ConanURLSessionTask *)DownloadFileWithURL:(ConanAfnRequestMethodType )requestType
                                        Url:(NSString *)url
                                     Params:(NSDictionary *)senDic
                               SaveFileName:(NSString *)fileName
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
            return [self GetDownloadFileWithURL:requestType Url:url Params:senDic SaveFileName:fileName SaveFileType:type SaveFilePath:filePathType Progress:^(int64_t bytesRead, int64_t totalBytesRead, int64_t totalBytesExpectedToRead) {
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
            return [self PostDownloadFileWithURL:requestType Url:url Params:senDic SaveFileName:fileName SaveFileType:type SaveFilePath:filePathType Progress:^(int64_t bytesRead, int64_t totalBytesRead, int64_t totalBytesExpectedToRead) {
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
    NSString *filePath = [ConanSaveFilePath ConanConanSaveFilePath:filePathType FileType:type FileName:fileName];
    
    NSString *file = [ConanSaveFilePath ConanConanSaveFilePath:filePathType FileType:type FileName:@""];
    
    BOOL isExist = [ConanFileManager fileExistsAtPath:file];
    
    if (!isExist)
    {
//        必须加上，下载的时候必须有目录才能加载
        [ConanFileManager createDirectoryAtPath:file withIntermediateDirectories:YES attributes:nil error:nil];
    }

    ConanURLSessionTask *conanSessionTask = nil;
    
    [manager GET:url parameters:senDic progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            progressBlock(downloadProgress.completedUnitCount,downloadProgress.totalUnitCount,downloadProgress.totalUnitCount-downloadProgress.completedUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         ConanLog(@"请求地址：\n%@;\n请求参数：\n%@\n返回路径filePath：\n%@",url,senDic,filePath);
        if (successBlock) {
            NSData *fileData =responseObject;
            BOOL wroteToFileIsSuccess = [fileData writeToFile:filePath atomically:YES];
            
            if (wroteToFileIsSuccess) {

                if ([[ConanEncryption ConanMd5HashOfFileAtPath:filePath] isEqualToString:fileName]) {
                    successBlock(responseObject,filePath);
                }else{
                    [fileData writeToFile:filePath atomically:YES];
                    successBlock(responseObject,filePath);
                }
            } else {
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
    NSString *filePath = [ConanSaveFilePath ConanConanSaveFilePath:filePathType FileType:type FileName:fileName];

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
                
                if ([[ConanEncryption ConanMd5HashOfFileAtPath:filePath] isEqualToString:fileName]) {
                    successBlock(responseObject,filePath);
                }else{
                    [fileData writeToFile:filePath atomically:YES];
                    successBlock(responseObject,filePath);
                }
            } else {
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

- (void)DownloadFileWithMd5:(NSString *)url
                   FileName:(NSString *)fileName
               SaveFileType:(NSString *)type
               SaveFilePath:(ConanCacheFilePathType )filePathType
          DownloadFileBlock:(ConanResponseDownloadFile )downloadFileBlock{
    NSString *downloadFilePath = [ConanSaveFilePath ConanConanSaveFilePath:filePathType FileType:type FileName:fileName];
    
    if ([ConanFileManager fileExistsAtPath:downloadFilePath]) {
        downloadFileBlock(downloadFilePath);
    }else{
        [self GetDownloadFileWithURL:ConanAfnRequestMethodTypeGET Url:url Params:@{@"MD5":fileName} SaveFileName:fileName SaveFileType:type SaveFilePath:filePathType Progress:^(int64_t bytesRead, int64_t totalBytesRead, int64_t totalBytesExpectedToRead) {
            
        } SuccessBlock:^(id returnData, NSString *filePath) {
            if (downloadFileBlock) {
                downloadFileBlock(filePath);
            }
        } FailureBlock:^(NSError *error) {
            
        } ShowHUD:ConanShowNothing ShowMessage:@""];
    }
    
}

@end
