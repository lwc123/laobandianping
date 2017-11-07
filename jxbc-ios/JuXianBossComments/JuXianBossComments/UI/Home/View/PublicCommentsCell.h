//
//  PublicCommentsCell.h
//  JuXianBossComments
//
//  Created by juxian on 16/11/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWTextView.h"
@interface PublicCommentsCell : UITableViewCell<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *iTextView;

@property (strong, nonatomic)  IWTextView *myTextView;

@property (nonatomic,strong)UILabel * lenthLabel;

@property (weak, nonatomic) IBOutlet UIView *topBgView;

@end
