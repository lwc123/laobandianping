//
//  CompanyMangerTagsVC.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "CompanyMangerTagsVC.h"

@interface CompanyMangerTagsVC ()

@end

@implementation CompanyMangerTagsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"管理标签";
    [self isShowLeftButton:YES];

    JXFooterView * footer = [JXFooterView footerView];
    footer.nextLabel.text = @"保存";
    self.jxTableView.tableFooterView = footer;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 5;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * cellId = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    UITextField * textfield = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 15, 44)];
    textfield.text = @"ddd";
    [cell.contentView addSubview:textfield];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView * bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    UILabel * label = [UILabel labelWithFrame:CGRectMake(20, 8, SCREEN_WIDTH - 40, 20) title:@"保存成功后，公司详情页的标签将立即变更新为最新标签" titleColor:[PublicUseMethod setColor:KColor_Text_EumeColor] fontSize:11.0 numberOfLines:1];
    [bgview addSubview:label];
    return bgview;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}



@end
