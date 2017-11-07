//
//  JXNoticeMessageVC.m
//  JuXianBossComments
//
//  Created by juxian on 2017/2/9.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JXNoticeMessageVC.h"
#import "JXMessageCellThird.h"
#import "JXMessageVC.h"

@interface JXNoticeMessageVC ()
@property (nonatomic, strong) UIView *detailView;

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation JXNoticeMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"消息";
    [self isShowLeftButton:YES];
    [self initUI];
}

- (void)initUI{

    [self.jxTableView addSubview:self.detailView];
    self.jxTableView.scrollEnabled = NO;
}

- (void)leftButtonAction:(UIButton *)button{
    
    if ([self.navigationController.viewControllers[1] isKindOfClass:[JXMessageVC class]]) {
        JXMessageVC * messageVC = self.navigationController.viewControllers[1];
        [messageVC.jxTableView.mj_header beginRefreshing];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIView *)detailView{

    if (!_detailView) {
        _detailView = [[UIView alloc]initWithFrame:self.jxTableView.bounds];
        _detailView.backgroundColor = [UIColor whiteColor];
        self.iconView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 50, 50)];
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.messageModel.Picture] placeholderImage:LOADing_Image];
        [_detailView addSubview:self.iconView];
        
        self.contentLabel = [[UILabel alloc]init];
        self.contentLabel.font = [UIFont systemFontOfSize:15];
        self.contentLabel.textColor = ColorWithHex(KColor_Text_BlackColor);
        self.contentLabel.text = self.messageModel.Content;
        self.contentLabel.numberOfLines = 0;
        [_detailView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconView).offset(8);
            make.left.equalTo(self.iconView.mas_right).offset(8);
            make.right.equalTo(_detailView).offset(-8);
        }];
        
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.font = [UIFont systemFontOfSize:13];
        self.timeLabel.textColor = ColorWithHex(KColor_Text_ListColor);
        self.timeLabel.text = [self distanceTimeWithBeforeTime:self.messageModel.CreatedTime];
        [_detailView addSubview:self.timeLabel];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentLabel);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(20);
            make.height.mas_equalTo(10);
        }];
        
        
    }
    return _detailView;
}

// 时间格式化
- (NSString *)distanceTimeWithBeforeTime:(NSDate *)date

{
    NSTimeInterval beTime = [date timeIntervalSince1970];
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    double distanceTime = now - beTime;
    
    
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    
    if (distanceTime < 60) {//小于一分钟
        
        distanceStr = @"刚刚";
        
    }
    
    else if (distanceTime < 60*60) {//时间小于一个小时
        
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
        
    }
    
    else if(distanceTime < 60*60*24){//时间小于一天
        
        distanceStr = [NSString stringWithFormat:@"%ld小时前",(long)distanceTime/3600];
        
    }
    
    
    else{
        
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        distanceStr = [df stringFromDate:beDate];
        
    }
    
    return distanceStr;
    
}


@end
