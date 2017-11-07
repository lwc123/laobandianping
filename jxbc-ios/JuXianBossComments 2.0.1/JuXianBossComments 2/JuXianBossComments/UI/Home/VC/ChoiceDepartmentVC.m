//
//  ChoiceDepartmentVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/29.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "ChoiceDepartmentVC.h"
#import "DepartmentsEntity.h"
#import "NSString+RegexCategory.h"
@interface ChoiceDepartmentVC ()<JXFooterViewDelegate>

@property (nonatomic,strong)UITextField * cityTf;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)CompanyMembeEntity * bossEntity;
@property (nonatomic,strong)CompanyMembeEntity * myEntity;
@property (nonatomic,assign)CGFloat btnY;


@end

@implementation ChoiceDepartmentVC

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    _bossEntity = [UserAuthentication GetBossInformation];
    _dataArray = [NSMutableArray array];
    [self initRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择部门";
    [self isShowLeftButton:YES];
    [self initData];
    [self initUI];
}

- (void)initRequest{

    [MineRequest getDepartmentWithCompanyId:_bossEntity.CompanyId success:^(JSONModelArray *array) {
        NSLog(@"array===%@",array);
        if (array.count == 0) {
            
        }else{
//            _dataArray = [array copy];
            for (DepartmentsEntity * model in array) {
                if (model.DeptName) {
                    [_dataArray addObject:model.DeptName];

                }
            }
                        
            [self createDepartmentWith:_dataArray];
        }

    } fail:^(NSError *error) {
        NSLog(@"error===%@",error);
    }];

}

- (void)initData{

    _myEntity = [UserAuthentication GetMyInformation];

}

- (void)initUI{

//    _dataArray = @[@"添加0",@"添加1",@"添加2",@"添加3",@"添加4",@"添加5",@"添加6",@"添加7",@"添加8"];
    _cityTf = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 44)];
    _cityTf.backgroundColor = [UIColor whiteColor];
    _cityTf.placeholder = @"  请输入部门名称";
    [_cityTf becomeFirstResponder];
    _cityTf.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:_cityTf];

    
    
    JXFooterView * footer = [JXFooterView footerView];
    footer.y = CGRectGetMaxY(_cityTf.frame) + 0;
    footer.x = 10;
    footer.width = SCREEN_WIDTH - 20;
    footer.nextLabel.text = @"完成";
    footer.delegate = self;
    [self.view addSubview:footer];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(footer.frame), SCREEN_WIDTH - 20, 30)];
    label.text = @"选择已创建的部门";
    label.font = [UIFont systemFontOfSize:15.0];
    label.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
    [self.view addSubview:label];
    _btnY = CGRectGetMaxY(label.frame)+ 10;
}

- (void)createDepartmentWith:(NSMutableArray *)dataArray{

    int totalColumns = 3;
    CGFloat cellW = (SCREEN_WIDTH - 40) /3;
    CGFloat cellH = 35;
    CGFloat margin = 10;
    for(int index = 0; index< dataArray.count; index++) {
        UIButton *cellView = [[UIButton alloc ]init ];
        int row = index / totalColumns;
        int col = index % totalColumns;
        CGFloat cellX = margin + col * (cellW + margin);
        CGFloat cellY = row * (cellH + margin) + _btnY;
        cellView.frame = CGRectMake(cellX, cellY, cellW, cellH);
        cellView.layer.masksToBounds = YES;
        cellView.layer.cornerRadius = 4;
        cellView.layer.borderWidth = .5;
        cellView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
        cellView.layer.borderColor = [PublicUseMethod setColor:KColor_GoldColor].CGColor;
        [cellView setTitleColor:[PublicUseMethod setColor:KColor_Text_BlackColor] forState:UIControlStateNormal];
        cellView.titleLabel.font = [UIFont systemFontOfSize:15.0];
        
        cellView.tag = 1000 + index;
        [cellView setTitle:self.dataArray[index] forState:UIControlStateNormal];
        [cellView addTarget:self action:@selector(cellView:) forControlEvents:UIControlEventTouchUpInside];
        // 添加到view 中
        [self.view addSubview:cellView];
    }
}

- (void)cellView:(UIButton *)batn{
    NSString * str = batn.titleLabel.text;
    NSLog(@"str===%@",str);
    if (self.block) {
        self.block(str);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{
    
    
    if (_cityTf.text.length == 0) {
        
        [PublicUseMethod showAlertView:@"请填写所在部门"];
        return;
    }
    
    if (_cityTf.text.length > 20) {
        
        [PublicUseMethod showAlertView:@"所在部门最多20个汉字"];
        return;
    }
    if ([_cityTf.text isContainsEmoji]) {
        [PublicUseMethod showAlertView:@"部门名称不可以包含表情"];
        return;
    }

    
    DepartmentsEntity * departments = [[DepartmentsEntity alloc] init];
    departments.DeptName = _cityTf.text;
    departments.CompanyId = _bossEntity.CompanyId;
    departments.PresenterId = _myEntity.PresenterId;

    NSString * str = _cityTf.text;

    [self showLoadingIndicator];
    
    
    
    MJWeakSelf
    [self showLoadingIndicator];
    [MineRequest postAddDepartmentWith:departments success:^(ResultEntity *resultEntity) {
        [weakSelf dismissLoadingIndicator];
        
        if (resultEntity.Success) {
            [PublicUseMethod showAlertView:@"添加成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.block) {
                    self.block(str);
                }
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            
            [PublicUseMethod showAlertView:resultEntity.ErrorMessage];
        }
        
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
