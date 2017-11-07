//
//  AddArchiveOnPcVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/29.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "AddArchiveOnPcVC.h"

@interface AddArchiveOnPcVC ()

@end

@implementation AddArchiveOnPcVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"建立员工档案";
    [self isShowLeftButton:YES];
    [self initUI];
}

- (void)initUI{


    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 94) * 0.5, 30 + 20, 94, 94)];
    imageView.image = [UIImage imageNamed:@"company"];
    [self.view addSubview:imageView];
    
    UILabel * showLabel = [UILabel labelWithFrame:CGRectMake((SCREEN_WIDTH - 150) * 0.5, CGRectGetMaxY(imageView.frame) + 10, 150, 50) title:@"用电脑浏览器打开网址www.laobandianping.com" titleColor:[PublicUseMethod setColor:KColor_Text_ListColor] fontSize:12.0 numberOfLines:0];
    showLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:showLabel];



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
