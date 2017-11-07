//
//  JXTableViewController.m
//  JuXianTalentBank
//
//  Created by juxian on 16/8/8.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "JXTableViewController.h"
#import "MacroDefinition.h"
@interface JXTableViewController ()

@end

@implementation JXTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
//    self.view.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initTableView];
    self.jxTableView.tableFooterView = UIView.new;
    
}

- (void)initTableView{
    
    _jxTableView = [[JXTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _jxTableView.delegate = self;
    _jxTableView.dataSource = self;
    _jxTableView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
    _jxTableView.showsVerticalScrollIndicator = NO;
    _jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _jxTableView.separatorColor = KColor_CellColor;
    // 设置下拉刷新
    
    [self.view addSubview:_jxTableView];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"UITableViewCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 45;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
