//
//  JXTableView.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/10.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXTableView.h"
#import "JXLRefreshHeader.h"

@implementation JXTableView

//下拉刷新
- (void)setDragDownRefreshWith:(void (^)())block{

    JXLRefreshHeader *header = [JXLRefreshHeader headerWithRefreshingBlock:block];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    

    [header setImages:@[[UIImage imageNamed:@"jiazai1"],[UIImage imageNamed:@"jiazai2"],[UIImage imageNamed:@"jiazai3"],[UIImage imageNamed:@"jiazai4"]] duration:.6 forState:MJRefreshStateRefreshing];
    
    self.mj_header = header;

}

//上啦加载
- (void)setDragUpLoadMoreWith:(void (^)())block;
{
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:block];
    [footer setTitle:@"上拉刷新" forState:MJRefreshStateIdle];

    
    self.mj_footer = footer;
    footer.stateLabel.hidden = YES;
}

//结束刷新
- (void)endRefresh;
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

- (void)beginRefresh
{
    [self.mj_header beginRefreshing];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    [self endEditing:YES];
    
    return [super hitTest:point withEvent:event];
}

@end
