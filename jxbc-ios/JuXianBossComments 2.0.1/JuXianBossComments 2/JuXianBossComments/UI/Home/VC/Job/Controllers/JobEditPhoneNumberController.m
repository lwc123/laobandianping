//
//  JobEditPhoneNumberController.m
//  JuXianBossComments
//
//  Created by Jam on 17/1/16.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JobEditPhoneNumberController.h"
#import "NSString+RegexCategory.h"

@interface JobEditPhoneNumberController ()<JXFooterViewDelegate,UITextFieldDelegate>

@property (nonatomic, copy) NSString *phoneNum;

@property (nonatomic, copy) EndEditPhoneNumBlock endEditPhoneNumBlock;

@property (nonatomic, strong) JXFooterView *footerView;

@property (nonatomic, strong) IBOutlet UITextField *textField;

@property (nonatomic, strong) IBOutlet UILabel *label;



@end

@implementation JobEditPhoneNumberController

- (instancetype)initWithPhoneNum:(NSString *)string
{
    self = [super init];
    if (self) {
        self.phoneNum = string;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系电话";
    [self isShowLeftButton:YES];

    self.textField.delegate = self;
    
    [self.view addSubview:self.footerView];
    
    
    if (self.phoneNum) {
        self.textField.text = self.phoneNum;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}

#pragma mark - function
- (void)completeEditPhoneNumHandle:(EndEditPhoneNumBlock)endEditPhoneNumBlock{
    self.endEditPhoneNumBlock = endEditPhoneNumBlock;
}

- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{
    // 判断是否正确的联系电话
    if (![self.textField.text isValidWithMinLenth:8 maxLenth:20 containChinese:NO containDigtal:YES containLetter:NO containOtherCharacter:nil firstCannotBeDigtal:NO]) {
        [self alertString:@"请输入正确的联系电话" duration:1];
        return;
    }


    // 回传
    self.endEditPhoneNumBlock(self.textField.text);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textFiled delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (string.length == 0) return YES;
    
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > 30) {
        return NO;
    }
    
    
    return YES;
}
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 30) {
        textField.text = [textField.text substringToIndex:30];
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
