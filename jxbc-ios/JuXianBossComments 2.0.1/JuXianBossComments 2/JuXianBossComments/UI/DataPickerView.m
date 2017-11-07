//
//  DataPickerView.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/5/12.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "DataPickerView.h"
#import "NSCalendar+ST.h"

@interface DataPickerView()
@property (nonatomic, assign) NSInteger currentYear;
@property (nonatomic, assign) NSInteger currentMonth;
@property (nonatomic, assign) NSInteger currentDay;

@property (nonatomic, strong) NSMutableArray *yearArray;
@property (nonatomic, strong) NSMutableArray *mothArray;
@property (nonatomic, strong) NSMutableArray *toMothArray;

@end

@implementation DataPickerView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:.45];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapAction:)]];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 225+150, SCREEN_WIDTH, 40)];
        view.backgroundColor = [PublicUseMethod setColor:@"666666"];
        UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 90) *0.5,0,90,40)];
        dateLabel.backgroundColor = [PublicUseMethod setColor:@"666666"];
//        dateLabel.text = @"里  弄";
        dateLabel.textColor = [UIColor whiteColor];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.font = [UIFont systemFontOfSize:12];
        [view addSubview:dateLabel];
        
        UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
        button1.backgroundColor = [PublicUseMethod setColor:@"666666"];
        [button1 setTitle:@"取消" forState:UIControlStateNormal];
        button1.titleLabel.font = [UIFont systemFontOfSize:12];
        [button1 setTitleColor:[PublicUseMethod setColor:@"CCCCCC"] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button1];
        
        UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, 0, 50, 40)];
        button2.backgroundColor = [PublicUseMethod setColor:@"666666"];
        [button2 setTitle:@"确定" forState:UIControlStateNormal];
                button2.titleLabel.font = [UIFont systemFontOfSize:12];
        [button2 setTitleColor:[PublicUseMethod setColor:KColor_GoldColor] forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button2];
        [self addSubview:view];
    }
    return self;
}
#pragma mark - TapAction
- (void)TapAction:(UITapGestureRecognizer*)tap
{
    [UIView animateWithDuration:.35 animations:^{
        [self removeFromSuperview];
    }];
}
- (void)cancelAction:(UIButton*)button
{
    [UIView animateWithDuration:.35 animations:^{
        [self removeFromSuperview];

    }];
}
#pragma mark - 确认按钮
- (void)sureAction:(UIButton*)button
{
    
    NSString *mothStr;
    NSString *noMothStr;

    if ([self.yearArray[[_pickerView selectedRowInComponent:0]] integerValue] ==_currentYear && _currentMonth<12) {

        mothStr = [NSString stringWithFormat:@"%@月",self.toMothArray[[_pickerView selectedRowInComponent:1]]];
        noMothStr = [NSString stringWithFormat:@"%@",self.toMothArray[[_pickerView selectedRowInComponent:1]]];
    }else{
        
        mothStr = [NSString stringWithFormat:@"%@月",self.mothArray[[_pickerView selectedRowInComponent:1]]];
        noMothStr = [NSString stringWithFormat:@"%@",self.mothArray[[_pickerView selectedRowInComponent:1]]];
    }

    NSString *yearStr = [NSString stringWithFormat:@"%@",self.yearArray[[_pickerView selectedRowInComponent:0]]];
    #pragma mark - wait
    NSString *dayStr = [NSString stringWithFormat:@"%zd",[_pickerView selectedRowInComponent:2]+1];

    NSString *dataStr;
    NSString *noDateStr;

    if(_isEndTime && [self.yearArray[[_pickerView selectedRowInComponent:0]] isEqualToString:@"至今"] ) {
        dataStr =[NSString stringWithFormat:@"%@",yearStr];
    }else{
        dataStr =[NSString stringWithFormat:@"%@年%@%@日",yearStr,mothStr,dayStr];
        noDateStr = [NSString stringWithFormat:@"%@.%@",yearStr,noMothStr];
        
    }
    __weak DataPickerView *Weakself = self;
    [UIView animateWithDuration:.35 animations:^{
        Weakself.hidden = YES;
    }];
    
    if (_block) {
        _block(dataStr,noDateStr);
    }
    
}
-(UIViewController*)viewController
{
    UIResponder *nextResponder =  self;
    
    do
    {
        nextResponder = [nextResponder nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController*)nextResponder;
        
    } while (nextResponder != nil);
    
    return nil;
}
- (void)loadPickerView;
{
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 225+190, SCREEN_WIDTH, SCREEN_HEIGHT-64-225-190- 10)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    _currentYear = [NSCalendar currentYear];
    _currentMonth = [NSCalendar currentMonth];
    _currentDay = [NSCalendar currentDay];
    
    [self addSubview:_pickerView];
    
}
#pragma mark - 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
#pragma mark - 行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return self.yearArray.count;
    }else if(component==1){
        NSInteger selectedRow = [_pickerView selectedRowInComponent:0];

        if(_isEndTime && 0 == selectedRow){
            return 0;
        }else if(_isEndTime && selectedRow ==1){
            return self.toMothArray.count;

        }else if (!_isEndTime && selectedRow ==0){
            return self.toMothArray.count;

        }else{
        
            return self.mothArray.count;
        }
        
        
    }else{
        if(_isEndTime && [self.yearArray[[_pickerView selectedRowInComponent:0]] isEqualToString:@"至今"] ) {
            return 0;
        }else{
            
            NSInteger selectedYear = _currentYear;
            NSInteger selectedMouth = [self.pickerView selectedRowInComponent:1]+1;
            // 先计算选中的年份
            if (_isEndTime) {
                selectedYear = _currentYear + 1 - [self.pickerView selectedRowInComponent:0];
            }else{
                selectedYear = _currentYear  - [self.pickerView selectedRowInComponent:0];
            }
            // 判断是不是当前年
            if(selectedYear == _currentYear) { // 是当前年
                // 判断是不是当前月
                if (_currentMonth == selectedMouth) {
                    return [NSCalendar currentDay];
                }else{
                    return [NSCalendar getDaysWithYear:selectedYear month:selectedMouth];
                }

            }else{ // 不是当前年
                return [NSCalendar getDaysWithYear:selectedYear month:selectedMouth];

            }
            
        }
    }
}

