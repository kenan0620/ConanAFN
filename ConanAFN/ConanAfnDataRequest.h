//
//  ConanAfnDataRequest.h
//  ConanAfn
//
//  Created by Conan on 2017/2/23.
//  Copyright © 2017年 柯南集团. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "ConanAfnEnumType.h"
#import "ConanAfnBlock.h"
#import "ConanMacroDefine.h"
#import "ConanShowAutoDismissAlertMessageView.h"
#import "ConanAfnBase.h"
@interface ConanAfnDataRequest : AFHTTPSessionManager
/*
 *数据网络请求管理单例
 */
+(ConanAfnDataRequest *)sharedInstance;

/**
 *POST~~网络请求,通过Block回调结果
 *
 * @param requestType 请求类型
 * @param url 请求地址
 * @param senDic 请求参数
 * @param successBlock 请求结果返回成功的回调
 * @param failBlock 请求结果返回失败的回调
 * @param showHUB 请求方式是否显示加载视图
 */
-(void)RequestWithURL:(ConanAfnRequestMethodType )requestType
                  Url:(NSString *)url
               Params:(NSDictionary *)senDic
         SuccessBlock:(ConanResponseSuccess )successBlock
         FailureBlock:(ConanResponseFail )failBlock
              ShowHUB:(ConanShowHUDType)showHUB
          ShowMessage:(NSString *)message;

@end
