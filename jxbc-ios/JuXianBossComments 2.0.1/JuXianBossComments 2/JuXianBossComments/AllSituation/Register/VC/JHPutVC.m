//
//  JHPutVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/3.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JHPutVC.h"
#import "ChoiceIndustryViewController.h"//行业选择
#import "SectionManagerVC.h"//部门管理
#import "CompanyMembeEntity.h"
#import "JXAccountInformationVC.h" //修改姓名


@interface JHPutVC ()<JXFooterViewDelegate>

@property (nonatomic,strong)CompanyMembeEntity * bossEntity;
@property (nonatomic,strong)CompanyMembeEntity * myEntity;


@end

@implementation JHPutVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self isShowLeftButton:YES];
    [self isShowRightButton:YES with:@"保存"];
    [self initData];
    [self initUI];
}

- (void)initData{

    _bossEntity = [UserAuthentication GetBossInformation];
    _myEntity = [UserAuthentication GetMyInformation];

}

- (void)initUI{
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    bgView.backgroundColor = [UIColor whiteColor];
    _jhTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 44)];
    _jhTextField.borderStyle = UITextBorderStyleNone;
    _jhTextField.font =[UIFont systemFontOfSize:15.0];
    _jhTextField.placeholder = self.textStr;
    _jhTextField.backgroundColor = [UIColor whiteColor];
    [_jhTextField becomeFirstResponder];
    if (_departmentsEntity) {
        _jhTextField.text = _departmentsEntity.DeptName;
    }
    if (_nameStr) {
        _jhTextField.text = _nameStr;
    }
    
    [bgView addSubview:_jhTextField];
    [self.view addSubview:bgView];
    
    
    JXFooterView * footer = [JXFooterView footerView];
    footer.y = CGRectGetMaxY(_jhTextField.frame) + 10;
    footer.x = (SCREEN_WIDTH - footer.width) * 0.5;
    footer.delegate = self;
    footer.nextLabel.text = @"保存";
    [self.view addSubview:footer];

}

- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{
    [self save];
}

- (void)save{
    

    if ([self.secondVC isKindOfClass:[ChoiceIndustryViewController class]]) {
        
        ChoiceIndustryViewController *editVC = [[ChoiceIndustryViewController alloc] init];
        NSString *tagStr = [_jhTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (tagStr.length == 0) {
            [PublicUseMethod showAlertView:@"请输入行业名称"];
            return;
        }
        
        if (tagStr.length > 10) {
            [PublicUseMethod showAlertView:@"最多输入10个字,请重新输入"];
            return;
        }
        
        if (self.block) {
            
            [[NSUserDefaults standardUserDefaults] setObject:_jhTextField.text forKey:@"Identity"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            self.block(_jhTextField.text);
            
            
            [editVC.signView.collectionView reloadData];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([self.secondVC isKindOfClass:[SectionManagerVC class]]) {//添加部门
        
        if (_jhTextField.text.length == 0) {
            [PublicUseMethod showAlertView:@"请输入部门名称"];
            return;
        }
        
        if (_jhTextField.text.length > 20) {
            
            [PublicUseMethod showAlertView:@"部门名称不能多于20个字"];
            return;
        }
        
        [self initDepartmentRequest];
    }
    
    if ([self.secondVC isKindOfClass:[JXAccountInformationVC class]]) {//修改姓名
        
        if (_jhTextField.text.length == 0) {
            [PublicUseMethod showAlertView:@"请输入姓名"];
            return;
        }
        
        if (_jhTextField.text.length > 5) {
            
            [PublicUseMethod showAlertView:@"姓名超过了5个汉字"];
            return;
        }
        [self initUpdateName];
    }
    
    
    
    
    
}

#pragma mark -- 修改姓名
- (void)initUpdateName{

    _myEntity.RealName = _jhTextField.text;
    [self showLoadingIndicator];
    [MineRequest postUpdateCompanyMemberWith:_myEntity success:^(id result) {
        [self dismissLoadingIndicator];
//        Log(@"result===%@",result);
        if ([result integerValue] > 0) {
            [PublicUseMethod showAlertView:@"修改成功"];
            
            if (_block) {
                _block(_jhTextField.text);
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } fail:^(NSError *error) {
        [self dismissLoadingIndicator];
        NSLog(@"error===%@",error);
        [PublicUseMethod showAlertView:@"修改失败 请稍后重试..."];
    }];

}

#pragma matk --添加部门
- (void)initDepartmentRequest{
    
    DepartmentsEntity * departments = [[DepartmentsEntity alloc] init];
    departments.DeptName = _jhTextField.text;
    departments.CompanyId = _bossEntity.CompanyId;
    departments.PresenterId = _myEntity.PresenterId;
    if (_departmentsEntity) {
        departments.DeptId = _departmentsEntity.DeptId;
    }
    
    if (_departmentsEntity) {//修改部门
        
        [MineRequest postUpdateDepartmentWith:departments success:^(id result) {
            
//            Log(@"result===%@",result);
            [self dismissLoadingIndicator];
            NSInteger dic = [result[@"Success"] integerValue];
            
            if (dic > 0) {
                [PublicUseMethod showAlertView:@"修改成功"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                
                NSString * messageError = result[@"ErrorMessage"];
                [PublicUseMethod showAlertView:messageError];
            }
        } fail:^(NSError *error) {
            [self dismissLoadingIndicator];
            NSLog(@"error===%@",error);
        }];
        
        
    }else{//添加部门
    
        //    [departments toJSONString];
        MJWeakSelf
        [self showLoadingIndicator];
        [MineRequest postAddDepartmentWith:departments success:^(ResultEntity *resultEntity) {
            [weakSelf dismissLoadingIndicator];
            if (resultEntity.Success) {
                [PublicUseMethod showAlertView:@"添加成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
            
                [PublicUseMethod showAlertView:resultEntity.ErrorMessage];
            }
            
        } fail:^(NSError *error) {
            [weakSelf dismissLoadingIndicator];
            [PublicUseMethod showAlertView:error.localizedDescription];
        }];
        
        
//        [MineRequest postAddDepartmentWith:departments success:^(id result) {
////            Log(@"result===%@",result);
//            [self dismissLoadingIndicator];
//            NSInteger dic = [result[@"Success"] integerValue];
//            
//            if (dic > 0) {
//                [PublicUseMethod showAlertView:@"添加成功"];
//                SectionManagerVC *sectionManagerVC =  self.navigationController.viewControllers[2];
//                
////                [sectionManagerVC.jxTableView.mj_header beginRefreshing];
//                
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self.navigationController popViewControllerAnimated:YES];
//                });
//                
//                
//            }else{
//                
//                NSString * messageError = result[@"ErrorMessage"];
//                [PublicUseMethod showAlertView:messageError];
//            }
//            
//            
//        } fail:^(NSError *error) {
//            [self dismissLoadingIndicator];
//            NSLog(@"error===%@",error);
//        }];
        
    }
}

- (void)rightButtonAction:(UIButton *)button{
        [self save];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
