//
//  MineQueryRecordVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/25.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "MineQueryRecordVC.h"
#import "QueryRecordCell.h"

@interface MineQueryRecordVC ()

@end

@implementation MineQueryRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavView];
    [self initUI];
    
}

- (void)initNavView{

    self.title = @"我的查询记录";

}

- (void)initUI{

    self.jxTableView.frame = CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT- 10);
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    self.jxTableView.tableFooterView = [[UIView alloc] init];
    [self.jxTableView registerNib:[UINib nibWithNibName:@"QueryRecordCell" bundle:nil] forCellReuseIdentifier:@"queryRecordCell"];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    QueryRecordCell * queryCell = [tableView dequeueReusableCellWithIdentifier:@"queryRecordCell" forIndexPath:indexPath];
    queryCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return queryCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 89;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
