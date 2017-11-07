//
//  HomeViewController.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/18.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "HomeViewController.h"
#import "JXBecomeHunterView.h"
#import "PayViewController.h"
#import "CheckStaffViewController.h"
//点评
#import "CommentsWorkerVC.h"

@interface HomeViewController ()<XJHAlertViewDelegate>

@property (nonatomic,strong)UIImageView * bgIMageView;
@property (nonatomic,strong)UIView * blackView;
@property (nonatomic,strong)XJHAlertView * jhAlertView;

@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationItem setHidesBackButton:YES];

}


- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
//    [self.navigationItem setHidesBackButton:YES];
    
    [_blackView removeFromSuperview];
    [_jhAlertView removeFromSuperview];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavView];
    [self initUI];
}

- (void)initNavView{
    [self isShowLeftButton:NO];
    
}


- (void)initUI{
    

    UIImageView * bgImageView = [[UIImageView alloc] initWithFrame:self.view.frame];;
    bgImageView.image = [UIImage imageNamed:@"bosshome"];
    bgImageView.userInteractionEnabled = YES;
    [self.view addSubview:bgImageView];
    
    CGFloat bgViewX = 0;
    CGFloat bgViewY = SCREEN_HEIGHT - 30 - 150;
    CGFloat bgViewW = SCREEN_WIDTH;
    CGFloat bgViewH = 34;
    CGFloat btnW = 90;
    CGFloat btnH = 34;


    //讲登录 注册按钮放在这个View上面
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(bgViewX, bgViewY, bgViewW, bgViewH)];
    bgView.backgroundColor = [UIColor clearColor];
//    bgView.backgroundColor = [UIColor redColor];
    [self.view addSubview:bgView];
    UIButton * commentBtn = [UIButton buttonWithFrame:CGRectMake((bgViewW - 220) * 0.5, 2, btnW, btnH) title:@"点评员工" fontSize:14.0 titleColor:[UIColor whiteColor] imageName:nil bgImageName:nil];
    
    
    
    commentBtn.backgroundColor = [PublicUseMethod setColor:KColor_MainColor];
    commentBtn.layer.masksToBounds = YES;
    commentBtn.layer.cornerRadius = 8;
    [bgView addSubview:commentBtn];
    [commentBtn addTarget:self action:@selector(commentBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * checkBtn = [UIButton buttonWithFrame:CGRectMake(CGRectGetMaxX(commentBtn.frame) + 40, 2, btnW, btnH) title:@"查询" fontSize:14.0 titleColor:[UIColor whiteColor] imageName:nil bgImageName:nil];
    
    
    checkBtn.backgroundColor = [PublicUseMethod setColor:KColor_MainColor];
    checkBtn.layer.masksToBounds = YES;
    checkBtn.layer.cornerRadius = 8;
    [bgView addSubview:checkBtn];
    [checkBtn addTarget:self action:@selector(checkBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIButton * clearBtn = [UIButton buttonWithFrame:CGRectMake(CGRectGetMaxX(commentBtn.frame) + 40, bgViewY - 20, 120, 50) title:nil fontSize:0 titleColor:nil imageName:nil bgImageName:nil];
    clearBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:clearBtn];
    [clearBtn addTarget:self action:@selector(checkBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //测试  两个app之间的跳转
    UIButton * tenBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 30)];
    tenBtn.backgroundColor = [UIColor redColor];
    tenBtn.enabled = YES;
    [tenBtn addTarget:self action:@selector(taoBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [bgImageView addSubview:tenBtn];
}
#pragma mark -- 测试 两个app之间的跳转
- (void)taoBtn:(UIButton *)tr{
    //判断本地是否有淘宝App
    NSURL * myURL_APP_A = [NSURL URLWithString:@"taobao://"];
    if ([[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
        NSLog(@"canOpenURL");
        [[UIApplication sharedApplication] openURL:myURL_APP_A];
    }
    else{
        NSLog(@"淘宝图标不显示");
//跳转到APPstore
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/gb/app/yi-dong-cai-bian/id391945719?mt=8"]];
    }
}

#pragma mark -- 点评员工
- (void)commentBtn:(UIButton *)btn{
    
    CommentsWorkerVC * commentsVC = [[CommentsWorkerVC alloc] init];
    commentsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commentsVC animated:YES];

}

#pragma mark -- 查询
- (void)checkBtn:(UIButton *)btn{

    if (btn.selected)
    {
        //如果当前是选中的状态就不执行任何代码，防止多次请求网络数据
        btn.selected = NO;
    }
    else
    {
        [self showLoadingIndicator];
        [HomeRequest homeMyLastContractWithSuccess:^(ServiceContractEntity *model) {
            [self dismissLoadingIndicator];
            NSLog(@"%@",model);
            
            if ([model isKindOfClass:[NSNull class]]) {//从来没有充值过
                
                _blackView = [[UIView alloc] initWithFrame:self.view.bounds];
                _blackView.backgroundColor = [UIColor blackColor];
                _blackView.alpha = .4;
                [_blackView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarAction:)]];
                
                [self.view addSubview:_blackView];
                _jhAlertView = [XJHAlertView jhAlertView];
                _jhAlertView.frame = CGRectMake(0, 170, SCREEN_WIDTH, 200);
                _jhAlertView.delegate = self;
                [self.view addSubview:_jhAlertView];
            }else{
                
                if (model.ContractStatus == ContractStatusServicing) {//可以查询
                    CheckStaffViewController * checkVC = [[CheckStaffViewController alloc] init];
                    checkVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:checkVC animated:YES];
                }else{
                    
                    _blackView = [[UIView alloc] initWithFrame:self.view.bounds];
                    _blackView.backgroundColor = [UIColor blackColor];
                    _blackView.alpha = .4;
                    [_blackView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarAction:)]];
                    
                    [self.view addSubview:_blackView];
                    _jhAlertView = [XJHAlertView jhAlertView];
                    _jhAlertView.frame = CGRectMake(0, 170, SCREEN_WIDTH, 200);
                    _jhAlertView.delegate = self;
                    [self.view addSubview:_jhAlertView];
                    
                }
            }
            
        } fail:^(NSError *error) {
            [self dismissLoadingIndicator];
            
            NSLog(@"判断是否可以查询%@",error.localizedDescription);
            
        }];

        btn.selected = YES;
    }
}

- (void)tapAvatarAction:(UITapGestureRecognizer *)tap{

    [_blackView removeFromSuperview];
    [_jhAlertView removeFromSuperview];

}

#pragma mark -- 提示页面的关闭按钮
- (void)xjhAlertViewDidClickOffBtn:(XJHAlertView *)jhAlertView{
    
    [_blackView removeFromSuperview];
    [_jhAlertView removeFromSuperview];

}

#pragma mark -- 提示页面的充值按钮
- (void)xjhAlertViewDidClicRechargeBtn:(XJHAlertView *)jhAlertView{
    
    PayViewController * payVC = [[PayViewController alloc] init];
    payVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:payVC animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
