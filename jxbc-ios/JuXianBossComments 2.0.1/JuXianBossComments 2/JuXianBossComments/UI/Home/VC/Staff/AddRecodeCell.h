//
//  AddRecodeCell.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/4.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddRecodeCell;
@protocol AddRecodeCellDelegate <NSObject>

- (void)addRecodeCellClickTimeBtnWith:(int)index andView:(AddRecodeCell *)resonCell;

@end


//目前在职状态
@interface AddRecodeCell : UITableViewCell

//在职
@property (weak, nonatomic) IBOutlet UIButton *inJobBtn;
//离任
@property (weak, nonatomic) IBOutlet UIButton *onJobBtn;

@property (nonatomic,strong)UIButton * selectedBtn;
@property (nonatomic,assign)int index;
@property (nonatomic,weak) id<AddRecodeCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *inLabel;
@property (weak, nonatomic) IBOutlet UILabel *outLabel;

//管理员
@property (weak, nonatomic) IBOutlet UILabel *managerLabel;
@property (weak, nonatomic) IBOutlet UIButton *managerBtn;
@property (weak, nonatomic) IBOutlet UIView *managerView;

@property (weak, nonatomic) IBOutlet UIButton *bigManagerBtn;

@property (weak, nonatomic) IBOutlet UILabel *stasulLabel;

@end
