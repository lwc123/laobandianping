//
//  OpinionCompanyDetailVC.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/18.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "OpinionCompanyDetailVC.h"
#import "CompanyDetailHeaderView.h"
#import "OpinionEntity.h"
#import "CompanyDetailCell.h"
#import "UserCommentCompanyVC.h"
#import "UserCommentDetailVC.h"//点评详情
#import "JX_ShareManager.h"
#import "UserAddCommentVC.h"

#define Size 15


@interface OpinionCompanyDetailVC ()<companyDetailHeaderViewDelegate>
@property (nonatomic, strong) CompanyDetailHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) int page;
@property (nonatomic, strong) NilView * nilview;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation OpinionCompanyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //公司详情
    [self isShowLeftButton:YES];
        
    [self isShowRightButton:YES withImg:[UIImage imageNamed:@"newshare"]];
    [self initData];
    [self initCompanyDetail];
    [self initUI];
    
    

}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)initData{
    _page =1;
}

- (void)initCompanyDetail{

    MJWeakSelf
    [self showLoadingIndicator];

    [UserOpinionRequest getCompanyDetailWithCompanyId:weakSelf.companyEntity.CompanyId page:weakSelf.page size:Size Success:^(OpinionCompanyEntity *companyEntity) {
        [weakSelf dismissLoadingIndicator];

        if (companyEntity.Opinions.count == 0) {
            if (weakSelf.page == 1) {
                [self.jxTableView addSubview:self.nilview];
            }else{
                //                [PublicUseMethod showAlertView:@"米有数据"];
            }
            
        }else{
            [self.nilview removeFromSuperview];
            self.nilview = nil;
            if (weakSelf.page == 1) {
                // 清空数组
                weakSelf.dataArray = @[].mutableCopy;
            }
            for (int i = 0; i < companyEntity.Opinions.count; ++i) {
                
                NSDictionary * dic = companyEntity.Opinions[i];
                OpinionEntity * opinionEntity = [[OpinionEntity alloc] initWithDictionary:dic error:nil];
                [weakSelf.dataArray addObject:opinionEntity];
            }
        }
        weakSelf.companyEntity = companyEntity;
        
        /*
        if (companyEntity.Opinions.count != 0) {
            for (int i = 0; i < companyEntity.Opinions.count; ++i) {
                
                NSDictionary * dic = companyEntity.Opinions[i];
                OpinionEntity * opinionEntity = [[OpinionEntity alloc] initWithDictionary:dic error:nil];
                [weakSelf.dataArray addObject:opinionEntity];
            }
        }
         */
        [weakSelf.jxTableView reloadData];
        [weakSelf.jxTableView endRefresh];
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [weakSelf.jxTableView endRefresh];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];

}


- (void)initUI{

    [self.view addSubview:self.commentBtn];
    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44);
    self.jxTableView.tableHeaderView = self.headerView;
    self.headerView.companyEntity = self.companyEntity;
    [self.jxTableView registerClass:[CompanyDetailCell class] forCellReuseIdentifier:@"companyDetailCell"];
    
    MJWeakSelf
    [self.jxTableView setDragDownRefreshWith:^{
        
        weakSelf.page = 1;
        [weakSelf initCompanyDetail];
    }];
    
    [self.jxTableView setDragUpLoadMoreWith:^{
        
        weakSelf.page++;
        [weakSelf initCompanyDetail];
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 0) return 38;
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        
        UILabel * textLabel = [UILabel labelWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 38) title:@" " titleColor:[PublicUseMethod setColor:KColor_Text_EumeColor] fontSize:15 numberOfLines:1];
        textLabel.text = [NSString stringWithFormat:@"    总阅读%ld   共%ld条点评   来自%ld位员工",self.companyEntity.ReadCount,self.companyEntity.CommentCount,self.companyEntity.StaffCount];
        return textLabel;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CompanyDetailCell * detailCell = [tableView dequeueReusableCellWithIdentifier:@"companyDetailCell" forIndexPath:indexPath];
    detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    OpinionEntity * opinionEntity = self.dataArray[indexPath.section];
    detailCell.opinionEntity = opinionEntity;
    self.cellHeight = detailCell.cellHeight;
    return detailCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OpinionEntity * opinionEntity = self.dataArray[indexPath.section];

    UserCommentDetailVC * commentDetail = [[UserCommentDetailVC alloc] init];
    commentDetail.title = @"点评详情";
    commentDetail.opinionEntity = opinionEntity;
    [self.navigationController pushViewController:commentDetail animated:YES];
}

- (NilView *)nilview{
    
    if (_nilview == nil) {
        _nilview = [[NilView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame) + 20, ScreenWidth, 300)];
        _nilview.labelStr = @"此公司没有收到任何评价，您可以点击下方的点评这家公司进行点评哦~";
        _nilview.isHiddenButton = YES;
    }
    return _nilview;
}

- (UIButton *)commentBtn{

    if (_commentBtn == nil) {
        _commentBtn = [UIButton buttonWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44) title:@"点评这家公司" fontSize:15.0 titleColor:[UIColor whiteColor] imageName:nil bgImageName:nil];
        
        if (self.companyEntity.IsCloseComment == YES) {//代表能评论
            _commentBtn.backgroundColor = [PublicUseMethod setColor:KColor_GoldColor];

        }else{//不能评论
            _commentBtn.backgroundColor = [PublicUseMethod setColor:KColor_FeildBack_Color];
        }
        [_commentBtn  addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}

#pragma mark-- 导航栏显示
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY > 250 - 64) {
//        self.navigationController.navigationBar.alpha = 0;

        
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        self.jxTableView.height = SCREEN_HEIGHT - 44 - 64;
        self.commentBtn.y =  SCREEN_HEIGHT - 44 - 64;
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        self.jxTableView.height = SCREEN_HEIGHT - 44;
        self.commentBtn.y =  SCREEN_HEIGHT - 44;
    }
    
}


#pragma mark -- 点评这家公司
- (void)commentBtnClick{
    
    if (self.companyEntity.IsCloseComment == YES) {//代表能评论
        UserCommentCompanyVC * commentVC = [[UserCommentCompanyVC alloc] init];
        commentVC.secondVC = self;
//        [self.navigationController pushViewController:commentVC animated:YES];
        
        UserAddCommentVC * user = [[UserAddCommentVC alloc] init];
        user.companyId = self.companyEntity.CompanyId;
        [self.navigationController pushViewController:user animated:YES];

    }else{//不能评论
        [PublicUseMethod showAlertView:@"该公司暂无法点评"];
    }
}

#pragma mark -- headerView的代理
- (void)companyDetailHeaderViewBack:(CompanyDetailHeaderView *)headerView button:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)companyDetailHeaderViewShare:(CompanyDetailHeaderView *)headerView button:(UIButton *)button{
    [self ImgButtonAction:nil];
}

#pragma mark -- 分享
- (void)ImgButtonAction:(UIButton *)btn{
    
    JX_ShareManager *manager = [JX_ShareManager shareManager];
    manager.curentVC = self;
    manager.companyDetail = self.companyEntity;
    [manager isShowShareViewWithSuperView:self.view];
    
}

- (CompanyDetailHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [CompanyDetailHeaderView companyDetailHeaderView];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
