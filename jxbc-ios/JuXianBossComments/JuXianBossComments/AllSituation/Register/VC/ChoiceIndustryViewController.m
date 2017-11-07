//
//  ChoiceIndustryViewController.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/22.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "ChoiceIndustryViewController.h"
#import "JHPutVC.h"

@interface ChoiceIndustryViewController ()<JXFooterViewDelegate>{

    UIScrollView * _myScrollView;
}
@property (nonatomic,strong)NSMutableArray * industryArray;

@end

@implementation ChoiceIndustryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公司行业";
    [self isShowLeftButton:YES];
    
    [self initUI];
    [self initIndustryDic];
}


#pragma mark -- 行业字典
- (void)initIndustryDic{

    [WebAPIClient getJSONWithUrl:API_Dictionary_Industry parameters:nil success:^(id result) {
        
        for (NSDictionary * modelDict in result[@"industry"]) {
            
            AcademicModel *model = [[AcademicModel alloc]initWithDictionary:modelDict error:nil];
 
            [self.industryArray addObject:model];
        }
        [self initData];
        [self initUI];
    } fail:^(NSError *error) {
        
    }];

}

- (NSMutableArray *)industryArray{
    if (!_industryArray) {
        _industryArray = [NSMutableArray array];
    }
    return _industryArray;
}

- (void)initData{
    
    NSMutableArray * nameArray = [NSMutableArray array];
    for (AcademicModel *academicModel in _industryArray) {
        [nameArray addObject:academicModel.Name];
    }
    
    self.mutableArray = [NSMutableArray arrayWithArray:nameArray];
    //传过来的
    NSString * identityStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"Identity"];
    if (identityStr) {
        [self.mutableArray addObject:identityStr];
    }
    [self.mutableArray addObject:@"+      "];

    /*
    NSArray *industryModelA;

    NSMutableArray * modelArray = [NSMutableArray array];
    for (IndustryModel *industryModel in  [DictionaryRepository getComment_IndustryModelArray]) {
        
        [modelArray addObject:industryModel.Name];
        
    }
    industryModelA = [modelArray copy];
    
    self.mutableArray = [NSMutableArray arrayWithArray:industryModelA];
    NSString * identityStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"Identity"];
    if (identityStr) {
        [self.mutableArray addObject:identityStr];
    }
    
    
    [self.mutableArray addObject:@"+      "];
    */
}

- (void)initUI{
 
    
    _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    
    _myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+330);
    self.signView  = [[JCTagListView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+300)];
    self.signView.tagSelectedBackgroundColor = [UIColor purpleColor];
    self.signView.tags = _mutableArray;
    self.signView .tagTextColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
    
    [_myScrollView addSubview:self.signView];
    [self.view addSubview:_myScrollView];

    
    __weak typeof(self) weakSelf = self;
    [self.signView setCompletionBlockWithSelected:^(NSInteger index) {
        if (index == _mutableArray.count-1) {
            //弹框
            [UIView animateWithDuration:.35 animations:^{
           //应该跳转
                
                JHPutVC * putVC = [[JHPutVC alloc] init];
                putVC.title = @"公司行业";
                putVC.textStr = @"请输入行业名称";
                putVC.secondVC = weakSelf;
                putVC.block = ^(NSString *string){
                    
                    [weakSelf.mutableArray insertObject:string atIndex:weakSelf .mutableArray.count-1];
                    [weakSelf.signView.collectionView reloadData];
                };
                
                [weakSelf.navigationController pushViewController:putVC animated:YES];
            }];
            
        }else{
            
//            [weakSelf.mutableArray removeObjectAtIndex:index];
            NSString * str = weakSelf.mutableArray[index];
            if (weakSelf.block) {
                weakSelf.block(str,nil);
            }
            [weakSelf.signView.collectionView reloadData];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    JXFooterView * footer = [JXFooterView footerView];
    footer.y = CGRectGetMaxY(self.signView.frame) + 25;
    footer.x = 0;
    footer.delegate = self;
    footer.nextLabel.text = @"保存";
    [self.view addSubview:footer];
    
}

- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{



}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
