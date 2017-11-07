//
//  ShareManage.m
//  KONKA_MARKET
//
//  Created by wxxu on 14/12/18.
//  Copyright (c) 2014年 archon. All rights reserved.
//  分享管理

//#import "JuXianTalentBank-Swift.h"
#import "ShareManage.h"
//#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
//#import "UMSocialQQHandler.h"
//#import "UMSocialControllerService.h"
#import "WXApi.h"
//#import "UMSocialManager.h"
//#import "JXTrend.h"
#import "UIView+HLTishi.h"
#import "JX_ShareManager.h"
//#import "UMSocialSinaHandler.h"
//<UMSocialUIDelegate>

@interface ShareManage ()
@property (nonatomic, strong)NSString *channel;
@property (nonatomic,strong)JX_ShareManager *sManager;
@property (nonatomic,copy)NSString *shareUrl;
@end

@implementation ShareManage
{
    UIViewController *_viewC;
}

static ShareManage *shareManage;

+ (ShareManage *)shareManage
{
    @synchronized(self)
    {
        if (shareManage == nil) {
            shareManage = [[self alloc] init];
        }
        return shareManage;
    }
}

#pragma mark 注册友盟分享微信
- (void)shareConfig
{
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMeng_APIKey];
    [[UMSocialManager defaultManager] openLog:YES];
    //注册微信
    [WXApi registerApp:WX_APP_KEY];

}


#pragma mark 微信分享
- (void)wxShareWithViewControll:(UIViewController *)viewC
{
    self.channel = @"1";
    _viewC = viewC;
    [[UMSocialWechatHandler defaultManager] setAppId:WX_APP_KEY appSecret:WX_APP_SECRET url:self.sManager.shareModel.shareUrl];
//    UMSocialPlatformType_WechatSession, //微信聊天
//    UMSocialPlatformType_WechatTimeLine,//微信朋友圈
    
    //xin
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WX_APP_KEY appSecret:WX_APP_SECRET redirectURL:self.sManager.shareModel.shareUrl];
      [UMSocialPlatformConfig platformNameWithPlatformType:UMSocialPlatformType_WechatSession];

    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.sManager.shareModel.Brief descr:self.sManager.shareModel.Content thumImage:Company_LOGO_Image];
    
    //设置网页地址
    shareObject.webpageUrl =self.sManager.invitedEntity.InviteRegisterUrl;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:viewC completion:^(id data, NSError *error) {
        
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                NSLog(@"response data is %@",data);
            }
        }
//                [self alertWithError:error];
    }];

    [[UMSocialManager defaultManager] platformProviderWithPlatformType:UMSocialPlatformType_WechatSession];
        //微信分享统计
   NSDictionary *dic = @{@"shareWay":@"微信好友"};
    UMShare_wx_Event(dic);
}





//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"分享标题" descr:@"分享内容描述" thumImage:[UIImage imageNamed:@"icon"]];
    //设置网页地址
    shareObject.webpageUrl =@"http://www.juxian.com/";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                NSLog(@"response data is %@",data);
            }
        }
//        [self alertWithError:error];
    }];
}





#pragma mark 新浪微博分享
- (void)wbShareWithViewControll:(UIViewController *)viewC
{
}

#pragma mark 微信朋友圈分享
- (void)wxpyqShareWithViewControll:(UIViewController *)viewC
{
    self.channel = @"2";
    _viewC = viewC;
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WX_APP_KEY appSecret:WX_APP_SECRET redirectURL:self.sManager.shareModel.shareUrl];
    
    [UMSocialPlatformConfig platformNameWithPlatformType:UMSocialPlatformType_WechatSession];
    
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    
    //创建网页内容对象@"夏靖涵朋友圈share_title"
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.sManager.shareModel.Brief descr:self.sManager.shareModel.Content thumImage:self.sManager.shareModel.shareUrl];
    shareObject.webpageUrl = self.sManager.shareModel.shareUrl;
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:viewC completion:^(id data, NSError *error) {
        
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                NSLog(@"response data is %@",data);
            }
        }
        //        [self alertWithError:error];
    }];
    [[UMSocialManager defaultManager] platformProviderWithPlatformType:UMSocialPlatformType_WechatTimeLine];
    NSDictionary  *dic = @{@"shareWay":@"微信朋友圈"};
    UMShare_wx_Event(dic);

}
-(void)QQShareWithViewControll:(UIViewController *)viewC
{

}




- (void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    picker.navigationBar.tintColor = [UIColor blackColor];
    //    picker.recipients = [NSArray arrayWithObject:@"10086"];
    picker.body = @"77777777";
    [_viewC presentViewController:picker animated:YES completion:nil];
}


#pragma mark---懒加载
- (JX_ShareManager *)sManager
{
    if (!_sManager)
    {
        _sManager = [JX_ShareManager shareManager];
    }
    return _sManager;
}

@end
