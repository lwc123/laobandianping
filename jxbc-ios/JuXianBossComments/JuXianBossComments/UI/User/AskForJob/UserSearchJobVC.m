//
//  UserSearchJobVC.m
//  JuXianBossComments
//
//  Created by juxian on 17/1/19.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "UserSearchJobVC.h"
#import "SearchCitiVC.h"
#import "SearchViewController.h"
#import "ChoiceIndustryViewController.h"
#import "DegreeView.h"
#import "AskforJobVC.h"

@interface UserSearchJobVC ()<UITextFieldDelegate,JXFooterViewDelegate>
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITextField *myTextF;
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, copy) NSString *industry;
@property (nonatomic, copy) NSString *salar;

@end

@implementation UserSearchJobVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"搜索职位";
    [self isShowLeftButton:YES];
    [self initUI];
}

- (NSArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = @[@"请输入职位",@"请选择行业",@"请选择城市",@"请选择薪资"];
    }
    return _dataArray;
}


- (void)initUI{
    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH - 64);
    self.jxTableView.separatorColor = KColor_CellColor;
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    JXFooterView * footerView = [JXFooterView footerView];
    footerView.nextLabel.text = @"搜索";
    footerView.delegate = self;
    self.jxTableView.tableFooterView = footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString * cellId = @"textCellId";
    UITableViewCell * textFieldCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!textFieldCell) {
        textFieldCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        _myTextF = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 10, 44)];
        _myTextF.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
        _myTextF.font = [UIFont systemFontOfSize:15.0];
        _myTextF.delegate = self;
        [textFieldCell.contentView addSubview:_myTextF];
    }
    
    textFieldCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _myTextF.tag = 100 + indexPath.row;
    _myTextF.placeholder = self.dataArray[indexPath.row];
    return textFieldCell;
    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    MJWeakSelf
    if (textField.tag == 100) {
        return YES;
    }else if (textField.tag == 101){//行业
        
        ChoiceIndustryViewController *signVC = [[ChoiceIndustryViewController alloc]init];
        signVC.block = ^(NSString * informationStr,NSString * cityCode){
            textField.text = informationStr;
            _industry = informationStr;
        };
        [self.navigationController pushViewController:signVC animated:YES];
    }else if (textField.tag == 102){//城市
        SearchViewController *searchVC = [[SearchViewController alloc]init];
        searchVC.block = ^(CityModel* city){
            textField.text = city.Name;
            weakSelf.cityCode = city.Code;
        };
        
        [self.navigationController pushViewController:searchVC animated:YES];
        
        return NO;
    }else{//薪资
        DegreeView *degreeView = [[DegreeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        degreeView.title = @"薪资范围";
        degreeView.cellData = @[@"3k-5k",@"5k-10k",@"10k-20k",@"20k-50k",@"50k-100k",@"100k-1000k",];
        
        degreeView.block = ^(NSString *string,NSInteger index){
            textField.text = string;
            _salar = string;
        };
        [degreeView loadDegreeView];
        if (_salar.length > 0) {
            NSInteger row = [degreeView.cellData indexOfObject:_salar];
            [degreeView.picker selectRow:row inComponent:0 animated:NO];
        }
        
        [self.view addSubview:degreeView];
        
        return NO;
    }
    return NO;
}

- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{
    
    AskforJobVC * jobVC = [[AskforJobVC  alloc] init];
    UITextField * nameTf = [self.view viewWithTag:100];
    jobVC.jobName = nameTf.text;
    jobVC.jobCity = _cityCode;
    jobVC.industry = _industry;
    jobVC.salaryRange = _salar;
    [UIView animateWithDuration:2 animations:^{
        [self.navigationController pushViewController:jobVC animated:YES];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
