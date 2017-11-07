//
//  XJHYearPicker.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/10.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "XJHYearPicker.h"
#import "NSCalendar+ST.h"
@interface XJHYearPicker()<UIPickerViewDataSource, UIPickerViewDelegate>
/** 1.年 */
@property (nonatomic, assign)NSInteger year;
/** 2.今年 */
@property (nonatomic, assign)NSInteger currentYear;//SC.XJH.12.26
@end

@implementation XJHYearPicker
#pragma mark - --- init 视图初始化 ---

- (void)setupUI {
    
    self.title = @"请选择日期";
    
    _yearLeast = 1960;
    _currentYear = [NSCalendar currentYear];//SC.XJH.12.26
    _yearSum   = _currentYear-_yearLeast+1;//SC.XJH.12.26
    _heightPickerComponent = 28;
    
    _year  = [NSCalendar currentYear];
    
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
    //SC.XJH.12.26
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
}

#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.yearSum;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self reloadData];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    
    NSString *text = [NSString stringWithFormat:@"%zd年", _currentYear-row];//SC.XJH.12.26
    
    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:17]];
    [label setText:text];
    return label;
}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    self.year  = _currentYear - [self.pickerView selectedRowInComponent:0];

    if ([self.delegate respondsToSelector:@selector(pickerDate:year:)]) {
        [self.delegate pickerDate:self year:self.year];
    }
    
    [super selectedOk];
}

#pragma mark - --- private methods 私有方法 ---

- (void)reloadData
{
    //SC.XJH.12.26
    self.year  = _currentYear - [self.pickerView selectedRowInComponent:0];
}

#pragma mark - --- setters 属性 ---

- (void)setYearLeast:(NSInteger)yearLeast
{
    _yearLeast = yearLeast;
}

- (void)setYearSum:(NSInteger)yearSum
{
    _yearSum = yearSum;
}

@end
