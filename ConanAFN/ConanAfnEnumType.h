//
//  ConanAfnEnumType.h
//  ConanAfn
//
//  Created by 柯南 on 2016/12/12.
//  Copyright © 2016年 柯南集团. All rights reserved.
//

#ifndef ConanAfnEnumType_h
#define ConanAfnEnumType_h

#pragma mark =============数据请求的枚举类型=============
/*
 *定义请求方法的枚举类型
 */
typedef NS_ENUM(NSInteger ,ConanAfnRequestMethodType)
{
    ConanAfnRequestMethodTypeGET = 0,
    ConanAfnRequestMethodTypePOST,
};

/*
 *定义请求发送数据的枚举类型
 */
typedef NS_ENUM(NSUInteger, ConanAfnRequestSendDataType) {
    ConanAfnRequestSendDataTypeJSON = 0, // 默认 JSON
    ConanAfnRequestSendDataTypePlainText  = 1 ,// 普通text/html 二进制格式
    ConanAfnRequestSendDataTypeAFProperty = 2 ,//PList(是一种特殊的XML,解析起来相对容易)
};

/*
 *响应数据的枚举
 */
typedef NS_ENUM(NSUInteger, ConanAfnResponseDataType) {    ConanAfnResponseDataTypeJSON = 0, // 默认 JSON
    ConanAfnResponseDataTypeData  = 1, // 二进制格式
    ConanAfnResponseDataTypeXML = 2,// XML,只能返回XMLParser,还需要自己通过代理方法解析
    ConanAfnResponseDataTypeAFPropertyList  = 3, // PList
    ConanAfnResponseDataTypeAFImage = 4,//Image
    ConanAfnResponseDataTypeAFCompound = 5,//组合
};
#pragma mark =============弹框的枚举类型=============

/*
 *定义ShowHUD的枚举类型
 */
typedef NS_ENUM(NSInteger ,ConanShowHUDType)
{
    ConanShowHUD = 0, //显示加载等待视图
    ConanShowHUDMessage, //显示加载等待视图+信息
    ConanShowAutoDismissLoadingMessage, //显示自动消失的加载提示框信息(可进行UI操作)
    ConanShowAutoDismissSuccessMessage, //显示自动消失的加载提示框信息(可进行UI操作)
    ConanShowAutoDismissFailMessage, //显示自动消失的加载提示框信息(可进行UI操作)
    ConanShowNothing, //不显示任何
};

#pragma mark =============文件上传、下载的枚举类型=============
typedef NS_ENUM(NSInteger, ConanUploadFileType) {
    ConanUploadFileTypeFile = 0,//文件上传类型为文件
    ConanUploadFileTypeData//文件上传类型为数据Data
};

#pragma mark =============文件管理存储位置的枚举类型=============
typedef NS_ENUM(NSInteger, ConanCacheFilePathType)
{
    ConanCacheFilePathTypeDocuments = 0,//存储在Document目录下
    ConanCacheFilePathTypeLibrary = 1,//存储在Library目录下
    ConanCacheFilePathTypeCaches = 2,//存储在Caches目录下
    ConanCacheFilePathTypeTemp = 3,//存储在Temp目录下
    ConanCacheFilePathTypeHome = 4,//存储在Home(根)目录下(建议不要使用)
};
#endif /* ConanAfnEnumType_h */
