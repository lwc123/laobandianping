//
//  JHMenuTabbleView.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHMenuTabbleView.h"
static NSTimeInterval const kSheetAnimationDuration = 0.25;


@interface JHMenuTabbleView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView      *jhTableView;
@property (nonatomic, strong) NSArray          *myDataArray;
@property (nonatomic,strong) UIView            *bottomView;
@property (nonatomic,assign) CGFloat selfX;
@property (nonatomic, assign) CGFloat selfHeight;
@property (nonatomic, assign) CGFloat selfWidth;

@end

@implementation JHMenuTabbleView

- (instancetype)initWithViewX:(CGFloat)viewx
                       width:(CGFloat)width
                       height:(CGFloat)height
                      delegat:(id<JHMenuTabbleViewDelaegate >)aDelegat{

    if (self = [super initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)]) {
//        self.alpha = 0.f;
//        self.backgroundColor = [UIColor blackColor];
        self.delegate = aDelegat;
        self.selfX = viewx;
        self.selfWidth = width;
        self.selfHeight = height;
        [self createSubView];
    }
    return self;
}

-(UIView *)bottomView
{
    if(!_bottomView){
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blackTap)];
        _bottomView.userInteractionEnabled = YES;
        [_bottomView addGestureRecognizer:tap];
    }
    return _bottomView;
}

- (void)blackTap{

    if ([self.delegate respondsToSelector:@selector(menuViewRecognizer:)]) {
        
        [self.delegate menuViewRecognizer:self];
    }

}

- (void)createSubView{

    _myDataArray = [NSArray array];
    [self addSubview:self.bottomView];
    
    [self addSubview:self.jhTableView];
    
}


-(void)refreshWithData:(NSArray *)data
{
    self.myDataArray = data;
    [self.jhTableView reloadData];
}
- (UITableView *)jhTableView{

    if (!_jhTableView) {
        
        _jhTableView = [[UITableView alloc] initWithFrame:CGRectMake(_selfX, 0, _selfWidth, _selfHeight)];
        [_jhTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
        _jhTableView.delegate =self;
        _jhTableView.dataSource = self;
    }

    return _jhTableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _myDataArray.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];

    if (!cell) {
        
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.textLabel.text = _myDataArray[indexPath.row];
    cell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(menuView:indexPath:)]) {
        [self.delegate menuView:self indexPath:indexPath];
    }
}

//- (void)showInView:(UIView *)view
//{
//    [view addSubview:self];
//    
//    CGRect frame = self.bottomView.frame;
//
//    frame.origin.y = 0;
//    
//    [UIView animateWithDuration:kSheetAnimationDuration
//                          delay:0.f
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         
//                         
//                         self.bottomView.frame = frame;
//                         self.alpha = 1.f;
//                     } completion:^(BOOL finished) {
//                         
//                     }];
//}

//- (void)dismiss
//{
//    CGRect frame = self.bottomView.frame;
//    frame.origin.y = SCREEN_HEIGHT;
//    [UIView animateWithDuration:kSheetAnimationDuration
//                          delay:0.f
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         self.bottomView.frame = frame;
//                         self.alpha = 0;
//                     } completion:^(BOOL finished) {
//                         [self removeFromSuperview];
//                     }];
//}


@end
