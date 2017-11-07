//
//  DataPickerView.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/5/12.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^dataBlock)(NSString *dataStr,NSString *noDateStr);


@interface DataPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,strong)UIPickerView *pickerView;
@property (nonatomic,copy)dataBlock block;
@property (nonatomic,assign)BOOL isEndTime;
- (void)loadPickerView;
@property (nonatomic,copy)NSString *titleStr;

// 预选
- (void)selectedDateWithString:(NSString*)dateString;

@end
