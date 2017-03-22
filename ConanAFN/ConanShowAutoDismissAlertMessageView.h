//
//  ConanShowAutoDismissAlertMessageView.h
//  ConanAfn
//
//  Created by 柯南 on 2016/12/16.
//  Copyright © 2016年 柯南集团. All rights reserved.
//

#import <UIKit/UIKit.h>


#define ConanShowBGColor  [UIColor colorWithWhite:0.0 alpha:0.5]
#define ConanShowSuccess	 [UIImage imageNamed:@"ConanShowSuccess"]
#define ConanShowFail	 [UIImage imageNamed:@"ConanShowFail"]
#define ConanSHOWHUDTIME 3.0  //2秒后自动隐藏

#define ConanSCREEN_BOUNDS [[UIScreen mainScreen] bounds]
#define ConanWIDTH  [[UIScreen mainScreen] bounds].size.width
#define ConanHEIGHT [[UIScreen mainScreen] bounds].size.height

#define ConanSCENTER CGPointMake(ConanWIDTH*0.5, ConanHEIGHT*0.5)
#define ConanSRECT CGRectMake(0, 0, ConanWIDTH, ConanHEIGHT)
#define ConanRectWidth  100


@interface ConanShowAutoDismissAlertMessageView : UIView

/*
 *单例模式
 */
+(ConanShowAutoDismissAlertMessageView *)shareIntance;

/**
 *  显示加载提示框信息
 *
 *  @param ShowMessage 加载显示的信息
 */
+(void)ConanShowLoading:(NSString *)ShowMessage;

/**
 *  显示成功的提示框信息
 *
 *  @param ShowMessage 加载显示的信息
 */
+(void)ConanShowSuccessMessage:(NSString *)ShowMessage;

/**
 *  显示加载提示框信息
 *
 *  @param ShowMessage 加载显示的信息
 */
+(void)ConanShowFailMessage:(NSString *)ShowMessage;
/**
 *  加载提示框消失
 *
 */
+(void)ConanShowDismissHud;

@end
