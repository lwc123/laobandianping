//
//  JHTextNumberView.h
//  JuXianBossComments
//
//  Created by juxian on 2017/4/14.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWTextView.h"

@interface JHTextNumberView : UIView
@property (nonatomic, strong) IWTextView *myTextView;
- (instancetype)initWithplacehoder:(NSString *)placehoder
                        numbertaxt:(NSString *)numberText
                    textViewHeight:(CGFloat)textViewHeight;
@end
