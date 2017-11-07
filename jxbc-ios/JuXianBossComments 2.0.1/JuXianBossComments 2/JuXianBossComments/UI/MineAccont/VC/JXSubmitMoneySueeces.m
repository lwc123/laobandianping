//
//  JXSubmitMoneySueeces.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/29.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXSubmitMoneySueeces.h"

@interface JXSubmitMoneySueeces ()

@end

@implementation JXSubmitMoneySueeces

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现成功";
    [self isShowLeftButton:YES];
    [self initUI];
    
}

- (void)initUI{

    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100) * 0.5, 30 + 20, 100, 100)];
    imageView.image = [UIImage imageNamed:@"luch"];
    [self.view addSubview:imageView];
    
    UILabel * showLabel = [UILabel labelWithFrame:CGRectMake((SCREEN_WIDTH - 200) * 0.5, CGRectGetMaxY(imageView.frame) + 20, 200, 50) title:@"提现申请已提交！1个工作日内运营将处理您的请求。\n联系客服：400-815-9166" titleColor:[PublicUseMethod setColor:KColor_Text_ListColor] fontSize:12.0 numberOfLines:0];
    showLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:showLabel];
    
    UILabel * tradeLabel = [UILabel labelWithFrame:CGRectMake((SCREEN_WIDTH - 200) * 0.5, CGRectGetMaxY(showLabel.frame) + 10, 200, 12) title:@"可以在交易记录中查看提现信息" titleColor:[PublicUseMethod setColor:KColor_Text_BlackColor] fontSize:12.0 numberOfLines:1];
    tradeLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:tradeLabel];

}

- (void)leftButtonAction:(UIButton *)button{
    [self dismissLoadingIndicator];
    [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
