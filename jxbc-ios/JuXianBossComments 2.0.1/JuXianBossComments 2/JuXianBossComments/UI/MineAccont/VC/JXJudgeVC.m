//
//  JXJudgeVC.m
//  JuXianBossComments
//
//  Created by CZX on 16/12/14.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXJudgeVC.h"
#import "JudgePassCell.h"
#import "JXCheckVC.h"
#import "JudgeBackCell.h"
#import "JudgeCheckingCell.h"
#import "dropViewVC.h"
#import "CompanyMembeEntity.h"
#import "UserAuthentication.h"
#import "JXNewView.h"
#import <MJRefresh.h>
#import "MineRequest.h"
#import "dropViewCell.h"
#import "WorkCommentsVC.h"

static NSString *rightItemCell = @"rightItemCell";
static NSString *cellID = @"cellID";
@interface JXJudgeVC ()<UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>

@property(nonatomic,strong)dropViewVC *dropVC;
@property(nonatomic,strong)UITableView *rigthNavItemDropTableView;
@property(nonatomic,strong)CompanyMembeEntity *myAccount;
@property(nonatomic,assign)NSInteger compID;

//蒙版
@property(nonatomic,strong)UIView *moView;
@property(nonatomic,assign)BOOL isAppearMoView;
@property(nonatomic,strong)NSArray *dropDataArray;
@property(nonatomic,strong)UITableView *popTableView;
@property(nonatomic,assign)NSInteger tag;
@property(nonatomic,assign)NSInteger flag;
@property(nonatomic,strong)JXNewView *aview;
//请求的page参数， 即当前的页码
@property(nonatomic,assign)NSInteger page;
//请求的数据
@property(nonatomic,strong)NSMutableArray *Marray;
@property (nonatomic,strong)CompanyMembeEntity *membeEntity;
@property(nonatomic,assign)NSInteger auditStatus;
@property(nonatomic,strong)UITableView *dropTableView;
@property(nonatomic,strong)ArchiveCommentEntity *archiveModel;
@property (nonatomic,assign)CGFloat itemHeight;

@end

@implementation JXJudgeVC



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价列表";
    [self isShowLeftButton:YES];
    [self isShowRightButton:YES withImg:[UIImage imageNamed:@"detail"]];
    [self initData];
    [self setupUI];
    [self initRequest:_auditStatus];
}

- (void)initData{
    self.flag = 1;
    self.isAppearMoView = YES;
    self.dropDataArray = @[@"所有",@"审核中",@"审核通过",@"审核未通过"];
    _auditStatus = 0;
    //初始化page参数
    self.page = 1;
    self.compID = [UserAuthentication GetMyInformation].CompanyId;
}
-(void)setupUI
{
    JXTableView *tableView = [[JXTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.jxTableView = tableView;
    //注册
    [self.jxTableView registerNib:[UINib nibWithNibName:@"JudgePassCell" bundle:nil] forCellReuseIdentifier:@"passCell"];
    [self.jxTableView registerNib:[UINib nibWithNibName:@"JudgeBackCell" bundle:nil] forCellReuseIdentifier:@"againCell"];
    [self.jxTableView registerNib:[UINib nibWithNibName:@"JudgeCheckingCell" bundle:nil] forCellReuseIdentifier:@"checkingCell"];
    //数据源
    self.jxTableView.dataSource = self;
    self.jxTableView.delegate = self;
    
    //行高
    self.jxTableView.rowHeight = UITableViewAutomaticDimension;

    
}


-(void)loadData:(NSInteger)page
{
    self.Marray = [NSMutableArray array];
    [MineRequest getCompanyMemberListCompanyId:self.compID andAuditStatus:_auditStatus andPage:self.page andSize:50 success:^(JSONModelArray *array) {
        NSLog(@"%ld",array.count);
        [self dismissLoadingIndicator];
        if (array.count == 0) {
        }else
        {
            for (ArchiveCommentEntity *archiveModel in array)
            {
                [self.Marray addObject:archiveModel];
            }
            [self.jxTableView endRefresh];
            [self.jxTableView reloadData];
        }
    } fail:^(NSError *error) {
        [self dismissLoadingIndicator];
        [self.jxTableView endRefresh];
        NSLog(@"%@",error);
    }];
    
}

//设置组间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 1000) {
        return .01;
    }
        return 10;
}

