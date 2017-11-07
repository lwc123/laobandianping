//
//  JobPublicListViewController.m
//  JuXianBossComments
//
//  Created by Jam on 17/1/12.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JobPublicListViewController.h"
#import "JobPublicPositionViewController.h"
#import "WorkBenchJobRequest.h"
#import "JobEntity.h"
#import "JobPublicJobcell.h"
#import "JobDetailController.h"

@interface JobPublicListViewController ()<JXFooterViewDelegate>
{
    NSMutableArray *_dataArray;
    
}

@property (nonatomic, strong) UIView *nilView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) int page;

@end

@implementation JobPublicListViewController
static NSString* reuseId = @"jobCell";

#pragma mark - licf cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showLoadingIndicator];
    
    self.page = 1;
    [self initUI];
    
    self.title = @"招聘";
    [self requestData];
    // 下拉刷新
    MJWeakSelf
    [self.jxTableView setDragDownRefreshWith:^{
        
        // 更新数据
        weakSelf.page = 1;
        [weakSelf requestData];
        
    }];
    // 上拉加载更多
    [self.jxTableView setDragUpLoadMoreWith:^{
        [weakSelf requestData];
    }];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.page == 1) return;
    
    int page = self.page;
    self.page = 1;
    for (NSInteger i = 1;i < page; i++) {
        [self requestData];
    }
    
}
#pragma mark - init
- (void)initUI{
    [self isShowLeftButton:YES];
    [self isShowRightButton:YES with:@"发布职位"];
    
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.jxTableView registerNib:[UINib nibWithNibName:NSStringFromClass([JobPublicJobcell class]) bundle:nil] forCellReuseIdentifier:reuseId];
    
}
- (void)requestData{
    
    CompanyMembeEntity *company = [UserAuthentication GetBossInformation];
    MJWeakSelf
    [WorkBenchJobRequest getJob_jobListWithCompanyId:company.CompanyId withSize:20 withPage:weakSelf.page success:^(JSONModelArray *array) {
        Log(@"array:%@",array);
        [weakSelf.jxTableView endRefresh];
        [weakSelf dismissLoadingIndicator];
        //        Log(@"***************%@",array);
        
        if (array.count == 0 && weakSelf.page == 1) {
            [weakSelf.jxTableView addSubview:self.nilView];
        }else{
            [weakSelf.nilView removeFromSuperview];
        }
        
        CompanyMembeEntity* companyMemeber;
        if (array.count != 0) {
            if (weakSelf.page == 1) {
                // 清空数组
                weakSelf.dataArray = @[].mutableCopy;
            }
            weakSelf.page++;
            for (JobEntity * model in array) {
                
                companyMemeber = model.CompanyMember;
                if ([model isKindOfClass:[JobEntity class]]) {
                    [weakSelf.dataArray addObject:model];
                    
                }
            }
            [weakSelf.jxTableView reloadData];
            
        }
        
    } fail:^(NSError *error) {
        [weakSelf.jxTableView endRefresh];
        [weakSelf dismissLoadingIndicator];
        
        
    }];
}

#pragma mark - function
- (void)rightButtonAction:(UIButton* )sender{
    JobPublicPositionViewController *publicPositionVC = [[JobPublicPositionViewController alloc]init];
    
    [self.navigationController pushViewController:publicPositionVC animated:YES];
}

-(void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{
    [self rightButtonAction:nil];
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MJWeakSelf;
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"确认删除吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf showLoadingIndicator];
        JobEntity* job = self.dataArray[indexPath.row];
        // 删除
        [WorkBenchJobRequest getJob_deleteJobWith:[UserAuthentication GetMyInformation].CompanyId and:job.JobId success:^(id result) {
            [weakSelf dismissLoadingIndicator];
            if ([result boolValue]) {
                [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
                [weakSelf.jxTableView reloadData];
                [weakSelf alertString:@"删除成功" duration:1];
            }
        } fail:^(NSError *error) {
            [weakSelf dismissLoadingIndicator];
            [weakSelf alertString:[NSString stringWithFormat:@"%@",error.localizedDescription] duration:1];
            
        }];
        
    }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:done];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JobDetailController* detailVC = [[JobDetailController alloc]initWithJob:self.dataArray[indexPath.row]];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 39;
}
// 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 78;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView* view = UIView.new;
    view.width = ScreenWidth;
    view.height = 39;
    UILabel* label = [[UILabel alloc]init];
    label.text = @"已发布职位";
    label.x = 16;
    [label sizeToFit];
    label.centerY = view.centerY;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = ColorWithHex(@"75747A");
    [view addSubview:label];
    return view;
}


#pragma mark - tableView datacouse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JobPublicJobcell* cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    cell.jobEntity = self.dataArray[indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - lazy load

- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    
    //    if (_dataArray.count == 0) {
    //        [self.jxTableView addSubview:self.nilView];
    //    }else{
    //        [self.nilView removeFromSuperview];
    //    }
}

- (NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    //    if (_dataArray.count == 0) {
    //        [self.jxTableView addSubview:self.nilView];
    //    }else{
    //        [self.nilView removeFromSuperview];
    //    }
    
    return _dataArray;
}

- (UIView *)nilView{
    
    if (!_nilView) {
        _nilView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 300)];
        
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - 100)* 0.5, 20, 100, 100)];
        imageView.image = [UIImage imageNamed:@"loginlogo"];
        [_nilView addSubview:imageView];
        
        
        JXFooterView* footerView = [JXFooterView footerView];
        footerView.y = CGRectGetMaxY(imageView.frame)+20;
        footerView.width = ScreenWidth;
        footerView.nextLabel.text = @"发布职位";
        footerView.delegate = self;
        [_nilView addSubview:footerView];
        
    }
    return _nilView;
}

@end
