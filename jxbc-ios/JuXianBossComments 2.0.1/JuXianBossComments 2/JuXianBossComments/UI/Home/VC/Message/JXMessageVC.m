//
//  JXMessageVC.m
//  JuXianBossComments
//
//  Created by CZX on 16/12/16.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXMessageVC.h"
#import "JXTableView.h"
#import "JXMessageCellThird.h"
#import "DepartureCheckVC.h"
#import "JXBaseSrollView.h"
#import "JXNoticeMessageVC.h"
#import "messageButton.h"

@interface JXMessageVC (){

    //选中时的下划线
    UIView *_underLine;
    //记录选中的button的TAG值
    NSInteger _index;
    JXBaseSrollView *_scrollView;
    JXNoticeMessageVC * _noticeVC;
    messageButton * _noticeBtn;
    messageButton * _waitBtn;
    BOOL _noticeIsShow;
    BOOL _waitsShow;

}
@property(nonatomic,assign)NSInteger passportId;

@property(nonatomic,assign)NSInteger compID;
@property (nonatomic,strong)CompanyMembeEntity * myEntity;
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)NSMutableArray *tmpArray;
//通知
@property (nonatomic, strong)NSArray *dataNoticeArray;
@property (nonatomic, strong)NSMutableArray *tmpNoticeArray;

@property (nonatomic,strong)NilView * nilView;
@property(nonatomic,assign) int page;
@property (nonatomic, assign) int size;
//通知的page  Size
@property (nonatomic, assign) int noticePage;
@property (nonatomic, assign) int noticeSize;
@property (nonatomic, assign) int messageType;

@end

@implementation JXMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    [self isShowLeftButton:YES];
    [self initData];
    self.compID = [UserAuthentication GetMyInformation].CompanyId;
    self.passportId = [UserAuthentication GetMyInformation].PassportId;

    //一进来就请求待处理消息
    _messageType = 2;
    [self initMessageType];
    
    //为了展示红点所以一开始都要展示
    [self initNoticeMsg];
    [self addChoiceItems];
    [self setupUI];

}


- (void)initData{
    _myEntity = [UserAuthentication GetMyInformation];
    self.page = 1;
    self.size = 10;//SC.XJH.2.9size
    self.noticePage = 1;
    self.noticeSize = 10;//SC.XJH.2.9size
}

