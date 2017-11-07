//
//  STPickerDate.h
//  STPickerView
//
//  Created by https://github.com/STShenZhaoliang/STPickerView on 16/2/16.
//  Copyright © 2016年 shentian. All rights reserved.
//

#import "STPickerView.h"
NS_ASSUME_NONNULL_BEGIN
@class XJHPickerDate;
@protocol  XJHPickerDateDelegate<NSObject>
- (void)xjhPickerDate:(XJHPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

@end
@interface XJHPickerDate : STPickerView

/** 1.最小的年份，default is 1900 */
@property (nonatomic, assign)NSInteger yearLeast;
/** 2.显示年份数量，default is 200 */
@property (nonatomic, assign)NSInteger yearSum;
/** 3.中间选择框的高度，default is 28*/
@property (nonatomic, assign)CGFloat heightPickerComponent;

@property(nonatomic, weak)id <XJHPickerDateDelegate>delegate ;

@end
NS_ASSUME_NONNULL_END
