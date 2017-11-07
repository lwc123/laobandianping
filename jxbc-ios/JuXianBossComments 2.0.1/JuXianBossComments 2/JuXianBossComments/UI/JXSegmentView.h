//
//  JXSegmentView.h
//  JuXianBossComments
//
//  Created by Jam on 17/2/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonClickBlock)();

@interface JXSegmentView : UIView

@property (nonatomic, copy) NSString *leftButtonTitle;
@property (nonatomic, copy) NSString *rightButtonTitle;

+ (instancetype)segmentView;

- (void)leftButtonClickCompletHandle:(ButtonClickBlock)buttonClickBlock;
- (void)rightButtonClickCompletHandle:(ButtonClickBlock)buttonClickBlock;

@end
