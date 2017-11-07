//
//  JXAddAuthorizeVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/21.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXAddAuthorizeVC.h"
#import "JXMineModel.h"
#import "JXFooterView.h"
#import "AddRecodeCell.h"
#import "AddAuditiPersonVC.h"
#import "ReloInstructionVC.h"
#import "JXAuthorizationManagerVC.h"
#import "AccountRepository.h"
#import "JXAuthorizationManagerVC.h"
#import "NSString+RegexCategory.h"

@interface JXAddAuthorizeVC ()<JXFooterViewDelegate,UITextFieldDelegate,AddRecodeCellDelegate>

@property (nonatomic,strong)NSArray * textArray;
@property (nonatomic,strong)JXFooterView * footerView;
@property (nonatomic,strong)UITextField *allFieldTex;
@property (nonatomic,assign)int index;
@property (nonatomic,copy)NSString *reloStr;
@property (nonatomic,strong)CompanyMembeEntity *membeEntity;
@property (nonatomic,copy)NSString * passportId;


@end

@implementation JXAddAuthorizeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加授权人";
    [self isShowLeftButton:YES];
    _membeEntity = [UserAuthentication GetMyInformation];
    [self initData];
    [self initUI];
}

- (void)initData{

    _textArray = @[@"姓名",@"手机",@"职务",@"角色"];
    _index = 0;

}

