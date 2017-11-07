//
//  JXTableViewController.h
//  JuXianTalentBank
//
//  Created by juxian on 16/8/8.
//  Copyright © 2016年 Max. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "JXBasedViewController.h"
#import "JXTableView.h"


@interface JXTableViewController : JXBasedViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)JXTableView * jxTableView;

@end
