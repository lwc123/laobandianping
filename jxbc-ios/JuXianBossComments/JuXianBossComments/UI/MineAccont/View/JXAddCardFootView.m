//
//  JXAddCardFootView.m
//  JuXianBossComments
//
//  Created by wy on 16/12/21.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXAddCardFootView.h"

@implementation JXAddCardFootView
+(instancetype)addCardFootView
{
    UINib *nib = [UINib nibWithNibName:@"JXAddCardFootView" bundle:nil];
    JXAddCardFootView *View = [nib instantiateWithOwner:nil options:nil][0];
    return View;
}


- (void)awakeFromNib{

    [super awakeFromNib];
    [self.getMoneyClick setBackgroundImage:[UIImage imageNamed:@"timeButton"] forState:UIControlStateNormal];
}

@end
