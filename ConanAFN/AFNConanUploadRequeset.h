//
//  AFNConanUploadRequeset.h
//  ConanAFN
//
//  Created by Conan on 2017/7/21.
//  Copyright © 2017年 Conan. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface AFNConanUploadRequeset : AFHTTPSessionManager

+ (AFNConanUploadRequeset *)ShareInstance;

/**
 AFN图片上传
 
 @param apiUrl api地址
 @param uploadImageList 图片对象数组
 @param show 是否显示HUB
 */
- (void)AFNConanUploadWithUrl:(NSString *)apiUrl
                    ImageList:(NSArray *)uploadImageList
                      ShowHUB:(BOOL)show;
@end
