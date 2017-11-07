//
//  JXBasedViewController.h
//  JuXianBossComments
//
//  Created by juxian on 16/10/10.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertDoneButtonClickBlock)();

@interface JXBasedViewController : UIViewController
// 加载页面数据
- (void)loadPageData;
// 重新加载数据
- (void)retryLoadData;

//是否显示左侧返回按钮
- (void)isShowLeftButton:(BOOL)isShow;

//右侧
- (void)isShowRightButton:(BOOL)isShow;
- (void)isShowRightButton:(BOOL)isShow with:(NSString*)string;
- (void)isShowRightButton:(BOOL)isShow withImg:(UIImage*)image;

- (void)dismissLoadingIndicator;
- (void)showLoadingIndicator;
- (void)showLoadingIndicatorWithString:(NSString *)string;

// alert
- (void)alertString:(NSString *)string duration:(CGFloat) duration;

// 提示并显示按钮
- (void)alertStringWithString:(NSString *)string doneButton:(BOOL)isDone cancelButton:(BOOL) isCancel duration:(CGFloat) duration doneClick:(AlertDoneButtonClickBlock)alertDoneButtonClickBlock;
// 提示标题，文字，并显示按钮
- (void)alertStringWithTitle:(NSString *)title String:(NSString *)string doneButton:(BOOL)isDone cancelButton:(BOOL) isCancel duration:(CGFloat) duration doneClick:(AlertDoneButtonClickBlock)alertDoneButtonClickBlock;
@end
