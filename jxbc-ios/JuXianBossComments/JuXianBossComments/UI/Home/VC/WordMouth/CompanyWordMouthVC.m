//
//  CompanyWordMouthVC.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "CompanyWordMouthVC.h"
#import "JHMenuTabbleView.h"
#import "JXAdvancedSettingVC.h"
#import "CompanyMangerTagsVC.h"//标签管理
#import "MangerWordMouthVC.h"//口碑管理
#import "CompanyAnswerCommentVC.h"//回复评论
#import "CompanyDetailHeaderView.h"
#import "CompanyDetailCell.h"
#import "UserCommentDetailVC.h"

@interface CompanyWordMouthVC ()<JHMenuTabbleViewDelaegate,companyDetailHeaderViewDelegate>
@property (nonatomic, strong) NSArray *dataArray;

//点评详情
@property (nonatomic, strong) NSMutableArray *opinionArray;

@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong)  JHMenuTabbleView * menuView;
@property (nonatomic, assign) BOOL isClicked;
@property (nonatomic, strong) UIButton *answerCommentBtn;

@property (nonatomic, strong) CompanyDetailHeaderView *headerView;
@property (nonatomic, assign) CGFloat cellHeight;


@end

@implementation CompanyWordMouthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公司口碑";
    [self isShowLeftButton:YES];
    [self isShowRightButton:YES with:@"管理"];
    [self initData];
    [self initUI];
}


- (void)initData{
    self.isClicked = NO;
}

- (void)initUI{

    [self.view addSubview:self.answerCommentBtn];
    
    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.jxTableView.tableHeaderView = self.headerView;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 5;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) return 38;
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        UILabel * textLabel = [UILabel labelWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 38) title:@" vvvvvv" titleColor:[PublicUseMethod setColor:KColor_Text_EumeColor] fontSize:15 numberOfLines:1];
//        textLabel.text = [NSString stringWithFormat:@"    总阅读%ld   共%ld条点评   来自%ld位员工",self.companyEntity.ReadCount,self.companyEntity.CommentCount,self.companyEntity.StaffCount];
        return textLabel;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellId = @"companyDetailCell";
    
    CompanyDetailCell * detailCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!detailCell) {
        detailCell = [[CompanyDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
//    OpinionEntity * opinionEntity = self.dataArray[indexPath.section];
//    detailCell.opinionEntity = opinionEntity;
    self.cellHeight = detailCell.cellHeight;
    detailCell.backgroundColor =[UIColor cyanColor];
    return detailCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserCommentDetailVC * commentDetail = [[UserCommentDetailVC alloc] init];
    commentDetail.title = @"点评详情";
    commentDetail.isCompany = YES;
    [self.navigationController pushViewController:commentDetail animated:YES];
}


#pragma mark -- headerView的代理
- (void)companyDetailHeaderViewBack:(CompanyDetailHeaderView *)headerView button:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)companyDetailHeaderViewShare:(CompanyDetailHeaderView *)headerView button:(UIButton *)button{
    [self rightButtonAction:nil];
}


- (void)rightButtonAction:(UIButton *)button{
    if (self.isClicked == NO) {
        self.isClicked = YES;
        [self.view addSubview:self.menuView];
        [_menuView refreshWithData:self.dataArray];
    }else{
        self.isClicked = NO;
        [self.menuView removeFromSuperview];
    }
}

#pragma mark --JHMenuTabbleView的delegate
- (void)menuViewRecognizer:(JHMenuTabbleView *)tableView{
    [_menuView removeFromSuperview];
    self.isClicked = NO;
}

- (void)menuView:(JHMenuTabbleView *)tableView indexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {//口碑
        MangerWordMouthVC * mangerVC = [[MangerWordMouthVC alloc] init];
        [self.navigationController pushViewController:mangerVC animated:YES];
    }else if (indexPath.row == 1){//标签
        CompanyMangerTagsVC * tagsVC = [[CompanyMangerTagsVC alloc] init];
        [self.navigationController pushViewController:tagsVC animated:YES];
    }else if (indexPath.row == 2){//高级设置
        JXAdvancedSettingVC * settingVC = [[JXAdvancedSettingVC alloc] init];
        [self.navigationController pushViewController:settingVC animated:YES];
    }
}


- (CompanyDetailHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [CompanyDetailHeaderView companyDetailHeaderView];
        _headerView.delegate = self;
        _headerView.attentionBtn.hidden = YES;
        _headerView.shareBtn.hidden = YES;
        _headerView.claimButton.hidden = YES;
    }
    return _headerView;
}

-(NSMutableArray *)opinionArray{
    
    if (_opinionArray == nil) {
        _opinionArray = @[].mutableCopy;
    }
    return _opinionArray;
}

- (NSArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = @[@"管理口碑",@"管理标签",@"高级设置",@"修改企业信息"];
    }
    return _dataArray;
}

- (JHMenuTabbleView *)menuView{
    if (_menuView == nil) {
        _menuView = [[JHMenuTabbleView alloc] initWithViewX:(SCREEN_WIDTH - 100) - 20 width:100 height:176 delegat:self];
    }
    return _menuView;
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_menuView removeFromSuperview];
    self.isClicked = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
