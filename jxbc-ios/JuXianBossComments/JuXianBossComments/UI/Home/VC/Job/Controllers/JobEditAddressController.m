//
//  JobEditAddressController.m
//  JuXianBossComments
//
//  Created by Jam on 17/1/16.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JobEditAddressController.h"

@interface JobEditAddressController ()<JXFooterViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *textField;

@property (nonatomic, copy) EndEditAddressblock endEditAddressblock;

@property (nonatomic, strong) JXFooterView *footerView;

@property (nonatomic, copy) NSString *address;

@end

@implementation JobEditAddressController

- (instancetype)initWithAddress:(NSString *)string{

    self = [super init];
    if (self) {
        _address = string;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作地点";
    [self isShowLeftButton:YES];

    [self.view addSubview:self.footerView];
    self.textField.delegate = self;
    
    if (self.address) {
        self.textField.text = self.address;
    }
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)completeEditText:(EndEditAddressblock)endEditAddressblock{

    self.endEditAddressblock = endEditAddressblock;
}

#pragma mark - textField delegate
// 不能大于100字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (string.length == 0) return YES;
    
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > 100) {
        return NO;
    }
    
    
    return YES;
}
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 100) {
        textField.text = [textField.text substringToIndex:100];
    }
}

#pragma mark - function
- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{
    // 回传
    self.endEditAddressblock(self.textField.text);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - view
- (JXFooterView *)footerView{
    
    if (_footerView == nil) {
        _footerView = [JXFooterView footerView];
        _footerView.y = CGRectGetMaxY(self.textField.frame);
        _footerView.width = ScreenWidth;
        _footerView.nextLabel.text = @"确认";
        _footerView.delegate = self;
    }
    return _footerView;
}


@end
