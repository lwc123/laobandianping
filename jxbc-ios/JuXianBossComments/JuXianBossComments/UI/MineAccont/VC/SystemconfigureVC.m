//
//  SystemconfigureVC.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/16.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "SystemconfigureVC.h"
#import "LoginViewcontroller.h"
#import "AnonymousAccount.h"
#import "UserAuthentication.h"
#import "JXUserProfile.h"
#import "MineDataRequest.h"
#import "ChangeSecretCodeViewCtrl.h"
#import "AccountRepository.h"

#import "SectionManagerVC.h"
#import "AboutUsViewController.h"

#import "FAQViewController.h"
#import "AdviceFeedbackViewController.h"
#import "JXUserTabBarCtrVC.h"


@interface SystemconfigureVC ()<JXFooterViewDelegate>{
    AnonymousAccount * _account;
    
}
//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIButton *exitButton;
@property (nonatomic, strong) NSString *cacheSize;



@end

@implementation SystemconfigureVC
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self dismissLoadingIndicator];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    //    self.navBarBackView.backgroundColor = [PublicUseMethod setColor:KColor_MainColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _account = [UserAuthentication GetCurrentAccount];
    //计算缓存
    [self initSubViews];
}
//计算缓存
#pragma mark - 计算缓存的大小
- (NSString *)getCacheSizeOfApplication

{
    float size_m = [self sizeOfCaches]/(1000.0*1000.0);
    //返回
    return [NSString stringWithFormat:@"%.2fM",size_m];
}
- (float)sizeOfCaches
{
    float sumSize =0 ;
    NSString * cacheFilePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSArray * subFilepaths = [fileManager subpathsOfDirectoryAtPath:cacheFilePath error:nil];
    for (NSString * subPath in subFilepaths) {
        NSString * filepath = [cacheFilePath stringByAppendingPathComponent:subPath];
        //2 调用文件管理对象的实例方法attributesOfItemAtPath（某一路径下数据的属性）返回一个存放该数据属性的字典  key NSFilesize 获得大小 单位是位 byte  1byte=8bit 1kB=1000byte
        long long fileszie = [fileManager attributesOfItemAtPath:filepath error:nil] .fileSize;
        sumSize += fileszie;
    }
    sumSize += [[SDImageCache sharedImageCache]getSize];
    return sumSize;
}
- (void)initSubViews
{
    self.navigationItem.title = @"设置";
    [self isShowLeftButton:YES];
    
    _dataArray = @[@"切换个人身份",@"清除缓存",@"常见问题",@"意见反馈",@"关于我们"];
    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-10-64 - 40);
    self.jxTableView.scrollEnabled = NO;
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    JXFooterView * footerView = [JXFooterView footerView];
    footerView.delegate = self;
    footerView.nextLabel.text = @"退出当前账号";
    self.jxTableView.tableFooterView= footerView;
    
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

#pragma mark - 左侧返回按钮
- (void)leftButtonAction:(UIButton*)button
{
    //    self.navBarBackView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {//切换个人身份
        static NSString *identifier = @"cellhh";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = _dataArray[indexPath.row];
        cell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
        
    }else if (indexPath.row == 1){//清理缓存
        static NSString *identifier = @"cellid2";
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!myCell) {
            myCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            myCell.textLabel.text = _dataArray[indexPath.row];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-120, 0, 90, 45)];
            label.text = [self getCacheSizeOfApplication];
            label.textAlignment = NSTextAlignmentRight;
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:12];
            label.tag = 100;
            [myCell.contentView addSubview:label];
            //            cell.hidden = YES;
        }
        myCell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
        myCell.textLabel.font = [UIFont systemFontOfSize:15];
        return myCell;
    }else{
        static NSString *identifier = @"cellid";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = _dataArray[indexPath.row];
        cell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)return 0;
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0) return 0;
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {//切换个人端
        
        if ([_account.MobilePhone isEqualToString:DemoPhone]) {//是演示账号不能切换
            
            [PublicUseMethod showAlertView:@"演示账号不能使用此功能"];
            
        }else{
            [AccountRepository changeCurrentToUserProfileSuccess:^(AccountEntity *result) {

                [PublicUseMethod goViewController:[JXUserTabBarCtrVC class]];
                
            } fail:^(NSError *error) {
                [PublicUseMethod showAlertView:error.localizedDescription];
            }];
        }
        
    }else if(indexPath.row == 1){//清除缓存
        if (([self sizeOfCaches]/(1000.0*1000.0))>=0.01) {
            [self clearCache];
        }
        else{}
    }else if(indexPath.row == 2){//常见问题
        FAQViewController* FAQVc = [[FAQViewController alloc]init];
        [self.navigationController pushViewController:FAQVc animated:YES];
    }else if (indexPath.row == 3){// 意见反馈
        AdviceFeedbackViewController* adviceVc = [[AdviceFeedbackViewController alloc]init];
        [self.navigationController pushViewController:adviceVc animated:YES];
    }else if (indexPath.row == 4){//关于我们
        AboutUsViewController* aboutUsVC = [[AboutUsViewController alloc]init];
        [self.navigationController pushViewController:aboutUsVC animated:YES];
    }
}

#pragma mark - 缓存的清理
- (void)clearCache
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //
        NSString *filePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        NSFileManager *manager = [NSFileManager defaultManager];
        NSArray *fileArray = [manager subpathsAtPath:filePath];
        
        for (NSString *subpath in fileArray) {
            NSString *comPath = [filePath stringByAppendingPathComponent:subpath];
            if ([manager fileExistsAtPath:comPath]) {
                [manager removeItemAtPath:comPath error:nil];
            }
        }
        //清除图片缓存
        [[SDImageCache sharedImageCache]cleanDisk];
        //回到主线程
        [self performSelectorOnMainThread:@selector(alertShow) withObject:self waitUntilDone:YES];
        
    });
}
- (void)alertShow
{
    [PublicUseMethod showAlertView:@"缓存清理完成"];
    UILabel *label = (UILabel*)[self.view viewWithTag:100];
    label.text = [self getCacheSizeOfApplication];
    
}
- (void)kaiguanButtonAction:(UIButton*)button
{
    button.selected = !button.selected;
    if (button.selected) {
        [button setImage:[UIImage imageNamed:@"kai"] forState:UIControlStateNormal];
        //接受新消息通知
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"guan"] forState:UIControlStateNormal];
        button.selected = NO;
        //关闭接受新消息通知
    }
    
}
#pragma mark - exitAction
- (void)exitAction
{
    if (!_account) {
        
        [PublicUseMethod showAlertView:@"您还没用登录"];
        return;
        
    }else{
        
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
                
                
                
                LoginViewController * landingVC = [[LoginViewController alloc] init];
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
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
