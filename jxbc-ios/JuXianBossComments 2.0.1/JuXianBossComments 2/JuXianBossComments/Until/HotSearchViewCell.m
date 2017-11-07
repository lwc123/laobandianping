//
//  HotSearchView.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/2/26.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "HotSearchViewCell.h"
#import "JCCollectionViewTagFlowLayout.h"
@implementation HotSearchViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    // Initialization code
}
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        self.hotSearchView = [[JCTagListView alloc]initWithFrame:CGRectZero];
//        self.hotSearchView.backgroundColor = [UIColor whiteColor];
//        self.hotSearchView.tagCornerRadius = 12.5;
//        self.hotSearchView.tagTextColor = [PublicUseMethod setColor:KColor_MainColor];
//        self.hotSearchView.tagBackgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
//        self.hotSearchView.collectionView.scrollEnabled = NO;
////        self.hotSearchView.collectionView.backgroundColor = [UIColor greenColor];
//        [self.contentView addSubview:_hotSearchView];
////        __weak typeof(self) weakSelf = self;
////        [self.hotSearchView setCompletionBlockWithSelected:^(NSInteger index) {
////            
////            weakSelf.block(index);
////        }];
////        
//    }
//    return self;
//}
//- (void)setArray:(NSArray *)array
//{
//    if (array) {
//        if (_array!=array) {
//            _array = array;
////            [self.hotSearchView.tags addObjectsFromArray:_array];
//        }
//}
//    
//    
////    [self.hotSearchView.collectionView reloadData];
//    
//}


- (void)setArray:(NSArray *)array{


    _array = array;
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    if ([_array isKindOfClass:[NSNull class]]) {
        return;
    }
    for (int i = 0; i<_array.count; i++) {
        CGFloat with = [_array[i] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 25) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.width;
        
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeSystem];
        
        
        [bt setTitle:_array[i] forState:UIControlStateNormal];
        [bt setTitleColor:[PublicUseMethod setColor:KColor_MainColor]
                 forState:UIControlStateNormal];
        bt.tag = i;
        [bt addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        bt.layer.masksToBounds = YES;
//        bt.layer.borderWidth = [UIScreen mainScreen].scale/2;
        //            bt.backgroundColor = ;
//        bt.layer.borderColor = [PublicUseMethod setColor:KColor_BackgroundColor].CGColor;
        bt.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
        bt.layer.cornerRadius = 12.5;
        
        CGFloat btWidth = MIN(with+15, SCREEN_WIDTH-30);
        
        bt.frame = CGRectMake(15 + x, y,btWidth, 25);
        
        if(15 + x + with + 15 > SCREEN_WIDTH){
            x = 0;
            y = y + bt.frame.size.height + 15;
            bt.frame = CGRectMake(15 + x, y, btWidth, 25);
        }
        x = bt.frame.size.width + bt.frame.origin.x;
        [self.contentView addSubview:bt];
        _height = CGRectGetMaxY(bt.frame)+15;
        
    }
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];

//    self.hotSearchView.frame = CGRectMake(self.contentView.frame.origin.x, 0, SCREEN_WIDTH, self.contentView.bounds.size.height);
    
    
}

- (void)buttonAction:(UIButton *)button{

    
    if (self.block) {
        self.block(button.tag);
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
