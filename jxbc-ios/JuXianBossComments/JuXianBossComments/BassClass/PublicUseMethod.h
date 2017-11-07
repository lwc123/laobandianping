//
//  PublicUseMethod.h
//  JuXianBossComments
//
//  Created by juxian on 16/10/10.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MacroDefinition.h"
@interface PublicUseMethod : NSObject

/**
 *  限制输入文本的长度 判断
 */
+(BOOL)textField:(UITextField *)textField length:(int)length;

/**
 *  手机号是否合法
 */
+(BOOL)isMobileNumber:(NSString*)mobileNum;

+ (NSString *)valiMobile:(NSString *)mobile;

/**
 *  封装AlertView
 */
+(void)showAlertView:(NSString *)messageString;
/**
 *  改变跟视图
 */
+(void)goViewController:(Class)cls;
+(void)goViewControllerWithNav:(Class)cls;
///改变跟视图VC
+(void)changeRootNavController:(UIViewController *)vc;

+(void)changeRootViewController:(UIViewController *)vc;
/**
 *  把十六进制的颜色字符串RGB转换成UIColor
 */
+(UIColor *)setColor:( NSString *)hexColor;
/**
 *  等比压缩图片
 */
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;
/**
 *  像素压缩
 */
+(UIImage*)transformWidth:(CGFloat)width height:(CGFloat)height with:(UIImage *)sourceImage;
/**
 *  照片选择
 */
+ (void)pickerImageChannelWithImageController:(UIImagePickerController *)imagePickerCtr andViewController:(UIViewController *)vc;

///改变图片的方向至服务器
+(UIImage *)fixOrientationForImage:(UIImage *)aImage;

/**
 *  金额
 */
+(NSString *)moneyFormatWith:(NSString *)moneyStr;
/**
 *  判断邮箱
 */
+ (BOOL)validateEmail:(NSString *)email;

/**渐变色*/
+ (void)colorWear:(UIView *)view;

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle okTitle:(NSString *)okTitle;

//判断身份证是否合法
+ (BOOL)verifyIDCardNumber:(NSString *)value;
+ (BOOL)isCorrect:(NSString *)IDNumber;

@end
