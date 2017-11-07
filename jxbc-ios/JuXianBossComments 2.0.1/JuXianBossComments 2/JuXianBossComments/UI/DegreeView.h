//
//  DegreeView.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/5/15.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^dataBlock)(NSString *dataStr,NSInteger index);
@interface DegreeView : UIView<UIGestureRecognizerDelegate>
@property (nonatomic,copy)dataBlock block;
@property (nonatomic,strong)NSArray *cellData;
@property (nonatomic,copy)NSString *title;
@property (nonatomic, strong) UIPickerView *picker;
- (void)loadDegreeView;
@end
