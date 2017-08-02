//
//  AFNConanBlockType.h
//  ConanAFN
//
//  Created by Conan on 2017/7/21.
//  Copyright © 2017年 Conan. All rights reserved.
//

#ifndef AFNConanBlockType_h
#define AFNConanBlockType_h

#pragma mark ============ 请求结果的Block ================
/**
 定义请求成功的block
 */
typedef void(^AFNConanResponseSuccess)(id returnData);
typedef void(^AFNConanResponseDownloadFileSuccess)(NSMutableDictionary *downloadFilePathManager);

/**
 定义请求失败的block
 */
typedef void(^AFNConanResponseFailure)(NSError * error);

#pragma mark ============ 上传和下载进度的Block ================
/*!
 *
 *  上传进度
 *
 *  @param bytesWritten              已上传的大小
 *  @param totalBytesWritten         总上传大小
 */
typedef void (^AFNConanUploadProgress)(int64_t bytesWritten,
int64_t totalBytesWritten);


/*!
 *
 *  下载进度 get or post
 *
 *  @param bytesRead                 已下载的大小
 *  @param totalBytesRead            文件总大小
 *  @param totalBytesExpectedToRead 还有多少需要下载
 */
typedef void (^AFNConanDownloadProgress)(int64_t bytesRead,
int64_t totalBytesRead,
int64_t totalBytesExpectedToRead);

typedef AFNConanDownloadProgress AFNConanDownloadGetProgress;
typedef AFNConanDownloadProgress AFNConanDownloadPostProgress;

#pragma mark ============ NSURLSessionTask的Block ================

@class NSURLSessionTask;
// 请勿直接使用NSURLSessionDataTask,以减少对第三方的依赖
// 所有接口返回的类型都是基类NSURLSessionTask，若要接收返回值
// 且处理，请转换成对应的子类类型

typedef NSURLSessionTask AFNConanURLSessionTask;

#endif /* AFNConanBlockType_h */