- (NSArray *)dataArray{

    if (_dataArray == nil) {
        
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)tmpArray{

    if (_tmpArray == nil) {
        _tmpArray = [[NSMutableArray alloc] init];
    }
    return _tmpArray;
}

- (NSArray *)dataNoticeArray{

    if (_dataNoticeArray == nil) {
        
        _dataNoticeArray = [[NSArray alloc] init];
    }
    return _dataNoticeArray;
}

- (NSMutableArray *)tmpNoticeArray{
    if (_tmpNoticeArray == nil) {
        _tmpNoticeArray = [[NSMutableArray alloc] init];
    }
    return _tmpNoticeArray;
}

-(void)setupUI
{

//    tableView.rowHeight = UITableViewAutomaticDimension;
    self.jxTableView.frame =CGRectMake(0, 47, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 47);
    self.jxTableView.tableFooterView = [[UIView alloc] init];
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    self.jxTableView.showsHorizontalScrollIndicator = YES;
    
    [self.jxTableView registerNib:[UINib nibWithNibName:@"JXMessageCell" bundle:nil] forCellReuseIdentifier:@"messageCellID"];
    
    [self.jxTableView registerNib:[UINib nibWithNibName:@"JXMessageCellThird" bundle:nil] forCellReuseIdentifier:@"messageAgain"];
    
    MJWeakSelf
    [self.jxTableView setDragDownRefreshWith:^{
        
        if (weakSelf.messageType == 1) {//通知
            weakSelf.noticePage = 1;
            [weakSelf initNoticeMsg];
        }
        if (weakSelf.messageType == 2) {
            weakSelf.page = 1;
            [weakSelf initWaitMsg];
            
        }
    }];
    
    [self.jxTableView setDragUpLoadMoreWith:^{
        
        if (weakSelf.messageType == 1) {//通知
            weakSelf.noticePage++;//SC.XJH
            [weakSelf initNoticeMsg];
        }
        if (weakSelf.messageType == 2) {
            weakSelf.page++;//SC.XJH
            [weakSelf initWaitMsg];
        }
    }];

}

- (void)addChoiceItems{
    NSArray *titleArray = @[@"待处理事项",@"通 知"];
    float width = SCREEN_WIDTH/2;
    
    for (int i = 0; i < titleArray.count; i ++) {
        messageButton *button = [[messageButton alloc]initWithFrame:CGRectMake(width*i, 0, width, 36)];
        button.backgroundColor = [UIColor whiteColor];
        button.tag = 10+i;
        
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[PublicUseMethod setColor:KColor_Text_BlackColor] forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        if (button.tag ==10) {
            [button setTitleColor:[PublicUseMethod setColor:KColor_RedColor] forState:UIControlStateNormal];
            _index = 10;
        }
        [self.view addSubview:button];
    
    }
    _noticeBtn = [self.view viewWithTag:11];
    _waitBtn = [self.view viewWithTag:10];
    _underLine = [[UIView alloc]initWithFrame:CGRectMake(0, 35, width, 1)];
    _underLine.backgroundColor = [PublicUseMethod setColor:KColor_RedColor];
    [self.view addSubview:_underLine];
    
}

#pragma mark - selectAction
- (void)selectAction:(UIButton*)button
{
    UIButton *button1 = (UIButton*)[self.view viewWithTag:_index];
    
    //变黑色
    [button1 setTitleColor:[PublicUseMethod setColor:KColor_Text_BlackColor] forState:UIControlStateNormal];
    //变红色
    [button setTitleColor:[PublicUseMethod setColor:KColor_RedColor] forState:UIControlStateNormal];
    
    if (button.tag == 10) {//待处理
        _messageType = 2;
        _page = 1;
        [self initWaitMsg];
    }
    if (button.tag == 11) {//通知
        
        _messageType = 1;
        _noticePage = 1;
        [self initNoticeMsg];
    }
    
    _index = button.tag;
    
    [UIView animateWithDuration:.35 animations:^{
        
        _underLine.x = (SCREEN_WIDTH/2)*(_index -10);
        
        CGPoint point = CGPointMake((_index-10)*SCREEN_WIDTH, 0);
        _scrollView.contentOffset = point;
    }];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_messageType == 1) {//通知
        return [JXMessageCellThird sizeWithMessageModel:self.dataNoticeArray[indexPath.row]];

    }else{
        return [JXMessageCellThird sizeWithMessageModel:self.dataArray[indexPath.row]];
    }
//    return 82;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messageType == 1?self.dataNoticeArray.count : self.dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JXMessageCellThird *cell1 = [tableView dequeueReusableCellWithIdentifier:@"messageAgain" forIndexPath:indexPath];
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JXMessageEntity *messageModel = _messageType == 1 ? self.dataNoticeArray[indexPath.row] : _dataArray[indexPath.row];
    cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell1.messageModel = messageModel;
    return cell1;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JXMessageEntity *messageModel = _messageType == 1? self.dataNoticeArray[indexPath.row] : self.dataArray[indexPath.row];
    if (_messageType == 1) {//通知
        NSLog(@"ddd");
        _noticeVC = [[JXNoticeMessageVC alloc] init];
        _noticeVC.messageModel = messageModel;
        
        if (messageModel.IsRead == 0) {
            [self isReadWithMessageId:messageModel.MessageId conr:_noticeVC];
        }else{
            [self.navigationController pushViewController:_noticeVC animated:YES];
        }
    }else{

        DepartureCheckVC * departureVC = [[DepartureCheckVC  alloc] init];
        departureVC.commentId = messageModel.BizId;
        departureVC.companyId = messageModel.ToCompanyId;
        if (messageModel.BizType == 2) {
            departureVC.title = @"离任报告";
        }else if (messageModel.BizType == 3){
            departureVC.title = @"阶段评价";
        }
        departureVC.BizType = messageModel.BizType;
        if (messageModel.IsRead == 0) {
            [self isReadWithMessageId:messageModel.MessageId conr:departureVC];
        }else{
            [self.navigationController pushViewController:departureVC animated:YES];
        }
    }
}

