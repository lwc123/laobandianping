//
//  BossReviewRechargeVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/21.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "BossReviewRechargeVC.h"
#import "JXFooterView.h"
#import "PayViewController.h"
#import "MyWalletCell.h"
#import "InLineModel.h"
@interface BossReviewRechargeVC ()<JXFooterViewDelegate,JHMenuViewDelegate>{

    NSMutableArray * _tempArray;
}

@property (nonatomic,strong)JXFooterView * footerView;
@property (nonatomic,strong)NilView * nilView;
@property (nonatomic,strong)UIView * vire;
@property (nonatomic,strong)CompanyMembeEntity *bossEntity;
@property (nonatomic,strong)UIView * maskView;
@property (nonatomic ,assign)BOOL isClicked;//
@property (nonatomic,strong)JHMenuView * menuView;
@property (nonatomic ,assign)int mode;//
@property(nonatomic,assign)int page;
@property(nonatomic,assign)int size;
@property(nonatomic,strong)NSArray *dataArray;
@end

@implementation BossReviewRechargeVC

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isClicked = NO;
    [_maskView removeFromSuperview];
    [_menuView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交易记录";
    
    self.page = 1;
    self.size = 20;
    
    //XJH  将提现隐藏之后 这只有一种记录 消费
     _mode = 0;    
    // 下拉刷新
    MJWeakSelf
    [self.jxTableView setDragDownRefreshWith:^{
        // 更新数据
        weakSelf.page = 1;
        [weakSelf initRequestHttpWith:weakSelf.mode];
    }];
    
    // 上拉加载更多
    [self.jxTableView setDragUpLoadMoreWith:^{
        [weakSelf initRequestHttpWith:weakSelf.mode];
    }];

    [self isShowLeftButton:YES];
    [self isShowRightButton:YES withImg:[UIImage imageNamed:@"detail"]];

    [self initData];
    [self initUI];
    [self initRequestHttpWith:_mode];
}

- (void)initData{
    
    _bossEntity = [UserAuthentication GetBossInformation];
    _tempArray = [NSMutableArray array];
    _dataArray = [NSArray array];
   
}

/*
 TradeMode
 static let TradeMode_All = 0;
 static let TradeMode_Payoff = 1;
 static let TradeMode_Payout = 2;
 static let TradeMode_Action_Buy = 21;//消费记录
 static let TradeMode_Action_Withdraw = 22;//提现/提现退款
 */

- (void)initUI{
    _isClicked = NO;
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha= .5;
    _maskView.userInteractionEnabled = YES;
    [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarAction:)]];
    _menuView = [JHMenuView menuView];
    _menuView.height = 105;
    _menuView.seconLineView.hidden = NO;
//    _menuView.Withdrawals.hidden = NO;
    _menuView.fixCommentsImage.hidden = YES;
    _menuView.fixStaffImageView.hidden = YES;
    _menuView.fixArchiveBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _menuView.fixCommentBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _menuView.Withdrawals.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [_menuView.fixArchiveBtn setTitle:@"收入记录" forState:UIControlStateNormal];
    [_menuView.fixCommentBtn setTitle:@"消费记录" forState:UIControlStateNormal];
    _menuView.y = 0;
    _menuView.x = SCREEN_WIDTH - _menuView.width;
    _menuView.delegate = self;
    
    self.jxTableView.frame = CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT - 10 - 64);
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    self.jxTableView.tableFooterView = [[UIView alloc] init];

}

