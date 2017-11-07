//
//  MyArchiveList.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/20.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "MyArchiveList.h"
#import "NilView.h"
#import "JHNilView.h"
#import "ArchiveListCell.h"
#import "JXBindIDCardVC.h"
#import "UserOpenVipVC.h"
#import "UserArchiveDetailVC.h"
#import "EmployeArchiveEntity.h"
@interface MyArchiveList ()

@property (nonatomic,strong)NilView * nilView;
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)NSMutableArray *tmpArray;
@property (nonatomic,copy)NSString * iDCard;
@property (nonatomic,assign)long count;
@property (nonatomic,strong)PrivatenessServiceContract * contract;


@end

@implementation MyArchiveList

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self initRequestCon];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的档案";
    [self isShowLeftButton:YES];
    [self initData];
    [self initRequest];
    [self initUI];
}

- (void)initData{
    _contract = [UserAuthentication getUserContract];
    _tmpArray = [NSMutableArray array];
}

- (void)initRequestCon{
    
    [UserWorkbenchRequest getPrivatenessSummaryWithSuccess:^(PrivatenessSummaryEntity *summaryEntity) {
        NSLog(@"summaryEntity===%@",summaryEntity);
        
        [UserAuthentication saveUserContract:summaryEntity.PrivatenessServiceContract];
//        _contract = summaryEntity;
        _contract = [UserAuthentication getUserContract];

    } fail:^(NSError *error) {
        NSLog(@"error===%@",error);
    }];
    
}

- (void)initRequest{
    [self showLoadingIndicator];
    _dataArray = [NSArray array];
    [UserWorkbenchRequest getPrivatenessmyArchivesWithSuccess:^(JSONModelArray *array) {
        [self dismissLoadingIndicator];
        NSLog(@"array===%@",array);
        if (array.count == 0) {
            [self.jxTableView endRefresh];
            if (!_nilView) {
                _nilView = [[NilView alloc] initWithFrame:self.view.bounds];
                _nilView.labelStr = @"还没有阶段工作评价";
                _nilView.isHiddenButton = YES;
            }
            [self.jxTableView addSubview:_nilView];
            [self.jxTableView reloadData];
                
        }else{
            [_nilView removeFromSuperview];
            
            
            for (EmployeArchiveEntity *model in array) {
                [_tmpArray addObject:model];
                _iDCard = model.IDCard;
            }
            _dataArray = _tmpArray;
            _count = _dataArray.count;
            [self.jxTableView reloadData];
        }
    } fail:^(NSError *error) {
        [self dismissLoadingIndicator];
        NSLog(@"error===%@",error);
    }];
}


- (void)initUI{
    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_HEIGHT - 64);
    self.jxTableView.tableFooterView = [[UIView alloc] init];
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    [self.jxTableView registerNib:[UINib nibWithNibName:@"ArchiveListCell" bundle:nil] forCellReuseIdentifier:@"archiveListCell"];
    [self.jxTableView registerNib:[UINib nibWithNibName:@"ArchiveListCell" bundle:nil] forCellReuseIdentifier:@"oneCell"];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) return 1;
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{    
    if (indexPath.section == 0) {
            ArchiveListCell * idCell = [tableView dequeueReusableCellWithIdentifier:@"oneCell" forIndexPath:indexPath];
        if (_dataArray.count!=0) {
            EmployeArchiveEntity * myArchives = _dataArray[indexPath.row];
            idCell.companyNameLabel.text = [NSString stringWithFormat:@"发现您的%lu份工作档案",(unsigned long)_dataArray.count];
            idCell.messageLabel.textColor = [UIColor redColor];
            idCell.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
            idCell.messageLabel.text = [NSString stringWithFormat:@"身份证号：%@",myArchives.IDCard];
        }else{
            idCell.companyNameLabel.text = [NSString stringWithFormat:@"发现您的%lu份工作档案",(unsigned long)_dataArray.count];
            idCell.messageLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
            idCell.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
            idCell.messageLabel.text = [NSString stringWithFormat:@"身份证号："];
        }
        return idCell;
        
    }else{
        ArchiveListCell * listCell = [tableView dequeueReusableCellWithIdentifier:@"archiveListCell" forIndexPath:indexPath];
        
        EmployeArchiveEntity * myArchives = _dataArray[indexPath.row];
        listCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        listCell.myArchives = myArchives;
        return listCell;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
    }else{//
        EmployeArchiveEntity * myArchives = _dataArray[indexPath.row];
        //先判断有没有开户
        if ([self.contract.ContractStatus integerValue] == 2 ) {//开户了
            UserArchiveDetailVC * detailVC = [[UserArchiveDetailVC alloc] init];
            detailVC.archiveId = myArchives.ArchiveId;
            [self.navigationController pushViewController:detailVC animated:YES];
        }else{//没有开户
            UserOpenVipVC * openVC = [[UserOpenVipVC alloc] init];
            openVC.idCardFieldStr = myArchives.IDCard;
            [self.navigationController pushViewController:openVC animated:YES];
        }
    }
}

- (void)leftButtonAction:(UIButton *)button{
    
    [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
