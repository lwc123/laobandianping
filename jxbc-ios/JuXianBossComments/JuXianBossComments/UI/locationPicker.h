//
//  locationPicker.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/23.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface locationPicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,strong)UIPickerView *pickerView;
@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;
@property (strong, nonatomic) NSArray *selectedArray;
@property (strong, nonatomic) NSDictionary *pickerDic;

@property (nonatomic,strong)UILabel *label;
- (void)loadPickerView;
@end
