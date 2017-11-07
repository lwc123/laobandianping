//
//  ShareManage.h
//  KONKA_MARKET
//
//  Created by wxxu on 14/12/18.
//  Copyright (c) 2014年 archon. All rights reserved.
//  分享管理

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
@class JXTrend;
@interface ShareManage : NSObject <MFMessageComposeViewControllerDelegate>
@property (nonatomic, strong)JXTrend *trend;
@property (nonatomic, strong)NSIndexPath *path;

+ (ShareManage *)shareManage;

- (void)shareConfig;

/**微信分享**/
- (void)wxShareWithViewControll:(UIViewController *)viewC;

/**新浪微博分享**/
- (void)wbShareWithViewControll:(UIViewController *)viewC;

/**微信朋友圈分享**/
- (void)wxpyqShareWithViewControll:(UIViewController *)viewC;






#pragma mark---暂时不用
//-(void)QQShareWithViewControll:(UIViewController *)viewC;
/**短信分享**/
//- (void)smsShareWithViewControll:(UIViewController *)viewC;

@end
