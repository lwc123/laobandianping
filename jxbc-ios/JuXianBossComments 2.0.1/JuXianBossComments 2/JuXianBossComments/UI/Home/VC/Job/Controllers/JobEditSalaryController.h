//
//  JobEditSalaryController.h
//  JuXianBossComments
//
//  Created by Jam on 17/1/16.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JXBasedViewController.h"
typedef void(^EndEditSalaryBlock)(int min,int max);

@interface JobEditSalaryController : JXBasedViewController

@property (nonatomic, assign) int minSalary;
@property (nonatomic, assign) int maxSalary;


- (void)completeEditText:(EndEditSalaryBlock)endEditSalaryBlock;

@end
