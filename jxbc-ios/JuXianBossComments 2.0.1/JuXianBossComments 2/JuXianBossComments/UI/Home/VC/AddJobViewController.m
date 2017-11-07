//
//  AddJobViewController.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/25.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "AddJobViewController.h"
#import "STPickerDate.h"
#import "ChoiceDepartmentVC.h"
#import "XJHPickerDate.h"
#import "DataPickerView.h"
#import "JobModel.h"
#import "NSString+RegexCategory.h"

@interface AddJobViewController ()<UITextFieldDelegate,JXFooterViewDelegate,STPickerDateDelegate,XJHPickerDateDelegate>
@property (nonatomic,strong)UITextField *allFieldTex;
@property (nonatomic,strong)NSArray * dataArray;
@property (nonatomic,strong)NSArray * placehoderArray;

@property (nonatomic,strong)UITextField *startDateTf;
@property (nonatomic,strong)UITextField *overDateTf;
@property (nonatomic,strong)UITextField *zhiWuTf;
@property (nonatomic,strong)UITextField *moneyTf;

//部门
@property (nonatomic,strong)UITextField *doorTf;
@property (nonatomic,copy)NSString *startDateStr;
@property (nonatomic,copy)NSString *overDateStr;

@end

@implementation AddJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"添加职务";
    [self isShowLeftButton:YES];
    [self initData];
    [self initUI];
}

- (void)initData{

    _dataArray = @[@"担任职务",@"任职开始时间",@"任职结束时间",@"年薪收入(万元)",@"所在部门"];
    _placehoderArray = @[@"请输入担任职务",@"请选择任职开始时间",@"请选择任职结束时间",@"包括：薪资、福利、奖金等等",@"请选择所在部门"];
}

