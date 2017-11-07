//
//  SetingVC.m
//  JuXianBossComments
//
//  Created by juxian on 17/1/5.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "SetingVC.h"
#import "LandingPageViewController.h"
#import "AccountRepository.h"
#import "AboutUsViewController.h"
#import "JXMineModel.h"
#import "FAQViewController.h"
#import "ChoiceCompanyVC.h"
#import "OpenCommentVC.h"

@interface SetingVC ()<JXFooterViewDelegate>
@property (nonatomic,strong)NSArray * groupArray;

@end

@implementation SetingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self isShowLeftButton:YES];
    [self initUI];
    
}

#pragma mark - init
- (NSArray *)groupArray{
    
    if (_groupArray == nil) {
        _groupArray =@[@"  ",@"常见问题",@"关于我们"];
    }
    return _groupArray;
}

- (void)initUI{

    self.jxTableView.scrollEnabled = NO;
    self.jxTableView.separatorColor = KColor_CellColor;
    JXFooterView * footerView = [JXFooterView footerView];
    footerView.delegate = self;
    footerView.nextLabel.text = @"退出登录";
    self.jxTableView.tableFooterView = footerView;
}

- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{

     [self exitAction];

}
#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groupArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) { //我的公司
        
        
        if (self.summaryEntity.myCompanys > 0) {
            ChoiceCompanyVC * choiceVC = [[ChoiceCompanyVC alloc] init];
            choiceVC.secondVC = self;
            [self.navigationController pushViewController:choiceVC animated:YES];
            
        }else{
            OpenCommentVC * openVC = [[OpenCommentVC alloc] init];
            openVC.isChangeCompany = YES;
            openVC.secondVC = self;
            [self.navigationController pushViewController:openVC animated:YES];
        }
    }else if (indexPath.row == 1){//常见问题
        FAQViewController* FAQVc = [[FAQViewController alloc]init];
        [self.navigationController pushViewController:FAQVc animated:YES];
    
    }else{//关于我们
        AboutUsViewController * aboutUsVC = [[AboutUsViewController alloc]init];
        [self.navigationController pushViewController:aboutUsVC animated:YES];
    }
    
}
#pragma mark - tableView datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text = self.groupArray[indexPath.row];
    cell.textLabel.textColor = ColorWithHex(KColor_Text_ListColor);
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if (indexPath.row == 0) {
        cell.textLabel.text = self.summaryEntity.myCompanys > 0 ? @"我的公司" : @"创建新的公司";
    }
    return cell;
}


#pragma mark - exitAction
- (void)exitAction
{
    //发送退出登录的请求
    [self showLoadingIndicator];
    [AccountRepository signOut: ^(id result) {
        [self dismissLoadingIndicator];
        if (result) {
            [UserAuthentication removeCurrentAccount];
            
            NSUserDefaults *current = [NSUserDefaults standardUserDefaults];
            [current removeObjectForKey:@"currentIdentity"];
            [current synchronize];
            
            NSUserDefaults *company = [NSUserDefaults standardUserDefaults];
            [company removeObjectForKey:CompanyChoiceKey];
            [company synchronize];
            
            NSString * userProfilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"userProfile.data"];
            NSFileManager * userProfileFileManager = [[NSFileManager alloc]init];
            [userProfileFileManager removeItemAtPath:userProfilePath error:nil];
            
            LandingPageViewController * landingVC = [[LandingPageViewController alloc] init];
            [PublicUseMethod changeRootNavController:landingVC];
        }
        else
        {
            [self dismissLoadingIndicator];
            [PublicUseMethod showAlertView:@"退出登录失败"];
        }
    } fail:^(NSError *error) {
        
        [self dismissLoadingIndicator];
        [PublicUseMethod showAlertView:@"退出登录失败"];
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
