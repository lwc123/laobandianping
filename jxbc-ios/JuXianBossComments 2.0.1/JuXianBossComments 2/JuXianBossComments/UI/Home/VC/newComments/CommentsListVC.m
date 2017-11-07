//
//  CommentsListVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/7.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "CommentsListVC.h"
#import "WorkCommentsVC.h"
#import "DepartureListCell.h"
#import "CommentsDetail.h"
#import "SeachCommentVC.h"
@interface CommentsListVC ()<SeachViewDelegate>
@property (nonatomic,strong)NilView * nilView;
@property (nonatomic,strong)CompanyMembeEntity * bossInformation;
@property (nonatomic,copy)NSString * realName;
@property (nonatomic, assign) int pageIndex;
@property (nonatomic, assign) int size;
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)NSMutableArray *tmpArray;


@end

@implementation CommentsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阶段工作评价";
    [self isShowLeftButton:YES];
    [self isShowRightButton:YES with:@"添加"];
    [self initData];
    [self initUI];
    [self.jxTableView.mj_header beginRefreshing];
}

- (void)initData{
    
    _bossInformation = [UserAuthentication GetBossInformation];
    _dataArray = [NSArray array];
    self.tmpArray = @[].mutableCopy;
    self.pageIndex = 1;
    self.size = 20;
}

- (void)initUI{
    SeachView * searchView = [SeachView seachView];
    searchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    searchView.delegate = self;
    [self.view addSubview:searchView];
    
    self.jxTableView.frame = CGRectMake(0, CGRectGetMaxY(searchView.frame), SCREEN_WIDTH, SCREEN_HEIGHT -64 - 50);
    self.jxTableView.tableFooterView = [[UIView alloc] init];
    [self.jxTableView registerNib:[UINib nibWithNibName:@"DepartureListCell" bundle:nil] forCellReuseIdentifier:@"departureListCell"];
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    __weak typeof(self) weakSelf = self;
    //下拉
    [self.jxTableView setDragDownRefreshWith:^{
        weakSelf.pageIndex = 1;
        [weakSelf initRequest];
    }];
    //上啦
    [self.jxTableView setDragUpLoadMoreWith:^{
        [weakSelf initRequest];
    }];
    
}


-(void)initRequest{
    
    //0代表阶段评价 1 代表离任评价
    __weak typeof(self) weakSelf = self;
    [self showLoadingIndicator];
    
    [WorkbenchRequest getCommentSearchListWithCompanyId:_bossInformation.CompanyId commentType:0 name:_realName page:weakSelf.pageIndex size:weakSelf.size success:^(JSONModelArray *array) {
        [weakSelf dismissLoadingIndicator];
        //        Log(@"array===%@",array);
        
        if (array.count == 0) {
            [self.jxTableView endRefresh];
            if (_pageIndex == 1) {
                
                if (!_nilView) {
                    _nilView = [[NilView alloc] initWithFrame:self.view.bounds];
                    _nilView.labelStr = @"还没有阶段工作评价";
                    _nilView.isHiddenButton = NO;
                    UIButton * btn = [[UIButton alloc] init];
                    btn = [_nilView viewWithTag:2000];
                    [btn setTitle:@"添加阶段评价" forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                [weakSelf.jxTableView addSubview:_nilView];
                
                [weakSelf.jxTableView reloadData];
                
            }else{
                //                [PublicUseMethod showAlertView:@"添加阶段评价"];
            }
        }else{
            [_nilView removeFromSuperview];
            
            if (weakSelf.pageIndex == 1) {
                weakSelf.dataArray = @[];
            }
            
            weakSelf.pageIndex++;
            weakSelf.tmpArray = weakSelf.dataArray.mutableCopy;
            for (ArchiveCommentEntity *model in array) {
                if ([model isKindOfClass:[ArchiveCommentEntity class]]) {
                    [_tmpArray addObject:model];
                    
                }
            }
            _dataArray = _tmpArray.copy;
            [weakSelf.jxTableView endRefresh];
            [weakSelf.jxTableView reloadData];
            //            self.pageIndex++;
        }
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [weakSelf.jxTableView endRefresh];
        NSLog(@"error===%@",error);
        
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DepartureListCell * listCell = [tableView dequeueReusableCellWithIdentifier:@"departureListCell" forIndexPath:indexPath];
    ArchiveCommentEntity * model = _dataArray[indexPath.row];
    listCell.archiveModel = model;
    return listCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ArchiveCommentEntity * model = _dataArray[indexPath.row];
    
    CommentsDetail * commentsDetail = [[CommentsDetail alloc] init];
    commentsDetail.commentId = model.CommentId;
    commentsDetail.archiveId = model.ArchiveId;
    [self.navigationController pushViewController:commentsDetail animated:YES];
    
}
- (void)seachViewDidClickedSeachBtn:(SeachView *)seachView{
    
    SeachCommentVC * seachVC =[[SeachCommentVC alloc] init];
    [self.navigationController pushViewController:seachVC animated:YES];
}

- (void)rightButtonAction:(UIButton *)button{
    WorkCommentsVC * commentVC = [[WorkCommentsVC alloc] init];
    commentVC.title = @"添加点评";
    commentVC.companyId = self.companyId;
    [self.navigationController pushViewController:commentVC animated:YES];
}

#pragma  mark - 搜索按钮的点击事件
- (void)buttonAction:(UIButton*)button
{
    
    //    SearchViewController *searchVC = [[SearchViewController alloc]init];
    //    searchVC.hidesBottomBarWhenPushed = YES;
    //    [UIView animateWithDuration:.35 animations:^{
    //        [self.navigationController pushViewController:searchVC animated:YES];
    //    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
