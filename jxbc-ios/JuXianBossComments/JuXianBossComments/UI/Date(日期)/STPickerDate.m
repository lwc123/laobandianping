//
//  STPickerDate.m
//  STPickerView
//
//  Created by https://github.com/STShenZhaoliang/STPickerView on 16/2/16.
//  Copyright © 2016年 shentian. All rights reserved.
//

#import "STPickerDate.h"
#import "NSCalendar+ST.h"
@interface STPickerDate()<UIPickerViewDataSource, UIPickerViewDelegate>
/** 1.年 */
@property (nonatomic, assign)NSInteger year;
/** 2.月 */
@property (nonatomic, assign)NSInteger month;
/** 3.日 */
@property (nonatomic, assign)NSInteger day;
/** 4.今年 */
@property (nonatomic, assign)NSInteger currentYear;//SC.XJH.12.26
/** 4.今月 */
@property (nonatomic, assign)NSInteger currentMonth;//SC.XJH.12.26
/** 4.今日 */
@property (nonatomic, assign)NSInteger currentDay;//SC.XJH.12.26

@end

@implementation STPickerDate

#pragma mark - --- init 视图初始化 ---

- (void)setupUI {
    
    self.title = @"请选择日期";
    _yearLeast = 1900;
    _currentYear = [NSCalendar currentYear];//SC.XJH.12.26
    _currentMonth = [NSCalendar currentMonth];
    _currentDay = [NSCalendar currentDay];
    _yearSum   = _currentYear-_yearLeast+1;//SC.XJH.12.26
    _heightPickerComponent = 28;
    
    
    _year  = [NSCalendar currentYear];
    _month = [NSCalendar currentMonth];
    _day   = [NSCalendar currentDay];
    
    
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
    
    //SC.XJH.12.26初次打开选中cell
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    [self.pickerView selectRow:0 inComponent:1 animated:NO];
    [self.pickerView selectRow:0 inComponent:2 animated:NO];
}

#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //SC.XJH.12.26重写
    if (component == 0) {
        return self.yearSum;
    }else if(component == 1) {
        //SC.XJH.12.26判断如果是当前年，则最多只显示到当前月
        if ((_currentYear - [pickerView selectedRowInComponent:0]) == _currentYear) {
            return _currentMonth;
        }
        return 12;
    }else {
        //SC.XJH.12.26判断如果是当前年，月，则最多只显示到当日
        NSInteger yearSelected = _currentYear - [pickerView selectedRowInComponent:0];
        //SC.XJH.1.11
        NSInteger monthSelected = 0;
        if (yearSelected == _currentYear) {
            monthSelected = _currentMonth-[pickerView selectedRowInComponent:1];
        }else{
            monthSelected = 12-[pickerView selectedRowInComponent:1];
        }
        
        
        
        if (yearSelected == _currentYear && monthSelected == _currentMonth) {
            return _currentDay;
        }
        return  [NSCalendar getDaysWithYear:yearSelected month:monthSelected];
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
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            //SC.XJH.12.26滚动年，则刷新月日
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            break;
        case 1:
            [pickerView reloadComponent:2];
            //SC.XJH.12.26滚动月则刷新日
            [pickerView selectRow:0 inComponent:2 animated:YES];
        default:
            break;
    }
    
    [self reloadData];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    
    NSString *text;
    //SC.XJH.12.26重写年月日三个cell的显示，判断主要对当前年月日的处理
    if (component == 0) {
        text =  [NSString stringWithFormat:@"%zd年", _currentYear-row];//SC.XJH.12.26
        
    }else if (component == 1){
        if ((_currentYear - [pickerView selectedRowInComponent:0]) == _currentYear) {
            text =  [NSString stringWithFormat:@"%zd月", _currentMonth-row];//SC.XJH.12.26
        }else{
            text =  [NSString stringWithFormat:@"%zd月", 12-row];//SC.XJH.12.26
        }
    }else{
        NSInteger yearSelected = _currentYear - [pickerView selectedRowInComponent:0];
        
        //SC.XJH.1.11
        NSInteger monthSelected = 0;
        if (yearSelected == _currentYear) {
            monthSelected = _currentMonth-[pickerView selectedRowInComponent:1];
        }else{
            monthSelected = 12-[pickerView selectedRowInComponent:1];
        }
        if (yearSelected == _currentYear && monthSelected == _currentMonth) {
            text = [NSString stringWithFormat:@"%zd日", _currentDay-row];//SC.XJH.12.26
        }else{
            text = [NSString stringWithFormat:@"%zd日", [NSCalendar getDaysWithYear:yearSelected month:monthSelected]-row];//SC.XJH.12.26
        }
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
    [self reloadData];
    if ([self.delegate respondsToSelector:@selector(pickerDate:year:month:day:)]) {
        [self.delegate pickerDate:self year:self.year month:self.month day:self.day];
    }
    [super selectedOk];
}

#pragma mark - --- private methods 私有方法 ---

- (void)reloadData
{
    //SC.XJH.12.26重写，当前年月日的选择
    self.year  =  _currentYear - [self.pickerView selectedRowInComponent:0];
    
    if (self.year == _currentYear) {
        self.month = _currentMonth - [self.pickerView selectedRowInComponent:1];
    }else{
        self.month = 12 - [self.pickerView selectedRowInComponent:1];
    }
    
    if (self.year == _currentYear && self.month == _currentMonth) {
        self.day   = _currentDay - [self.pickerView selectedRowInComponent:2];
    }else{
        self.day   = [NSCalendar getDaysWithYear:self.year month:self.month] - [self.pickerView selectedRowInComponent:2];
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


#pragma mark - 预选
- (void)selectedDateWithString:(NSString*)dateString{
    
    if (!dateString) {
        return;
    }
    
    if (dateString.length == 0) {
        return;
    }
    NSInteger year = [[dateString substringWithRange:NSMakeRange(0, 4)] integerValue];
    NSInteger mouth = [[dateString substringWithRange:NSMakeRange(5, 2)] integerValue] ;
    NSInteger day = [[dateString substringWithRange:NSMakeRange(8, 2)] integerValue];

    [self.pickerView selectRow:(_currentYear - year) inComponent:0 animated:NO];
    [self.pickerView reloadAllComponents];
    if (_currentYear == year) {
        [self.pickerView selectRow:(_currentMonth - mouth) inComponent:1 animated:NO];
        [self.pickerView reloadAllComponents];
        if (_currentMonth == mouth) {
            [self.pickerView selectRow:( _currentDay-day) inComponent:2 animated:NO];
            [self.pickerView reloadAllComponents];
        }else{
            [self.pickerView selectRow:( [NSCalendar getDaysWithYear:year month:mouth]-day) inComponent:2 animated:NO];
            [self.pickerView reloadAllComponents];
        }
    }else{
        [self.pickerView selectRow:(12 - mouth) inComponent:1 animated:NO];
        [self.pickerView reloadAllComponents];
        [self.pickerView selectRow:( [NSCalendar getDaysWithYear:year month:mouth]-day) inComponent:2 animated:NO];
        [self.pickerView reloadAllComponents];

        
    }

}



@end


