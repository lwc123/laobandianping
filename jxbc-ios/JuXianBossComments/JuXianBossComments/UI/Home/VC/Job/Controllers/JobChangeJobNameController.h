//
//  JobChangeJobNameController.h
//  JuXianBossComments
//
//  Created by Jam on 17/1/16.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JXBasedViewController.h"

typedef void(^EndEditTextBlock)(NSString* text);

@interface JobChangeJobNameController : JXBasedViewController

@property (nonatomic, strong) IBOutlet UILabel *detailLabel;

- (void)completeEditText:(EndEditTextBlock)endEditTextBlock;
- (instancetype)initWithJobName:(NSString*)string;

@end
