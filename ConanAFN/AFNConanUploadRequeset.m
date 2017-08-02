//
//  AFNConanUploadRequeset.m
//  ConanAFN
//
//  Created by Conan on 2017/7/21.
//  Copyright © 2017年 Conan. All rights reserved.
//

#import "AFNConanUploadRequeset.h"
#import "AFNConanMBProgressHUD.h"
#import "AFNConanMBProgressHUD+Event.h"
#import "AFNConanEncryption.h"
#import "AFNConanMacroDefine.h"
#import "AFNConanEnumType.h"
#import "AFNConanResourcePathUrl.h"
#import "AFNConanTheCurrentVC.h"
@implementation AFNConanUploadRequeset

+ (AFNConanUploadRequeset *)ShareInstance{
    static AFNConanUploadRequeset *sessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionManager = [[AFNConanUploadRequeset alloc]init];
    });
    return sessionManager;
}

- (void)AFNConanUploadWithUrl:(NSString *)apiUrl
                    ImageList:(NSArray *)uploadImageList
                      ShowHUB:(BOOL)show{
    
    if (uploadImageList.count<1) {
        
        [AFNConanMBProgressHUD show:[NSString stringWithFormat:@"请至少选择一张图片再进行上传!"] icon:@"" view:[AFNConanTheCurrentVC getCurrentVC].view];
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
        
        NSURLSessionUploadTask* uploadTask = [self uploadTaskWithImageUrl:apiUrl Image:uploadImageList[i] completion:^(NSURLResponse *response, NSDictionary* responseObject, NSError *error) {
            AFNConanLog(@"第%ld张开始上传了~~",(long)i + 1);
            if (error) {
                AFNConanLog(@"第 %d 张图片上传失败: %@", (int)i + 1, error);
                dispatch_group_leave(group);
            } else {
                AFNConanLog(@"第 %d 张图片上传成功: %@", (int)i + 1, responseObject);
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
            [AFNConanMBProgressHUD show:[NSString stringWithFormat:@"图片上传完成!"] icon:@"" view:[AFNConanTheCurrentVC getCurrentVC].view];
        }
//        for (int i = 0; i <result.count; i++) {
//            id response = result[i];
//            AFNConanLog(@"%@", response);
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
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity:kRandomLength];
    for (int i = 0; i < kRandomLength; i++) {
        [randomString appendFormat: @"%C", [kRandomAlphabet characterAtIndex:arc4random_uniform((u_int32_t)[kRandomAlphabet length])]];
    }
    
    NSString *fileName = [AFNConanEncryption ConanMd5EncryptionStr:[NSString stringWithFormat:@"%@",randomString]];
    
    NSURL *tmpDirectoryUrl = [AFNConanResourcePathUrl resourceDirectory:AFNConanCacheFilePathDirectoryTypeCaches];
    NSURL *tmpCacheFileUrl = [AFNConanResourcePathUrl resourceFile:AFNConanCacheFileTypePictures Directory:tmpDirectoryUrl];
    NSURL *tmpFileURL = [tmpCacheFileUrl URLByAppendingPathComponent:fileName];
    
    BOOL write =[imageData writeToFile:[tmpFileURL path] atomically:YES];
    
    if (!write) {
        BOOL writeAgain = [imageData writeToFile:[tmpFileURL path] atomically:YES];
        if (!writeAgain) {
            [imageData writeToFile:[tmpFileURL path] atomically:YES];
        }
    }
    NSString *storageName = [AFNConanEncryption ConanMd5HashOfFileAtPath:[tmpFileURL path]];
    
    NSURL *storageDirectoryUrl = [AFNConanResourcePathUrl resourceDirectory:AFNConanCacheFilePathDirectoryTypeDocuments];
    NSURL *storageCacheFileUrl = [AFNConanResourcePathUrl resourceFile:AFNConanCacheFileTypePictures Directory:storageDirectoryUrl];
    NSURL *storageFileURL = [storageCacheFileUrl URLByAppendingPathComponent:storageName];
    if (![AFNConanFileManager fileExistsAtPath:[storageFileURL path]]) {
        
        NSError *error;
        
        BOOL moveFile = [AFNConanFileManager moveItemAtPath:[tmpFileURL path] toPath:[storageFileURL path] error:&error];
        
        if (!moveFile) {
            BOOL moveFileAgain = [AFNConanFileManager moveItemAtPath:[tmpFileURL path] toPath:[storageFileURL path] error:&error];
            if (!moveFileAgain) {
                [AFNConanFileManager moveItemAtPath:[tmpFileURL path] toPath:[storageFileURL path] error:&error];
            }
        }
    }else{
        AFNConanLog(@"文件已存在，秒移成功");
        [AFNConanFileManager removeItemAtURL:tmpFileURL error:nil];
    }
    
    NSDictionary *sendDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"", @"file",
                             [AFNConanEncryption ConanMd5HashOfFileAtPath:[storageFileURL path]], @"MD5",
                             [AFNConanEncryption ConanSha1HashOfFileAtPath:[storageFileURL path]], @"SHA1",
                             @"1", @"Type",
                             @"png", @"ExtensionName",
                             @"",@"PlayTime",
                             nil];
    NSError* error = NULL;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:sendDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:[AFNConanEncryption ConanMd5HashOfFileAtPath:[storageFileURL path]] mimeType:@"image/jpg/png/jpeg"];
        
    } error:&error];
    
    // 可在此处配置验证信息
    //    [request setValue:@"" forHTTPHeaderField:@""];
    // 将 NSURLRequest 与 completionBlock 包装为 NSURLSessionUploadTask
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
    } completionHandler:completionBlock];
    
    return uploadTask;
}

@end
