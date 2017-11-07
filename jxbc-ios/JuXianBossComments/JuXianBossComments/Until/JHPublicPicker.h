//
//  JHPublicPicker.h
//  datePicker
//
//  Created by easemob on 2017/1/1.
//  Copyright © 2017年 沈冲. All rights reserved.
//

#import "STPickerView.h"
NS_ASSUME_NONNULL_BEGIN
@class JHPublicPicker;
@protocol  JHPublicPickerDelegate<NSObject>
- (void)pickerPublic:(JHPublicPicker *)pickerPublic selectedTitle:(NSString *)selectedTitle;
@end
@interface JHPublicPicker : STPickerView

/** 1.设置字符串数据数组 */
@property (nonatomic, strong)NSMutableArray<NSString *> *arrayData;
/** 2.设置单位标题 */
@property (nonatomic, strong)NSString *titleUnit;
/** 3.中间选择框的高度，default is 44*/
@property (nonatomic, assign)CGFloat heightPickerComponent;
/** 4.中间选择框的宽度，default is 32*/
@property (nonatomic, assign)CGFloat widthPickerComponent;
@property(nonatomic, weak)id <JHPublicPickerDelegate>delegate;

@end
NS_ASSUME_NONNULL_END
