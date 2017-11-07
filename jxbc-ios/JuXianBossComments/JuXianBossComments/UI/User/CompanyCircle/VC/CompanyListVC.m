//
//  CompanyListVC.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/7.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "CompanyListVC.h"
#import "UserSeachCompanyVC.h"
#import "UserCommentDetailVC.h"
#import "ImagesScrollView.h"
#import "TopicEntity.h"
#import "JXTopicVC.h"
#import "OpinionEntity.h"//口碑列表
#import "CompanyReputationListCell.h"
#import "OpinionCompanyDetailVC.h"

const static int kNumSize = 15;


@interface CompanyListVC ()<SeachViewDelegate,ImagesScrollViewDelegate,CompanyReputationListCellDelegate>{

    NSMutableArray * _imageUrls;

}

@property (nonatomic, strong) SeachView * searchView;
@property (strong, nonatomic) ImagesScrollView *imagesScrollViewfromUrl; //用代码创建的
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int size;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) NilView * nilview;
@end

@implementation CompanyListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initTopicRequest];
    [self initReputationList];//公司口碑列表
    [self initUI];
    
}



- (void)initReputationList{
    
    
    [self showLoadingIndicator];
    MJWeakSelf
    [UserOpinionRequest getCompanyReputationListPage:weakSelf.page size:kNumSize success:^(JSONModelArray *array) {
        [weakSelf dismissLoadingIndicator];
        
        if (array.count == 0) {
            
            if (weakSelf.page == 1) {
                [self.jxTableView addSubview:self.nilview];

            }else{
//                [PublicUseMethod showAlertView:@"米有数据"];
            }
            
        }else{
            [self.nilview removeFromSuperview];
            if (weakSelf.page == 1) {
                // 清空数组
                weakSelf.dataArray = @[].mutableCopy;
            }
            
            for (OpinionEntity * model in array) {
                if ([model isKindOfClass:[OpinionEntity class]]) {
                    [weakSelf.dataArray addObject:model];
                }
            }
        }
        [weakSelf.jxTableView endRefresh];
        [weakSelf.jxTableView reloadData];

    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [weakSelf.jxTableView endRefresh];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];

}

- (void)initTopicRequest{
    [self showLoadingIndicator];
    MJWeakSelf
    [UserOpinionRequest getCompanyReputationTopicSuccess:^(JSONModelArray *array) {
        [weakSelf dismissLoadingIndicator];
        for (TopicEntity *model in array) {
            [_imageUrls addObject:model];
        }
        [_imagesScrollViewfromUrl reloadData];
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
}

- (void)initData{
    _imageUrls = [NSMutableArray array];
    _page = 1;
    _size = 15;
}



- (void)initUI{
    
    self.jxTableView.frame = CGRectMake(0, CGRectGetMaxY(self.searchView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.searchView.frame)-49-64-36);
    
    self.imagesScrollViewfromUrl = [[ImagesScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 155)];
    [self.view addSubview:self.imagesScrollViewfromUrl];
    self.imagesScrollViewfromUrl.delegate = self;
    self.imagesScrollViewfromUrl.autoScrollInterval = 1;
    self.imagesScrollViewfromUrl.isLoop = YES;
    self.jxTableView.tableHeaderView =  self.imagesScrollViewfromUrl;

    [self.jxTableView registerClass:[CompanyReputationListCell class] forCellReuseIdentifier:@"companyReputationListCell"];
    
    MJWeakSelf
    [self.jxTableView setDragDownRefreshWith:^{

        weakSelf.page = 1;
        [weakSelf initReputationList];
    }];
    
    [self.jxTableView setDragUpLoadMoreWith:^{
        
        weakSelf.page++;
        [weakSelf initReputationList];
    }];
    
    
}

#pragma mark -- 轮播图代理
- (NSInteger)numberOfImagesInImagesScrollView:(ImagesScrollView *)imagesScrollView
{
    return _imageUrls.count;
}

- (void)imagesScrollView:(ImagesScrollView *)imagesScrollView didSelectIndex:(NSInteger)index
{
    TopicEntity * topicEntity = _imageUrls[index];
    JXTopicVC * topicVC = [[JXTopicVC alloc] init];
    topicVC.topicEntity = topicEntity;
    topicVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:topicVC animated:YES];
}

- (NSString *)imagesScrollView:(ImagesScrollView *)imagesScrollView imageUrlStringWithIndex:(NSInteger)index
{
    TopicEntity * topic = _imageUrls[index];
    return topic.BannerPicture;
}
#pragma mark -- tableView 的delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    CompanyReputationListCell * listCell = [tableView dequeueReusableCellWithIdentifier:@"companyReputationListCell" forIndexPath:indexPath];
    OpinionEntity * opinionEntity = self.dataArray[indexPath.section];
    listCell.selectionStyle = UITableViewCellSelectionStyleNone;
    listCell.indexPath = indexPath;
    listCell.delegate = self;
    listCell.opinionModel = opinionEntity;
    
    self.cellHeight = listCell.cellHeight;
    return listCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return self.cellHeight;
}
#pragma mark -- 公司详情
- (void)ReputationListCellCompanydetail:(CompanyReputationListCell *)listCell indexPath:(NSIndexPath *)indexPath{

    OpinionEntity * opinionEntity = self.dataArray[indexPath.section];
    OpinionCompanyDetailVC * companyDetailVC = [[OpinionCompanyDetailVC alloc] init];
    companyDetailVC.title = opinionEntity.Company.CompanyName;
    companyDetailVC.companyEntity = opinionEntity.Company;
    companyDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:companyDetailVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OpinionEntity * opinionEntity = self.dataArray[indexPath.row];
    UserCommentDetailVC * detailVC =[[UserCommentDetailVC alloc] init];
    detailVC.title = @"点评详情";
    detailVC.opinionEntity = opinionEntity;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark -- 搜索
- (void)seachViewDidClickedSeachBtn:(SeachView *)seachView{

    UserSeachCompanyVC * seachVC = [[UserSeachCompanyVC alloc] init];
    seachVC.hidesBottomBarWhenPushed = YES;
    seachVC.secondVC = self;
    [self.navigationController pushViewController:seachVC animated:YES];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
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


- (SeachView *)searchView{

    if (_searchView == nil) {
        _searchView = [SeachView seachView];
        _searchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        _searchView.delegate = self;
        [self.view addSubview:_searchView];
    }
    return _searchView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
