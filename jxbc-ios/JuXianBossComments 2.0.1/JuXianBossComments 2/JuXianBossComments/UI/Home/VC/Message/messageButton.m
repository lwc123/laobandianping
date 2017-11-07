//
//  messageButton.m
//  JuXianBossComments
//
//  Created by Jam on 17/2/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "messageButton.h"

@interface messageButton ()


@property (nonatomic, assign) CGFloat pointRadiu;

@end

@implementation messageButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pointRadiu = 5;
        [self addSubview:self.redPoint];
    }
    return self;
}

- (void)layoutSubviews{
    [self.redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_offset(2*self.pointRadiu);
        make.top.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_right).offset(5);
    }];
}

- (void)setShowRedPoint:(BOOL)showRedPoint{

    _showRedPoint = showRedPoint;
    self.redPoint.hidden = !showRedPoint;
}

- (UILabel *)redPoint{

    if (_redPoint == nil) {
        _redPoint = [[UILabel alloc] init];
        _redPoint.layer.cornerRadius = self.pointRadiu;
        _redPoint.clipsToBounds = YES;
        _redPoint.backgroundColor = ColorWithHex(@"CA001A");
    }
    return _redPoint;
}
@end
