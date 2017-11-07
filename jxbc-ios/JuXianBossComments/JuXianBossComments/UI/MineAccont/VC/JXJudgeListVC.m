//
//  JXJudgeListVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/28.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXJudgeListVC.h"
#import "JudgeCell.h"
#import "WorkCommentsVC.h"
#import "JXCheckDetailVC.h"
#import "BossCommentTabBarCtr.h"
#import "AddDepartureReportVC.h"

//阶段评价列表
#import "CommentsListVC.h"
#import "ReportListVC.h"//离任报告

@interface JXJudgeListVC ()<judgeCellDelegate>


@property (nonatomic,strong)CompanyMembeEntity *membeEntity;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)NSMutableArray *temArray;
@property(nonatomic,strong)CompanyMembeEntity *myAccount;
@property(nonatomic,assign)long page;
@property(nonatomic,assign)long size;

@property (nonatomic, strong) UIView *popListView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *sanjiao;
@property (nonatomic, strong) NSArray *popTitleArray;
@property (nonatomic, strong) NilView *nilview;
@property (nonatomic,strong)ArchiveCommentEntity * commentEntity;

@end

@implementation JXJudgeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的评价";
    self.size = 20;
    self.page = 1;
    
    // 下拉刷新
    MJWeakSelf
    [self.jxCollectionView setDragDownRefreshWith:^{
        // 更新数据
        weakSelf.page = 1;
        [weakSelf initRequest:weakSelf.auditStatus];
    }];
    
    // 上拉加载更多
    [self.jxCollectionView setDragUpLoadMoreWith:^{
        [weakSelf initRequest:weakSelf.auditStatus];
    }];
    
    [self isShowRightButton:YES withImg:[UIImage imageNamed:@"筛选"]];
    [self isShowLeftButton:YES];    
    [self initData];
    [self initUI];
}
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    MJWeakSelf
    // 更新数据
    weakSelf.page = 1;
    [weakSelf initRequest:weakSelf.auditStatus];

}

#pragma mark - init

- (void)initData{
    _membeEntity = [UserAuthentication GetBossInformation];
    _dataArray = [NSArray array];
    _temArray = [NSMutableArray array];
    _myAccount = [UserAuthentication GetMyInformation];
    _commentEntity = [[ArchiveCommentEntity alloc] init];

}

-(void)initRequest:(NSInteger)auditStatus{
    
    MJWeakSelf
    [MineRequest getCompanyMemberListCompanyId:_membeEntity.CompanyId andAuditStatus:auditStatus andPage:weakSelf.page andSize:weakSelf.size success:^(JSONModelArray *array) {
        [weakSelf.jxCollectionView setEndRefresh];

        Log(@"array===%ld",array.count);
        
        [weakSelf dismissLoadingIndicator];
        
        // 没数据显示空视图
        if (array.count == 0 && weakSelf.page == 1) {
            weakSelf.dataArray = @[].mutableCopy;
            [weakSelf.jxCollectionView reloadData];
            [weakSelf.jxCollectionView addSubview:weakSelf.nilview];
            return ;
        }
     
        // 保存数据
        if (array.count != 0) {
            
            [weakSelf.nilview removeFromSuperview];
            
            if (weakSelf.page == 1) {
                weakSelf.dataArray = @[];
            }
            weakSelf.page++;
            weakSelf.temArray = weakSelf.dataArray.mutableCopy;
            for (ArchiveCommentEntity *archiveModel in array) {
                [_temArray addObject:archiveModel];
            }
            _dataArray = _temArray.copy;
            [weakSelf.jxCollectionView reloadData];
        }
        
    } fail:^(NSError *error) {
        [weakSelf.jxCollectionView setEndRefresh];

        [weakSelf dismissLoadingIndicator];
        Log(@"%@",error);
    }];
}

- (void)initUI{
    
    self.layout.itemSize = CGSizeMake(SCREEN_WIDTH, 160);
    self.layout.minimumInteritemSpacing = 10;
    self.jxCollectionView.frame = CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 10);
    self.jxCollectionView.collectionViewLayout = self.layout;
    self.jxCollectionView.delegate = self;
    self.jxCollectionView.dataSource = self;
    [self.jxCollectionView registerNib:[UINib nibWithNibName:@"JudgeCell" bundle:nil] forCellWithReuseIdentifier:@"judgeCell"];
    
}

