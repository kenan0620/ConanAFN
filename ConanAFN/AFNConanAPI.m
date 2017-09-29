//
//  AFNConanAPI.m
//  ConanAFN
//
//  Created by Conan on 2017/7/21.
//  Copyright © 2017年 Conan. All rights reserved.
//

#import "AFNConanAPI.h"
#import "AFNConanSessionManager.h"

@interface AFNConanAPI ()

@property (nonatomic, strong) NSString *url;

@end

@implementation AFNConanAPI

+ (AFNConanAPI *)ShareInstance{
    static AFNConanAPI *conanAPI = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        conanAPI = [[AFNConanAPI alloc]init];
    });
    return conanAPI;
}

- (void)AFNConanRequestWithUrl:(NSString *)apiUrl
                   RequestTyep:(AFNConanRequestMethodType)requestType
                 RequestParams:(NSDictionary *)sendDic
                       ShowHUB:(BOOL)show
                   ShowMessage:(NSString *)message{
    NSString *apiKey = apiUrl;
    AFNConanSessionManager *manager = [self ConfigManager];
    if (_url) {
        apiUrl = [NSString stringWithFormat:@"%@%@",_url,apiUrl];
    }
    [manager AFNConanRequestWithUrl:apiUrl RequestTyep:requestType RequestParams:sendDic ResponseSuccessBlock:^(id returnData) {
        if ([self.delegate respondsToSelector:@selector(ResponseSuccessData:APIKey:)]) {
            [self.delegate ResponseSuccessData:returnData APIKey:apiKey];
        }
    } ResponseFailureBlock:^(NSError *error) {
        if ([self.delegate respondsToSelector:@selector(ResponseFailureData:APIKey:)]) {
            [self.delegate ResponseFailureData:error APIKey:apiKey];
        }
    } ShowHUB:show ShowMessage:message];
}

- (void)AFNConanUploadWithUrl:(NSString *)apiUrl
                    ImageList:(NSArray *)uploadImageList
                      ShowHUB:(BOOL)show{
    AFNConanSessionManager *manager = [self ConfigManager];
    if (_url) {
        apiUrl = [NSString stringWithFormat:@"%@%@",_url,apiUrl];
    }
    [manager AFNConanUploadWithUrl:apiUrl ImageList:uploadImageList ShowHUB:show];
}
/**
 
 AFN下载文件
 
 @param apiUrl api地址
 @param apiKey 获取返回数据的唯一识别
 @param downloadList 下载的文件标示码集合
 @param requestType 请求方式
 @param directoryType 保存的文件目录（Document、Library、Cache）
 @param fileType 保存的文件类型(图片、视频、音频)
 */
- (void)AFNConanDownloadFileWithUrl:(NSString *)apiUrl
                             APIKey:(NSString *)apiKey
                           FileList:(NSArray *)downloadList
                        RequestTyep:(AFNConanRequestMethodType)requestType
             CacheFileDirectoryType:(AFNConanCacheFileDirectoryType )directoryType
                      CacheFileType:(AFNConanCacheFileType )fileType{
    AFNConanSessionManager *manager = [self ConfigManager];
    if (_url) {
        apiUrl = [NSString stringWithFormat:@"%@%@",_url,apiUrl];
    }
    
    [manager AFNConanDownloadFileWithUrl:apiUrl FileList:downloadList RequestTyep:requestType CacheFileDirectoryType:directoryType CacheFileType:fileType ResponseSuccessBlock:^(NSMutableDictionary *downloadFilePathManager) {
        if ([self.delegate respondsToSelector:@selector(ResponseSuccessData:APIKey:)]) {
            [self.delegate ResponseSuccessData:downloadFilePathManager APIKey:apiKey];
        }
    } ResponseFailureBlock:^(NSError *error) {
        if ([self.delegate respondsToSelector:@selector(ResponseFailureData:APIKey:)]) {
            [self.delegate ResponseFailureData:error APIKey:apiKey];
        }
    }];
}

