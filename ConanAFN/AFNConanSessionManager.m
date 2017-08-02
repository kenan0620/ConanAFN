//
//  AFNConanSessionManager.m
//  ConanAFN
//
//  Created by Conan on 2017/7/21.
//  Copyright © 2017年 Conan. All rights reserved.
//

#import "AFNConanSessionManager.h"

#import "AFNConanDataRequeset.h"
#import "AFNConanUploadRequeset.h"
#import "AFNConanDownloadRequeset.h"
@implementation AFNConanSessionManager

+ (AFNConanSessionManager *)ShareInstance{
    static AFNConanSessionManager *sessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionManager = [[AFNConanSessionManager alloc]init];
    });
    return sessionManager;
}

- (void)AFNConanRequestWithUrl:(NSString *)apiUrl
                   RequestTyep:(AFNConanRequestMethodType)requestType
                 RequestParams:(NSDictionary *)sendDic
          ResponseSuccessBlock:(AFNConanResponseSuccess)successBlock
          ResponseFailureBlock:(AFNConanResponseFailure)failureBlock
                       ShowHUB:(BOOL)show
                   ShowMessage:(NSString *)message{
    
    AFNConanDataRequeset *requset = [AFNConanDataRequeset ShareInstance];
    requset.requestSerializer = self.requestSerializer;
    requset.requestSerializer.timeoutInterval = self.requestSerializer.timeoutInterval;
    requset.responseSerializer = self.responseSerializer;
    
    [requset AFNConanRequestWithUrl:apiUrl RequestTyep:requestType RequestParams:sendDic ResponseSuccessBlock:^(id returnData) {
        if (successBlock) {
            successBlock(returnData);
        }
    } ResponseFailureBlock:^(NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    } ShowHUB:show ShowMessage:message];
}

- (void)AFNConanUploadWithUrl:(NSString *)apiUrl
                    ImageList:(NSArray *)uploadImageList
                      ShowHUB:(BOOL)show{
    AFNConanUploadRequeset *requset = [AFNConanUploadRequeset ShareInstance];
    requset.requestSerializer = self.requestSerializer;
    requset.requestSerializer.timeoutInterval = self.requestSerializer.timeoutInterval;
    requset.responseSerializer = self.responseSerializer;
    [requset AFNConanUploadWithUrl:apiUrl ImageList:uploadImageList ShowHUB:show];
}

- (void)AFNConanDownloadFileWithUrl:(NSString *)apiUrl
                           FileList:(NSArray *)downloadList
                        RequestTyep:(AFNConanRequestMethodType)requestType
             CacheFileDirectoryType:(AFNConanCacheFileDirectoryType )directoryType
                      CacheFileType:(AFNConanCacheFileType )fileType
               ResponseSuccessBlock:(AFNConanResponseDownloadFileSuccess)successBlock
               ResponseFailureBlock:(AFNConanResponseFailure)failureBlock{
    AFNConanDownloadRequeset *requset = [AFNConanDownloadRequeset ShareInstance];
    requset.requestSerializer = self.requestSerializer;
    requset.requestSerializer.timeoutInterval = self.requestSerializer.timeoutInterval;
    requset.responseSerializer = [AFHTTPResponseSerializer serializer];
    [requset AFNConanDownloadFileWithUrl:apiUrl FileList:downloadList RequestTyep:requestType CacheFileDirectoryType:directoryType CacheFileType:fileType ResponseSuccessBlock:^(NSMutableDictionary *downloadFilePathManager) {
        {
            if (successBlock) {
                successBlock(downloadFilePathManager);
            }
        }
    } ResponseFailureBlock:^(NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

@end
