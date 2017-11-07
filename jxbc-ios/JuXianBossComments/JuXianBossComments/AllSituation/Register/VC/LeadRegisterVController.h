//
//  LeadRegisterVController.h
//  JuXianTalentBank
//
//  Created by 马欣欣 on 15/9/14.
//  Copyright (c) 2015年 Max. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "JXBasedViewController.h"

@interface LeadRegisterVController : JXBasedViewController<UIAlertViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *number_TextField;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIView *btnBgview;
@property (copy,nonatomic) NSString *identifi;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UIButton *protocolButton;
- (IBAction)protocolAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *xianlingView;
@property (nonatomic,strong)UIViewController *secondVC;

@property (nonatomic,assign)BOOL isCollect;
@property (nonatomic,strong)UIViewController *popVC;
@end