- (void)AFNConanDownloadFileWithUrl:(NSString *)apiUrl
                            FileMD5:(NSString *)downloadFile
                        RequestTyep:(AFNConanRequestMethodType)requestType
             CacheFileDirectoryType:(AFNConanCacheFileDirectoryType )directoryType
                      CacheFileType:(AFNConanCacheFileType )fileType
               ResponseSuccessBlock:(AFNConanResponseDownloadFileSuccess)successBlock
               ResponseFailureBlock:(AFNConanResponseFailure)failureBlock{
    AFNConanSessionManager *manager = [self ConfigManager];
    if (_url) {
        apiUrl = [NSString stringWithFormat:@"%@%@",_url,apiUrl];
    }
    if (!downloadFile) {
        NSMutableDictionary *downloadFilePathManager = [NSMutableDictionary dictionary];
        successBlock(downloadFilePathManager);
    }else{
        [manager AFNConanDownloadFileWithUrl:apiUrl FileList:@[downloadFile] RequestTyep:requestType CacheFileDirectoryType:directoryType CacheFileType:fileType ResponseSuccessBlock:^(NSMutableDictionary *downloadFilePathManager) {
            {
                if (successBlock) {
                    successBlock(downloadFilePathManager);
                }
            }
        }ResponseFailureBlock:^(NSError *error) {
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    }
}
#pragma mark -----Config Manager-----

- (AFNConanSessionManager *)ConfigManager{
    AFNConanSessionManager *manager = [AFNConanSessionManager ShareInstance];
    manager.requestSerializer.timeoutInterval = self.requestTimeOut;
    [self setupRequestDataType];
    [self setupResponseDataType];
    if (!_requestTimeOut) {
        _requestTimeOut = 10;
    }
    
    return manager;
}
#pragma mark -----Url-----

- (void)setUrl:(NSString *)url{
    _url = url;
}

- (void)configBaseUrl:(NSString *)domainUrl{
    _url = domainUrl;
}
#pragma mark -----Serializer-----

- (void)setupRequestDataType{
    AFNConanSessionManager *manager = [AFNConanSessionManager ShareInstance];
    switch (self.requestType) {
        case AFNConanRequestSendDataTypeJSON:{
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
        }
            break;
        case AFNConanRequestSendDataTypePlainText:{
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        }
            break;
        case AFNConanRequestSendDataTypeAFProperty:{
            manager.requestSerializer = [AFPropertyListRequestSerializer serializer];
        }
            break;
            
        default:{
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
        }
            break;
    }
}

-(void)setupResponseDataType{
    AFNConanSessionManager *manager = [AFNConanSessionManager ShareInstance];
    
    switch (self.responseType) {
        case AFNConanResponseDataTypeJSON:{
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        }
            break;
        case AFNConanResponseDataTypeData:{
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"image/gif",@"image/jpeg", nil];
        }
            break;
        case AFNConanResponseDataTypeXML:{
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
        }
            break;
        case AFNConanResponseDataTypeAFPropertyList:{
            manager.responseSerializer = [AFPropertyListResponseSerializer serializer];
        }
            break;
        case AFNConanResponseDataTypeAFImage:{
            manager.responseSerializer = [AFImageResponseSerializer serializer];
        }
            break;
        case AFNConanResponseDataTypeAFCompound:{
            manager.responseSerializer = [AFCompoundResponseSerializer serializer];
        }
            break;
        default:{
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        }
            break;
    }
}

#pragma mark -----AFNConanDataType-----

- (void)setRequestType:(AFNConanRequestSendDataType)requestType{
    _requestType = requestType;
}

- (void)setResponseType:(AFNConanResponseDataType)responseType{
    _responseType = responseType;
}

#pragma mark -----RequestTimeOut-----

- (void)setRequestTimeOut:(NSTimeInterval)requestTimeOut{
    _requestTimeOut = requestTimeOut;
}

@end
