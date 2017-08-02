//
//  AFNConanAPI.h
//  ConanAFN
//
//  Created by Conan on 2017/7/21.
//  Copyright © 2017年 Conan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNConanEnumType.h"

@protocol AFNConanAPIResponseDelegate <NSObject>

@optional
/**
 请求成功的代理
 
 @param responseObject 服务器返回结果
 @param key 获取数据的唯一识别
 */
- (void)ResponseSuccessData:(id)responseObject APIKey:(NSString *)key;

/**
 请求失败的代理
 
 @param errorData 请求失败的返回结果
 @param key 获取失败数据的唯一识别
 */
- (void)ResponseFailureData:(NSError *)errorData APIKey:(NSString *)key;

@end

@interface AFNConanAPI : NSObject

@property (nonatomic, assign) AFNConanRequestSendDataType requestType;

@property (nonatomic, assign) AFNConanResponseDataType responseType;

@property (nonatomic, assign) NSTimeInterval requestTimeOut;

@property (nonatomic, weak) id<AFNConanAPIResponseDelegate> delegate;

#pragma mark -----一道华丽的风格线-----

+ (AFNConanAPI *)ShareInstance;

/**
 配置统一域名
 @param domainUrl 域名
 */
- (void)configBaseUrl:(NSString *)domainUrl;

/**
 AFN数据请求
 
 @param apiUrl api地址
 @param requestType 请求方式
 @param sendDic 请求参数
 @param show 是否显示HUB
 @param message （HUB为YES时）显示加载信息
 */
- (void)AFNConanRequestWithUrl:(NSString *)apiUrl
                   RequestTyep:(AFNConanRequestMethodType)requestType
                 RequestParams:(NSDictionary *)sendDic
                       ShowHUB:(BOOL)show
                   ShowMessage:(NSString *)message;

/**
 AFN图片上传
 
 @param apiUrl api地址
 @param uploadImageList 图片对象数组
 @param show 是否显示HUB
 */
- (void)AFNConanUploadWithUrl:(NSString *)apiUrl
                    ImageList:(NSArray *)uploadImageList
                      ShowHUB:(BOOL)show;

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
                      CacheFileType:(AFNConanCacheFileType )fileType;
@end
