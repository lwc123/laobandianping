//
//  RsonCell.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/5.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWTextView.h"

@protocol RsonCellCellDelegate;

@interface RsonCell : UITableViewCell<UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UITextView *myTextView;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (strong, nonatomic)IWTextView *explanTextView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) id<RsonCellCellDelegate> delegate;
@property (nonatomic,strong)NSIndexPath *indexPath;


@end
@protocol RsonCellCellDelegate <NSObject>
@optional
- (void)resonCell:(RsonCell *)sliderCell WithIndexPath:(NSIndexPath *)indexPath textView:(NSString *)myTest changeText:(NSString *)changeText;
@end
