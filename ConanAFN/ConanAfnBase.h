//
//  ConanAfnBase.h
//  ConanAfn
//
//  Created by 柯南 on 2016/12/12.
//  Copyright © 2016年 柯南集团. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "ConanAfnBlock.h"
#import "ConanAfnEnumType.h"

@import MBProgressHUD;
@import AFNetworking;
@interface ConanAfnBase : NSObject<MBProgressHUDDelegate>

@property (nonatomic ,strong) MBProgressHUD *conanHud;

/**
 *  ConanAfnBase单例
 *
 *  @return GDHNetworkObject的单例对象
 */
+(ConanAfnBase *)sharedInstance;

/*
 *  配置网络请求的请求头，只调用一次即可，通常放在应用启动的时候配置就可以了
 *
 *  @param headerDic 只需要将与服务器商定的固定参数设置即可
 */
+(void)ConfigConanAfnHeaders:(NSDictionary *)headerDic;

/*
 *  配置网络请求超时时间和应用最大请求数，只调用一次即可，通常放在应用启动的时候配置就可以了
 *
 *  @param timeOut 设定的网络请求超时时间 默认二十秒
 *  @param maxConcurrentOperationCount 设定的网络请求的最大线程数，默认为3
 */
+(void)ConfigConanAfnTimeOut:(NSTimeInterval)timeOut MaxConcurrentOperationCount:(NSInteger) maxConcurrentOperationCount;

/*
 *  配置网络请求的数据发送和接收类型
 *
 *  @param requestSendendDataType 数据发送类型
 *  @param responseDataType 数据接收类型
 */
+(void)ConfigRequestType:(ConanAfnRequestSendDataType)requestSendendDataType ResponseDataType:(ConanAfnResponseDataType )responseDataType;

/*
 *配置网络请求管理类
 *
 */
+(AFHTTPSessionManager *)manager;

//获取所有的请求
+ (NSMutableArray *)AllTasks;

/*
 *上传文件成功，进行数据解析
 */
+ (void)SuccessResponse:(id)responseData Callback:(ConanResponseSuccess)success;

@end
