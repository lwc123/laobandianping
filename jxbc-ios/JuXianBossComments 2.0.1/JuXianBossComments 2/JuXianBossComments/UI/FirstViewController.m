//
//  FirstViewController.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/9.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "FirstViewController.h"
#import "JXBecomeHunterView.h"

@interface FirstViewController ()

@property (nonatomic,strong)UITableView * tabbleView;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor= [UIColor redColor];
    
    
    _tabbleView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT -64) style:UITableViewStylePlain];
    _tabbleView.tableHeaderView = [JXBecomeHunterView becomeHunterView];
    [self.view addSubview:_tabbleView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
