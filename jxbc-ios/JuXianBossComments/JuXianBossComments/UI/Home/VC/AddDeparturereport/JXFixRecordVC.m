//
//  JXFixRecordVC.m
//  JuXianBossComments
//
//  Created by juxian on 2017/2/9.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JXFixRecordVC.h"
#import "TextfieldCell.h"
#import "ArchiveCommentLogEntity.h"
#import "NilView.h"

@interface JXFixRecordVC ()
@property (nonatomic,strong)CompanyMembeEntity *membeEntity;
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)NSMutableArray *tmpArray;
@property (nonatomic,strong)NilView * nilView;
@property (nonatomic, strong) UITextField *mytexyF;


@end

@implementation JXFixRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改记录";
    [self isShowLeftButton:YES];
    [self initData];
    [self initRequest];
    [self initUI];
}

- (void)initData{
    _membeEntity = [UserAuthentication GetBossInformation];
}

- (NSArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)tmpArray{
    if (_tmpArray == nil) {
        _tmpArray = [[NSMutableArray alloc] init];
    }
    return _tmpArray;
}

- (void)initRequest{

    MJWeakSelf
    [self showLoadingIndicator];
    [WorkbenchRequest getlogListWithCompanyId:_membeEntity.CompanyId commentId:_commentId success:^(JSONModelArray *array) {
        [weakSelf dismissLoadingIndicator];        
        if (array.count == 0) {
            [self.jxTableView endRefresh];
            
            if (!_nilView) {
                _nilView = [[NilView alloc] initWithFrame:self.view.bounds];
                _nilView.labelStr = @"还没有修改记录";
                _nilView.isHiddenButton = YES;
                [self.jxTableView addSubview:_nilView];
                [self.jxTableView reloadData];
            }else{
            }
        }else{
            [_nilView removeFromSuperview];
            for (ArchiveCommentLogEntity *model in array) {
                [weakSelf.tmpArray addObject:model];
            }
            weakSelf.dataArray = weakSelf.tmpArray.copy;
            [self.jxTableView endRefresh];
            [self.jxTableView reloadData];
        }
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
}

- (void)initUI{

    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"cellId";
    UITableViewCell * myCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!myCell) {
        
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        _mytexyF = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 180, 0, 180, 44)];
        _mytexyF.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
        _mytexyF.font = [UIFont systemFontOfSize:15.0];
        _mytexyF.userInteractionEnabled = NO;
        [myCell.contentView addSubview:_mytexyF];
    }
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    myCell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
    myCell.textLabel.font = [UIFont systemFontOfSize:15.0];
    
    ArchiveCommentLogEntity * commentLog = self.dataArray[indexPath.row];
    NSString * role ;
    if (commentLog.CompanyMember.Role == Role_Boss) {
        role = @"老板";
    }else if (commentLog.CompanyMember.Role == Role_manager){
        role = @"管理员";
    }else if (commentLog.CompanyMember.Role == Role_BuildMembers){
        role = @"建档员";
    }else{
        role = @"高管";
    }
    
    myCell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",commentLog.CompanyMember.RealName,role];
    _mytexyF.text = [NSString stringWithFormat:@"修改于%@",[JXJhDate JHFormatDateWith:commentLog.CreatedTime]];
    return myCell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
