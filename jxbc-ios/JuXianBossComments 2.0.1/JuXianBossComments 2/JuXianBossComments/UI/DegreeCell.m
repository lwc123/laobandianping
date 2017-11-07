//
//  DegreeCell.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/5/15.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "DegreeCell.h"

@implementation DegreeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.degreeName.text = _data;
}

@end
