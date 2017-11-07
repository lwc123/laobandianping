//
//  JX_ShareManager.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/4.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "JX_ShareManager.h"
#import "JXAPIs.h"
//企业注册
#import "InvitationRegistVC.h"
static JX_ShareManager *shareManager = nil;
@implementation JX_ShareManager
+(id)shareManager;
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[JX_ShareManager alloc]init];
    });
    return shareManager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.shareBaseManager = [ShareManage shareManage];
    }
    return self;
}
+ (id)allocWithZone:(struct _NSZone *)zone
{
    
    static dispatch_once_t onceToken;
    // dispatch_once宏可以保证块代码中的指令只被执行一次
    dispatch_once(&onceToken, ^{
        // 在多线程环境下，永远只会被执行一次，instance只会被实例化一次
        shareManager = [super allocWithZone:zone];
    });
    
    return shareManager;
}
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

//
- (void)isShowShareViewWithSuperView:(UIView*)superView;
{
    //初始化分享视图
    if (!_shareView) {
        _shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _shareView.delegate = self;
    }
    [UIView animateWithDuration:.35 animations:^{
        self.shareView.maskView.alpha = .5;
        
        [superView addSubview:_shareView];
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark - ShareViewDelegate
- (void)shareButtonIndex:(NSInteger)index
{
    if (index==100) {
        //微信好友
        
      [self.shareBaseManager wxShareWithViewControll:self.curentVC];
    }else
    {
    //微信朋友圈
      [self.shareBaseManager wxpyqShareWithViewControll:self.curentVC];
    }
}



- (void)setInvitedEntity:(InvitedRegisterEntity *)invitedEntity{
    if (_invitedEntity != invitedEntity) {
        _invitedEntity = invitedEntity;
        _shareModel = [[ShareModel alloc]init];
        AnonymousAccount *myaccount = [UserAuthentication GetCurrentAccount];
        if (myaccount.UserProfile.CurrentProfileType == OrganizationProfile) {// 企业
            self.shareModel.Brief = CompanyShare_title;
            self.shareModel.Content = Company_Conten;

        }else{// 个人
            self.shareModel.Brief = UserShare_title;
            self.shareModel.Content = User_Conten;

        }
        self.shareModel.shareUrl = invitedEntity.InviteRegisterUrl;
    }
}


//公司详情分享
- (void)setCompanyDetail:(OpinionCompanyEntity *)companyDetail{

    if (_companyDetail != companyDetail) {
        _companyDetail = companyDetail;
        
        self.shareModel.shareUrl = companyDetail.ShareLink;
        self.shareModel.Brief = [NSString stringWithFormat:@"%ld位员工点评了%@",companyDetail.StaffCount,companyDetail.CompanyName];
        self.shareModel.Content = [NSString stringWithFormat:@"有%ld位员工，对%@产生了%ld条点评，同志们速来看看",companyDetail.StaffCount,companyDetail.CompanyName,companyDetail.CommentCount];
        self.shareModel.ImgPath = companyDetail.CompanyLogo;
        
    }
}

//点评详情分享
- (void)setOpinionEntity:(OpinionEntity *)opinionEntity{

    if (_opinionEntity != opinionEntity) {
        _opinionEntity = opinionEntity;
        self.shareModel.shareUrl = self.opinionDetailUrl;
        self.shareModel.Brief = opinionEntity.Title;
        
        if (opinionEntity.Content.length < 41) {
            self.shareModel.Content = opinionEntity.Content;
        }else{
        
            self.shareModel.Content = [opinionEntity.Content substringToIndex:41];
        }
        self.shareModel.ImgPath = opinionEntity.Company.CompanyLogo;
    }

}

@end
