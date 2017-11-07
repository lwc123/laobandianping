//
//  JXBindIDCardVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/27.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXBindIDCardVC.h"
#import "MyArchiveList.h"

@interface JXBindIDCardVC ()<JXFooterViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong)UITextField *allFieldText;



@property (nonatomic,strong)PrivatenessServiceContract *contract;


@end

@implementation JXBindIDCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的档案";
    [self isShowLeftButton:YES];
    [self initData];
    [self initUI];
}

- (void)initData{

    _contract = [[PrivatenessServiceContract alloc] init];

}

- (void)initUI{
    // 关闭滚动
    self.jxTableView.scrollEnabled = NO;
    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    JXFooterView * footerView = [JXFooterView footerView];
    footerView.nextLabel.text = @"保存并查询";
    footerView.delegate= self;
    UILabel * textLabel = [UILabel labelWithFrame:CGRectMake(53, CGRectGetMaxY(footerView.frame) - 10, SCREEN_WIDTH - 106, 11) title:@"身份证号填写后不能修改，请谨慎填写" titleColor:[PublicUseMethod setColor:KColor_Text_EumeColor] fontSize:11.0 numberOfLines:1];
    [footerView addSubview:textLabel];
    self.jxTableView.tableFooterView = footerView;
    self.jxTableView.scrollEnabled = NO;
    [self.jxTableView registerNib:[UINib nibWithNibName:@"TextfieldCell" bundle:nil] forCellReuseIdentifier:@"textfieldCell"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString * cellId = @"myCellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        CGFloat allFieldTexW = 235;
        _allFieldText = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, allFieldTexW, 44)];
        _allFieldText.textAlignment = NSTextAlignmentLeft;
        _allFieldText.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
        _allFieldText.font = [UIFont systemFontOfSize:15];
        _allFieldText.delegate = self;
        [cell.contentView addSubview:_allFieldText];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
    
    if (indexPath.row == 0) {
        cell.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
        _allFieldText.hidden = YES;
        cell.textLabel.text = @"为了查询更精准及保护隐私，请校验身份";
    }else{
        _allFieldText.placeholder = @"请输入您的身份证号";
        _allFieldText.tag = 10;
        cell.textLabel.text = @"身份证号";
    }
    return cell;
}


#pragma mark -- 保存并查询
- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{
    
    //先暂时写2  实际上是1
    UITextField *idCardFieldText = [self.view viewWithTag:10];
    if (idCardFieldText.text.length == 0) {
        [PublicUseMethod showAlertView:@"请输入身份证号"];
        return;
    }
    
    if (![PublicUseMethod verifyIDCardNumber:idCardFieldText.text]) {
        [PublicUseMethod showAlertView:@"请输入合法身份证号"];
        return;
    }
    [self showLoadingIndicator];
    [UserWorkbenchRequest postPrivatenessBindingIDCard:idCardFieldText.text success:^(id result) {
        [self dismissLoadingIndicator];
//        Log(@"result===%@",result);

        if ([result[@"Success"] integerValue] > 0) {
            
            _contract = [[PrivatenessServiceContract alloc] initWithString:result[@"JsonModel"] error:nil];;
            MyArchiveList * myArchiveList = [[MyArchiveList alloc] init];
            
            [UserAuthentication saveUserContract:_contract];
            myArchiveList.idCardFieldStr = idCardFieldText.text;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController pushViewController:myArchiveList animated:YES];
            });
            
        }else{
        
            [PublicUseMethod showAlertView:result[@"ErrorMessage"]];
        
        }
        
    } fail:^(NSError *error) {
       [self dismissLoadingIndicator];
        NSLog(@"error===%@",error);
    }];
    
    
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
