//
//  ChoiceIdentityVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/17.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "ChoiceIdentityVC.h"
#import "BossCommentTabBarCtr.h"
#import "ProveOneViewController.h"
#import "ChoiceCompanyVC.h"
#import "OpenCommentVC.h"
#import "UserWorkbenchVC.h"

@interface ChoiceIdentityVC ()

@property (nonatomic,strong)AnonymousAccount * account;


@end

@implementation ChoiceIdentityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    [self isShowLeftButton:NO];
    _account = [UserAuthentication GetCurrentAccount];
    [self initUI];
}

- (void)initUI{

    CGFloat btnW = 110;
    CGFloat btnH = btnW;
    CGFloat btnY = 92 * 0.5;
    CGFloat btnX = (SCREEN_WIDTH - btnW) * 0.5;

    UIButton * companyBtn = [UIButton buttonWithFrame:CGRectMake(btnX, btnY, btnW, btnH) title:nil fontSize:13.0 titleColor:nil imageName:@"incompany" bgImageName:nil];
    companyBtn.layer.masksToBounds = YES;
    companyBtn.layer.cornerRadius = btnW * 0.5;
    [self.view addSubview:companyBtn];
    [companyBtn addTarget:self action:@selector(companyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * personBtn = [UIButton buttonWithFrame:CGRectMake(btnX, CGRectGetMaxY(companyBtn.frame) + 36, btnW, btnH) title:nil fontSize:14.0 titleColor:nil imageName:@"inpersonal" bgImageName:nil];
    /*
    personBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [personBtn setImage:[UIImage imageNamed:@"PhoneNum"] forState:UIControlStateNormal];
    [personBtn setTitleEdgeInsets:UIEdgeInsetsMake(personBtn.imageView.frame.size.height + 20 ,-personBtn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [personBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -personBtn.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
     */
    [self.view addSubview:personBtn];
    [personBtn addTarget:self action:@selector(personBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -- 我的是企业用户
- (void)companyBtnClick:(UIButton *)btn{
    
    //判断有几个企业 0 -> 就去开户 1 (认证被拒绝 重新认证  认证通过或是认证中 进入工作台) 多个 就要选择公司
    
    ChoiceCompanyVC * choiceVC = [[ChoiceCompanyVC alloc] init];
    choiceVC.currentProfile = 2;
    [self.navigationController pushViewController:choiceVC animated:YES];

    /*
    [MineDataRequest InformationWithSuccess:^(JSONModelArray *array) {
    
        NSLog(@"array===%@",array);
        CompanyModel *compModel;
        for (CompanyMembeEntity *model in array) {
            
            compModel = model.myCompany;
        }
        if (array.count ==0) {//去开户
            [self.navigationController pushViewController:[[OpenCommentVC alloc] init] animated:YES];
        }else if (array.count == 1){//查看认证状态
        
            if (compModel.AuditStatus == 1 || compModel.AuditStatus == 2) {
                [PublicUseMethod goViewController:[BossCommentTabBarCtr class]];
            }
            if (compModel.AuditStatus == 0 || compModel.AuditStatus == 9) {
                
                [self.navigationController pushViewController:[[ProveOneViewController alloc] init] animated:YES];
            }
        }else{//选择公司
        
            ChoiceCompanyVC * choiceVC = [[ChoiceCompanyVC alloc] init];
            choiceVC.currentProfile = 2;
            [self.navigationController pushViewController:choiceVC animated:YES];
        }
        ChoiceCompanyVC * choiceVC = [[ChoiceCompanyVC alloc] init];
        choiceVC.currentProfile = 2;
        [self.navigationController pushViewController:choiceVC animated:YES];
        
    } fail:^(NSError *error) {
        
        NSLog(@"error===%@",error);
        
    }];
     */
    //直接跳入 工作台
//    [PublicUseMethod goViewController:[BossCommentTabBarCtr class]];
}

#pragma mark -- 我的个人用户
- (void)personBtnClick:(UIButton *)btn{
    
    
    
    //存个人
    _account.UserProfile.CurrentProfileType = UserProfile;
    [UserAuthentication SaveCurrentAccount:_account];
    UserWorkbenchVC * userVC = [[UserWorkbenchVC alloc] init];
    [PublicUseMethod changeRootNavController:userVC];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
