//
//  locationPicker.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/23.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "locationPicker.h"

@implementation locationPicker
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:.45];
       [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapAction:)]];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 225+70, SCREEN_WIDTH, 40)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        button1.backgroundColor = [UIColor whiteColor];
        [button1 setTitle:@"取消" forState:UIControlStateNormal];
        button1.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [button1 setTitleColor:[PublicUseMethod setColor:KColor_MainColor] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button1];
        
        
        
        UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, 0, 60, 40)];
        button2.backgroundColor = [UIColor whiteColor];
        [button2 setTitle:@"确定" forState:UIControlStateNormal];
        button2.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [button2 setTitleColor:[PublicUseMethod setColor:KColor_MainColor] forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button2];
        [self addSubview:view];

    }
    return self;
}
- (void)loadPickerView;
{
    //数据
    NSString *filepath = [[NSBundle mainBundle]pathForResource:@"Address" ofType:@"plist"];
    _pickerDic = [[NSDictionary alloc]initWithContentsOfFile:filepath];
    self.provinceArray = [_pickerDic allKeys];
    self.selectedArray = _pickerDic[_provinceArray[0]];
    if (self.selectedArray.count>0) {
        //有数据取城市
        self.cityArray = [_selectedArray[0]allKeys];
    }
    if (self.cityArray.count>0) {
        self.townArray = [_selectedArray[0]objectForKey:_cityArray[0]
                          ];
    }
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 225+100, SCREEN_WIDTH, SCREEN_HEIGHT-64-225-100)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [self addSubview:_pickerView];
    
}
#pragma mark - TapAction
- (void)TapAction:(UITapGestureRecognizer*)tap
{
    
    [UIView animateWithDuration:.35 animations:^{
        self.hidden = YES;
    }];
   
}
- (void)cancelAction:(UIButton*)button
{
    [UIView animateWithDuration:.35 animations:^{
        self.hidden = YES;
    }];
}
- (void)sureAction:(UIButton*)button
{
//    label.text =[NSString stringWithFormat:@"%@.%@.%@",self.provinceArray[[self.pickerView selectedRowInComponent:0]],self.cityArray[[self.pickerView selectedRowInComponent:1]],self.townArray[[self.pickerView selectedRowInComponent:2]]];
    self.label.text =[NSString stringWithFormat:@"%@",self.cityArray[[self.pickerView selectedRowInComponent:1]]];
    __weak locationPicker *weakSelf = self;
    [UIView animateWithDuration:.35 animations:^{
        weakSelf.hidden = YES;
    }];
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

#pragma mark - UIPickerViewDelegate UIPickerViewDatasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return _provinceArray.count;
    }else if (component==1)
    {
        return _cityArray.count;
    }
    return _townArray.count;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (SCREEN_WIDTH==320) {
        if (component == 0) {
            return 110;
        } else if (component == 1) {
            return 100;
        } else {
            return 110;
        }
        
    }
    else
    {
        if (component == 0) {
            return 130;
        } else if (component == 1) {
            return 115;
        } else {
            return 130;
        }
    }
    
}

//---最重要的两个delegate
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0) {
        return _provinceArray[row];
    }else if (component==1)
    {
        return _cityArray[row];
    }
    return _townArray[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0) {
        self.selectedArray = self.pickerDic[_provinceArray[row]];
        if (self.selectedArray.count>0) {
            self.cityArray = [self.selectedArray[0]allKeys];
        }else {
            self.cityArray = nil;
        }
        if (self.cityArray.count>0) {
            self.townArray = self.selectedArray[0][_cityArray[0]];
        }else
        {
            self.townArray = nil;
        }
        [pickerView reloadComponent:1];//刷新
        
        //保证已经选中的不变(默认选中)。。没啥11
        [pickerView selectedRowInComponent:1];
        [pickerView selectedRowInComponent:2];
    }
    else if (component==1)
    {
        if (self.selectedArray.count>0&&self.cityArray.count>0) {
            //
            self.townArray = _selectedArray[0][_cityArray[row]];
        }else
        {
            self.townArray = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    [pickerView reloadComponent:2];//刷新
}
- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 125, 30)];
    
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    if (component==0) {
        if (self.cityArray.count>0) {
            label.text = self.provinceArray[row];
        }
        return label;
    }
    else if (component==1)
    {
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 115, 30)];
        
        label1.font = [UIFont systemFontOfSize:14];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.backgroundColor = [UIColor whiteColor];
        if (self.cityArray.count>0) {
            label1.text = self.cityArray[row];
        }
        return label1;
    }
    else{
        if (self.townArray.count>0) {
            label.text = self.townArray[row];        }
        
        return label;
    }
    
}

@end
