//
//  AFNConanDataRequeset.m
//  ConanAFN
//
//  Created by Conan on 2017/7/21.
//  Copyright © 2017年 Conan. All rights reserved.
//

#import "AFNConanDataRequeset.h"

@implementation AFNConanDataRequeset

+ (AFNConanDataRequeset *)ShareInstance{
    static AFNConanDataRequeset *sessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionManager = [[AFNConanDataRequeset alloc]init];
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
    
    switch (requestType) {
            
        case AFNConanRequestMethodTypeGET:{
            [self AFNConanRequestGETWithUrl:apiUrl RequestParams:sendDic ResponseSuccessBlock:^(id returnData) {
                if (successBlock) {
                    successBlock(returnData);
                }
            } ResponseFailureBlock:^(NSError *error) {
                if (failureBlock) {
                    failureBlock(error);
                }
            } ShowHUB:show ShowMessage:message];
        }
            break;
        case AFNConanRequestMethodTypePOST:{
            [self AFNConanRequestPOSTWithUrl:apiUrl RequestParams:sendDic ResponseSuccessBlock:^(id returnData) {
                if (successBlock) {
                    successBlock(returnData);
                }
            } ResponseFailureBlock:^(NSError *error) {
                if (failureBlock) {
                    failureBlock(error);
                }
            } ShowHUB:show ShowMessage:message];
        }
            break;
        case AFNConanRequestMethodTypePUT:{
            
        }
            break;
        case AFNConanRequestMethodTypePATCH:{
            
        }
            break;
        case AFNConanRequestMethodTypeDELETE:{
            
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark -----GET-----
- (void)AFNConanRequestGETWithUrl:(NSString *)apiUrl
                 RequestParams:(NSDictionary *)sendDic
          ResponseSuccessBlock:(AFNConanResponseSuccess)successBlock
          ResponseFailureBlock:(AFNConanResponseFailure)failureBlock
                       ShowHUB:(BOOL)show
                      ShowMessage:(NSString *)message{
    [self GET:apiUrl parameters:sendDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

#pragma mark -----POST-----
- (void)AFNConanRequestPOSTWithUrl:(NSString *)apiUrl
                    RequestParams:(NSDictionary *)sendDic
             ResponseSuccessBlock:(AFNConanResponseSuccess)successBlock
             ResponseFailureBlock:(AFNConanResponseFailure)failureBlock
                          ShowHUB:(BOOL)show
                       ShowMessage:(NSString *)message{
    [self POST:apiUrl parameters:sendDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}
@end