- (void)initUI{

    self.jxTableView.frame = CGRectMake(0, 10, SCREEN_WIDTH, 280);
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    self.jxTableView.scrollEnabled = NO;
    _footerView = [JXFooterView footerView];
    _footerView.height = 90;
    _footerView.delegate = self;
    _footerView.nextLabel.text = @"保存";
    _footerView.nextLabel.font = [UIFont systemFontOfSize:15.0];
    self.jxTableView.tableFooterView = _footerView;
    
    // 提示文字
    UILabel * alertLabel = [UILabel labelWithFrame:CGRectMake(20, CGRectGetMaxY(self.jxTableView.frame) - 40, SCREEN_WIDTH - 40, 30) title:@"确认授权后，该用户可以登录老板点评，进行点评，请谨慎操作。" titleColor:[PublicUseMethod setColor:KColor_Text_EumeColor] fontSize:10.0 numberOfLines:0];
    [self.view addSubview:alertLabel];
    [self.jxTableView registerNib:[UINib nibWithNibName:@"AddRecodeCell" bundle:nil] forCellReuseIdentifier:@"addRecodeCell"];
    
    // 角色权限说明
    UIButton * textButton =[UIButton buttonWithFrame:CGRectMake(0,SCREEN_HEIGHT - 30 - 100, SCREEN_WIDTH, 30) title:@"角色权限说明" fontSize:13.0 titleColor:[PublicUseMethod setColor:KColor_Add_BlueColor] imageName:nil bgImageName:nil];
    textButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [textButton addTarget:self action:@selector(explanClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:textButton];
}

#pragma maek -- footerView的代理方法
#pragma mark -- 点击确认授权后
- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{

    CompanyMembeEntity * meberEntity = [[CompanyMembeEntity alloc] init];
    NSString *message = @"已发短信告知账号及密码";
    NSString *title = @"添加成功";
    NSString *cancelButtonTitle = @"返回";
    NSString *otherButtonTitle = @"继续添加";
    UITextField * nameTf = [self.view viewWithTag:100];
    UITextField * phoneTf = [self.view viewWithTag:101];
    UITextField * positionTf = [self.view viewWithTag:102];
    
    // 姓名
    if (nameTf.text.length == 0) {
        [PublicUseMethod showAlertView:@"请输入姓名"];
        return;
    }

    if (nameTf.text.length > 5) {
        
        [PublicUseMethod showAlertView:@"姓名最多5个字"];
        return;
    }
    
    // 手机号
    if (phoneTf.text.length == 0) {
        
        [PublicUseMethod showAlertView:@"请输入手机号"];
        return;
    }
    if ([PublicUseMethod textField:phoneTf length:11]==NO)
    {
        [PublicUseMethod showAlertView:@"手机号为11位数字"];
        return;
    }
    
    if (![phoneTf.text isMobileNumber])
    {
        [PublicUseMethod showAlertView:@"请输入正确的手机号"];
        return;
    }
    
    if (positionTf.text.length == 0) {
        [PublicUseMethod showAlertView:@"请输入职务"];
        return;
    }
    if (positionTf.text.length > 30) {
        [PublicUseMethod showAlertView:@"职务最多30个汉字"];
        return;
    }
    
    if ([self.secondVC isKindOfClass:[AddAuditiPersonVC class]]) {//只能添加高管
        meberEntity.Role = 3;
    }else {
        if (_index == 0) {
            [PublicUseMethod showAlertView:@"请选择角色"];
            return;
        }
        meberEntity.Role = _index;
    }
    
    meberEntity.RealName = nameTf.text;
    meberEntity.JobTitle = positionTf.text;
    meberEntity.MobilePhone = phoneTf.text;
    meberEntity.CompanyId = _membeEntity.CompanyId;
    
    NSLog(@"hhh===%@",[meberEntity toJSONString]);
    
    if (self.allreaddyCompany) {//修改
        meberEntity.MemberId = _allreaddyCompany.MemberId;
        meberEntity.PassportId = _allreaddyCompany.PassportId;
        [self showLoadingIndicator];
        [MineRequest postUpdateCompanyMemberWith:meberEntity success:^(id result) {
            [self dismissLoadingIndicator];
            if (result > 0) {
                if ([self.navigationController.viewControllers[1] isKindOfClass:[JXAuthorizationManagerVC class]]) {
                    
                    JXAuthorizationManagerVC *managerVC =  self.navigationController.viewControllers[1];
                    [managerVC.jxTableView.mj_header beginRefreshing];
                }
                [PublicUseMethod showAlertView:@"修改成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        } fail:^(NSError *error) {
            [self dismissLoadingIndicator];
            
        }];
    }else{//添加
    
        [self showLoadingIndicator];
        [MineRequest postAddCompanyMemberWith:meberEntity success:^(ResultEntity *resultEntity) {
            [self dismissLoadingIndicator];
            if (resultEntity.Success) {
                _passportId = [NSString stringWithFormat:@"%@",resultEntity.BizId];
                [self alertWithTitle:title message:message cancelTitle:cancelButtonTitle okTitle:otherButtonTitle];
            }else{
                [PublicUseMethod showAlertView:resultEntity.ErrorMessage];
            }
        } fail:^(NSError *error) {
            [self dismissLoadingIndicator];
            [PublicUseMethod showAlertView:error.localizedDescription];
        }];
        
    }
}


#pragma mark -- 角色说明
- (void)explanClick{

    ReloInstructionVC * reloVC = [[ReloInstructionVC alloc] init];
    [self.navigationController pushViewController:reloVC animated:YES];
}
#pragma mark -- 封装elert
- (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle okTitle:(NSString *)okTitle{
    
    
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:message];
    [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0,message.length)];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController setValue:hogan forKey:@"attributedTitle"];
    //取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        if ([self.secondVC isKindOfClass:[AddAuditiPersonVC class]]) {//添加评价的添加审核人
            
            if (_index != 3) {//如果添加的不是高管就不用传值了
                
            }else{//添加的是高管就要传值
                //将名字传过去
                UITextField * nameTf = [self.view viewWithTag:101];
                if (self.block) {
                    self.block(nameTf.text,_passportId);
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        if ([self.navigationController.viewControllers[1] isKindOfClass:[JXAuthorizationManagerVC class]]) {//授权管理列表
            
            JXAuthorizationManagerVC *managerVC =  self.navigationController.viewControllers[1];
            [managerVC.jxTableView.mj_header beginRefreshing];
            [PublicUseMethod showAlertView:@"添加成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
    //确定
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UITextField * nameTf = [self.view viewWithTag:100];
        UITextField * positionTf = [self.view viewWithTag:101];
        UITextField * phoneTf = [self.view viewWithTag:102];

        if ([okTitle isEqualToString:@"继续添加"]) {
            nameTf.text = @"";
            positionTf.text = @"";
            phoneTf.text = @"";
        }
    }];
    
    //设置cancelAction的title颜色
    [cancelAction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
    //设置cancelAction的title的对齐方式
    [cancelAction setValue:[NSNumber numberWithInteger:NSTextAlignmentCenter] forKey:@"titleTextAlignment"];
    //设置okAction的title颜色
    [otherAction setValue:ColorWithHex(KColor_Text_BlackColor) forKey:@"titleTextColor"];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _textArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (_membeEntity.Role == Role_manager && _membeEntity.PassportId == self.allreaddyCompany.PassportId) {
        
        if (indexPath.row == 3) {
            return 0;
        }else{
    
            return 44;
        }
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {//角色
//        AddAuditiPersonVC
        AddRecodeCell * roleCell = [tableView dequeueReusableCellWithIdentifier:@"addRecodeCell" forIndexPath:indexPath];
        roleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        roleCell.delegate = self;
        roleCell.stasulLabel.text = @"角色";
        roleCell.inLabel.text = @"高管";
        roleCell.outLabel.text = @"建档员";
        if ([self.secondVC isKindOfClass:[AddAuditiPersonVC class]]) {//阶段评价 离任报告 只能添加高管需要单独处理
            roleCell.outLabel.text = @"高管";
            [roleCell.onJobBtn setImage:[UIImage imageNamed:@"myok"] forState:UIControlStateNormal];
//            roleCell.onJobBtn.enabled = NO;
            roleCell.inLabel.hidden = YES;
            roleCell.inJobBtn.hidden = YES;
            roleCell.managerBtn.hidden = YES;
            roleCell.managerLabel.hidden = YES;
        }else{
            if (_membeEntity.Role == Role_Boss) {//当前
                roleCell.managerView.hidden = NO;
                roleCell.bigManagerBtn.enabled = YES;
            }
            if (self.allreaddyCompany) {//修改的时候
                
                if (self.allreaddyCompany.Role == Role_manager) {
                    [roleCell.managerBtn setImage:[UIImage imageNamed:@"myok"] forState:UIControlStateNormal];
                    _index = 2;
                }else if (self.allreaddyCompany.Role == Role_HightManager){
                    [roleCell.inJobBtn setImage:[UIImage imageNamed:@"myok"] forState:UIControlStateNormal];
                    _index = 3;
                }else if(self.allreaddyCompany.Role == Role_BuildMembers) {
                    
                    [roleCell.onJobBtn setImage:[UIImage imageNamed:@"myok"] forState:UIControlStateNormal];
                    _index = 4;
                }
                if (_membeEntity.Role == Role_manager && _membeEntity.PassportId == self.allreaddyCompany.PassportId) {
                    
                    roleCell.hidden = YES;
                }            
            }
        }
        
        
        
        return roleCell;
    }else{
    
        
        static NSString *identifier = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            CGFloat allFieldTexW = 210;
            _allFieldTex = [UITextField alloc];
            _allFieldTex = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-allFieldTexW-10, 8, allFieldTexW, 30)];
            _allFieldTex.textAlignment = NSTextAlignmentRight;
            _allFieldTex.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
            _allFieldTex.font = [UIFont systemFontOfSize:14];
            _allFieldTex.delegate = self;
            [cell.contentView addSubview:_allFieldTex];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString * testStr = _textArray[indexPath.row];
        _allFieldTex.tag = indexPath.row + 100;
        _allFieldTex.placeholder = [NSString stringWithFormat:@"请输入%@",_textArray[indexPath.row]];
        
        if (indexPath.row == 1) {
            _allFieldTex.keyboardType = UIKeyboardTypeNumberPad;
            _allFieldTex.placeholder = @"请输入手机号，将作为登录账号";
            if (self.allreaddyCompany) {
                _allFieldTex.text = self.allreaddyCompany.MobilePhone;
                _allFieldTex.enabled = NO;
            }
        }else if (self.allreaddyCompany) {
           if (indexPath.row == 0){
                _allFieldTex.text = self.allreaddyCompany.RealName;
            
            }else {
                _allFieldTex.text = self.allreaddyCompany.JobTitle;
            }
            
        }
        
        
        cell.textLabel.text = testStr;
        cell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    
    }
}

#pragma mark -- 担任角色的代理获取添加什么角色
- (void)addRecodeCellClickTimeBtnWith:(int)index andView:(AddRecodeCell *)resonCell{

    NSLog(@"index===%d",index);
    
    if ([self.secondVC isKindOfClass:[AddAuditiPersonVC class]]) {
        [PublicUseMethod showAlertView:@"只有高管才有审核权限哦~"];
    }
    
    if ( index == 3) {
        _reloStr = @"高管";
    }
    if (index == 4) {
        _reloStr = @"建党员";
    }
    if (index == 2) {
        _reloStr = @"管理员";

    }
    if (index == 1) {//不可能有这种情况
        _reloStr = @"公司法人";
    }
    _index = index ;
}

- (void)cancelAction:(UIButton *)btn{
    [self dismissViewControllerAnimated:YES completion:nil];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
