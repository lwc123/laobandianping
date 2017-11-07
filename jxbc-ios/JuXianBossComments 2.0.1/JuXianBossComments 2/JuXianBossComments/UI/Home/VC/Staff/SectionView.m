//
//  SectionView.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/9.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "SectionView.h"

@implementation SectionView

+(instancetype)sectionView{
    return [[NSBundle mainBundle] loadNibNamed:@"SectionView" owner:nil options:nil].lastObject;
}


@end
