//
//  JXTableView.h
//  JuXianBossComments
//
//  Created by juxian on 16/10/10.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^refreshing)();

@interface JXTableView : UITableView
//下拉刷新
- (void)setDragDownRefreshWith:(void (^)())block;
//上啦加载
- (void)setDragUpLoadMoreWith:(void (^)())block;
//结束刷新
- (void)endRefresh;
//开始刷新
- (void)beginRefresh;

@end
