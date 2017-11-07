//
//  BossCircleViewController.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/22.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "BossCircleViewController.h"
#import "BossCircleRequest.h"
#import "CompanyMembeEntity.h"
#import "BossDynamicEntity.h"
#import "BossCircleHeaderView.h"
#import "BossCircleDynamicCell.h"
#import "BossCirclePublicDynamicViewController.h"
#import "BossCircleInputView.h"
#import "BossCirclePrivateViewController.h"
#import "MineRequest.h"
#import "SubAddCardVC.h"
#import "JXGetMoneyVC.h"


const static int kDynamicNumPrePage = 20;

@interface BossCircleViewController ()
{
    NSMutableArray<BossDynamicEntity*>* _dataArray;
}

// 记录数据页数
@property (nonatomic, assign) int totalPageNum ;

// 输入框
@property (nonatomic, strong) BossCircleInputView *inputView;

// 全屏按钮 退出编辑
@property (nonatomic, strong) UIButton *endEditButton;

// 要评论的老板圈
@property (nonatomic, strong) BossDynamicCommentEntity *comment;
// 要评论的老板圈index
@property (nonatomic, strong) NSIndexPath *commentIndexPath;

@property (nonatomic, strong) UIBarButtonItem *publicButton;

@property (nonatomic, assign) BOOL bossNameHidden;

@property (nonatomic, strong) NilView * nilview;
@end

@implementation BossCircleViewController

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showLoadingIndicator];
    [self isShowLeftButton:NO];
    
    // 评论
    self.inputView.y = ScreenHeight;
    self.totalPageNum = 1;
    self.navigationItem.rightBarButtonItem = self.publicButton;
    [self requestData];
    // 下拉刷新
    MJWeakSelf
    [self.jxTableView setDragDownRefreshWith:^{
        
        // 更新数据
        [weakSelf updateData];

    }];
    // 上拉加载更多
    [self.jxTableView setDragUpLoadMoreWith:^{
        [weakSelf requestData];
    }];
    
    // 头部试图
    BossCircleHeaderView* header = [[BossCircleHeaderView alloc]init];
    self.jxTableView.tableHeaderView = header;
    self.jxTableView.tableHeaderView.height = 194;
    self.jxTableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    [header iconButtonClickBlockComplete:^{
        // 跳转个人界面
        BossCirclePrivateViewController *privateVC = [[BossCirclePrivateViewController alloc]init];
        [weakSelf.navigationController pushViewController:privateVC animated:YES];

    }];
    
    // 注册键盘消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditButtonClick) name:UIKeyboardDidHideNotification object:nil];

}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];

}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    // 更新头像和公司名
    BossCircleHeaderView* header = (BossCircleHeaderView*)self.jxTableView.tableHeaderView;
    [header updateIconAndCompanyName];
    
    
}

#pragma mark - funtions
// 请求数据
- (void)requestData{
    
//    [self showLoadingIndicator];
    // 获取公司id
    CompanyMembeEntity * companyEntity= [UserAuthentication GetBossInformation];
    
    MJWeakSelf
    [BossCircleRequest getBossCircleListWithCompanyId:companyEntity.CompanyId withSize:kDynamicNumPrePage withPage:weakSelf.totalPageNum success:^(JSONModelArray *array) {
        [weakSelf.jxTableView endRefresh];
        [weakSelf dismissLoadingIndicator];
        
        if (array.count == 0) {
            [self.jxTableView addSubview:self.nilview];
        }else{
            [self.nilview removeFromSuperview];
        }

//        Log(@"***************%@",array);
        if (array.count != 0) {
            if (weakSelf.totalPageNum == 1) {
                // 清空数组
                weakSelf.dataArray = @[].mutableCopy;
            }

            weakSelf.totalPageNum++;
            for (BossDynamicEntity * model in array) {
                if ([model isKindOfClass:[BossDynamicEntity class]]) {
                    [weakSelf.dataArray addObject:model];

                }
            }
            
            [weakSelf.jxTableView reloadData];

        }
        
    } fail:^(NSError *error) {
        
        Log(@"error:%@",error.localizedDescription);
        [weakSelf.jxTableView endRefresh];
        [weakSelf dismissLoadingIndicator];

    }];
    
}

// 重置数据
- (void)updateData{
    
    MJWeakSelf
    weakSelf.totalPageNum = 1;
    // 请求数据
    [weakSelf requestData];
    

}

// 发布按钮点击
- (void)publicItemClick{
    
    // 获取个人信息
    CompanyMembeEntity * myInforEntity = [UserAuthentication GetMyInformation];

    // 只有老板可以发布
    if (myInforEntity.Role == Role_Boss) {
        
        BossCirclePublicDynamicViewController* publicVC  = [[BossCirclePublicDynamicViewController alloc]init];
        
        MJWeakSelf
        [publicVC CompletePublicHandle:^{
            
            [weakSelf updateData];
            
        }];
        
        // 跳转发布页面
        [self.navigationController pushViewController:publicVC animated:YES];

    }else{
        // 温馨提示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"只有老板可以发布老板圈哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
        
    }

    
}


// 退出编辑
- (void)endEditButtonClick{

    // 退出键盘
    [self.view endEditing:YES];
    [self.inputView.inputView resignFirstResponder];
    // 退出输入框
    MJWeakSelf
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.inputView.y = ScreenHeight;
    }];
    // 去掉全屏按钮
    self.endEditButton.hidden = YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - tableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
};

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPathP{

    [tableView deselectRowAtIndexPath:indexPathP animated:NO];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [BossCircleDynamicCell calculateCellHeightWithDynamic:self.dataArray[indexPath.section]];
}

