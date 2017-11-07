//
//  UserMessageVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/22.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "UserMessageVC.h"
#import "JXMessageCellThird.h"
#import "MyWalletCell.h"
#import "JXNoticeMessageVC.h"

@interface UserMessageVC (){

    JXNoticeMessageVC * _noticeVC;

}

@property (nonatomic,assign)int page;
@property (nonatomic,assign)int size;
@property (nonatomic,strong)NilView * nilView;
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)NSMutableArray *tmpArray;

@end

@implementation UserMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"消息";
    [self isShowLeftButton:YES];
    [self initData];
//    [self initMessage];
    [self initUI];
    [self.jxTableView.mj_header beginRefreshing];

}

- (void)initData{
    _page = 1;
    _size = 10;
    _dataArray = [NSArray array];
    _tmpArray = [NSMutableArray array];
}

- (void)initUI{

    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.jxTableView.tableFooterView = [[UIView alloc] init];
    [self.jxTableView registerNib:[UINib nibWithNibName:@"JXMessageCellThird" bundle:nil] forCellReuseIdentifier:@"jXMessageCellThird"];
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    __weak typeof(self) weakSelf = self;
    //下拉
    [self.jxTableView setDragDownRefreshWith:^{
        weakSelf.page = 1;
        [weakSelf initNoticeMsg];
    }];
    //上啦
    [self.jxTableView setDragUpLoadMoreWith:^{
        [weakSelf initNoticeMsg];
    }];
}



- (void)initNoticeMsg{
    
    if (self.jxTableView.mj_header.state == MJRefreshStateRefreshing) {
        //第二次刷新 清除原来的数据
        if (_dataArray.count!=0) {
            _dataArray = @[];
        }
    }
    MJWeakSelf
    [self showLoadingIndicator];
    [WorkbenchRequest getMessageListMessageType:1 size:weakSelf.size andPage:weakSelf.page success:^(JSONModelArray *array) {
        
        [weakSelf dismissLoadingIndicator];
        if (array.count == 0) {
            [weakSelf.jxTableView endRefresh];
            if (weakSelf.page !=1) {
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
            
            if (weakSelf.nilView) {
                [weakSelf.nilView removeFromSuperview];
                weakSelf.nilView = nil;
            }
            if (weakSelf.page == 1) {
                weakSelf.dataArray = @[];
            }
            weakSelf.tmpArray = weakSelf.dataArray.mutableCopy;
            for (JXMessageEntity *messageModel in array) {
                if ([messageModel isKindOfClass:[JXMessageEntity class]]) {
                    //标记
                    [weakSelf.tmpArray addObject:messageModel];
                }
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




- (void)initMessage{
    
    if (self.jxTableView.mj_header.state == MJRefreshStateRefreshing) {
        //第二次刷新 清除原来的数据
        if (_dataArray.count!=0) {
            _dataArray = @[];
        }
    }
    
    __weak typeof(self) weakSelf = self;
    [self showLoadingIndicator];
    [WorkbenchRequest getMessageWithSize:_size andPage:_page success:^(JSONModelArray *array) {
        [weakSelf dismissLoadingIndicator];
        if (array.count == 0) {
            
            if (_page == 1) {
                if (!_nilView) {
                    _nilView = [[NilView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                    _nilView.labelStr = @"还没有消息";
                    _nilView.isHiddenButton = YES;
                }
            }
            [self.jxTableView addSubview:_nilView];
            [self.jxTableView endRefresh];
            [self.jxTableView reloadData];
            
        }else{
            
            if (weakSelf.page == 1) {
                weakSelf.dataArray = @[];
            }
            weakSelf.page++;
            weakSelf.tmpArray = weakSelf.dataArray.mutableCopy;
            
            for (JXMessageEntity *messageModel in array) {
                if ([messageModel isKindOfClass:[JXMessageEntity class]]) {
                    [_tmpArray addObject:messageModel];
                }
            }
            _dataArray = _tmpArray;
            [self.jxTableView endRefresh];
            [self.jxTableView reloadData];
        }
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [self.jxTableView endRefresh];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [MyWalletCell sizeWithMessageModel:self.dataArray[indexPath.row]];
    return 62;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    JXMessageCellThird * messageCell = [tableView dequeueReusableCellWithIdentifier:@"jXMessageCellThird" forIndexPath:indexPath];
    
    MyWalletCell * walletCell = [MyWalletCell infoCellWithTableView:tableView];
    walletCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JXMessageEntity *messageModel = _dataArray[indexPath.row];

    if (messageModel.BizType == 0) {
        
    }else{
    }
//    messageCell.messageModel = messageModel;
//    return messageCell;
    walletCell.messageModel = messageModel;
    walletCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return walletCell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JXMessageEntity *messageModel = _dataArray[indexPath.row];
    _noticeVC = [[JXNoticeMessageVC alloc] init];
    _noticeVC.messageModel = messageModel;
    
    if (messageModel.IsRead == 0) {
        [self isReadWithMessageId:messageModel.MessageId conr:_noticeVC];
    }else{
        [self.navigationController pushViewController:_noticeVC animated:YES];
    }
}

#pragma mark -- 调已读接口
- (void)isReadWithMessageId:(long)messageId conr:(UIViewController *)vc{
    MJWeakSelf
    [self showLoadingIndicator];
    [WorkbenchRequest getReadMsgForMessageId:messageId success:^(id result) {
        [weakSelf dismissLoadingIndicator];
        if ([result integerValue] > 0) {
            //是不是这好点
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [weakSelf.jxTableView endRefresh];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