#pragma mark - dataSource
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0) {
        if (_isEndTime && row==0) {
            return [NSString stringWithFormat:@"%@",self.yearArray[row]];
        }else{
            return [NSString stringWithFormat:@"%@年",self.yearArray[row]];
        }
    }
    else if(component == 1){
        return [NSString stringWithFormat:@"%@月",self.mothArray[row]];
    }else{
        return [NSString stringWithFormat:@"%zd日",row+1];
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0) {
        [_pickerView reloadComponent:1];
        [_pickerView reloadComponent:2];
    }
    if (component==1) {
        [_pickerView reloadComponent:2];
    }
    
}

- (NSMutableArray *)yearArray{
    
    if (!_yearArray) {
        _yearArray = [NSMutableArray array];
        
        if (_isEndTime) {
            [_yearArray addObject:@"至今"];
            for (NSInteger i = _currentYear; i>=_currentYear-24; i--) {
                [_yearArray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
            }
        }else{
        
            for (NSInteger i = _currentYear; i>=_currentYear-24; i--) {
                [_yearArray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
            }
        }
    }
    
    return _yearArray;
}
- (NSMutableArray *)mothArray{

    if (!_mothArray) {
        _mothArray = [NSMutableArray array];
        
        for (NSInteger j=1; j<13; j++) {
            
            if(j<10){
                [_mothArray addObject:[NSString stringWithFormat:@"0%ld",(long)j]];
            }else{
                [_mothArray addObject:[NSString stringWithFormat:@"%ld",(long)j]];
            }
            
        }
    }
    return  _mothArray;
}
- (NSMutableArray *)toMothArray{
    
    if (!_toMothArray) {
        _toMothArray = [NSMutableArray array];
        for (NSInteger j=1; j<_currentMonth+1; j++) {
            if (j<10) {
                [_toMothArray addObject:[NSString stringWithFormat:@"0%ld",(long)j]];
            }else{
                [_toMothArray addObject:[NSString stringWithFormat:@"%ld",(long)j]];
            }
            
        }
    }
    return  _toMothArray;
}

#pragma mark - 预选
- (void)selectedDateWithString:(NSString*)dateString{
    
    if (!dateString) {
        return;
    }
    
    if (dateString.length == 0) {
        return;
    }
    if ([dateString isEqualToString:@"至今"]) {
        [self.pickerView selectRow:0 inComponent:0 animated:NO];
        [self.pickerView reloadComponent:1];
        [self.pickerView reloadComponent:2];

        return;
    }
    NSInteger year = _currentYear;
    NSInteger mouth = _currentMonth;
    NSInteger day = _currentDay;
    if ([dateString containsString:@"日"]) {
        year = [[dateString substringWithRange:NSMakeRange(0, 4)] integerValue];
        mouth = [[dateString substringWithRange:NSMakeRange(5, 2)] integerValue];
        day = [[dateString substringWithRange:NSMakeRange(8, 2)] integerValue];

    }else{
        year = [[dateString substringWithRange:NSMakeRange(0, 4)] integerValue];
        mouth = [[dateString substringWithRange:NSMakeRange(5, 2)] integerValue];
        day = 1;

    }
    
    
    
    if (_isEndTime) {
        [self.pickerView selectRow:(_currentYear - year + 1) inComponent:0 animated:NO];
        [self.pickerView reloadComponent:1];
    }else{
        [self.pickerView selectRow:(_currentYear - year) inComponent:0 animated:NO];
        [self.pickerView reloadComponent:1];
    }
    
    if (_currentYear == year) {
        [self.pickerView selectRow:(mouth-1) inComponent:1 animated:NO];
        [self.pickerView reloadComponent:2];
        if (_currentMonth == mouth) {
            [self.pickerView selectRow:(day-1) inComponent:2 animated:NO];
//            [self.pickerView reloadAllComponents];
        }else{
            [self.pickerView selectRow:(day-1) inComponent:2 animated:NO];
//            [self.pickerView reloadAllComponents];
        }
    }else{
        [self.pickerView selectRow:(mouth-1) inComponent:1 animated:NO];
        [self.pickerView reloadComponent:2];
        [self.pickerView selectRow:(day-1) inComponent:2 animated:NO];
        
        
        
    }
    
}


@end
