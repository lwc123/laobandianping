//
//  AdviceFeedbackViewController.m
//  JuXianBossComments
//
//  Created by Jam on 17/2/7.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "AdviceFeedbackViewController.h"
#import "ContactUsViewController.h"
#import "NSString+RegexCategory.h"
#import "MineRequest.h"
#import "FeedbackEntity.h"
// 字数限制
const int MaxLetterCount = 1000;

@interface AdviceFeedbackViewController ()<UITextViewDelegate>

// 反馈次数
@property (nonatomic, assign) NSInteger adviceCount;
// 输入框
@property (nonatomic, strong) IBOutlet UITextView *textview;
// 提交按钮
@property (nonatomic, strong) JXFooterView *footerView;
// 字数label
@property (nonatomic, strong) IBOutlet UILabel *letterCountLabel;

@property (nonatomic, assign) BOOL isGetFeedbackCount;

@property (nonatomic, assign) int feedbackCount;

@end

@implementation AdviceFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self isShowLeftButton:YES];
    
    self.textview.delegate = self;
    [self initData];
}

- (void)initData{
    self.isGetFeedbackCount = NO;
    self.feedbackCount = 0;
    [self requestFeedbackCount];
}

- (void)requestFeedbackCount{
    MJWeakSelf
    [MineRequest getAdviceFeedbackFrequencyWithPassportId:[UserAuthentication GetPassportId] success:^(id result) {
        Log(@"请求反馈次数成功");
        weakSelf.feedbackCount = [result intValue];
        weakSelf.isGetFeedbackCount = YES;
    } fail:^(NSError *error) {
        [PublicUseMethod showAlertView:error.localizedDescription];
        Log(@"请求反馈次数失败");
    }];
}

#pragma mark - function
- (IBAction)jxFooterViewDidClickedNextBtn{
    NSString* text = _textview.text;
    
    // 判断当前提交次数
    if (self.isGetFeedbackCount) { //请求到了
        
        if (self.feedbackCount>2) { // 没超过3次
            [PublicUseMethod showAlertView:@"很抱歉~每天最多只能提交3次"];
            return;
        }
        
    }else{ // 没请求到
        [self requestFeedbackCount];
        [PublicUseMethod showAlertView:@"网络链接超时，请稍后再试"];

        return;
    }

    // 判断文字长度
    if (text.length<5) {
        [PublicUseMethod showAlertView:@"您输入的文字过少，需多于5个字更有助于我们解决您的问题 !"];
        return;
    }
    if (text.length>1000) {
        [PublicUseMethod showAlertView:@"抱歉！您输入的文字太多了，请在1000个字以内"];

        return;
    }
    
    // 判断是否含有表情
    if ([text isContainsEmoji]) {
        [PublicUseMethod showAlertView:@"抱歉，请不要输入表情"];

        return;
    }

    FeedbackEntity* entity = [[FeedbackEntity alloc]init];
    
    entity.Content = text;
    entity.CompanyId = [UserAuthentication GetMyInformation].CompanyId;
    
    // 提交
    MJWeakSelf

    [MineRequest postAddFeedback:entity success:^(ResultEntity *resultEntity) {
        [self alertStringWithTitle:@"感谢您的建议！" String:@"您的意见已经收到，将会有专业人员来处理您的反馈。这对我们提升服务品质来说非常的重要！欢迎您再次提出建议！" doneButton:YES cancelButton:NO duration:0 doneClick:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
    
        }];

    } fail:^(NSError *error) {
        Log(@"%@",error.localizedDescription);
    }];
}

#pragma mark - textView delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if (textView.text.length > 1000) {
        self.letterCountLabel.textColor = ColorWithHex(@"F4504B");
    }else{
        self.letterCountLabel.textColor = ColorWithHex(KColor_Text_ListColor);
    }
    //不让显示负数
    self.letterCountLabel.text = [NSString stringWithFormat:@"%ld",MAX(0,textView.text.length)];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 1000) {
        self.letterCountLabel.textColor = ColorWithHex(@"F4504B");
    }else{
        self.letterCountLabel.textColor = ColorWithHex(KColor_Text_ListColor);
    }
    //不让显示负数
    self.letterCountLabel.text = [NSString stringWithFormat:@"%ld",MAX(0,textView.text.length)];

    
//    NSString  *nsTextContent = textView.text;
//    NSInteger existTextNum = nsTextContent.length;
//    
//    if (existTextNum > MaxLetterCount)
//    {
//        //截取到最大位置的字符
//        NSString *s = [nsTextContent substringToIndex:MaxLetterCount];
//        
//        [textView setText:s];
//    }
//
//    //不让显示负数
//    self.letterCountLabel.text = [NSString stringWithFormat:@"%ld",MAX(0,existTextNum)];
}

#pragma mark - 联系我们按钮
- (IBAction)contactUsClick{

    ContactUsViewController * contactUsVc = [[ContactUsViewController alloc]init];
    [self.navigationController pushViewController:contactUsVc animated:YES];
    
}

@end
