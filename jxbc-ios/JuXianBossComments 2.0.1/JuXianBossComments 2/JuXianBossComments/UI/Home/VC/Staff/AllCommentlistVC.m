//
//  AllCommentlistVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/19.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "AllCommentlistVC.h"
#import "WorkCommentsVC.h"
#import "AddDepartureReportVC.h"

@interface AllCommentlistVC ()

@property (nonatomic,strong)NSArray * dataArray;
@property (nonatomic,strong)NSMutableArray * tempArray;
@property (nonatomic,strong)NSMutableArray * reportArray;
@property (nonatomic,strong)CompanyMembeEntity * bossMembe;
@property (nonatomic,strong)NilView * nilView;
@property (nonatomic,strong)EmployeArchiveEntity * employeEntity;



@end

@implementation AllCommentlistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"阶段工作评价";
    [self isShowLeftButton:YES];
    [self initData];
    [self initRequest];
    [self initUI];
    
}

- (void)initData{
    _bossMembe = [UserAuthentication GetBossInformation];
    _dataArray = [NSArray array];
    _tempArray = [NSMutableArray array];
    _reportArray = [NSMutableArray array];
    _employeEntity = [[EmployeArchiveEntity alloc] init];
}

- (void)initRequest{
    
    [WorkbenchRequest getAllArchiveCommentWithCompanyId:_bossMembe.CompanyId ArchiveId:_archiveId success:^(JSONModelArray *array) {
        
        NSLog(@"array===%@",array);
        if (array.count == 0) {
            [PublicUseMethod showAlertView:@"暂时没有评价"];
            if (!_nilView) {
                _nilView = [[NilView alloc] initWithFrame:self.view.bounds];
                _nilView.y = 44;
                _nilView.labelStr = @"还没有阶段工作评价";
                _nilView.isHiddenButton = YES;
            }
            [self.jxTableView addSubview:_nilView];
            [self.jxTableView reloadData];
            
        }else{
            for (ArchiveCommentEntity * commentModel in array) {
                if (commentModel.CommentType == 1) {
                    
                    [_reportArray addObject:commentModel];//离任
                    
                }else{
                    [_tempArray addObject:commentModel];//阶段
                }
            }
            _dataArray = _tempArray;
            [self.jxTableView reloadData];
        }

    } fail:^(NSError *error) {
        NSLog(@"error===%@",error);

    }];

}

- (void)initUI{

    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    self.jxTableView.tableFooterView = [[UIView alloc] init];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        
        return _dataArray.count;
    }else{
        return _reportArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        
        UILabel * label = [UILabel labelWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 44) title:@"" titleColor:[PublicUseMethod setColor:KColor_BackgroundColor] fontSize:15.0 numberOfLines:1];
        label.text = [NSString stringWithFormat:@"   选择%@的评价/离任报告修改",_nameStr];
        label.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
        return label;
    }else{
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * cellId = @"myCellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0) {
        ArchiveCommentEntity * commentModel= _dataArray[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@评价",commentModel.StageYear,commentModel.StageSectionText];
        
    }else{
        cell.textLabel.text = @"离任报告";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {//都是阶段工作评价
        ArchiveCommentEntity * commentModel= _dataArray[indexPath.row];
        [self initRecodeDetailWith:commentModel];
    }else{//离任
        ArchiveCommentEntity * commentModel= _reportArray[indexPath.row];
        [self initRecodeWith:commentModel];
    }
}


- (void)initRecodeDetailWith:(ArchiveCommentEntity *)commentModel{
    [self showLoadingIndicator];
    [WorkbenchRequest getArchiveDetailWithCompanyId:_bossMembe.CompanyId ArchiveID:self.archiveId success:^(EmployeArchiveEntity *archiveEntity) {
        [self dismissLoadingIndicator];
        
        if (archiveEntity) {
            _employeEntity =archiveEntity;
            WorkCommentsVC * commentsVC = [[WorkCommentsVC alloc] init];
            commentsVC.title = @"修改阶段评价";
            commentModel.EmployeArchive = _employeEntity;
            commentsVC.detailComment = commentModel;
            [self.navigationController pushViewController:commentsVC animated:YES];
        }
    } fail:^(NSError *error) {
        [self dismissLoadingIndicator];
    }];
}


- (void)initRecodeWith:(ArchiveCommentEntity *)commentModel{
    [self showLoadingIndicator];
    [WorkbenchRequest getArchiveDetailWithCompanyId:_bossMembe.CompanyId ArchiveID:self.archiveId success:^(EmployeArchiveEntity *archiveEntity) {
        [self dismissLoadingIndicator];
        
        if (archiveEntity) {
            _employeEntity =archiveEntity;
            AddDepartureReportVC * reportVC = [[AddDepartureReportVC alloc] init];
            commentModel.EmployeArchive = _employeEntity;
            reportVC.detaiComment = commentModel;
            reportVC.title = @"修改离任报告";
            [self.navigationController pushViewController:reportVC animated:YES];
        }
    } fail:^(NSError *error) {
        [self dismissLoadingIndicator];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
