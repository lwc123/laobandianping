//
//  CheckRsultVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/29.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "CheckRsultVC.h"
#import "HeaderView.h"
#import "CheckResultCell.h"
//标签云
#import "WWTagsCloudView.h"
#import "CommentsContensCell.h"
#import <AudioToolbox/AudioToolbox.h>
#import "CommentsWorkerVC.h"



@interface CheckRsultVC ()<WWTagsCloudViewDelegate,AVAudioPlayerDelegate,JXFooterViewDelegate>{

    NSArray * _dataArray;
    AVAudioPlayer * _audioPalyer;

}

@property (nonatomic,strong)HeaderView * headerView;
@property (strong, nonatomic) WWTagsCloudView* tagCloud;
@property (strong, nonatomic) NSArray* tags;
@property (strong, nonatomic) NSArray* colors;
@property (strong, nonatomic) NSArray* fonts;
@property (assign, nonatomic) CGFloat cellHeight;
@property (strong,nonatomic) BossCommentsEntity * model;
@property (nonatomic,assign)NSInteger pageIndex;
@property (nonatomic,assign)NSInteger size;
@property (nonatomic,strong)NSArray * modelArray;
@property (nonatomic,strong)JXFooterView * footerView;


@end

@implementation CheckRsultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self isShowLeftButton:YES];

    [self initData];
    [self initUI];
    [self initReuest];
}

- (void)initData{
    _pageIndex = 1;
    _size = 10;
    _dataArray = [NSArray array];
    _modelArray = [NSArray array];
    _tags = [NSArray array];
}

- (void)initUI{
    
    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    _headerView = [HeaderView headerView];
    _headerView.nameLabel.text = self.nameCtr;
    _headerView.idLabel.text = self.idCtr;
    
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 120);
    self.jxTableView.tableHeaderView = _headerView;
    self.jxTableView.tableFooterView = [[UIView alloc] init];
    self.jxTableView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
    
    [self.jxTableView registerNib:[UINib nibWithNibName:@"CommentsContensCell" bundle:nil] forCellReuseIdentifier:@"commentsContensCell"];
    [self.jxTableView registerNib:[UINib nibWithNibName:@"CheckResultCell" bundle:nil] forCellReuseIdentifier:@"checkResultCell"];

    UIButton * commentsBtn = [UIButton buttonWithFrame:CGRectMake((SCREEN_WIDTH - 285) * 0.5, (SCREEN_HEIGHT - 44), 285, 44) title:@"+ 添加点评" fontSize:15.0 titleColor:[PublicUseMethod setColor:KColor_Text_BlueColor] imageName:nil bgImageName:nil];
    commentsBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:commentsBtn];

    
//    [self.jxTableView registerClass:[CheckResultCell class] forCellReuseIdentifier:@"checkResultCell"];
    
    _tags = @[@"当幸福来敲门", @"海滩", @"如此的夜晚", @"大进军", @"险地", @"姻缘订三生", @"死亡城", @"苦海孤雏"];
    _colors = @[[PublicUseMethod setColor:KColor_Add_Fen],[PublicUseMethod setColor:KColor_Add_Lan],[PublicUseMethod setColor:KColor_Add_Huang],[PublicUseMethod setColor:KColor_Add_Hui],[PublicUseMethod setColor:KColor_Add_Zi]];
    
    _fonts = @[[UIFont systemFontOfSize:14], [UIFont systemFontOfSize:14], [UIFont systemFontOfSize:14]];

    _footerView = [JXFooterView footerView];
    _footerView.delegate = self;
    _footerView.nextLabel.text = @"+ 添加点评";
    _footerView.nextLabel.textColor = [PublicUseMethod setColor:KColor_Add_BlueColor];
    _footerView.nextLabel.layer.masksToBounds = YES;
    _footerView.nextLabel.layer.borderWidth = 1;
    _footerView.nextLabel.layer.borderColor = [PublicUseMethod setColor:KColor_Add_BlueColor].CGColor;
    _footerView.nextLabel.backgroundColor = [UIColor whiteColor];
    _footerView.nextLabel.layer.cornerRadius = 4;
    self.jxTableView.tableFooterView = _footerView;
    
}

