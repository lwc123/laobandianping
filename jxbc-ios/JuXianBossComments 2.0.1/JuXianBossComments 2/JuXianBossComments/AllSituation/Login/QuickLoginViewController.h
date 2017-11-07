//
//  QuickLoginViewController.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/6/20.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "JXBasedViewController.h"

typedef void(^pushBlock)();
@interface QuickLoginViewController : JXBasedViewController
@property (weak, nonatomic) IBOutlet UIButton *goBackBt;
@property (weak, nonatomic) IBOutlet UITextField *telephoneField;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginBt;
@property (weak, nonatomic) IBOutlet UIButton *codeBt;
@property (nonatomic,copy)pushBlock block;
@property (strong, nonatomic) NSString *tag;
@property (nonatomic,strong)UIViewController *secondVC;

@property (nonatomic,assign)BOOL isCollect;
@property (nonatomic,strong)UIViewController *popVC;

@end
