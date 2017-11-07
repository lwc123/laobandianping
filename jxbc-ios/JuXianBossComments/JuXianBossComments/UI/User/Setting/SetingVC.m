//
//  SetingVC.m
//  JuXianBossComments
//
//  Created by juxian on 17/1/5.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "SetingVC.h"
#import "LoginViewController.h"
#import "AccountRepository.h"
#import "AboutUsViewController.h"
#import "JXMineModel.h"
#import "FAQViewController.h"
#import "AdviceFeedbackViewController.h"

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
        _groupArray =@[@"意见反馈",@"常见问题",@"关于我们"];
    }
    return _groupArray;
}

- (void)initUI{
    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-10-64 - 40);

    self.jxTableView.scrollEnabled = NO;
    self.jxTableView.separatorColor = KColor_CellColor;
    JXFooterView * footerView = [JXFooterView footerView];
    footerView.delegate = self;
    footerView.nextLabel.text = @"退出当前账号";
    self.jxTableView.tableFooterView = footerView;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [NSString stringWithFormat:@"版本%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    UILabel * versionLabel = [UILabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(self.jxTableView.frame) + 10, SCREEN_WIDTH, 13) title:app_Version titleColor:[PublicUseMethod setColor:KColor_Text_BlackColor] fontSize:13.0 numberOfLines:1];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versionLabel];
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
    if (indexPath.row == 0) { //  意见反馈
        
        AdviceFeedbackViewController* adviceVc = [[AdviceFeedbackViewController alloc]init];
        [self.navigationController pushViewController:adviceVc animated:YES];
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.groupArray[indexPath.row];
    cell.textLabel.textColor = ColorWithHex(KColor_Text_ListColor);
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}


#pragma mark - exitAction
- (void)exitAction
{
    //发送退出登录的请求
    [self showLoadingIndicator];
    MJWeakSelf
    [AccountRepository signOut: ^(id result) {
        [weakSelf dismissLoadingIndicator];
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
            
            LoginViewController * landingVC = [[LoginViewController alloc] init];
            [PublicUseMethod changeRootNavController:landingVC];
        }
        else
        {
            [weakSelf dismissLoadingIndicator];
            [PublicUseMethod showAlertView:@"退出登录失败"];
        }
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:@"退出登录失败"];
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
