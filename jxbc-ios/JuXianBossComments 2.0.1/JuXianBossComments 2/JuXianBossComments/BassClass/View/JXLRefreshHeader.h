//
//  JXLRefreshHeader.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/4/8.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

@interface JXLRefreshHeader : MJRefreshStateHeader
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIImageView *loadImageView;
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state;
@end