//手势
-(void)TapGesture:(UITapGestureRecognizer *)sender
{
    self.isAppearMoView = YES;
    [self.moView removeFromSuperview];
    [self.rigthNavItemDropTableView removeFromSuperview];
}


- (void)ImgButtonAction:(UIButton *)btn{
    
    
    NSLog(@"弹一个view");
    if (self.isAppearMoView) {
        UIView *moView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT)];
        moView.backgroundColor = [UIColor blackColor];
        moView.alpha = .5;
        moView.userInteractionEnabled = YES;
        [self.view addSubview:moView];
        self.moView = moView;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapGesture:)];
        [moView addGestureRecognizer:tap];
        UITableView *dropTableView = [[UITableView alloc]initWithFrame:CGRectMake(220, 10, 170, 170) style:UITableViewStylePlain];
        self.rigthNavItemDropTableView = dropTableView;
        //用tag来区分是哪一个tableview
        dropTableView.tag = 1000;
        dropTableView.scrollEnabled = false;
        [self.view addSubview:dropTableView];
        
        dropTableView.dataSource = self;
        dropTableView.delegate = self;
        
        [dropTableView registerClass:[dropViewCell class] forCellReuseIdentifier:rightItemCell];
        [dropTableView registerNib:[UINib nibWithNibName:@"dropViewCell" bundle:nil] forCellReuseIdentifier:@"dropViewCellID"];
        self.flag = 0;
        self.isAppearMoView = NO;
    }else{
        [self.rigthNavItemDropTableView removeFromSuperview];
        [self.moView removeFromSuperview];
        self.isAppearMoView = YES;
    }
}

