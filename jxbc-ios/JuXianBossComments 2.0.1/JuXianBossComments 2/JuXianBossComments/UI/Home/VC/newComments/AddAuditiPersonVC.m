//
//  AddAuditiPersonVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/12.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "AddAuditiPersonVC.h"
#import "JXAddAuthorizeVC.h"

@interface AddAuditiPersonVC ()
@property (nonatomic,strong)CompanyMembeEntity *membeEntity;
@property (nonatomic,strong)CompanyMembeEntity *bossntity;

@property (nonatomic,strong)NSMutableArray *modelArray;
@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, strong) NSMutableArray * passportIdArray;
@property (nonatomic, strong) NSMutableArray * jobTitleArray;


@end

@implementation AddAuditiPersonVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self initauthorizRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   self.title= @"选择授权审核人";
    [self isShowLeftButton:YES];
    [self initData];
   
}

- (void)initData{
    _membeEntity = [UserAuthentication GetMyInformation];
    _bossntity = [UserAuthentication GetBossInformation];
    _modelArray = [NSMutableArray array];
    _dataArray = [NSArray array];
    _passportIdArray = [NSMutableArray array];
    _jobTitleArray = [NSMutableArray array];
    self.signView  = [[JCTagListView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:_signView];

}

//审核人列表
- (void)initauthorizRequest{

    [MineRequest getCompanyMemberListCompanyId:_bossntity.CompanyId success:^(JSONModelArray *array) {
        [self dismissLoadingIndicator];
        NSLog(@"array===%@",array);
        if (array.count == 0) {
            [PublicUseMethod showAlertView:@"暂无数据"];
        }else{
            
            if (_modelArray.count != 0) {
                [_modelArray removeAllObjects];
                _passportIdArray = @[].mutableCopy;
                _jobTitleArray = @[].mutableCopy;

            }
            for (CompanyMembeEntity * model in array) {
                if (model.Role == Role_HightManager) {//只有高管有审核的资格 老板始终有
                    [_modelArray addObject:model.RealName];
                    [_passportIdArray addObject:[NSString stringWithFormat:@"%ld",model.PassportId]];
                    [_jobTitleArray addObject:model.JobTitle];
                }
            }
            _dataArray = _modelArray;
            [self initUI];
            [self.signView.collectionView reloadData];

        }
    } fail:^(NSError *error) {
        [self dismissLoadingIndicator];
        NSLog(@"error==%@",error);
    }];
}


- (void)initUI{
//    self.array = @[@"李然"];
    self.mutableArray = [NSMutableArray arrayWithArray:_dataArray];
    [self.mutableArray addObject:@"+ 添加审核人"];
    
    self.signView.tags = _mutableArray;
    self.signView.tagTextColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
    self.signView.tagCornerRadius = 4;
    __weak typeof(self) weakSelf = self;
    
    [self.signView setCompletionBlockWithSelected:^(NSInteger index) {
        if (index == _mutableArray.count-1) {
            //弹框

            CompanyMembeEntity * myInforEntity = [UserAuthentication GetMyInformation];
            
            if (myInforEntity.Role == Role_Boss || myInforEntity.Role == Role_manager) {
                
                //应该跳转
                JXAddAuthorizeVC * addAuthorizeVC = [[JXAddAuthorizeVC alloc] init];
                addAuthorizeVC.secondVC = weakSelf;
                addAuthorizeVC.block= ^(NSString *authoriStr,NSString * passportId){
                    
                    if (authoriStr != nil && passportId != nil) {
                        [weakSelf.mutableArray insertObject:authoriStr atIndex:weakSelf .mutableArray.count-1];
//                        [weakSelf.passportIdArray addObject:passportId];
                        [weakSelf.signView.collectionView reloadData];
                    }else{}
                    
                };
                [weakSelf.navigationController pushViewController:addAuthorizeVC animated:YES];
                
            }else{
                // 温馨提示
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"只有管理员和老板可以添加审核人哦!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                
                [alert show];
            }
        }else{
            //            [weakSelf.mutableArray removeObjectAtIndex:index];
            NSString * str = weakSelf.mutableArray[index];
            
            NSString * passportId  = weakSelf.passportIdArray[index];
            NSString * jobTitle = weakSelf.jobTitleArray[index];
            
            if (weakSelf.block) {
                weakSelf.block(str,passportId,jobTitle);
            }
            [weakSelf.signView.collectionView reloadData];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    JXFooterView * footer = [JXFooterView footerView];
    footer.y = CGRectGetMaxY(self.signView.frame) + 25;
    footer.x = 0;
//    footer.delegate = self;
    footer.nextLabel.text = @"确定";
    [self.view addSubview:footer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
