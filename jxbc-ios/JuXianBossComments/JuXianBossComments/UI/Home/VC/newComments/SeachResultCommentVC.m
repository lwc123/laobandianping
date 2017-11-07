//
//  SeachResultCommentVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/17.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "SeachResultCommentVC.h"
#import "DepartureListCell.h"
#import "SeachCommentVC.h"
#import "CommentsDetail.h"
#import "WorkCommentsVC.h"
@interface SeachResultCommentVC ()<SeachViewDelegate>
@property (nonatomic,strong)NilView * nilView;
@property (nonatomic,strong)CompanyMembeEntity * bossInformation;
@property (nonatomic, assign)int pageIndex;
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)NSMutableArray *tmpArray;
@end

@implementation SeachResultCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阶段工作评价";
    [self isShowLeftButton:YES];
    [self initData];
    [self initUI];
    [self.jxTableView.mj_header beginRefreshing];
}


- (void)initData{
    
    _bossInformation = [UserAuthentication GetBossInformation];
    _dataArray = [NSArray array];
    _tmpArray = [NSMutableArray array];
}

- (void)initUI{
    SeachView * searchView = [SeachView seachView];
    
    searchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    searchView.delegate = self;
    searchView.placehoderText.text = self.realName;
    [self.view addSubview:searchView];
    
    self.jxTableView.frame = CGRectMake(0, CGRectGetMaxY(searchView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - 30 - 10);
    self.jxTableView.tableFooterView = [[UIView alloc] init];
    [self.jxTableView registerNib:[UINib nibWithNibName:@"DepartureListCell" bundle:nil] forCellReuseIdentifier:@"departureListCell"];
    
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
    [WorkbenchRequest getCommentSearchListWithCompanyId:_bossInformation.CompanyId commentType:0 name:_realName page:1 size:10 success:^(JSONModelArray *array) {
        [weakSelf dismissLoadingIndicator];
        NSLog(@"array===%@",array);
        
        if (array.count == 0) {
            [self.jxTableView endRefresh];
            if (_pageIndex == 1) {
                
                if (!_nilView) {
                    _nilView = [[NilView alloc] initWithFrame:self.view.bounds];
                    _nilView.labelStr = @"没有员工的阶段工作评价";
                    _nilView.isHiddenButton = YES;

                }
                [self.jxTableView addSubview:_nilView];
                [self.jxTableView reloadData];                
            }else{
                [PublicUseMethod showAlertView:@"添加阶段评价"];
            }
        }else{
            [_nilView removeFromSuperview];
            for (ArchiveCommentEntity *model in array) {
                [_tmpArray addObject:model];
            }
            _dataArray = _tmpArray;
            [self.jxTableView endRefresh];
            [self.jxTableView reloadData];
            self.pageIndex++;
        }
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [self.jxTableView endRefresh];
        [PublicUseMethod showAlertView:error.localizedDescription];
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
    [self.navigationController pushViewController:commentsDetail animated:YES];
}
- (void)seachViewDidClickedSeachBtn:(SeachView *)seachView{
    
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

- (void)leftButtonAction:(UIButton *)button{
    
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end