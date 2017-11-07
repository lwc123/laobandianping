//
//  CompanyAttentionVC.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/7.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "CompanyAttentionVC.h"
#import "OpinionCompanyEntity.h"
#import "AttentionCell.h"
#import "OpinionCompanyDetailVC.h"
const static int attentionSize = 15;

//关注
@interface CompanyAttentionVC ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *formerClubArray;
@property (nonatomic, assign) int page;

@property (nonatomic, assign) CGFloat cellHeight;
@end

@implementation CompanyAttentionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initConcernedRequest];
    [self initUI];
}

- (void)initData{

    _page = 1;
}

- (void)initUI{
    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 36 - 49);
    MJWeakSelf
    [self.jxTableView setDragDownRefreshWith:^{
        
        weakSelf.page = 1;
        [weakSelf initConcernedRequest];
    }];
    
    [self.jxTableView setDragUpLoadMoreWith:^{
        
        weakSelf.page++;
        [weakSelf initConcernedRequest];
    }];
    

}

#pragma mark --
- (void)initConcernedRequest{
    [self showLoadingIndicator];
    MJWeakSelf
    [UserOpinionRequest getConcernedMineListPage:weakSelf.page size:attentionSize success:^(JSONModelArray *array) {
        [weakSelf dismissLoadingIndicator];

        if (array.count == 0) {
            
//            [self.jxTableView addSubview:self.nilview];
        }else{
//            [self.nilview removeFromSuperview];
        }
        
        if (array.count != 0) {
            if (weakSelf.page == 1) {
                // 清空数组
                weakSelf.dataArray = @[].mutableCopy;
            }
            for (OpinionCompanyEntity * model in array) {
                if (model.IsFormerClub == YES) {//是老东家
                    [weakSelf.formerClubArray addObject:model];

                }else{
                    [weakSelf.dataArray addObject:model];
                }
            }
        }
        
        [weakSelf.jxTableView reloadData];
        [weakSelf.jxTableView endRefresh];
        
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [weakSelf.jxTableView endRefresh];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        return self.formerClubArray.count;
    }else{
        return self.dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        if (self.formerClubArray.count == 0) {
            return 0;
        }else{
            return 30;
        }
    }
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
        UILabel *formerClubLabel = [UILabel labelWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30) title:@" " titleColor:[PublicUseMethod setColor:KColor_Text_BlackColor] fontSize:15.0 numberOfLines:1];
    if (section == 0) {

        formerClubLabel.text = @"   老东家";
    }else{
        formerClubLabel.text = [NSString stringWithFormat:@"   共有关注%ld家",self.consoleEntity.ConcernedTotal];
    }
    
    return formerClubLabel;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"cellid1";
    AttentionCell *attentionCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!attentionCell) {
        attentionCell = [[AttentionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    OpinionCompanyEntity * companyEntity;
    if (indexPath.section == 0) {
        companyEntity  = self.formerClubArray[indexPath.row];
    }else{
        companyEntity  = self.dataArray[indexPath.row];
    }
    attentionCell.companyEntity = companyEntity;
    self.cellHeight = attentionCell.cellHeight;
    return attentionCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OpinionCompanyEntity * companyEntity;

    if (indexPath.section == 0) {
        companyEntity  = self.formerClubArray[indexPath.row];
    }else{
        companyEntity  = self.dataArray[indexPath.row];
    }
    OpinionCompanyDetailVC * detailVC = [[OpinionCompanyDetailVC alloc] init];
    detailVC.companyEntity = companyEntity;
    detailVC.title = companyEntity.CompanyName;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return self.cellHeight;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (NSMutableArray *)formerClubArray{
    if (!_formerClubArray) {
        _formerClubArray = @[].mutableCopy;
    }
    return _formerClubArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