#pragma mark -- 调已读接口
- (void)isReadWithMessageId:(long)messageId conr:(UIViewController *)vc{
    MJWeakSelf
    [self showLoadingIndicator];
    [WorkbenchRequest getReadMsgForMessageId:messageId success:^(id result) {
        [weakSelf dismissLoadingIndicator];
        NSLog(@"result===%@",result);
        if ([result integerValue] > 0) {
            //是不是这好点
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [weakSelf.jxTableView endRefresh];

        NSLog(@"error===%@",error);
    }];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)initMessageType{
    
    if (_messageType == 1) {//通知
        
        [self initNoticeMsg];
    }
    if (_messageType == 2) {//待处理
        [self initWaitMsg];
    }
}

- (void)initWaitMsg{

    MJWeakSelf
    [self showLoadingIndicator];
    [WorkbenchRequest getMessageListMessageType:2 size:weakSelf.size andPage:weakSelf.page success:^(JSONModelArray *array) {
        
        [weakSelf dismissLoadingIndicator];
        
        Log(@"%ld",array.count);
        if (array.count == 0) {
            _waitBtn.showRedPoint = NO;
            [weakSelf.jxTableView endRefresh];
            if (weakSelf.page !=1) {
//                weakSelf.page--;SC.XJH
                return ;
            }
            if (!_nilView) {
                _nilView = [[NilView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                _nilView.labelStr = @"主人，消息空空如也";
                _nilView.isHiddenButton = YES;
            }
            [weakSelf.jxTableView addSubview:_nilView];
            [weakSelf.jxTableView reloadData];
            
        }else{
            
            if (weakSelf.nilView && _messageType == 2) {
                [weakSelf.nilView removeFromSuperview];
                weakSelf.nilView = nil;
            }
            if (weakSelf.page == 1) {
                weakSelf.dataArray = @[];
            }
//            weakSelf.page++;//page问题
            weakSelf.tmpArray = weakSelf.dataArray.mutableCopy;
            _waitsShow = NO;
            for (JXMessageEntity *messageModel in array) {
                if ([messageModel isKindOfClass:[JXMessageEntity class]]) {
                    if (messageModel.IsRead == 0) {
                        _waitsShow = YES;
                    }
                    [weakSelf.tmpArray addObject:messageModel];
                }
            }
            if (_waitsShow == YES) {
                _waitBtn.showRedPoint = YES;
            }else{
                _waitBtn.showRedPoint = NO;
            }
            weakSelf.dataArray = weakSelf.tmpArray.copy;
            [weakSelf.jxTableView endRefresh];
            [weakSelf.jxTableView reloadData];
        }
        
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [weakSelf.jxTableView endRefresh];
    }];

}

- (void)initNoticeMsg{

    MJWeakSelf
    [self showLoadingIndicator];
    [WorkbenchRequest getMessageListMessageType:1 size:weakSelf.noticeSize andPage:weakSelf.noticePage success:^(JSONModelArray *array) {
        
        [weakSelf dismissLoadingIndicator];
        
        Log(@"%ld",array.count);
        if (array.count == 0) {
            _noticeBtn.showRedPoint = NO;
            [weakSelf.jxTableView endRefresh];
            if (weakSelf.noticePage !=1) {
//                weakSelf.noticePage--;SC.XJH
                return ;
            }
            if (!_nilView && _messageType == 1) {
                _nilView = [[NilView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                _nilView.labelStr = @"主人，消息空空如也";
                _nilView.isHiddenButton = YES;
            }
            [weakSelf.jxTableView addSubview:_nilView];
            [weakSelf.jxTableView reloadData];
        }else{
            
            if (weakSelf.nilView) {
                [weakSelf.nilView removeFromSuperview];
                weakSelf.nilView = nil;
            }
            if (weakSelf.noticePage == 1) {
                weakSelf.dataNoticeArray = @[];
            }
//            weakSelf.noticePage++;//page问题
            weakSelf.tmpNoticeArray = weakSelf.dataNoticeArray.mutableCopy;
            _noticeIsShow = NO;
            for (JXMessageEntity *messageModel in array) {
                if ([messageModel isKindOfClass:[JXMessageEntity class]]) {
                    //标记
                    if (messageModel.IsRead == 0) {
                        _noticeIsShow = YES;
                    }
                    
                    [weakSelf.tmpNoticeArray addObject:messageModel];
                }
            }
            if (_noticeIsShow == YES) {
                _noticeBtn.showRedPoint = YES;
            }else{
                _noticeBtn.showRedPoint = NO;
            }
            weakSelf.dataNoticeArray = weakSelf.tmpNoticeArray.copy;
            [weakSelf.jxTableView endRefresh];
            [weakSelf.jxTableView reloadData];
        }
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [weakSelf.jxTableView endRefresh];
    }];

}

@end
