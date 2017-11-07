//
//  JobChangeJobNameController.m
//  JuXianBossComments
//
//  Created by Jam on 17/1/16.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JobChangeJobNameController.h"

@interface JobChangeJobNameController ()<JXFooterViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *textField;

@property (nonatomic, strong) JXFooterView *footerView;

@property (nonatomic, copy) EndEditTextBlock endEditTextBlock;

@property (nonatomic, copy) NSString *jobName;

@end

@implementation JobChangeJobNameController

#pragma mark - life cycle
- (instancetype)initWithJobName:(NSString *)string{

    self = [super init];
    if (self) {
        _jobName = string;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self isShowLeftButton:YES];

    self.textField.delegate = self;
    self.title = @"职位名称";

    if (self.jobName) {
        self.textField.text = self.jobName;
    }
    
    [self.view addSubview:self.footerView];
}
- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];

}

#pragma mark - textFiled delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 20) {
            return NO;
        }
    
    
    return YES;
}
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 20) {
        textField.text = [textField.text substringToIndex:20];
    }
}

#pragma mark - function
- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{
    // 回传
    self.endEditTextBlock(self.textField.text);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)completeEditText:(EndEditTextBlock)endEditTextBlock{
    
    if (endEditTextBlock) {
        self.endEditTextBlock = endEditTextBlock;
    }
}

#pragma mark - view
- (JXFooterView *)footerView{
    
    if (_footerView == nil) {
        _footerView = [JXFooterView footerView];
        _footerView.y = CGRectGetMaxY(self.detailLabel.frame);
        _footerView.width = ScreenWidth;
        _footerView.nextLabel.text = @"确认";
        _footerView.delegate = self;
    }
    return _footerView;
}

@end
