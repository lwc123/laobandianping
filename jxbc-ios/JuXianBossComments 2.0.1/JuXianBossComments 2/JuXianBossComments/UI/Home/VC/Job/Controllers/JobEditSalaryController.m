//
//  JobEditSalaryController.m
//  JuXianBossComments
//
//  Created by Jam on 17/1/16.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JobEditSalaryController.h"

@interface JobEditSalaryController ()<JXFooterViewDelegate>

@property (nonatomic, strong) IBOutlet UITextField *minField;

@property (nonatomic, strong) IBOutlet UITextField *maxField;

@property (nonatomic, strong) JXFooterView *footerView;

@property (nonatomic, copy) EndEditSalaryBlock endEditSalaryBlock;

@end

@implementation JobEditSalaryController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.footerView];
    self.title = @"薪资范围";
    [self isShowLeftButton:YES];

    
    if (self.minSalary > 0) {
        self.minField.text = [NSString stringWithFormat:@"%d",self.minSalary];
    }
    if (self.maxSalary > 0) {
        self.maxField.text = [NSString stringWithFormat:@"%d",self.maxSalary];
        
    }

}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    [self.minField becomeFirstResponder];
}

#pragma mark - function
- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{
    
    int min = self.minField.text.intValue;
    int max = self.maxField.text.intValue;
    // 最小薪资不能少于三千元
    if(min < 3000){
        [[[UIAlertView alloc]initWithTitle:nil message:@"月薪不能少于3000元" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    // 最小薪资不能少于三千元
    if(max > 1000000){
        [[[UIAlertView alloc]initWithTitle:nil message:@"月薪不能大于1000000元" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    // 最高薪资比最低薪资 要高
    if (max < min) {
        [[[UIAlertView alloc]initWithTitle:nil message:@"最高薪资低于最低薪资" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    // 回传
    self.endEditSalaryBlock(min,max);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)completeEditText:(EndEditSalaryBlock)endEditSalaryBlock{
    
    if (endEditSalaryBlock) {
        self.endEditSalaryBlock = endEditSalaryBlock;
    }
}


- (JXFooterView *)footerView{
    
    if (_footerView == nil) {
        _footerView = [JXFooterView footerView];
        _footerView.y = CGRectGetMaxY(self.maxField.frame);
        _footerView.width = ScreenWidth;
        _footerView.nextLabel.text = @"确认";
        _footerView.delegate = self;
    }
    return _footerView;
}

@end
