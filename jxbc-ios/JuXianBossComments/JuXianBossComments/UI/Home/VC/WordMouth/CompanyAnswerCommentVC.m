//
//  CompanyAnswerCommentVC.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "CompanyAnswerCommentVC.h"
#import "IWTextView.h"
#import "JHTextNumberView.h"
#import "CompanyWordMouthVC.h"
#import "OpinionReplyEntity.h"

@interface CompanyAnswerCommentVC ()<UITextViewDelegate,JXFooterViewDelegate>

@property (nonatomic, strong) IWTextView *myTextView;
@property (nonatomic, strong) UILabel *changeLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong)  JHTextNumberView * myNTextView;
@end

@implementation CompanyAnswerCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self isShowLeftButton:YES];
    [self initUI];
}

- (void)initUI{


    [self.view addSubview:self.myNTextView];
    
//    [self.view addSubview:self.myTextView];
//    [self.view addSubview:self.changeLabel];
//    [self.view addSubview:self.numberLabel];
    JXFooterView * footer = [JXFooterView footerView];
    footer.frame = CGRectMake(20, CGRectGetMaxY(self.myNTextView.frame) + 25, SCREEN_WIDTH - 40, 44);
    footer.nextLabel.text = @"匿名评论";
    footer.delegate = self;
    [self.view addSubview:footer];
}




#pragma mark -- 回复
- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{

    if (self.myNTextView.myTextView.text.length == 0) {
        [PublicUseMethod showAlertView:@"评论不能为空~"];
        return;
    }
    
    if (self.myNTextView.myTextView.text.length > 140) {
        [PublicUseMethod showAlertView:@"评论最多140字哦~"];
        return;
    }
    
    OpinionReplyEntity * replyEntity = [[OpinionReplyEntity alloc] init];
    replyEntity.OpinionId = self.opinionEntity.OpinionId;
    replyEntity.CompanyId = self.opinionEntity.CompanyId;
    replyEntity.Content = self.myNTextView.myTextView.text;
    
    if ([self.secondVC isKindOfClass:[CompanyWordMouthVC class]]) {//回复评论 公司口碑
        replyEntity.ReplyType = 1;
    }else{//点评详情 谢谢评论
    
        replyEntity.ReplyType = 0;
    }
    NSLog(@"replyEntity===%@",[replyEntity toJSONString]);
    [self showLoadingIndicator];
    MJWeakSelf
    [UserOpinionRequest postOpinionReplyCreateWith:replyEntity success:^(ResultEntity *resultEntity) {
        [weakSelf dismissLoadingIndicator];
        if (resultEntity.Success) {
            
            [PublicUseMethod showAlertView:@"评论成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
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

- (JHTextNumberView *)myNTextView{
    if (_myNTextView == nil) {
        _myNTextView = [[JHTextNumberView alloc] initWithplacehoder:@"发布评论" numbertaxt:@"140" textViewHeight:170];
        _myNTextView.backgroundColor = [UIColor whiteColor];
        _myNTextView.frame = CGRectMake(10, 10, SCREEN_WIDTH- 20, 190);
    }
    return _myNTextView;
}

- (UILabel *)changeLabel{

    if (_changeLabel == nil) {
        
        _changeLabel = [UILabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(self.myTextView.frame), SCREEN_WIDTH - 40, 20) title:@"0" titleColor:[PublicUseMethod setColor:KColor_Text_EumeColor] fontSize:11.0 numberOfLines:1];
        _changeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _changeLabel;
}

- (UILabel *)numberLabel{
    if (_numberLabel == nil) {
        
        _numberLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.changeLabel.frame), CGRectGetMaxY(self.myTextView.frame), 40, 20) title:@"/140" titleColor:[PublicUseMethod setColor:KColor_Text_EumeColor] fontSize:11.0 numberOfLines:1];
    }
    return _numberLabel;
}

- (IWTextView *)myTextView{

    if (_myTextView == nil) {
        _myTextView =[[IWTextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        _myTextView.placeholder = @"  发表评论";
        _myTextView.placeholderColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
        _myTextView.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
        _myTextView.delegate = self;
    }
    return _myTextView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    if (![self.myTextView isExclusiveTouch]) {
        
        [self.myTextView resignFirstResponder];
    }
}


- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length > 140) {
        
        self.changeLabel.textColor = [UIColor redColor];
    }else{
        
        self.changeLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
        
    }
    self.changeLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)textView.text.length];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
