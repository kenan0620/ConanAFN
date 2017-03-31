//
//  ConanAfnBase.m
//  ConanAfn
//
//  Created by 柯南 on 2016/12/12.
//  Copyright © 2016年 柯南集团. All rights reserved.
//

#import "ConanAfnBase.h"


#import "AFNetworkActivityIndicatorManager.h"

#pragma mark - ============ 静态变量 ================
static ConanAfnBase *conanAfnBase = nil;
static AFHTTPSessionManager *afnManager = nil;
static ConanAfnRequestSendDataType conanAfnRequestSendDataType = ConanAfnRequestSendDataTypeJSON;//默认请求Json
static ConanAfnResponseDataType conanAfnResponseDataType =ConanAfnResponseDataTypeJSON;//默认接收Json
static NSTimeInterval  conanAfnTimeOut = 20.0f;//默认请求时间为20秒
static NSInteger conanAfnMaxCOPCount = 3;
static NSDictionary *conanAfnHeaderDic = nil;//配置请求头字典

static NSMutableArray *conanRequestTasks;//所有的请求数组
@implementation ConanAfnBase

+(ConanAfnBase *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        conanAfnBase = [[ConanAfnBase alloc]init];
    });
    return conanAfnBase;
}

+(void)ConfigConanAfnHeaders:(NSDictionary *)headerDic
{
    conanAfnHeaderDic = headerDic;
}

+(void)ConfigConanAfnTimeOut:(NSTimeInterval)timeOut MaxConcurrentOperationCount:(NSInteger)maxConcurrentOperationCount
{
    conanAfnTimeOut =timeOut;
    conanAfnMaxCOPCount= maxConcurrentOperationCount;
}

+(void)ConfigRequestType:(ConanAfnRequestSendDataType)requestSendendDataType ResponseDataType:(ConanAfnResponseDataType )responseDataType
{
    conanAfnRequestSendDataType = requestSendendDataType;
    conanAfnResponseDataType = responseDataType;
}

#pragma mark - ============  MBProgressHUD ================

-(MBProgressHUD *)conanHud {
    if (_conanHud == nil) {
        //x_hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
        _conanHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        // 隐藏时候从父控件中移除
        _conanHud.removeFromSuperViewOnHide = YES;
        //设置风火轮的颜色
        _conanHud.contentColor=[ UIColor whiteColor];
        //设置风火轮的w文字
//        _conanHud.label.text= @"加载中~~~";
//        _conanHud.label.textColor = [UIColor redColor];
        
        //设置风火轮的方形背景颜色
        _conanHud.bezelView.backgroundColor= [UIColor blackColor];
//        _conanHud.bezelView.alpha = 0.5;
        // YES代表需要蒙版效果
//            _conanHud.dimBackground = YES;
        _conanHud.mode = MBProgressHUDModeIndeterminate;
        _conanHud.animationType = MBProgressHUDAnimationFade;
        _conanHud.delegate = self;
    }
    return _conanHud;
}

- (void)hudWasHidden:(MBProgressHUD *)conanHud {
    self.conanHud = nil;
}

#pragma mark - ============ Private ================

+(AFHTTPSessionManager *)manager
{
    @synchronized (self) {
        if (afnManager==nil) {
            //开启转圈圈
            
            [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
            AFHTTPSessionManager *manager= [AFHTTPSessionManager manager];
            
            //选择请求参数的上传类型
            switch (conanAfnRequestSendDataType) {
                    
                case ConanAfnRequestSendDataTypeJSON:
                    manager.requestSerializer = [AFJSONRequestSerializer serializer];
                    break;
                    
                case ConanAfnRequestSendDataTypePlainText:
                    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                    break;
                    
                case ConanAfnRequestSendDataTypeAFProperty:
                manager.requestSerializer = [AFPropertyListRequestSerializer serializer];
                    
                default:
                    
                    break;
            }
            
            //选择数据的接收类型
            switch (conanAfnResponseDataType) {
                case ConanAfnResponseDataTypeJSON:
                    manager.responseSerializer =[AFJSONResponseSerializer serializer];
                    break;
                    
                case ConanAfnResponseDataTypeData:
                    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
                    break;
                    
                case ConanAfnResponseDataTypeXML:
                    manager.responseSerializer =[AFXMLParserResponseSerializer serializer];
                    break;
                    
                case ConanAfnResponseDataTypeAFPropertyList:
                    manager.responseSerializer =[AFPropertyListResponseSerializer serializer];
                    break;
                    
                case ConanAfnResponseDataTypeAFImage:
                    manager.responseSerializer =[AFImageResponseSerializer serializer];
                    break;
                    
                case ConanAfnResponseDataTypeAFCompound:
                    manager.responseSerializer =[AFCompoundResponseSerializer serializer];
                    break;
                    
                default:
                    break;
            }
            //配置请求头
            for (NSString *key in conanAfnHeaderDic.allKeys) {
                if (conanAfnHeaderDic[key] != nil) {
                    [manager.requestSerializer setValue:conanAfnHeaderDic[key] forHTTPHeaderField:key];
                }
            }
            
            //请求数据进行编码
            manager.requestSerializer.stringEncoding =NSUTF8StringEncoding;
            //可以通过的类型（数据过滤）
            NSArray *acceptableContentTypesList =@[@"application/json",
                                               @"text/html",
                                               @"text/json",
                                               @"text/plain",
                                               @"text/javascript",
                                               @"text/xml",
                                               @"charset=UTF-8",
                                               @"image/jpeg"];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:acceptableContentTypesList];
            //请求超时时间
            manager.requestSerializer.timeoutInterval = conanAfnTimeOut;
            manager.operationQueue.maxConcurrentOperationCount = conanAfnMaxCOPCount;
            afnManager =manager;
        }
    }
    
    return afnManager;
}

//获取所有的请求
+ (NSMutableArray *)AllTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (conanRequestTasks == nil) {
            conanRequestTasks = [[NSMutableArray alloc] init];
        }
    });
    
    return conanRequestTasks;
}

/*
 *上传文件成功，进行数据解析
 */
+ (void)SuccessResponse:(id)responseData Callback:(ConanResponseSuccess)success {
    if (success) {
        success([self TryToParseData:responseData]);
    }
}

+ (id)TryToParseData:(id)responseData {
    if ([responseData isKindOfClass:[NSData class]]) {
        // 尝试解析成JSON
        if (responseData == nil) {
            return responseData;
        } else {
            NSError *error = nil;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&error];
            
            if (error != nil) {
                return responseData;
            } else {
                return response;
            }
        }
    } else {
        return responseData;
    }
}



@end