- (void)initRequestHttpWith:(int)mode{
    
    if (self.jxTableView.mj_header.state == MJRefreshStateRefreshing) {
        //第二次刷新 清除原来的数据
        if (_dataArray.count!=0) {
            _dataArray = @[];
        }
    }
    [self showLoadingIndicator];
    MJWeakSelf
    [MineRequest getCompanyWalletTradeHistoryWithCompanyId:_bossEntity.CompanyId mode:mode page:self.page size:self.size success:^(id result) {
        [weakSelf dismissLoadingIndicator];
        JSONModelArray *modelArray = [[JSONModelArray alloc]initWithArray:result modelClass:[TradeJournalEntity class]];
        if (modelArray.count == 0) {
            if (weakSelf.page == 1) {
                if (!_nilView) {
                    _nilView = [[NilView alloc] initWithFrame:self.view.bounds];
                    _nilView.labelStr = @"主人，还没有产生交易记录";
                    _nilView.isHiddenButton = YES;
                }
                [self.jxTableView addSubview:_nilView];
                [self.jxTableView reloadData];
            }
        }
        if (modelArray.count!=0) {
            [_nilView removeFromSuperview];

            if (weakSelf.page == 1) {
                weakSelf.dataArray = @[];
            }
            weakSelf.page++;
            _tempArray = weakSelf.dataArray.mutableCopy;
            for (TradeJournalEntity * model in modelArray) {
                [_tempArray addObject:model];
            }
            _dataArray = _tempArray;
            [weakSelf.jxTableView reloadData];
        }
        [weakSelf.jxTableView endRefresh];
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [weakSelf.jxTableView endRefresh];
    }];
}

- (void)leftButtonAction:(UIButton*)button
{
//    [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
    [self.navigationController popViewControllerAnimated:YES];

}
#pragma maek -- footerView的代理方法
- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{
    
    PayViewController * payVC = [[PayViewController alloc] init];
    [self.navigationController pushViewController:payVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TradeJournalEntity * tradeModel = _dataArray[indexPath.row];
    MyWalletCell * walletCell = [MyWalletCell infoCellWithTableView:tableView];
    walletCell.selectionStyle = UITableViewCellSelectionStyleNone;
    walletCell.model = tradeModel;
    return walletCell;
}

- (void)ImgButtonAction:(UIButton *)btn{
    
    if (self.isClicked == NO) {
        self.isClicked = YES;
        [self.view addSubview:_maskView];
        [self.view addSubview:_menuView];
    }else{
        self.isClicked = NO;
        [_menuView removeFromSuperview];
        [_maskView removeFromSuperview];
    }
}

- (void)tapAvatarAction:(UITapGestureRecognizer*)myTap{
    [_maskView removeFromSuperview];
    [_menuView removeFromSuperview];
    self.isClicked = NO;
}

- (NilView *)nilview{
    
    if (_nilView == nil) {
        _nilView = [[NilView alloc]initWithFrame:CGRectMake(0, 200, ScreenWidth, 300)];
        _nilView.labelStr = @"老板们都还在来这里的路上";
        _nilView.isHiddenButton = YES;
    }
    return _nilView;
}
/*
 TradeMode
 static let TradeMode_All = 0;
 static let TradeMode_Payoff = 1;收益
 static let TradeMode_Payout = 2;支出
 static let TradeMode_Action_Buy = 21;//消费记录
 static let TradeMode_Action_Withdraw = 22;//提现/提现退款
 */

#pragma mark -- 收入记录
- (void)menuViewDidClickedFixArchive:(JHMenuView *)jxFooterView{
    self.mode = 1;
    self.page = 1;
    //第二次刷新 清除原来的数据
    if (_dataArray.count!=0) {
        _dataArray = @[];
    }
    [self initRequestHttpWith:self.mode];
    
    self.isClicked = NO;
    [_maskView removeFromSuperview];
    [_menuView removeFromSuperview];
}
#pragma mark -- 消费记录
- (void)menuViewDidClickedFixComment:(JHMenuView *)jxFooterView{
    self.mode = 21;
    self.page = 1;
    //第二次刷新 清除原来的数据
    if (_dataArray.count!=0) {
        _dataArray = @[];
    }
    [self initRequestHttpWith:self.mode];
    
    self.isClicked = NO;
    [_maskView removeFromSuperview];
    [_menuView removeFromSuperview];
}

#pragma  mark -- 提现记录
- (void)menuViewDidClickedWithdrawals:(JHMenuView *)jxFooterView{
    self.mode = 22;
    self.page = 1;
    [self initRequestHttpWith:self.mode];
    
    self.isClicked = NO;
    [_maskView removeFromSuperview];
    [_menuView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
