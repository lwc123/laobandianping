//
//  JXTopicVC.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/17.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JXTopicVC.h"
#import "HotTopicCell.h"
#import "OpinionCompanyEntity.h"
#import "OpinionCompanyDetailVC.h"
@interface JXTopicVC ()
@property (nonatomic, strong) NilView * nilview;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation JXTopicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"热门公司";
    [self isShowLeftButton:YES];
    [self initDetailRequest];
    [self initUI];
    
}

- (void)initUI{

    [self.view addSubview:self.headerImageView];
    self.jxTableView.tableHeaderView = self.headerImageView;
    [self.jxTableView registerNib:[UINib nibWithNibName:@"HotTopicCell" bundle:nil] forCellReuseIdentifier:@"hotTopicCell"];
}

- (void)initDetailRequest{

    MJWeakSelf
    [self showLoadingIndicator];
    [UserOpinionRequest getTopicDetaillWithTopicId:weakSelf.topicEntity.TopicId page:1 size:15 Success:^(TopicEntity *topicEntity) {
        [weakSelf dismissLoadingIndicator];

        if (topicEntity.Companys.count == 0) {
            [self.jxTableView addSubview:self.nilview];
        }else{
            [self.nilview removeFromSuperview];
        }

        if (topicEntity.Companys.count != 0) {
            for (int i = 0; i < topicEntity.Companys.count; ++i) {
                
                NSDictionary * dic = topicEntity.Companys[i];
                OpinionCompanyEntity * topicEntity = [[OpinionCompanyEntity alloc] initWithDictionary:dic error:nil];
                [weakSelf.dataArray addObject:topicEntity];
            }
            [weakSelf.jxTableView reloadData];
        }
        
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];

    }];


}
- (NilView *)nilview{
    
    if (_nilview == nil) {
        _nilview = [[NilView alloc]initWithFrame:CGRectMake(0, 200, ScreenWidth, 300)];
        _nilview.labelStr = @"很抱歉，暂时没有";
        _nilview.isHiddenButton = YES;
    }
    return _nilview;
}

- (UIImageView *)headerImageView{

    if (_headerImageView == nil) {
        
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:self.topicEntity.HeadFigure] placeholderImage:nil];
    }
    return _headerImageView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotTopicCell * topicCell = [tableView dequeueReusableCellWithIdentifier:@"hotTopicCell" forIndexPath:indexPath];
    topicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    OpinionCompanyEntity * companyEntity = self.dataArray[indexPath.row];
    topicCell.companyEntity = companyEntity;
    self.cellHeight = topicCell.cellHeight;
    return topicCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return self.cellHeight;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 38;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UILabel * textLabel = [UILabel labelWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 38) title:@"    热门公司" titleColor:[PublicUseMethod setColor:KColor_Text_BlackColor] fontSize:15.0 numberOfLines:1];
    return textLabel;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OpinionCompanyEntity * companyEntity = self.dataArray[indexPath.row];
    OpinionCompanyDetailVC * companyDetail = [[OpinionCompanyDetailVC alloc] init];
    companyDetail.companyEntity = companyEntity;
    companyDetail.title = companyEntity.CompanyName;
    [self.navigationController pushViewController:companyDetail animated:YES];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
