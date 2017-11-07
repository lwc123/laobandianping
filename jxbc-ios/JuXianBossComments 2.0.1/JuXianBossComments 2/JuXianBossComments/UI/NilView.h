//
//  NilView.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/5/23.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^refreshBlock)();
@interface NilView : UIView
@property (nonatomic,assign)BOOL isHiddenButton;
@property (nonatomic,copy)NSString *labelStr;
@property (nonatomic,copy)refreshBlock block;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *buttonTitle;
@end
