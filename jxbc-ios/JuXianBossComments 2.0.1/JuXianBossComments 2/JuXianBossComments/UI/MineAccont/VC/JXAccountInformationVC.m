//
//  JXAccountInformationVC.m
//  JuXianBossComments
//
//  Created by juxian on 2017/2/6.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JXAccountInformationVC.h"
#import "ChoiceCompanyCell.h"
#import "JHPutVC.h"

@interface JXAccountInformationVC ()
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic,strong)CompanyMembeEntity *userEntity;
@property (nonatomic, copy) NSString *roleStr;
@property (nonatomic, copy) NSString *nameStr;

@end

@implementation JXAccountInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号信息";
    [self isShowLeftButton:YES];
    [self initUI];
}

- (NSArray *)dataArray{

    if (_dataArray == nil) {
        
        _dataArray = @[@"姓名:",@"手机号:",@"职务:",@"角色:",];
    }
    return _dataArray;
}

- (void)initUI{
    _userEntity = [UserAuthentication GetMyInformation];

    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    [self.jxTableView registerNib:[UINib nibWithNibName:@"ChoiceCompanyCell" bundle:nil] forCellReuseIdentifier:@"choiceCompanyCell"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        
        ChoiceCompanyCell * nameCell = [tableView dequeueReusableCellWithIdentifier:@"choiceCompanyCell" forIndexPath:indexPath];
        nameCell.selectionStyle = UITableViewCellSelectionStyleNone;
        nameCell.companyLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
        if (_nameStr) {
            nameCell.companyLabel.text = _nameStr;
        }else{
            nameCell.companyLabel.text = _userEntity.RealName;
        }
        
        if (_userEntity.Role == Role_Boss) {
            [nameCell.watiBtn setTitle:@" " forState:UIControlStateNormal];
            nameCell.watiBtn.enabled = NO;
        }else{
            [nameCell.watiBtn setTitle:@"修改" forState:UIControlStateNormal];
            nameCell.watiBtn.enabled = YES;
        }
        
        
        [nameCell.watiBtn addTarget:self action:@selector(fixBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return nameCell;
    }else{
        static NSString * cellId = @"myCellID";
        UITableViewCell * myCell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!myCell) {
            myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;

        myCell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
        myCell.textLabel.font = [UIFont systemFontOfSize:15.0];
        if (indexPath.row == 1) {
            myCell.textLabel.text = _userEntity.MobilePhone;
        }else if (indexPath.row == 2){
            myCell.textLabel.text = _userEntity.JobTitle;

        }else if (indexPath.row == 3){
            if (_userEntity.Role == Role_Boss) {
                _roleStr = @"老板";
            }else if (_userEntity.Role == Role_manager){
            
                _roleStr = @"管理员";
            }else if (_userEntity.Role == Role_BuildMembers){
            
                _roleStr = @"建档员";
            }else{
            
                _roleStr = @"高管";
            }
            myCell.textLabel.text = _roleStr;

        }
        return  myCell;
    }
}

- (void)fixBtnClick:(UIButton *)btn{
    
    JHPutVC * putVC = [[JHPutVC alloc] init];
    putVC.title = @"修改姓名";
    putVC.secondVC = self;
    putVC.textStr = @"请输入姓名";
    putVC.nameStr = _userEntity.RealName;
    
    putVC.block = ^(NSString *dataStr){
        _nameStr = dataStr;
        [self.jxTableView reloadData];
    };
    
    
    [self.navigationController pushViewController:putVC animated:YES];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
