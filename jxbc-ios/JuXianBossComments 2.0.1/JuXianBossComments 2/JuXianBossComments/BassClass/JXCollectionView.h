//
//  JXCollectionView.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/2/23.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONModel.h"
typedef void (^refreshing)();
@interface JXCollectionView : UICollectionView
//下拉刷新
- (void)setDragDownRefreshWith:(void (^)())block;
//上啦加载
- (void)setDragUpLoadMoreWith:(void (^)())block;
//开始刷新
- (void)setBeginRefresh;
//结束刷新
- (void)setEndRefresh;
@end
