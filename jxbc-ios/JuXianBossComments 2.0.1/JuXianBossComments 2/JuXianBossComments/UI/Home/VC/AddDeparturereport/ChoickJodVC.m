//
//  ChoickJodVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/1.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "ChoickJodVC.h"
#import "AddJobViewController.h"


@interface ChoickJodVC ()
@property (nonatomic,strong)NilView * nilView;

@end

@implementation ChoickJodVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"选择职务信息";
    [self isShowLeftButton:YES];
    [self isShowRightButton:YES];
    [self initUI];

}

- (void)initUI{

    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
//    _nilView = [[NilView alloc] initWithFrame:self.jxTableView.frame];
//    _nilView.isHiddenButton = NO;
//    _nilView.labelStr = @"还没有职务";
//    UIButton * btn = [[UIButton alloc] init];
//    btn = [_nilView viewWithTag:2000];
//    [btn setTitle:@"添加职务" forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.jxTableView addSubview:_nilView];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * cellId = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    cell.textLabel.text = @"我是职务";
    cell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
    
}


- (void)rightButtonAction:(UIButton *)button{

    AddJobViewController * addVC = [[AddJobViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
