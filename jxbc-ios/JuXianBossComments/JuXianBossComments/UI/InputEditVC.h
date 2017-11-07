//
//  InputEditVC.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/28.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "JXBasedViewController.h"
@interface InputEditVC : JXBasedViewController
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic,strong)NSString *editString;
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UITextField * tf;
//邮箱需要做格式验证 做特殊处理
@property (nonatomic,assign)BOOL isEmail;

@end
