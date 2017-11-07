//
//  JobEditWorkDetailController.m
//  JuXianBossComments
//
//  Created by Jam on 17/1/16.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JobEditWorkDetailController.h"
#import "IWTextView.h"

// 字数限制
const int MAX_LIMIT_NUMS = 5000;

@interface JobEditWorkDetailController ()<UITextViewDelegate,JXFooterViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) IWTextView *textView;

@property (nonatomic, strong) JXFooterView *footerView;

@property (nonatomic, copy) EndEditWorkDetailBlock endEditWorkDetailBlock;

@property (nonatomic, copy) NSString *descriptionStr;

@end

@implementation JobEditWorkDetailController

- (void)loadView{
    [super loadView];
    UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    scrollView.backgroundColor = [UIColor orangeColor];
    scrollView.scrollEnabled = NO;
    scrollView.delegate = self;
    self.view = scrollView;
}

-(instancetype)initWithDescripton:(NSString *)string{
    
    self = [super init];
    if (self) {
        _descriptionStr = string;
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"职位描述";
    [self isShowLeftButton:YES];
    [self isShowRightButton:YES with:@"确认"];

    [self.view addSubview:self.textView];
    [self.view addSubview:self.footerView];
//    [self setupConstraints];
    if (self.descriptionStr) {
        self.textView.text = self.descriptionStr;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self.view endEditing:YES];
    
}
- (void)setupConstraints{
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.height.mas_equalTo(300);
    }];
    
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(95);
    }];
    
    
}


#pragma mark - textView delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    //不让显示负数
    //    self.textView.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,MAX_LIMIT_NUMS - existTextNum),MAX_LIMIT_NUMS];
}

#pragma mark - function
- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{
    
    
    // 回传
    self.endEditWorkDetailBlock(self.textView.text);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)completeEndEditWorkDetailBlock:(EndEditWorkDetailBlock)endEditWorkDetailBlock{
    
    if (endEditWorkDetailBlock) {
        self.endEditWorkDetailBlock = endEditWorkDetailBlock;
    }
    
}
#pragma mark - view


- (IWTextView *)textView{
    if (!_textView) {
        _textView = [[IWTextView alloc]initWithFrame:CGRectMake(16, 30, ScreenWidth - 32, ScreenHeight* 0.4)];
        _textView.width = ScreenWidth - 36;
        _textView.placeholder = @"填写详细、清晰的职位描述，有助于您得到更匹配的候选人\n例如：\n1.岗位职责（工作内容）……；\n2.任职要求（硬技能、软实力等）……；\n3.职位优势诱惑……；\n4.团队介绍……；";
        _textView.placeholderColor = [UIColor lightGrayColor];
        _textView.delegate = self;
//        _textView.showsVerticalScrollIndicator = NO;
//        _textView.showsHorizontalScrollIndicator = NO;
        _textView.font = [UIFont systemFontOfSize:14];
        
        self.footerView.y = CGRectGetMaxY(_textView.frame);
    }
    return _textView;
}

- (JXFooterView *)footerView{
    
    if (_footerView == nil) {
        _footerView = [JXFooterView footerView];
        _footerView.width = ScreenWidth;
        _footerView.nextLabel.text = @"确认";
        _footerView.delegate = self;
    }
    return _footerView;
}

- (void)rightButtonAction:(UIButton *)button{
    
    [self jxFooterViewDidClickedNextBtn:nil];
    
}

@end