#pragma mark - uitableViewDatasorse
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 1000) {
        return 1;
    }
    return self.Marray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView.tag == 1000) {
        return 4;
    }
    NSLog(@"%ld",self.Marray.count);
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView.tag ==1000) {
        return 0.01;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ArchiveCommentEntity *archiveModel = self.Marray[indexPath.section];

    if (archiveModel.AuditStatus == 9) {
        return _itemHeight;
    }
    return 100;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == 1000) {
       dropViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dropViewCellID" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor colorWithRed:47/256.0 green:48/256.0 blue:52/256.0 alpha:0.5];
        NSString *str = (NSString *)self.dropDataArray[indexPath.row];
        cell.textLabel.text = str;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.backgroundColor = [UIColor colorWithRed:47/256.0 green:48/256.0 blue:52/256.0 alpha:0.5];
        cell.tag = indexPath.row;
        return cell;
    }
    //取到对应位置的模型
    ArchiveCommentEntity *archiveModel = self.Marray[indexPath.section];
    //判断要显示的cell类型
    //如果当前条目的ID和当前用户的ID相同，那么就是提交人
        if (archiveModel.PresenterId == self.myAccount.PassportId)
        {
            //审核中
            if (archiveModel.AuditStatus == 1) {
                JudgeCheckingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"checkingCell" forIndexPath:indexPath];
                cell.archiveModel = archiveModel;
                cell.cheakingClickBtn.tag = indexPath.section;

                [cell.cheakingClickBtn addTarget:self action:@selector(checkingClick:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }else if (archiveModel.AuditStatus == 2)
            {
                //已经审核
                JudgePassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"passCell" forIndexPath:indexPath];
                [cell.cheakBtn addTarget:self action:@selector(checkClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.cheakBtn.tag = indexPath.section;
                cell.archiveModel = archiveModel;
                return cell;
            }else {
                //审核不通过
                JudgeBackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"againCell" forIndexPath:indexPath];
                
                cell.archiveModel = archiveModel;
                self.itemHeight = cell.itemHeight;
                [cell.subAgain addTarget:self action:@selector(subAgainClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.subAgain.tag = indexPath.section;
                return cell;
            }
            
        }else{
            //审核人
            //审核中
            if (archiveModel.AuditStatus == 1) {
                JudgeCheckingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"checkingCell" forIndexPath:indexPath];
                cell.archiveModel = archiveModel;
                
                cell.cheakingClickBtn.tag = indexPath.section;
                [cell.cheakingClickBtn addTarget:self action:@selector(checkingClick:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }else if (archiveModel.AuditStatus == 2)
            {
                //已经审核
                JudgePassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"passCell" forIndexPath:indexPath];
                cell.archiveModel = archiveModel;
                cell.cheakBtn.tag = indexPath.section;
                [cell.cheakBtn addTarget:self action:@selector(checkClick:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }else{
                //审核不通过
                JudgeBackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"againCell" forIndexPath:indexPath];
                cell.archiveModel = archiveModel;
                self.itemHeight = cell.itemHeight;
                [cell.subAgain setTitle:@"重新提交" forState:UIControlStateNormal];
                [cell.subAgain addTarget:self action:@selector(subAgainClick:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
        }
    
    
    
    
}

#pragma mark - 按钮点击
-(void)checkClick:(UIButton *)sender
{
    JXCheckVC *vc = [[JXCheckVC alloc]init];
    //取到对应位置的模型
    ArchiveCommentEntity *archiveModel = self.Marray[sender.tag];
    vc.myBlock = ^(id result){
        for (ArchiveCommentEntity *archiveModel in result) {
            [self.Marray addObject:archiveModel];
        }
        [self.jxTableView reloadData];
    };
    NSLog(@"%ld",archiveModel.CommentId);
    vc.ArchiveModel = archiveModel;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)subAgainClick:(UIButton *)sender
{
    WorkCommentsVC *vc = [[WorkCommentsVC alloc]init];
    //取到对应位置的模型
    ArchiveCommentEntity *archiveModel = self.Marray[sender.tag];
    vc.detailComment = archiveModel;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)checkingClick:(UIButton *)sender
{
    JXCheckVC *vc = [[JXCheckVC alloc]init];
    ArchiveCommentEntity *archiveModel = self.Marray[sender.tag];
    vc.ArchiveModel = archiveModel;
    vc.commentId = archiveModel.CommentId;
    vc.commentType = archiveModel.CommentType;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dropViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.tag = cell.tag;
    if (tableView.tag == 1000 ) {
        switch (cell.tag) {
            case 0:
                //[self.Marray removeAllObjects];
                _auditStatus = 0;
                NSLog(@"0");
                [self.rigthNavItemDropTableView removeFromSuperview];
                [self.moView removeFromSuperview];
                self.isAppearMoView = YES;
                [self initRequest:0];
                break;
            case 1:
                //[self.Marray removeAllObjects];
                //self.num = 1;
                NSLog(@"1");
                [self initRequest:1];
                [self.rigthNavItemDropTableView removeFromSuperview];
                [self.moView removeFromSuperview];
                self.isAppearMoView = YES;
                break;
            case 2:
                [self.moView removeFromSuperview];
                [self.Marray removeAllObjects];
                NSLog(@"2");
                _auditStatus = 2;
                [self initRequest:2];
                [self.rigthNavItemDropTableView removeFromSuperview];
                [self.moView removeFromSuperview];
                self.isAppearMoView = YES;
                break;
            default:
                //[self.Marray removeAllObjects];
                _auditStatus = 9;
                NSLog(@"3");
                [self initRequest:9];
                [self.rigthNavItemDropTableView removeFromSuperview];
                [self.moView removeFromSuperview];
                self.isAppearMoView = YES;
                break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)initRequest:(NSInteger)auditStatus
{
    NSMutableArray *dataArray = [NSMutableArray array];
    [MineRequest getCompanyMemberListCompanyId:self.compID andAuditStatus:auditStatus andPage:1 andSize:50 success:^(JSONModelArray *array) {
        NSLog(@"%ld",array.count);
        for (ArchiveCommentEntity *archiveModel in array) {
            NSLog(@"%@",archiveModel);
            if (archiveModel != nil) {
                [dataArray addObject:archiveModel];
            }
        }
            if (_Marray) {
                [_Marray removeAllObjects];
            }
        _Marray = dataArray;
        [self.jxTableView reloadData];
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
