//
//  PayViewController.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/5.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "JXBasedViewController.h"
#import "JXAPIS.h"
#import "PaymentEntity.h"
#import "ColorButton.h"

@interface PayViewController : JXBasedViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet ColorButton *payButton;

- (IBAction)payButtonAction:(id)sender;

@property (nonatomic,strong)PaymentEntity *entity;
@property (nonatomic,copy)NSString * explainStr;
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,copy)NSString * companyName;

@property (nonatomic,strong)UIViewController * secondVC;

@end
