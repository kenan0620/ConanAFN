//
//  ConanAfnDataRequest.m
//  ConanAfn
//
//  Created by Conan on 2017/2/23.
//  Copyright © 2017年 柯南集团. All rights reserved.
//

#import "ConanAfnDataRequest.h"

static ConanAfnDataRequest *conanAfnDataRequest;
@implementation ConanAfnDataRequest
/*
 *数据网络请求管理单例
 */
+(ConanAfnDataRequest *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        conanAfnDataRequest =[[ConanAfnDataRequest alloc]initWithBaseURL:nil];
        
    });
    return conanAfnDataRequest;

}

-(void)RequestWithURL:(ConanAfnRequestMethodType )requestType
                  Url:(NSString *)url
               Params:(NSDictionary *)senDic
         SuccessBlock:(ConanResponseSuccess )successBlock
         FailureBlock:(ConanResponseFail )failBlock
              ShowHUB:(ConanShowHUDType)showHUB
          ShowMessage:(NSString *)message
{
    switch (requestType) {
        case ConanAfnRequestMethodTypeGET://GET
            
            [self GETWithURL:url Params:senDic SuccessBlock:successBlock FailureBlock:failBlock ShowHUB:showHUB ShowMessage:message];
            break;
        case ConanAfnRequestMethodTypePOST://POST
            [self POSTWithURL:url Params:senDic SuccessBlock:successBlock FailureBlock:failBlock ShowHUB:showHUB ShowMessage:message];
            break;
            
        default:
            break;
    }

}

/*
 *GET网络请求,通过Block回调结果
 */
-(void)GETWithURL:(NSString *)url
           Params:(NSDictionary *)senDic
     SuccessBlock:(ConanResponseSuccess )successBlock
     FailureBlock:(ConanResponseFail )failBlock
          ShowHUB:(ConanShowHUDType)showHUB
      ShowMessage:(NSString *)message
{
    NSURLSessionTask *GETsessionTask = nil;
    
    [self showHud:showHUB ShowMessage:message];
    
    ConanLog(@"GET网络请求,通过Block回调结果");
    AFHTTPSessionManager *manager=[ConanAfnBase manager];
    
    GETsessionTask= [manager GET:url parameters:senDic progress:^(NSProgress * _Nonnull downloadProgress) {
        ConanLog(@"downloadProgress~~%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self dismissHud:showHUB];
        
        ConanLog(@"请求地址：%@;\n\n请求参数：%@··\n\n返回结果：%@。\n\n",url,senDic,responseObject);
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self dismissHud:showHUB];
        
        ConanLog(@"error~~%@",error);
        if (failBlock) {
            failBlock(error);
        }
    }];
    
    [GETsessionTask resume];
}

/*
 *POST网络请求,通过Block回调结果
 */
-(void)POSTWithURL:(NSString *)url
            Params:(NSDictionary *)senDic
      SuccessBlock:(ConanResponseSuccess )successBlock
      FailureBlock:(ConanResponseFail )failBlock
           ShowHUB:(ConanShowHUDType)showHUB
       ShowMessage:(NSString *)message
{
    NSURLSessionTask *POSTsessionTask = nil;
    [self showHud:showHUB ShowMessage:message];
    
    AFHTTPSessionManager *manager=[ConanAfnBase manager];
    POSTsessionTask= [manager POST:url parameters:senDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self dismissHud:showHUB];
        
        ConanLog(@"请求地址：%@;\n请求参数：%@··\n返回结果：%@。\n",url,senDic,responseObject);
        if (successBlock) {
            successBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissHud:showHUB];
        
        ConanLog(@"error~~%@",error);
        if (failBlock) {
            failBlock(error);
        }
        
    }];
    
    [POSTsessionTask resume];
}


#pragma mark ============ 弹框展示与消失 =================
-(void)showHud : (ConanShowHUDType )showHud  ShowMessage:(NSString *)message
{
    switch (showHud ) {
            
        case ConanShowHUD:
            [[ConanAfnBase sharedInstance].conanHud showAnimated:YES];
            break;
        case ConanShowHUDMessage:
            [ConanAfnBase sharedInstance].conanHud.label.text = message;
            break;
        case ConanShowAutoDismissLoadingMessage:
            [ConanShowAutoDismissAlertMessageView ConanShowLoading:message];
            break;
        case ConanShowAutoDismissSuccessMessage:
            [ConanShowAutoDismissAlertMessageView ConanShowSuccessMessage:message];
            break;
        case ConanShowAutoDismissFailMessage:
            [ConanShowAutoDismissAlertMessageView ConanShowFailMessage:message];
            break;
        case ConanShowNothing:
            ConanLog(@"ConanShowNothing");
            break;
            
        default:
            ConanLog(@"ConanShowHUDTypeDefault");
            break;
    }
}

-(void)dismissHud :(ConanShowHUDType )disMissHud
{
    switch (disMissHud) {
            
        case ConanShowHUD:
            [[ConanAfnBase sharedInstance].conanHud hideAnimated:YES];
            break;
        case ConanShowHUDMessage:
            [[ConanAfnBase sharedInstance].conanHud hideAnimated:YES];
            break;
        case ConanShowAutoDismissLoadingMessage:
            [ConanShowAutoDismissAlertMessageView ConanShowDismissHud];
            break;
        case ConanShowAutoDismissSuccessMessage:
            [ConanShowAutoDismissAlertMessageView ConanShowDismissHud];
            break;
        case ConanShowAutoDismissFailMessage:
            [ConanShowAutoDismissAlertMessageView ConanShowDismissHud];
            break;
            
        case ConanShowNothing:
            ConanLog(@"ConanShowNothing");
            break;
            
        default:
            ConanLog(@"ConanShowHUDTypeDefault");
            break;
    }
    
}


@end