#pragma mark - collectionView datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JudgeCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"judgeCell" forIndexPath:indexPath];
    ArchiveCommentEntity *archiveModel = _dataArray[indexPath.row];
    cell.indexPath = indexPath;
    
    if (!archiveModel.RejectReason) {
        cell.lineView.hidden = YES;
        cell.resonLabel.hidden = YES;
    }else{
        cell.lineView.hidden = NO;
        cell.resonLabel.hidden = NO;
    }
    cell.archiveModel = archiveModel;
    cell.delegate = self;
    return cell;
}

#pragma mark - collectionView delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArchiveCommentEntity *archiveModel = _dataArray[indexPath.row];

    JudgeCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"JudgeCell" owner:self options:nil] lastObject];
    cell.archiveModel = archiveModel;
    if (archiveModel.RejectReason && archiveModel.AuditStatus == 9) {
        return CGSizeMake(SCREEN_WIDTH,cell.itemHeight);

    }else{
        return CGSizeMake(SCREEN_WIDTH,72);
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
}

- (void)judgeCellDelegateWithCheckBtn:(NSIndexPath *)indexPath WithCell:(JudgeCell *)judgeCell{

    ArchiveCommentEntity *archiveModel = _dataArray[indexPath.row];
    
    if (archiveModel.AuditStatus == 9) {//重新提交
        
        if (archiveModel.PresenterId != _myAccount.PassportId) {//代表是审核人  被拒绝的审核人可以直接查看
            JXCheckDetailVC * checkVC = [[JXCheckDetailVC alloc] init];
            checkVC.commentEntity = archiveModel;
            [self.navigationController pushViewController:checkVC animated:YES];
        }else{
            
            MJWeakSelf
            [self showLoadingIndicator];
            [WorkbenchRequest getCommentDetailWithCompanyId:archiveModel.CompanyId CommentId:archiveModel.CommentId success:^(ArchiveCommentEntity *commentEntity) {
                
                [weakSelf dismissLoadingIndicator];
                _commentEntity = commentEntity;
                [self jumbWith:_commentEntity];
                
            } fail:^(NSError *error) {
                [weakSelf dismissLoadingIndicator];
                [PublicUseMethod showAlertView:@"网络正忙"];
            }];
        }

    }else{
        JXCheckDetailVC * checkVC = [[JXCheckDetailVC alloc] init];
        checkVC.commentEntity = archiveModel;
        [self.navigationController pushViewController:checkVC animated:YES];
    }
}



#pragma mark -- 重新提交 判断跳阶段评价还是离任
- (void)jumbWith:(ArchiveCommentEntity *)archiveModel{
    
    if (archiveModel.CommentType == 0){
        WorkCommentsVC *commentsVC = [[WorkCommentsVC alloc]init];
        //取到对应位置的模型
        commentsVC.detailComment = archiveModel;
        commentsVC.title = @"修改阶段评价";
        commentsVC.secondVC = self;
//        commentsVC.archiveId = archiveModel.ArchiveId;
        [self.navigationController pushViewController:commentsVC animated:YES];
    }else if (archiveModel.CommentType == 1){//离任评价
        
        AddDepartureReportVC * addVC = [[AddDepartureReportVC alloc] init];
        addVC.title = @"修改离任报告";
        addVC.detaiComment = archiveModel;
        [self.navigationController pushViewController:addVC animated:YES];
    }
}



