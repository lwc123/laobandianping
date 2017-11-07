//
//  JobChangeCompanyInfoController.m
//  JuXianBossComments
//
//  Created by Jam on 17/1/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JobChangeCompanyInfoController.h"
#import "FixCompanyVC.h"


@interface JobChangeCompanyInfoController ()

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) CompanySummary *companySummary;


@end

@implementation JobChangeCompanyInfoController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self isShowLeftButton:YES];

    [self initUI];
}
- (void)viewWillAppear:(BOOL)animated{

    // 获取数据
    [self.jxTableView reloadData];
    self.companySummary = [UserAuthentication GetCompanySummary];

}

#pragma mark - init
- (void)initUI{
    self.title = @"发布职位";
    self.jxTableView.scrollEnabled = NO;
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
}

#pragma mark - function

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - tableView datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return indexPath.row == 0 ? 30 : 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count + 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    if (indexPath.row == 0) { // 修改企业信息
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
        
        label.text = @"若要修改，请到＂我的＂进行修改";
        label.textColor = ColorWithHex(@"EE8C34");
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:label];
        
        cell.backgroundColor = ColorWithHex(@"F7E2D4");
        cell.accessoryView.tintColor = ColorWithHex(@"F7E2D4");
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
    
        cell.textLabel.text = self.titleArray[indexPath.row - 1];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        cell.textLabel.textColor = ColorWithHex(KColor_Text_BlackColor);
        cell.detailTextLabel.textColor = ColorWithHex(KColor_Text_EumeColor);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString* detail;
        switch (indexPath.row) {
            case 1:     // 行业
                detail = self.companySummary.Industry;
                break;
                
            case 2:     // 简称
                detail = self.companySummary.CompanyAbbr;

                break;
            case 3:     // 规模
                detail = self.companySummary.CompanySizeText;

                break;
            case 4:     // 所在城市
                detail = self.companySummary.RegionText;
                
                break;
                
            default:
                break;
        }
        cell.detailTextLabel.text = detail;

        
    }

    
    
    return cell;
}

#pragma mark - lazy load
- (NSArray *)titleArray{

    if (_titleArray == nil) {
        _titleArray = @[@"公司所属行业",@"公司简称",@"公司人员规模",@"公司所在城市"];
    }
    return _titleArray;
}


@end
