//
//  AFNConanEnumType.h
//  ConanAFN
//
//  Created by Conan on 2017/7/21.
//  Copyright © 2017年 Conan. All rights reserved.
//

#ifndef AFNConanEnumType_h
#define AFNConanEnumType_h

#pragma mark =============数据请求的枚举类型=============

/**
 请求方式
 */

typedef NS_ENUM(NSInteger ,AFNConanRequestMethodType){
    AFNConanRequestMethodTypeGET = 0,
    AFNConanRequestMethodTypePOST,
    AFNConanRequestMethodTypePUT,
    AFNConanRequestMethodTypePATCH,
    AFNConanRequestMethodTypeDELETE
};

/**
 发送数据
 */

typedef NS_ENUM(NSUInteger, AFNConanRequestSendDataType) {
    AFNConanRequestSendDataTypeJSON = 1, // 默认 JSON
    AFNConanRequestSendDataTypePlainText  = 2 ,// 普通text/html 二进制格式
    AFNConanRequestSendDataTypeAFProperty = 3 ,//PList(是一种特殊的XML,解析起来相对容易)
};

/**
 响应数据的枚举
 */
typedef NS_ENUM(NSUInteger, AFNConanResponseDataType) {
    AFNConanResponseDataTypeJSON = 0, // 默认 JSON
    AFNConanResponseDataTypeData  = 1, // 二进制格式
    AFNConanResponseDataTypeXML = 2,// XML,只能返回XMLParser,还需要自己通过代理方法解析
    AFNConanResponseDataTypeAFPropertyList  = 3, // PList
    AFNConanResponseDataTypeAFImage = 4,//Image
    AFNConanResponseDataTypeAFCompound = 5,//组合
};

/**
 文件上传的枚举类型
 */
typedef NS_ENUM(NSInteger, AFNConanUploadFileType) {
    AFNConanUploadFileTypeImage = 0,//图片
    AFNConanUploadFileTypeMp3,//音频
    FNConanUploadFileTypeMp4,//视频
};

/*
 NSDemoApplicationDirectory
 NSApplicationDirectory
 NSDeveloperApplicationDirectory
 NSAdminApplicationDirectory
 NSLibraryDirectory
 NSDeveloperDirectory
 NSDocumentationDirectory
 NSDocumentDirectory
 NSDesktopDirectory
 NSAutosavedInformationDirectory
 NSCachesDirectory
 NSApplicationSupportDirectory
 NSDownloadsDirectory
 NSInputMethodsDirectory
 NSMoviesDirectory
 NSMusicDirectory
 NSPicturesDirectory
 NSSharedPublicDirectory
 NSPreferencePanesDirectory
 NSAllApplicationsDirectory
 NSAllLibrariesDirectory
 
 Documents：保存应用程序运行时生成的需要持久化数据，iTunes会自动备份该目录
 苹果公司建议将程序中建立的或者在程序浏览到的文件数据保存在该目录下，iTunes备份和恢复的时候会包括此目录
 
 Library：存储程序的默认设置和其他状态信息，iTunes会自动备份该文件目录
 
 Library/Caches：存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出时删除，通常存放体积比较大，但并不是很重要的资源
 Library/Preferences：保存应用的所有偏好设置，iOS的Setting（设置）应用会在该目录中查找应用的设置信息，iTunes会自动备份该目录。——PS：如果你想对偏好设置进行相应的操作，应该使用NSUserDefaults类来取得和设置应用程序的偏好，而不是直接创建偏好设置文件
 tmp：保存应用程序运行时所需的临时数据，使用完毕后再将相应的文件从该目录删除，应用没有运行时，系统也有可能会清除该目录下的文件，iTunes不会同步该目录，你的iPhone重启时，该目录下的文件会被删除
 
 */

/**
 文件下载存储根目录的枚举类型
 */
typedef NS_ENUM(NSInteger, AFNConanCacheFileDirectoryType)
{
    AFNConanCacheFilePathDirectoryTypeDocuments = 0,//存储在Document目录下
    AFNConanCacheFilePathDirectoryTypeLibrary = 1,//存储在Library目录下
    AFNConanCacheFilePathDirectoryTypeCaches = 2,//存储在Caches目录下
};

/**
 文件下载存储类型的枚举类型
 */
typedef NS_ENUM(NSInteger, AFNConanCacheFileType)
{
    AFNConanCacheFileTypePictures = 0,//Pictures目录下
    AFNConanCacheFileTypeMusic = 1,//Music目录下
    AFNConanCacheFileTypeMovies = 2,//Movies目录下
};
#endif /* AFNConanEnumType_h */
