//
//  XJHYearPicker.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/10.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "STPickerView.h"
NS_ASSUME_NONNULL_BEGIN
@class XJHYearPicker;

@protocol  XJHYearPickerDelegate<NSObject>
- (void)pickerDate:(XJHYearPicker *)pickerDate year:(NSInteger)year;

@end


@interface XJHYearPicker : STPickerView

/** 1.最小的年份，default is 1900 */
@property (nonatomic, assign)NSInteger yearLeast;
/** 2.显示年份数量，default is 200 */
@property (nonatomic, assign)NSInteger yearSum;
/** 3.中间选择框的高度，default is 28*/
@property (nonatomic, assign)CGFloat heightPickerComponent;

@property(nonatomic, weak)id <XJHYearPickerDelegate>delegate ;
@property (nonatomic,assign)BOOL isEndTime;

@end
NS_ASSUME_NONNULL_END
