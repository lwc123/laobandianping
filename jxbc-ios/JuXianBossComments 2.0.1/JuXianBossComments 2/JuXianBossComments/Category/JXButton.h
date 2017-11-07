//
//  JXButton.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/2/29.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXButton : UIButton
@property (nonatomic,assign)BOOL imageLeft;
@property (nonatomic,assign)BOOL imageRight;
@property (nonatomic,assign)CGFloat leftGrap;
@property (nonatomic,assign)CGFloat rightGrap;
@property (nonatomic,assign)CGFloat topGrap;
@property (nonatomic,assign)CGFloat bottomGrap;

@property (nonatomic,assign)CGSize imageSize;
@property (nonatomic,assign)CGSize  titleSize;


@end
