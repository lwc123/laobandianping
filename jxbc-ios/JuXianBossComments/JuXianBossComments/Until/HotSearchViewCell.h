//
//  HotSearchView.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/2/26.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCTagListView.h"

typedef void(^selectBlock)(NSInteger nubmer);

@interface HotSearchViewCell : UITableViewCell
@property (nonatomic,strong)JCTagListView * hotSearchView;
@property (nonatomic,strong)NSArray *array;
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,copy)selectBlock block;
@end
