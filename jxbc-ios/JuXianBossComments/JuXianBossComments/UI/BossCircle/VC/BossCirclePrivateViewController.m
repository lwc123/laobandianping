//
//  BossCirclePrivateViewController.m
//  JuXianBossComments
//
//  Created by Jam on 16/12/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "BossCirclePrivateViewController.h"
#import "BossCircleRequest.h"
#import "CompanyMembeEntity.h"
#import "BossDynamicEntity.h"
#import "BossCircleDynamicCell.h"
#import "BossCircleInputView.h"


@interface BossCirclePrivateViewController (){
    // 模型数组
    NSMutableArray* _dynamicArray;
}



// 记录数据页数
@property (nonatomic, assign) int totalPageNum ;

// 输入框
@property (nonatomic, strong) BossCircleInputView *inputView;

// 全屏按钮 退出编辑
@property (nonatomic, strong) UIButton *endEditButton;

// 要评论的老板圈
@property (nonatomic, strong) BossDynamicCommentEntity *comment;


@property (nonatomic, strong) NilView * nilview;

@property (nonatomic, assign) int size;

@end

@implementation BossCirclePrivateViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self isShowLeftButton:YES];

    [self showLoadingIndicator];
    // 初始化
    self.totalPageNum = 1;
    self.size = 20;
    
    // 下拉刷新
    MJWeakSelf
    [self.jxTableView setDragDownRefreshWith:^{
        
        weakSelf.totalPageNum = 1;
        // 清空数组
        weakSelf.dynamicArray = nil;
        // 请求数据
        [weakSelf requestData];
        
    }];
    // 上拉加载更多
    [self.jxTableView setDragUpLoadMoreWith:^{
        [weakSelf requestData];
    }];
    // 请求数据
    [self requestData];
    self.title = @"已发布";
    
}
#pragma mark - function
- (void)requestData{
    
    [self showLoadingIndicator];
    // 获取公司id
    CompanyMembeEntity * companyEntity= [UserAuthentication GetBossInformation];
    
    MJWeakSelf
    [BossCircleRequest getBossDynamicWithCompanyId:companyEntity.CompanyId withSize:weakSelf.size withPage:weakSelf.totalPageNum success:^(JSONModelArray *array) {
        [weakSelf.jxTableView endRefresh];
        [weakSelf dismissLoadingIndicator];
        //        Log(@"***************%@",array);
//        if (array.count == 0 && weakSelf.totalPageNum == 1) {
//            [weakSelf.jxTableView addSubview:weakSelf.nilview];
//            return ;
//        }
        if (array.count>0) {
            if (weakSelf.totalPageNum == 1) {
                // 清空数组
                weakSelf.dynamicArray = @[].mutableCopy;
            }
            for (BossDynamicEntity * model in array) {
                [weakSelf.dynamicArray addObject:model];
            }
//            [weakSelf.nilview removeFromSuperview];
            weakSelf.totalPageNum++;
            [weakSelf.jxTableView reloadData];
        }
    } fail:^(NSError *error) {
        [weakSelf.jxTableView endRefresh];
        [weakSelf dismissLoadingIndicator];
    }];

}

// 退出编辑
- (void)endEditButtonClick{
    
    // 退出键盘
    [self.view endEditing:YES];
    [self.inputView.inputView resignFirstResponder];
    // 退出输入框
    [UIView animateWithDuration:0.5 animations:^{
        self.inputView.y = ScreenHeight;
    }];
    // 去掉全屏按钮
    self.endEditButton.hidden = YES;
    
}

#pragma mark - tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
};

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [BossCircleDynamicCell calculateCellHeightWithDynamic:self.dynamicArray[indexPath.section]];
}

