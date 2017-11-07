//
//  JXAdvancedSettingVC.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JXAdvancedSettingVC.h"

@interface JXAdvancedSettingVC ()

@end

@implementation JXAdvancedSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"高级设置";
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"cellid1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.text = @"不允许任何人对公司进行点评和评论";
        
        UIButton * button = [UIButton buttonWithFrame:CGRectMake(SCREEN_WIDTH-56, 8.5, 46, 28) title:nil fontSize:17 titleColor:nil imageName:@"kai" bgImageName:nil];
        button.selected = YES;
        button.tag = 10;
        [button addTarget:self action:@selector(kaiguanButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
    }
    return cell;

}

- (void)kaiguanButtonAction:(UIButton*)button
{
    button.selected = !button.selected;
    if (button.selected) {
        [button setImage:[UIImage imageNamed:@"kai"] forState:UIControlStateNormal];
        //接受新消息通知
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"guan"] forState:UIControlStateNormal];
        button.selected = NO;
        //关闭接受新消息通知
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}



@end
