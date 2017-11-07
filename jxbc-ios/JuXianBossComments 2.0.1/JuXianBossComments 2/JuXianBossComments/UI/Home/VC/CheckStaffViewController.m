//
//  CheckStaffViewController.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/20.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "CheckStaffViewController.h"
#import "JXFooterView.h"
#import "CheckRsultVC.h"

@interface CheckStaffViewController ()<JXFooterViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong)NSArray * textArray;
@property (nonatomic,strong)NSArray * placehoderArray;
@property (nonatomic,strong)JXFooterView * footerView;
@property (nonatomic,strong)UITextField *allFieldTex;

@end

@implementation CheckStaffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查询评价";
    [self isShowLeftButton:YES];
    [self initData];
    [self initUI];
}


- (void)initData{

    _textArray = @[@"员工姓名：",@"身份证号："];
    _placehoderArray = @[@"员工姓名",@"身份证号"];
}

- (void)initUI{

    self.jxTableView.frame = CGRectMake(0, 10, SCREEN_WIDTH, 200);
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    _footerView = [JXFooterView footerView];
    _footerView.height = 90;
    _footerView.delegate = self;
    _footerView.nextLabel.text = @"查询";
    self.jxTableView.tableFooterView = _footerView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _textArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat allFieldTexW = 235;
        _allFieldTex = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-allFieldTexW-10, 0, allFieldTexW, 44)];
        _allFieldTex.textAlignment = NSTextAlignmentRight;
        _allFieldTex.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
        _allFieldTex.clearsOnBeginEditing = YES;
        _allFieldTex.font = [UIFont systemFontOfSize:14];
        _allFieldTex.delegate = self;
        [_allFieldTex becomeFirstResponder];
        [cell.contentView addSubview:_allFieldTex];
    }
    
    
    NSString * testStr = _placehoderArray[indexPath.row];
    _allFieldTex.placeholder = [NSString stringWithFormat:@"编辑%@",testStr];
    _allFieldTex.tag = indexPath.row + 100;
    cell.textLabel.text = testStr;
    cell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}


#pragma maek -- footerView的代理方法
- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{
    
    UITextField * namefield = [self.view viewWithTag:100];
    UITextField * idfield = [self.view viewWithTag:101];
    
    if (namefield.text.length == 0) {
        [PublicUseMethod showAlertView:@"请输入员工姓名"];
        return;
    }
    if (idfield.text.length == 0) {
        [PublicUseMethod showAlertView:@"请输入身份证号"];
        return;
    }
    
    
    CheckRsultVC * checkResultVC = [[CheckRsultVC alloc] init];
    checkResultVC.nameCtr = namefield.text;
    checkResultVC.idCtr = idfield.text;
    
    checkResultVC.title = [NSString stringWithFormat:@"%@的老板点评",namefield.text];
    [self.navigationController pushViewController:checkResultVC animated:YES];
}

#pragma mark -- TextFieldDelegate
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    
//    InputEditVC * inputVC = [[InputEditVC alloc] init];
//    
//    if (textField.tag == 1000) {//姓名
//        
//        UITextField *extField = [self.view viewWithTag:1000];
//        inputVC.tf = extField;
//        inputVC.title = @"编辑姓名";
//        [self.navigationController pushViewController:inputVC animated:YES];
//    }
//    
//    return NO;
//}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