#pragma mark - tableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString* reuseID = @"dynamic";
    BossCircleDynamicCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    if (!cell) {
        cell = [[BossCircleDynamicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    
    if (indexPath.section < self.dataArray.count) {
        cell.dynamic = self.dataArray[indexPath.section];
    }
    
    MJWeakSelf
    // 删除
    [cell deleteButtonClickCompletion:^(BossDynamicEntity *dynamic){
        
        // 获取公司id
        CompanyMembeEntity * companyEntity= [UserAuthentication GetBossInformation];
        dynamic.CompanyId = companyEntity.CompanyId;
        // 弹框确认

        [weakSelf alertStringWithString:@"确认删除本条老板圈吗?" doneButton:YES cancelButton:YES duration:0 doneClick:^{
            [weakSelf showLoadingIndicator];
            // 请求
            [BossCircleRequest postDeleteDynamicWithDynamicID:dynamic success:^(BOOL result) {
                [weakSelf dismissLoadingIndicator];
                if (result) {
                    Log(@"删除成功");
                    [PublicUseMethod showAlertView:@"删除成功"];
                }
                // 删除数据
                [weakSelf.dataArray removeObjectAtIndex:indexPath.section];
                // 刷新列表
                [weakSelf.jxTableView reloadData];
                
            } fail:^(NSError *error) {
                Log(@"删除失败");
                [weakSelf dismissLoadingIndicator];
                [PublicUseMethod showAlertView:[NSString stringWithFormat:@"%@",error.localizedDescription]];

            }];
        }];
        
    }];
    
    
    [cell commentButtonClickCompletion:^(BossDynamicCommentEntity* comment){
        
        // 保存评论信息
        weakSelf.comment = comment;
        weakSelf.commentIndexPath = indexPath;
        // 公司id
        CompanyMembeEntity * companyEntity= [UserAuthentication GetBossInformation];
        weakSelf.comment.CompanyId = companyEntity.CompanyId;
        
        // 弹出键盘 & 输入框 264 + 26 = 290
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.inputView.y = ScreenHeight - 290;
            [weakSelf.inputView.inputView becomeFirstResponder];
        } completion:^(BOOL finished) {
            // 显示全屏按钮
            weakSelf.endEditButton.hidden = NO;
            
        }];
        
    }];

    
    return cell;
}

#pragma mark - lazy Loading

- (BossCircleInputView *)inputView{

    if (_inputView == nil) {
        _inputView = [BossCircleInputView inputView];
        _inputView.width = ScreenWidth;
        _inputView.height = 44;
        _inputView.center = self.view.center;
        _inputView.y = ScreenHeight;
        [self.tabBarController.view addSubview:_inputView];
        
        MJWeakSelf
        // 发送评论按钮点击
        [_inputView SendButtonClickComplete:^{
            
            if (_inputView.inputView.text.length == 0) {
                // 提示评论不能为空
                [PublicUseMethod showAlertView:@"评论不能为空哦"];
                // 退出编辑
                [weakSelf endEditButtonClick];
                return ;
            }
            
            // 取输入框文字
            self.comment.Content = _inputView.inputView.text;
            
            [self showLoadingIndicator];
            
            MJWeakSelf
            // 发送请求
            [BossCircleRequest postCommentDynamicWith:self.comment success:^(long result) {
                Log(@"评论成功");
                [weakSelf dismissLoadingIndicator];
                // 刷新数据
                [weakSelf updateData];
                // 刷新表格
                [weakSelf.jxTableView reloadData];
                
                // 退出编辑
                [weakSelf endEditButtonClick];
                // 清空输入框文字
                weakSelf.inputView.inputView.text = nil;      
                _inputView.sendButton.enabled = YES;

                
            } fail:^(NSError *error) {
                [weakSelf dismissLoadingIndicator];
                [PublicUseMethod showAlertView:[NSString stringWithFormat:@"%@",error.localizedDescription]];
                [weakSelf endEditButtonClick];
                _inputView.sendButton.enabled = YES;
            }];
        }];
    }
    return _inputView;
}

- (UIButton *)endEditButton{

    if (!_endEditButton) {
        _endEditButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _endEditButton.backgroundColor = [UIColor clearColor];
        [_endEditButton addTarget:self action:@selector(endEditButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _endEditButton.hidden = YES;
        //        _endEditButton.backgroundColor = [UIColor lightGrayColor];

        [self.view addSubview:self.endEditButton];

    }
    return _endEditButton;
}

-(UIBarButtonItem *)publicButton{

    if (_publicButton == nil) {
        _publicButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"aaadd.png"] style:UIBarButtonItemStylePlain target:self action:@selector(publicItemClick)];
    }
    return _publicButton;
}

- (void)setDataArray:(NSMutableArray*)dataArray{
    _dataArray = dataArray;
//    if (_dataArray.count == 0) {
//        [self.jxTableView addSubview:self.nilview];
//    }else{
//        [self.nilview removeFromSuperview];
//    }
}

- (NSMutableArray*)dataArray{

    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
//    if (_dataArray.count == 0) {
//        [self.jxTableView addSubview:self.nilview];
//    }else{
//        [self.nilview removeFromSuperview];
//    }
    return _dataArray;
    
}

- (NilView *)nilview{

    if (_nilview == nil) {
        _nilview = [[NilView alloc]initWithFrame:CGRectMake(0, 200, ScreenWidth, 300)];
        _nilview.labelStr = @"老板们都还在来这里的路上";
        _nilview.isHiddenButton = YES;
    }
    return _nilview;
}

@end



