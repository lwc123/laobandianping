//
//  JX_ShareManager.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/4.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareManage.h"
#import "ShareView.h"
#import "ShareModel.h"
@interface JX_ShareManager : NSObject<ShareViewDelegate>
@property (nonatomic,strong)UIViewController *curentVC;
@property (nonatomic,strong)ShareManage *shareBaseManager;
@property (nonatomic,strong)ShareView   *shareView;
@property (nonatomic,strong)ShareModel *shareModel;
@property (nonatomic,copy)NSString *shareTitle;
//分享
@property (nonatomic,strong)InvitedRegisterEntity *invitedEntity;

//公司详情的分享
@property (nonatomic,strong)OpinionCompanyEntity *companyDetail;
//点评详情分享
@property (nonatomic, strong) OpinionEntity * opinionEntity;


//点评详情分享链接
@property (nonatomic,copy)NSString *opinionDetailUrl;


+(id)shareManager;
- (void)isShowShareViewWithSuperView:(UIView*)superView;
@end
