//
//  AFNConanDataRequeset.h
//  ConanAFN
//
//  Created by Conan on 2017/7/21.
//  Copyright © 2017年 Conan. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "AFNConanEnumType.h"
#import "AFNConanBlockType.h"

@interface AFNConanDataRequeset : AFHTTPSessionManager

+ (AFNConanDataRequeset *)ShareInstance;
/**
 AFN数据请求
 
 @param apiUrl api地址
 @param requestType 请求方式
 @param sendDic 请求参数
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @param show 是否显示HUB
 @param message （HUB为YES时）显示加载信息
 */
- (void)AFNConanRequestWithUrl:(NSString *)apiUrl
                   RequestTyep:(AFNConanRequestMethodType)requestType
                 RequestParams:(NSDictionary *)sendDic
          ResponseSuccessBlock:(AFNConanResponseSuccess)successBlock
          ResponseFailureBlock:(AFNConanResponseFailure)failureBlock
                       ShowHUB:(BOOL)show
                   ShowMessage:(NSString *)message;

@end
