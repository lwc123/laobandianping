//
//  dropViewCell.h
//  JuXianBossComments
//
//  Created by CZX on 16/12/14.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JXDropNewViewDelegate <NSObject>
-(void)rightTableViewClickWithtag:(NSInteger)tag;
@end


@interface dropViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *JXDropBtn;

@property(nonatomic,weak)id<JXDropNewViewDelegate> dele;


@end
