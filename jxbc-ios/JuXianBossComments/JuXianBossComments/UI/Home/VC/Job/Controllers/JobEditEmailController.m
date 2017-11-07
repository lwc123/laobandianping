//
//  JobEditEmailController.m
//  JuXianBossComments
//
//  Created by Jam on 17/1/16.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JobEditEmailController.h"
#import "NSString+RegexCategory.h"

@interface JobEditEmailController ()<JXFooterViewDelegate,UITextFieldDelegate>

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) EndEditEmailBlock endEditEmailBlock;

@property (nonatomic, strong) IBOutlet UILabel *label;


@property (nonatomic, strong) JXFooterView *footerView;

@property (nonatomic, strong) IBOutlet UITextField *textField;

@end

@implementation JobEditEmailController

- (instancetype)initWithEmail:(NSString *)string
{
    self = [super init];
    if (self) {
        self.email = string;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"接收简历邮箱";
    [self isShowLeftButton:YES];

    [self.view addSubview:self.footerView];
    
    self.textField.delegate = self;
    if (self.email) {
        self.textField.text = self.email;
    }
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}
#pragma mark - function
- (void)completeEditEmailHandle:(EndEditEmailBlock)endEditEmailBlock{

    self.endEditEmailBlock = endEditEmailBlock;
    
}

- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{
    
    // 判断是否正确的邮箱地址
    if (![self.textField.text isEmailAddress]) {
        [self alertString:@"请输入正确的邮箱地址" duration:1];
        return;
    }
        // 回传
    self.endEditEmailBlock(self.textField.text);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textFiled delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (string.length == 0) return YES;
    
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > 200) {
        return NO;
    }
    
    
    return YES;
}
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 200) {
        textField.text = [textField.text substringToIndex:200];
    }
}

#pragma mark - view
- (JXFooterView *)footerView{
    
    if (_footerView == nil) {
        _footerView = [JXFooterView footerView];
        _footerView.y = CGRectGetMaxY(self.label.frame);
        _footerView.width = ScreenWidth;
        _footerView.nextLabel.text = @"确认";
        _footerView.delegate = self;
    }
    return _footerView;
}



@end
