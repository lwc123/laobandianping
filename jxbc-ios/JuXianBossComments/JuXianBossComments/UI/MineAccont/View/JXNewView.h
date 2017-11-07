//
//  JXNewView.h
//  JuXianBossComments
//
//  Created by CZX on 16/12/15.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JXNewViewDelegate <NSObject>
-(void)btnClickWithBtn:(UIButton *)btn;
@end
@interface JXNewView : UITableView

@property(nonatomic,weak)id<JXNewViewDelegate> dele;
+(instancetype)appearView;
@end
