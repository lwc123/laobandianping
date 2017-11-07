//
//  UserMessageVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/22.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "UserMessageVC.h"
#import "JXMessageCellThird.h"

@interface UserMessageVC ()

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
    [self initMessage];
    [self initUI];
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
}


- (void)initMessage{
    __weak typeof(self) weakSelf = self;

    [self showLoadingIndicator];
    [WorkbenchRequest getMessageWithSize:_size andPage:_page success:^(JSONModelArray *array) {
        NSLog(@"array===%@",array);
        [weakSelf dismissLoadingIndicator];
        if (array.count == 0) {
            if (!_nilView) {
                _nilView = [[NilView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                _nilView.labelStr = @"还没有消息";
                _nilView.isHiddenButton = YES;
            }
            [self.jxTableView addSubview:_nilView];
            [self.jxTableView reloadData];
            
        }else{
            
            for (JXMessageEntity *messageModel in array) {
                
                if ([messageModel isKindOfClass:[JXMessageEntity class]]) {
                    [_tmpArray addObject:messageModel];
                }
            }
            _dataArray = _tmpArray;
            [self.jxTableView reloadData];
        }
        
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        NSLog(@"error===%@",error);
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JXMessageCellThird * messageCell = [tableView dequeueReusableCellWithIdentifier:@"jXMessageCellThird" forIndexPath:indexPath];
    messageCell.selectionStyle = UITableViewCellSelectionStyleNone;
    JXMessageEntity *messageModel = _dataArray[indexPath.row];

    if (messageModel.BizType == 0) {
        messageCell.accessoryType = UITableViewCellAccessoryNone;
        
    }else{
        messageCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    messageCell.messageModel = messageModel;
    return messageCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    JXMessageEntity *messageModel = _dataArray[indexPath.row];
    if (messageModel.BizType == 0) {//不可点击
        
    }else{

        [PublicUseMethod showAlertView:@"请进入到我的档案里查看"];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
