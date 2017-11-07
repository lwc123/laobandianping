//
//  JXCollectionView.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/2/23.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "JXCollectionView.h"
#import "JXLRefreshHeader.h"
@implementation JXCollectionView

//下拉刷新
- (void)setDragDownRefreshWith:(void (^)())block;//此处回调
{
    
    JXLRefreshHeader *header = [JXLRefreshHeader headerWithRefreshingBlock:block];
    [header setImages:@[[UIImage imageNamed:@"jiazai1"],[UIImage imageNamed:@"jiazai2"],[UIImage imageNamed:@"jiazai3"],[UIImage imageNamed:@"jiazai4"]] duration:.60 forState:MJRefreshStateRefreshing];
    self.mj_header = header;
}
//上拉加载
- (void)setDragUpLoadMoreWith:(void (^)())block;
{
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:block];
    self.mj_footer = footer;
    footer.stateLabel.hidden = YES;
    
    
}
- (void)setBeginRefresh
{
    [self.mj_header beginRefreshing];
}
//结束刷新
- (void)setEndRefresh;
{
    if (self.mj_footer.state==MJRefreshStateRefreshing)
    {
        [self.mj_footer endRefreshing];
    }
    else
    {
        [self.mj_header endRefreshing];
    }

}
//
- (void)dragDownRefreshWith:(NSString *)industry with:(NSString*)grade With:(NSString *)recommend with:(void (^)(JSONModelArray *restrict))block;//此处回调
{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //分页怎么办好呢 数据请求。。。。。
    }];
    self.mj_header = header;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