- (void)initUI{

    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    JXFooterView * footerView = [JXFooterView footerView];
    footerView.delegate = self;
    footerView.nextLabel.text = @"完成";
    footerView.nextLabel.font = [UIFont systemFontOfSize:15.0];
    self.jxTableView.tableFooterView = footerView;
}
#pragma mark - 提交
- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{
    
    if (_zhiWuTf.text.length == 0) {
        [PublicUseMethod showAlertView:@"请输入担任职务"];
        return;
    }
    if (_zhiWuTf.text.length > 30) {
        [PublicUseMethod showAlertView:@"担任职务最多30个字"];
        return;
    }

    _moneyTf = [self.view viewWithTag:203];
    if (_startDateTf.text == 0) {
        [PublicUseMethod showAlertView:@"请选择任职开始时间"];
        return;
    }
    if (_overDateTf.text.length == 0) {
        [PublicUseMethod showAlertView:@"请选择任职结束时间"];
        return;
    }
    if ([_zhiWuTf.text isContainsEmoji]) {
        [PublicUseMethod showAlertView:@"担任职务不可以包含表情"];
        return;
    }


    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate* joinCompanyDate = [outputFormatter dateFromString:self.joinCompanyDate];
    NSDate* leaveCompanyDate = [outputFormatter dateFromString:self.leaveCompanyDate];
    
    if ([_startDateTf.text containsString:@"日"]) {
        [outputFormatter setDateFormat:@"yyyy年MM月dd日"];
    }else{
        [outputFormatter setDateFormat:@"yyyy年MM月"];
    }
    NSDate *starDate = [JXJhDate getNowDateFromatAnDate:[outputFormatter dateFromString:_startDateTf.text]];

    NSString *endStr = _overDateTf.text;
    if ([endStr containsString:@"至今"]) {
        endStr = @"3000年1月";
        _overDateStr = @"至今";
    }
    
    if ([endStr containsString:@"日"]) {
        [outputFormatter setDateFormat:@"yyyy年MM月dd日"];
    }else{
        [outputFormatter setDateFormat:@"yyyy年MM月"];
    }
    NSDate *endDate = [JXJhDate getNowDateFromatAnDate:[outputFormatter dateFromString:endStr]];
    if ([endDate timeIntervalSinceDate:starDate]<0.0) {
        [PublicUseMethod showAlertView:@"任职结束时间不能小于任职开始时间"];
        return;
    } ;
    if ([starDate timeIntervalSinceDate:joinCompanyDate]<0.0) {
        [PublicUseMethod showAlertView:@"任职开始时间不能小于入职时间"];
        return;
    } ;

    if ([endDate timeIntervalSinceDate:leaveCompanyDate]>0.0) {
        [PublicUseMethod showAlertView:@"任职结束时间不能小于离任时间"];
        return;
    } ;
    
    if ([endDate isEqual:starDate]) {
        
        [PublicUseMethod showAlertView:@"开始和结束的时间不能相等"];
        return;
    }
    
    if (_moneyTf.text.length != 0) {
        // 正则判断
        NSString *salaryRegex = @"[0-9]{1,3}(\\.[0-9]{0,2})?";
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",salaryRegex];
        
        if (![pre evaluateWithObject:_moneyTf.text]) {
            [PublicUseMethod showAlertView:@"请输入正确的年薪哦\n年薪为3~999之间的两位小数或整数"];
            return;
        }
        if (_moneyTf.text.floatValue >=1000 || _moneyTf.text.floatValue < 3 ) {
            [PublicUseMethod showAlertView:@"年薪为3~999之间的两位小数或整数"];
            return;
        }
    }

    if (_doorTf.text.length == 0) {
        [PublicUseMethod showAlertView:@"请选择所在部门"];
        return;
    }
    
    NSLog(@"%@   %@",_startDateStr,_overDateStr);
        if (self.workItemBlock) {
            //将数据传到前页
            /*
            JobModel *jobModel = [[JobModel alloc]init];
            jobModel.jobStr = _zhiWuTf.text;
            jobModel.moneyStr = _moneyTf.text;
            jobModel.doorStr = _doorTf.text;
            jobModel.startDataStr = _startDateStr;
            jobModel.overDataStr = _overDateStr;
            _jobBlock(jobModel);
            */
            WorkItemEntity * workitem = [[WorkItemEntity alloc] init];
            workitem.PostStartTime = starDate;
            workitem.PostEndTime = endDate;
            workitem.PostTitle = _zhiWuTf.text;
            workitem.Salary = _moneyTf.text;
            workitem.Department = _doorTf.text;
            if (_workItemEntity.ItemId) {
                
                workitem.ItemId = _workItemEntity.ItemId;
            }
            self.workItemBlock(workitem,_startDateStr,_overDateStr);
        }
        [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell000";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat allFieldTexW = 235;
        _allFieldTex = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-allFieldTexW-10, 0, allFieldTexW, 44)];
        _allFieldTex.textAlignment = NSTextAlignmentRight;
        _allFieldTex.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
        _allFieldTex.font = [UIFont systemFontOfSize:14];
        _allFieldTex.delegate = self;
        if (indexPath.row == 3) { // 年薪收入
            _allFieldTex.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }

        [cell.contentView addSubview:_allFieldTex];
    }
    
    _allFieldTex.tag = 200 + indexPath.row;
    _startDateTf = [self.view viewWithTag:201];
    _overDateTf = [self.view viewWithTag:202];
    _zhiWuTf = [self.view viewWithTag:200];
    
    _allFieldTex.placeholder = _placehoderArray[indexPath.row];
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    
    if (_workItemEntity) {
        if (indexPath.row == 1) { // 任职开始时间
            _allFieldTex.text = [JXJhDate stringFromDate:_workItemEntity.PostStartTime];
            _startDateTf = _allFieldTex;
            _startDateStr = _allFieldTex.text;
        }else if (indexPath.row == 2){// 任职结束时间
            if ([[JXJhDate stringFromYearAndMonthDate:_workItemEntity.PostEndTime] isEqualToString:@"3000年01月"]) {
                _allFieldTex.text = @"至今";
            }else{
                _allFieldTex.text = [JXJhDate stringFromDate:_workItemEntity.PostEndTime];
            }
            _overDateTf = _allFieldTex;
            _overDateStr = _allFieldTex.text;
        }else if (indexPath.row == 0){ // 担任职务
        
            _allFieldTex.text = _workItemEntity.PostTitle;
            _zhiWuTf = _allFieldTex;
        }else if (indexPath.row == 3){// 薪资收入
            _allFieldTex.text = _workItemEntity.Salary;
            _moneyTf = _allFieldTex;
        }else{// 所在部门
            _allFieldTex.text = _workItemEntity.Department;
            _doorTf = _allFieldTex;
        }
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {//任职开始时间
        
        DataPickerView *picker = [[DataPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        picker.titleStr = @"入职日期";
        picker.block = ^(NSString *dataStr,NSString *noDateStr){
            _startDateTf = [self.view viewWithTag:201];
            _startDateTf.text = dataStr;
            _startDateStr = noDateStr;

        };
        [picker loadPickerView];
        [self.view addSubview:picker];
        [picker selectedDateWithString:_startDateTf.text];

    }else if (indexPath.row == 2){//离任结束时间

        DataPickerView *picker = [[DataPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        picker.isEndTime = YES;
        picker.titleStr = @"离任日期";

        picker.block = ^(NSString *dataStr,NSString *noDateStr){
            _overDateTf = [self.view viewWithTag:202];
            _overDateTf.text = dataStr;
            _overDateStr = noDateStr;
        };
        [picker loadPickerView];
        [self.view addSubview:picker];
        [picker selectedDateWithString:_overDateTf.text];

        
    }else if (indexPath.row == 4){//部门
        ChoiceDepartmentVC  * choiceVC= [[ChoiceDepartmentVC alloc] init];
        choiceVC.block = ^(NSString * informationStr){
            _doorTf = [self.view viewWithTag:204];
            _doorTf.text = informationStr;
        };
        [self.navigationController pushViewController:choiceVC animated:YES];
    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    if (textField.tag == 201) { // 任职开始时间
        DataPickerView *picker = [[DataPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        
        picker.titleStr = @"入职日期";
        picker.block = ^(NSString *dataStr,NSString *noDateStr){
            _startDateTf.text = dataStr;
            _startDateStr = noDateStr;

        };
        [picker loadPickerView];
        [self.view addSubview:picker];
        [picker selectedDateWithString:_startDateTf.text];
        
        return NO;
    }
    
    if (textField.tag == 202) {
        DataPickerView *picker = [[DataPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        picker.isEndTime = YES;
        
        picker.titleStr = @"离任日期";
        picker.block = ^(NSString *dataStr,NSString *noDateStr){
            _overDateTf.text = dataStr;
            _overDateStr = noDateStr;

        };
        [picker loadPickerView];
        [self.view addSubview:picker];
        [picker selectedDateWithString:_overDateTf.text];
        

        return NO;
    }
    if (textField.tag == 204) {//选择部门
        
        ChoiceDepartmentVC  * choiceVC= [[ChoiceDepartmentVC alloc] init];
        choiceVC.block = ^(NSString * informationStr){
            _doorTf = [self.view viewWithTag:204];
            _doorTf.text = informationStr;
        };
        [self.navigationController pushViewController:choiceVC animated:YES];
        return NO;
    }

    return YES;
}


- (void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day{

    //时间字符串显示样式
    NSString *monthStr;
    NSString *dayStr;
    if (month<10) {
        monthStr = [NSString stringWithFormat:@"0%zd",month];
    }else{
        monthStr = [NSString stringWithFormat:@"%zd",month];
    }
    
    if (day<10) {
        dayStr = [NSString stringWithFormat:@"0%zd",day];
    }else{
        dayStr = [NSString stringWithFormat:@"%zd",day];
    }
    
    NSString * dateStr = [NSString stringWithFormat:@"%zd年%@月%@日", year, monthStr, dayStr];
    _startDateTf.text = dateStr;
}

- (void)xjhPickerDate:(XJHPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day{

//    if (year==0) {
//        _overDateTf.text = @"至今";
//        _dateStr = _overDateTf.text;
//    }else{
//        NSString *text = [NSString stringWithFormat:@"%zd年%zd月%zd日", year, month, day];
//        _overDateTf.text = text;
//        _startDateStr = [NSString stringWithFormat:@"%zd%zd%zd", year, month, day];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