- (void)initReuest{

    [self showLoadingIndicator];
    //这个是查询的数据请求
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        return 1;
    }else{
    
        if (_modelArray.count == 0) {
            
            return 1;
        }else{
        
            return _modelArray.count;
        }
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
    
        static NSString *identifier = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.backgroundColor = [UIColor whiteColor];
            
//            _tags = _dataArray;
            //初始化
            _tagCloud = [[WWTagsCloudView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)
                                                       andTags:_tags
                                                  andTagColors:_colors
                                                      andFonts:_fonts
                                               andParallaxRate:1.7
                                                  andNumOfLine:3];
            _tagCloud.delegate = self;
            [cell.contentView addSubview:_tagCloud];
        }
        return cell;

    }else{
        
        if (_modelArray.count != 0) {
            
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            CommentsContensCell * commentsCell = [tableView dequeueReusableCellWithIdentifier:@"commentsContensCell" forIndexPath:indexPath];
            commentsCell.selectionStyle = UITableViewCellAccessoryNone;
            
            NSLog(@"_modelArray.count==%lu,indexPath.row==%ld",(unsigned long)_modelArray.count,(long)indexPath.row);
            NSDictionary *dict = _modelArray[indexPath.row];
            
            BossCommentsEntity * model = [[BossCommentsEntity alloc]initWithDictionary:dict error:nil];
            commentsCell.bossModel = model;
            commentsCell.companyLabel.text = self.companyCtr;
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVoice)] ;
            [commentsCell.voiceImagView addGestureRecognizer:tap];
            self.cellHeight = commentsCell.cellHeight;
            return commentsCell;
        }else{
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            CheckResultCell * checkResultCell = [tableView dequeueReusableCellWithIdentifier:@"checkResultCell" forIndexPath:indexPath];
            checkResultCell.selectionStyle = UITableViewCellAccessoryNone;
            checkResultCell.backgroundColor = [UIColor whiteColor];
            return checkResultCell;
        }
    }
}

- (void)playVoice{

    NSLog(@"ssssss");
    NSError *playerError;

    NSString *urlStr = @"http://bc-res.jux360.cn/boss-comment/00010101/17/17-cb0c6674ba1e4170b47778f8cbbb6ec5.mp3?t=161102155211800";
    NSURL *url = [[NSURL alloc]initWithString:urlStr];
    NSData * audioData = [NSData dataWithContentsOfURL:url];
    
    //将数据保存到本地指定位置
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp3", docDirPath , @"temp"];
    [audioData writeToFile:filePath atomically:YES];
    
    //播放本地音乐
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    _audioPalyer = audioPlayer;
    _audioPalyer.volume = 1.0f;
    if (_audioPalyer == nil)
    {
        NSLog(@"ERror creating player: %@", [playerError description]);
    }
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
    _audioPalyer.delegate = self;
    
   [self playing];
}
- (void)playing
{
    if([_audioPalyer isPlaying])
    {
        [_audioPalyer pause];
    }else
    {
        [_audioPalyer play];
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView * bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
    bgview.backgroundColor = [UIColor whiteColor];
    UIImageView *  imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 17, 15, 15)];
    [bgview addSubview:imageView];
    UILabel * label = [UILabel labelWithFrame:CGRectMake(35, 15, 70, 17) title:nil titleColor:[UIColor blackColor] fontSize:17.0 numberOfLines:1];
    [bgview addSubview:label];
    
    if (section == 0) {
        
        label.text = @"他的标签";
        imageView.image = [UIImage imageNamed:@"mark"];
    }else{
       UILabel * label1 = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 5, 21, 200, 11) title:nil titleColor:[PublicUseMethod setColor:KColor_Text_EumeColor] fontSize:11.0 numberOfLines:1];
        label.text = @"老板点评";
        imageView.image = [UIImage imageNamed:@"ping"];
        label1.text = [NSString stringWithFormat:@"截止目前该人才收到%lu条老板评价消息",(unsigned long)_modelArray.count];
        [bgview addSubview:label1];
    }
    return bgview;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 32;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0){
    
    return 85;
    
    }else{
    
        //    BossCommentsEntity * model = [[BossCommentsEntity alloc] init];
        //    return [CommentsContensCell cellHeightWithModel:model];
        
        if (_modelArray.count == 0) {
            
            return 160;
        }else{
            
            return self.cellHeight;
        }
    }
}


#pragma maek -- 添加点评
- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{

    CommentsWorkerVC * commentsVC= [[CommentsWorkerVC alloc] init];
    [self.navigationController pushViewController:commentsVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