#pragma mark - tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.dynamicArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString* reuseID = @"dynamic";
    BossCircleDynamicCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    if (!cell) {
        cell = [[BossCircleDynamicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    cell.dynamic = self.dynamicArray[indexPath.section];
    
    MJWeakSelf
    // 删除
    // 删除
    [cell deleteButtonClickCompletion:^(BossDynamicEntity *dynamic){
        
        // 弹框确认
        
        [weakSelf alertStringWithString:@"确认删除本条老板圈吗?" doneButton:YES cancelButton:YES duration:0 doneClick:^{
            
            // 请求
            [BossCircleRequest postDeleteDynamicWithDynamicID:dynamic success:^(BOOL result) {
                
                if (result) {
                    Log(@"删除成功");
                }
                // 删除数据
                [weakSelf.dynamicArray removeObjectAtIndex:indexPath.section];
                // 刷新列表
                [weakSelf.jxTableView reloadData];
                
            } fail:^(NSError *error) {
                Log(@"删除失败");
            }];
            
        }];
        
    }];
    
    // 评论按钮点击
    [cell commentButtonClickCompletion:^(BossDynamicCommentEntity* comment){
        
        // 保存评论信息
        self.comment = comment;
        
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

#pragma mark - lazy load

- (void)setDynamicArray:(NSMutableArray *)dynamicArray{
    _dynamicArray = dynamicArray;
    
    if (_dynamicArray.count == 0) {
        [self.jxTableView addSubview:self.nilview];
    }else{
        [self.nilview removeFromSuperview];
    }

}

- (NSMutableArray *)dynamicArray{

    if (_dynamicArray == nil) {
        _dynamicArray = [[NSMutableArray alloc] init];
    }
    if (_dynamicArray.count == 0) {
        [self.jxTableView addSubview:self.nilview];
    }else{
        [self.nilview removeFromSuperview];
    }

    return _dynamicArray;
}

- (UIView *)inputView{
    
    if (_inputView == nil) {
        _inputView = [BossCircleInputView inputView];
        _inputView.width = ScreenWidth;
        _inputView.height = 44;
        _inputView.center = self.view.center;
        _inputView.y = ScreenHeight;
        [self.tabBarController.view addSubview:_inputView];
        
        // 发送评论按钮点击
        [_inputView SendButtonClickComplete:^{
            
            // 取输入框文字
            self.comment.Content = _inputView.inputView.text;
            
            MJWeakSelf
            // 发送请求
            [BossCircleRequest postCommentDynamicWith:self.comment success:^(long result) {
                Log(@"发送成功");
#warning 不完善
                // 刷新
                weakSelf.totalPageNum = 1;
                // 清空数组
                weakSelf.dynamicArray = nil;
                // 请求数据
                [weakSelf requestData];
                
                // 退出编辑
                [weakSelf endEditButtonClick];
                // 清空输入框文字
                weakSelf.inputView.inputView.text = nil;
                
                
            } fail:^(NSError *error) {
                Log(@"#postCommentDynamic error: %@",error.localizedDescription);
                [weakSelf endEditButtonClick];
                weakSelf.inputView.inputView.text = nil;
                
            }];
            
        }];
    }
    return _inputView;
}

- (UIButton *)endEditButton{
    
    if (!_endEditButton) {
        _endEditButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        //        _endEditButton.backgroundColor = [UIColor lightGrayColor];
        _endEditButton.backgroundColor = [UIColor clearColor];
        [_endEditButton addTarget:self action:@selector(endEditButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _endEditButton.hidden = YES;
        //        [[UIApplication sharedApplication].keyWindow addSubview:_endEditButton];
        [self.view addSubview:self.endEditButton];
        
    }
    return _endEditButton;
}

- (NilView *)nilview{
    
    if (_nilview == nil) {
        _nilview = [[NilView alloc]initWithFrame:CGRectMake(0, 80, ScreenWidth, 300)];
        _nilview.labelStr = @"老板们都还在来这里的路上";
        _nilview.isHiddenButton = YES;
    }
    return _nilview;
}

@end
