//
//  JHPublicPicker.m
//  datePicker
//
//  Created by easemob on 2017/1/1.
//  Copyright © 2017年 沈冲. All rights reserved.
//

#import "JHPublicPicker.h"

@interface JHPublicPicker()<UIPickerViewDataSource, UIPickerViewDelegate>
/** 1.选中的字符串 */
@property (nonatomic, strong, nullable)NSString *selectedTitle;

@end

@implementation JHPublicPicker

- (void)setupUI
{
    [super setupUI];
    
    _titleUnit = @"123";
    _arrayData = @[@"1",@"2",@"3",@"4",@"5",@"6"].mutableCopy;
    _heightPickerComponent = 32;
    _widthPickerComponent = 32;
    
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
}

#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.arrayData.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}

//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
//{
//    
////    if (component == 0) {
////        return (self.st_width-self.widthPickerComponent)/2;
////    }else if (component == 1){
//        return self.widthPickerComponent;
////    }else {
////        return (self.st_width-self.widthPickerComponent)/2;
////    }
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedTitle = self.arrayData[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{

    UILabel *label = [[UILabel alloc]init];
    [label setText:self.arrayData[row]];
    [label setTextAlignment:NSTextAlignmentCenter];
    return label;
}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    if ([_delegate respondsToSelector:@selector(pickerPublic:selectedTitle:)]) {
        [self.delegate pickerPublic:self selectedTitle:self.selectedTitle];
    }
    [super selectedOk];
}

#pragma mark - --- private methods 私有方法 ---

#pragma mark - --- setters 属性 ---

- (void)setArrayData:(NSMutableArray<NSString *> *)arrayData
{
    _arrayData = arrayData;
    _selectedTitle = arrayData.firstObject;
    [self.pickerView reloadAllComponents];
}

- (void)setTitleUnit:(NSString *)titleUnit
{
    _titleUnit = titleUnit;
    [self.pickerView reloadAllComponents];
}


@end
