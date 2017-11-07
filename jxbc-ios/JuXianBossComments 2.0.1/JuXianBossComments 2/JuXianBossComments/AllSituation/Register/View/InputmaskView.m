//
//  InputmaskView.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/24.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "InputmaskView.h"
#import "ChoiceIndustryViewController.h"
@implementation InputmaskView


- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    
    return YES;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.backgroundColor = [UIColor clearColor];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapAction:)]];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-275)/2, (SCREEN_HEIGHT-130-143)/2, 275, 143)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
         _textfield= [[UITextField alloc]initWithFrame:CGRectMake((view.width-259)/2, (view.height-38)/2, 259, 38)];
        _textfield.backgroundColor = [PublicUseMethod setColor:KColor_Text_ListColor];
        _textfield.textAlignment = NSTextAlignmentCenter;
        _textfield.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
        _textfield.placeholder = @"添加公司行业";
        _textfield.font = [UIFont systemFontOfSize:15];
        _textfield.clearsOnBeginEditing = YES;
        _textfield.layer.cornerRadius = 5.0;
        _textfield.layer.masksToBounds = YES;
        _textfield.delegate = self;
        _textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        [view addSubview:_textfield];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(_textfield.left+4, 10, 251, 38)];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [PublicUseMethod setColor:KColor_Text_ListColor];
        label.text = @"请填写公司行业，最多10个字";
        label.font = [UIFont systemFontOfSize:15];
        UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(_textfield.left, view.height-51, 275/2, 51)];
        [cancel setTitle:@"取消"forState:UIControlStateNormal];
        [cancel setTitleColor:[PublicUseMethod setColor:KColor_Text_ListColor] forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        cancel.tag = 10;
        UIButton *sure = [[UIButton alloc]initWithFrame:CGRectMake(cancel.right, view.height-51, 275/2, 51)];
        [sure setTitle:@"确定"forState:UIControlStateNormal];
        [sure setTitleColor:[PublicUseMethod setColor:KColor_Text_ListColor] forState:UIControlStateNormal];
        [sure addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        sure.tag = 11;
        [view addSubview:label];
        [view addSubview:cancel];
        [view addSubview:sure];
        [self addSubview:view];
    }
    return self;
}
- (void)TapAction:(UITapGestureRecognizer*)tap
{
 [UIView animateWithDuration:.35 animations:^{
     [self.textfield resignFirstResponder];
 }];
}
- (void)buttonAction:(UIButton*)button
{
    if (button.tag ==10) {
        //
        [UIView animateWithDuration:.35 animations:^{
            self.hidden = YES;
        }];

    }else
    {

        ChoiceIndustryViewController *editVC =(ChoiceIndustryViewController*)[self viewController];
        
        NSString *tagStr = [_textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (tagStr.length == 0) {
            [PublicUseMethod showAlertView:@"请正确输入标签信息!"];
            return;
        }
        
        if (tagStr.length > 10) {
            [PublicUseMethod showAlertView:@"最多输入10个字,请重新输入"];
            return;
        }
        
        [editVC.mutableArray insertObject:_textfield.text atIndex:editVC.mutableArray.count-1];
        [editVC.signView.collectionView reloadData];
        [UIView animateWithDuration:.35 animations:^{
            self.hidden = YES;
        }];
        _textfield.text = nil;
    }
}
- (UIViewController*)viewController
{
    UIResponder *next = self;
    do {
        next = next.nextResponder;
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)next;
        }
    } while (next!=nil);
    return nil;
}
@end
