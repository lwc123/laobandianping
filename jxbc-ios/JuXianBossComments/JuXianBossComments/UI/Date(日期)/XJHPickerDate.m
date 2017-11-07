//
//  STPickerDate.m
//  STPickerView
//
//  Created by https://github.com/STShenZhaoliang/STPickerView on 16/2/16.
//  Copyright © 2016年 shentian. All rights reserved.
//

#import "XJHPickerDate.h"
#import "NSCalendar+ST.h"
@interface XJHPickerDate()<UIPickerViewDataSource, UIPickerViewDelegate>
/** 1.年 */
@property (nonatomic, assign)NSInteger year;
/** 2.月 */
@property (nonatomic, assign)NSInteger month;
/** 3.日 */
@property (nonatomic, assign)NSInteger day;

@property (nonatomic, assign) BOOL isNow;

@end

@implementation XJHPickerDate

#pragma mark - --- init 视图初始化 ---

- (void)setupUI {
    
    self.title = @"请选择日期";
    _isNow = NO;
    //其实年份
    _yearLeast = 1980;
    _yearSum   = [NSCalendar currentYear]-_yearLeast+1;
    _heightPickerComponent = 28;
    
    _year  = [NSCalendar currentYear];
    _month = [NSCalendar currentMonth];
    _day   = [NSCalendar currentDay];
    
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
    
    if (_isNow) {
        [self.pickerView selectRow:0 inComponent:0 animated:NO];
        [self.pickerView selectRow:0 inComponent:1 animated:NO];
        [self.pickerView selectRow:0 inComponent:2 animated:NO];
        
        _year  = 0;
        _month = 0;
        _day   = 0;
    }else{
        [self.pickerView selectRow:(_year - _yearLeast) inComponent:0 animated:NO];
        [self.pickerView selectRow:(_month - 1) inComponent:1 animated:NO];
        [self.pickerView selectRow:(_day - 1) inComponent:2 animated:NO];
    }
}

#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.yearSum+1;
    }else if(component == 1) {
        if (_isNow) {
            return 0;
        }else{
            NSInteger yearSelected = [NSCalendar currentYear]-[pickerView selectedRowInComponent:0]+1;
            //加判断完善了最多只能选择到当前月
            if (yearSelected==[NSCalendar currentYear]) {
                return [NSCalendar currentMonth];
            }
            return 12;
        }
    }else {
        if (_isNow) {
            return 0;
        }else{
            NSInteger yearSelected = [NSCalendar currentYear]-[pickerView selectedRowInComponent:0]+1;
            NSInteger monthSelected = [pickerView selectedRowInComponent:1] + 1;
            NSLog(@"monthSelected==%ld",monthSelected);
            //加判断完善了最多只能选择到当前日
            if (monthSelected == [NSCalendar currentMonth]) {
                return [NSCalendar currentDay];
            }
            return  [NSCalendar getDaysWithYear:yearSelected month:monthSelected];
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            if (row==0) {
                _isNow = YES;
            }else{
                _isNow = NO;
            }
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            break;
        case 1:
            [pickerView reloadComponent:2];
            //这个很神奇，加上之后还能解决pickerView在滑动的时候的bug
            [pickerView selectRow:0 inComponent:2 animated:YES];
        default:
            break;
    }
    
    [self reloadDataIsNow:_isNow];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    
    NSString *text;
    if (component == 0) {
        if (row==0) {
            text = @"至今";
        }else{
            //加1，修复了显示年份少1
            text =  [NSString stringWithFormat:@"%zd年", [NSCalendar currentYear]-row+1];
        }
    }else if (component == 1){
        text =  [NSString stringWithFormat:@"%zd月", row + 1];
    }else{
        text = [NSString stringWithFormat:@"%zd日", row + 1];
    }

    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:17]];
    [label setText:text];
    return label;
}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    if ([self.delegate respondsToSelector:@selector(xjhPickerDate:year:month:day:)]) {
         [self.delegate xjhPickerDate:self year:self.year month:self.month day:self.day];
    }
   
    [super selectedOk];
}

#pragma mark - --- private methods 私有方法 ---

- (void)reloadDataIsNow:(BOOL)isNow
{
    if (isNow) {
        self.year  = 0;
        self.month = 0;
        self.day   = 0;
    }else{
        //加1，修复了选择2016年输入框显示2015的问题
        self.year  = [NSCalendar currentYear]-[self.pickerView selectedRowInComponent:0]+1;
        self.month = [self.pickerView selectedRowInComponent:1] + 1;
        self.day   = [self.pickerView selectedRowInComponent:2] + 1;
    }
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
#pragma mark - --- getters 属性 ---


@end