#pragma mark - function
- (void)leftButtonAction:(UIButton *)button{
    
    if (self.isQuickLogin == YES) {
        
        BossCommentTabBarCtr * tabBar = [[BossCommentTabBarCtr alloc] init];
        tabBar.selectedIndex = 2;
        [PublicUseMethod changeRootViewController:tabBar];
    }else{
        
        if ([self.navigationController.viewControllers[1] isKindOfClass:[CommentsListVC class]]) {
            
            CommentsListVC *listVC = self.navigationController.viewControllers[1];
            [listVC.jxTableView.mj_header beginRefreshing];
            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
            
        }else if([self.navigationController.viewControllers[1] isKindOfClass:[ReportListVC class]]){
            ReportListVC *listVC = self.navigationController.viewControllers[1];
            [listVC.jxTableView.mj_header beginRefreshing];
            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
        }else{
        
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.navigationController.viewControllers[1] isKindOfClass:[CommentsListVC class]] || [self.navigationController.viewControllers[1] isKindOfClass:[ReportListVC class]]) {
        if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //在其他离开改页面的方法同样加上下面代码
    
    if ([self.navigationController.viewControllers[1] isKindOfClass:[CommentsListVC class]] || [self.navigationController.viewControllers[1] isKindOfClass:[ReportListVC class]]) {
        if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}

- (void)ImgButtonAction:(UIButton *)btn{
        // 弹出视图
    [self.navigationController.view addSubview:self.maskView];
    [self.navigationController.view addSubview:self.popListView];
    [self.navigationController.view addSubview:self.sanjiao];
}

- (void)tapAvatarAction:(UITapGestureRecognizer*)myTap{
    [self.maskView removeFromSuperview];
    [self.popListView removeFromSuperview];
    [self.sanjiao removeFromSuperview];
}

- (void)popListButtonClick:(UIButton *) sender{
    
    //  审核中
    if ([sender.currentTitle isEqualToString:@"全部"]) {
        self.auditStatus = 0;
    }else if ([sender.currentTitle isEqualToString:@"审核中"]) {
        self.auditStatus = 1;
        
    }else if ([sender.currentTitle isEqualToString:@"审核通过"]) {
        self.auditStatus = 2;
        
    }else if ([sender.currentTitle isEqualToString:@"审核未通过"]) {
        self.auditStatus = 9;
        
    }
    
    [self tapAvatarAction:nil];
    
    // 更新数据
    self.page = 1;
    [self initRequest:self.auditStatus];

}

#pragma mark - lazy load

- (NSArray *)popTitleArray{
    
    if (_popTitleArray == nil) {
        _popTitleArray = @[@"全部",@"审核中",@"审核通过",@"审核未通过"];
    }
    return _popTitleArray;
}

- (UIView *)popListView{
    
    if (_popListView == nil) {
        _popListView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth - 100 - 8, 64+8, 100, 44 * self.popTitleArray.count)];
        _popListView.alpha = 0.75;
        _popListView.layer.cornerRadius = 5;
        _popListView.backgroundColor = [UIColor blackColor];
        _popListView.clipsToBounds = YES;
        
        for (NSInteger i = 0;i < self.popTitleArray.count; i++) {
            // 按钮
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, i * 44 , _popListView.width, 43)];
            btn.backgroundColor = _popListView.backgroundColor;
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitle:self.popTitleArray[i] forState:UIControlStateNormal];
            [btn setTitle:self.popTitleArray[i] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(popListButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_popListView addSubview:btn];
            
            //分割线
            if (i != self.popTitleArray.count - 1 ) {
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(8, 43 , _popListView.width - 16, 0.5)];
                line.backgroundColor = [UIColor lightGrayColor];
                [btn addSubview:line];
            }
        }
    }
    return _popListView;
}

- (UIView *)maskView{

    if (_maskView == nil) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha= .5;
        _maskView.userInteractionEnabled = YES;
        [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarAction:)]];
    }
    return _maskView;
}

- (UIImageView *)sanjiao{

    if (_sanjiao == nil) {
        _sanjiao = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sanjiao"]];
        _sanjiao.frame = CGRectMake(ScreenWidth-40, 64, 11, 8);
        [self.navigationController.view addSubview:_sanjiao];

    }
    return _sanjiao;
    
}
- (NilView *)nilview{
    
    if (_nilview == nil) {
        _nilview = [[NilView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 300)];
        _nilview.labelStr = @"主人，还没有评价过哦！";
        _nilview.isHiddenButton = YES;
    }
    return _nilview;
}




@end
