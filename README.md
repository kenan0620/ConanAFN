# ConanAFN

[![CI Status](http://img.shields.io/travis/acct<blob>=<NULL>/ConanAFN.svg?style=flat)](https://travis-ci.org/acct<blob>=<NULL>/ConanAFN)
[![Version](https://img.shields.io/cocoapods/v/ConanAFN.svg?style=flat)](http://cocoapods.org/pods/ConanAFN)
[![License](https://img.shields.io/cocoapods/l/ConanAFN.svg?style=flat)](http://cocoapods.org/pods/ConanAFN)
[![Platform](https://img.shields.io/cocoapods/p/ConanAFN.svg?style=flat)](http://cocoapods.org/pods/ConanAFN)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ConanAFN is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ConanAFN"
```

## Usage
On AppDelegate import <ConanAFN/ConanAfnAPI.h>

set config contents and Monitor the network

//设置请求数据类型、返回数据类型
[ConanAfnBase ConfigRequestType:2 ResponseDataType:ConanAfnResponseDataTypeJSON];
//设置请求超时时间、最大并发数
[ConanAfnBase ConfigConanAfnTimeOut:20.0f MaxConcurrentOperationCount:3];
//设置请求API域名(或者根目录)
NSString * url= @"https://api.baidu.com/";
[ConanAfnAPI ConfigConanAfnBaseUrl:url];

### Usage in the eg

NSDictionary *jsonDic = @{};

request type ,get or post
SuccessBlock ,succecc
FailureBlock ,failure
ConanShowNothing ,showHUDtype
ShowMessage ,ShowMessage


ConanAfnRequestMethodTypeGET
[ConanAfnAPI RequestWithURL:ConanAfnRequestMethodTypeGET Url:jsonUrl Params:jsonDic SuccessBlock:^(id returnData) {


} FailureBlock:^(NSError *error) {

} ShowHUB:ConanShowNothing ShowMessage:@""];



## Author

kenan, houkenan0620@126.com

## License

ConanAFN is available under the MIT license. See the LICENSE file for more info.


~~> 1.0.0 ConanAFN。对AFN进行二次封装，逐步增加新的方法，不断的进行更新。

~~> 1.0.1 ConanAFN。项目引用更新。

~~> 1.0.3 ConanAFN。项目请求token设置优化。

~~> 1.0.4 ConanAFN 项目更新,解决长期连接问题。

~~> 1.0.7 ConanAFN 资源下载

~~> 1.0.8 ConanAFN 修改资源存储方式

~~> 1.0.9 ConanAFN 修改资源上传方式

~~> 1.1.0 ConanAFN 修改框架结构
