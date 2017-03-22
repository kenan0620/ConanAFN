//
//  ConanAfnBlock.h
//  ConanAfn
//
//  Created by 柯南 on 2016/12/12.
//  Copyright © 2016年 柯南集团. All rights reserved.
//

#ifndef ConanAfnBlock_h
#define ConanAfnBlock_h

#pragma mark ============ 请求结果的Block ================
/*
 *定义请求成功的block
 */
typedef void(^ConanRequestSuccess)( NSDictionary * object);

/*
 *定义请求失败的block
 */
typedef void(^ConanRequestFailure)( NSError *error);

#pragma mark ============ 上传和下载进度的Block ================
/*!
 *
 *  上传进度
 *
 *  @param bytesWritten              已上传的大小
 *  @param totalBytesWritten         总上传大小
 */
typedef void (^ConanUploadProgress)(int64_t bytesWritten,
int64_t totalBytesWritten);


/*!
 *
 *  下载进度 get or post
 *
 *  @param bytesRead                 已下载的大小
 *  @param totalBytesRead            文件总大小
 *  @param totalBytesExpectedToRead 还有多少需要下载
 */
typedef void (^ConanDownloadProgress)(int64_t bytesRead,
int64_t totalBytesRead,
int64_t totalBytesExpectedToRead);

typedef ConanDownloadProgress ConanDownloadGetProgress;
typedef ConanDownloadProgress ConanDownloadPostProgress;


#pragma mark ============ NSURLSessionTask的Block ================

@class NSURLSessionTask;
// 请勿直接使用NSURLSessionDataTask,以减少对第三方的依赖
// 所有接口返回的类型都是基类NSURLSessionTask，若要接收返回值
// 且处理，请转换成对应的子类类型

typedef NSURLSessionTask ConanURLSessionTask;
typedef void(^ConanResponseSuccess)(id returnData);
typedef void(^ConanResponseFail)(NSError * error);
typedef void(^ConanResponseDownloadSuccess)(id returnData , NSString *filePath);
#endif /* ConanAfnBlock_h */
