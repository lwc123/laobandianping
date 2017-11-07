//
//  WorkCommentsVC.m
//  JuXianBossComments
//
//  Created by easemob on 2016/12/3.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "WorkCommentsVC.h"
#import "JXMineModel.h"
#import "TggStarEvaluationView.h"
#import "IWComposePhotosView.h"
#import "SoundRecordingVC.h"
#import "MineAccountViewController.h"
#import "BossCommentTabBarCtr.h"
#import "BossReviewRechargeVC.h"
#import "FTImagePickerController.h"
#import "NSString+RegexCategory.h"
//滑动的
#import "DepartureResonCell.h"
#import "SliderTableViewCell.h"
#import "CommentsContentCell.h"
#import "CommentsContentModel.h"
#import "TopAlertView.h"
#import "WorkCommentsImageCell.h"
#import "StaffListVC.h"
#import "ArchiveCommentEntity.h"
#import "XJHYearPicker.h"
#import "AddAuditiPersonVC.h"

//录音
#import "SoundView.h"
#import "DotimeManage.h"
#import "Recorder.h"
#import "lame.h"
#import "SoundTouchOperation.h"
#import "AddDepartureReportVC.h"
#import "CommentsListVC.h"
#import "JXJudgeListVC.h"
#import "AudioStreamer.h"//SC.XJH.12.23
#import "ReviewedPeopleCell.h"//SC.XJH.12.25

#import "NSCalendar+ST.h"
#import "JXJudgeListVC.h"//我的评价列表
#import "TimeCell.h"
#import "CellViewButton.h"
#import "AddStaffRecordVC.h"
#import "JXShortMessage.h"

@interface WorkCommentsVC ()<DepartureResonCellDelegate,CommentsContentCellDelegate,UINavigationControllerDelegate, FTImagePickerControllerDelegate,AVAudioPlayerDelegate,IWComposePhotoViewDelegate,TopAlertViewDelegate,JXFooterViewDelegate,UITextViewDelegate,XJHYearPickerDelegate,SliderTableViewCellDelegate,SoundViewDelegate,DotimeManageDelegate,AVAudioPlayerDelegate,AVAudioSessionDelegate,ReviewedPeopleCellDelegate,TimeCellDelegate,JXShortMessageDelagate>{
    
    AVAudioPlayer *_audioPalyer;
    TopAlertView * _topView;
    NSString * _yearStr;
    
    AVAudioPlayer *_myaudioPalyer;
    DotimeManage *_timeManager;
    /**
     *  状态
     */
    UILabel *_StateLable;
    UILabel *_countDownLabel;
    NSOperationQueue *_soundTouchQueue;
    NSString *_WAVFilePath;
    NSString *_mp3FilePath;
    
    //是否正在转码
    BOOL transcoding;
    NSURL *recordedFile;
    AddDepartureReportVC * _addDepartVC;
    int _abilityScore;//工作能力分数
    int _attitudeScore;//工作态度
    int _achievementScore;//工作业绩
    BOOL _isEqualName;
    BOOL _isEquil;//是否是审核人
    UIButton * _playBtn;

}
@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, strong) NSArray *liZhiDataArray;
@property (nonatomic, strong) NSMutableArray *reviewPeopleArray;
@property (nonatomic, strong) NSMutableArray *photoArray;

@property (nonatomic, weak) IWComposePhotosView *photosView;
@property (nonatomic, strong) UIButton *camerBtn;
@property (nonatomic, strong) UIButton *voiceBtn;
@property (nonatomic, strong) UIButton *voiceImageBtn;
@property (nonatomic, strong) UIButton *deleteVoiceBtn;
@property (nonatomic, strong) CommentsContentModel *model;
@property (nonatomic,copy)NSString * mp3Str;
@property (nonatomic,copy)NSString * timeStr;

@property (nonatomic,strong)UILabel * lenthLabel;
@property (nonatomic,strong)IWTextView * mytexiView;
@property (nonatomic,assign)NSInteger index;
//审核人
@property (nonatomic,strong)NSArray * auditPersonsArray;
//可变审核人
@property (nonatomic,strong) NSMutableArray * personArray;
@property (nonatomic,copy)NSString * checkTimeStr;


//录音
@property (nonatomic,assign)int miao;
@property (nonatomic,strong) UIView * blackView;
@property (nonatomic,strong)SoundView * soundView;
//取本地值
@property (nonatomic,strong)CompanyMembeEntity *membeEntity;
@property (nonatomic, strong) AudioStreamer *streamer;

//获取已经评价的
@property (nonatomic,strong) NSMutableArray * sectionDateArray;
@property (nonatomic,strong) NSMutableArray * stageSectionArr;
@property (nonatomic, strong) NSMutableArray *originalPhotos;
//SC.XJH.1.6
@property (nonatomic, strong) TimeCell *timeSelectCell;
//传过来的职位
@property (nonatomic,copy)NSString * jobTitle;
@property (nonatomic, assign) BOOL isSendMes;
@property (nonatomic, strong) CompanyMembeEntity *myEntity;


@end

@implementation WorkCommentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavView];
    [self initData];
    [self initUI];
    if (_archiveId) {
        [self initRequset];
    }
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

}

- (void)initNavView{
    
    [self isShowRightButton:YES with:@"提交"];
    [self isShowLeftButton:YES];
}

- (void)initData{
    
    _isSendMes = YES;

    _membeEntity = [UserAuthentication GetBossInformation];
    _myEntity = [UserAuthentication GetMyInformation];
    _sectionDateArray = [NSMutableArray array];
    _liZhiDataArray = @[@"添加0",@"添加1",@"添加2",@"添加3",@"添加4",@"添加5"];
    _personArray = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%ld",_membeEntity.PassportId], nil];
    NSString * bossStr = [NSString stringWithFormat:@"%@(老板)",_membeEntity.RealName];
    
    //SC.XJH.12.17可能会修改，直接使用_detaiComment是不是更好呢，不用再定义_nameStr之类的了
    
    if (_employeArchive.ArchiveId > 0) {
        _nameStr = _employeArchive.RealName;
        _imageStr = _employeArchive.Picture;
        
    }
    
    if (_detailComment.CommentId > 0) {
        _nameStr = _detailComment.EmployeArchive.RealName;
        _imageStr = _detailComment.EmployeArchive.Picture;
        _miao = _detailComment.WorkCommentVoiceSecond;
    }
#pragma mark -- 修改评价审核人列表展示
    _reviewPeopleArray = [NSMutableArray array];
    
    if (self.detailComment.AuditPersonList!=nil) {
        
        for (NSDictionary *dict in _detailComment.AuditPersonList) {
            CompanyMembeEntity *auditPersonModel = [[CompanyMembeEntity alloc]initWithDictionary:dict error:nil];
            [_reviewPeopleArray addObject:[NSString stringWithFormat:@"%@(%@)",auditPersonModel.RealName,auditPersonModel.JobTitle]];
            if (auditPersonModel.Role == Role_Boss) {
                
            }else{
                [_personArray addObject:[NSString stringWithFormat:@"%ld",auditPersonModel.PassportId]];
            }
        }
    }else{
        [_reviewPeopleArray addObject:bossStr];
        
    }
    
}
- (NSArray *)sectionArray{
    if (!_sectionArray) {
        _sectionArray = @[@"选择员工档案",@"阶段工作评价",@"选择时间阶段",@"工作综合评价",@"工作评语",@"添加评价审核人"];
    }
    return _sectionArray;
}

- (NSMutableArray *)photoArray{
    
    if (!_photoArray) {
        _photoArray = [[NSMutableArray alloc] init];
    }
    return _photoArray;
}

- (CommentsContentModel *)model{
    if (!_model) {
        _model = [[CommentsContentModel alloc]init];
    }
    return _model;
}

//SC.XJH.12.22
- (ArchiveCommentEntity *)detailComment{
    if (!_detailComment) {
        _detailComment = [[ArchiveCommentEntity alloc]init];
    }
    return _detailComment;
}

#pragma mark -- //修改评价请求已被评价的时间
- (void)initRequset{
    
    [WorkbenchRequest getArchiveCommentExistsStageSectionWith:_membeEntity.CompanyId archiveId:self.archiveId success:^(JSONModelArray *array) {
        
        if (array > 0) {
            //
            //SC.XJH.1.6
            if (_sectionDateArray.count>0) {
                [_sectionDateArray removeAllObjects];
            }
            
            //SC.XJH.2.8
            for (ExistsStageSectionEntity * model in array) {
                [_sectionDateArray addObject:model];
            }
            
            for (UIView *view in _timeSelectCell.bgView.subviews) {
                if ([view isKindOfClass:[CellViewButton class]]) {
                    CellViewButton *btn = (CellViewButton *)view;
                    int i=0;
                    for (ExistsStageSectionEntity * model in _sectionDateArray) {
                        if ([model.StageYear isEqualToString:_yearStr]) {
                            for (NSString *title in model.StageSection) {
                                if ([btn.code isEqualToString:title]) {
                                    [btn setTitle:[NSString stringWithFormat:@"%@已评",btn.name] forState:UIControlStateNormal];
                                    [btn setTitleColor:[PublicUseMethod setColor:KColor_Text_EumeColor] forState:UIControlStateNormal];
                                    btn.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
                                    btn.enabled = NO;
                                    i++;
                                }
                            }
                        }
                    }
                    if (i>0) {
                    }else{
                        [btn setTitle:btn.name forState:UIControlStateNormal];//SC.XJH.1.6
                        [btn setTitleColor:[PublicUseMethod setColor:KColor_Text_BlackColor] forState:UIControlStateNormal];
                        btn.enabled = YES;
                        btn.backgroundColor = [PublicUseMethod setColor:@"F6F3EB"];
                        
                    }
                }
            }
            
        }
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)initUI{
    if (_detailComment.CommentId) {
        _yearStr = _detailComment.StageYear;
    }else{
        _yearStr = [NSString stringWithFormat:@"%ld年",(long)[NSCalendar currentYear]];//SC.XJH.1.6
    }
    self.auditPersonsArray = [NSArray array];
    //不要了
    _topView = [TopAlertView topAlertView];
    _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    _topView.delegate = self;
    [_topView.delagateBtn setImage:[UIImage imageNamed:@"offjh"] forState:UIControlStateNormal];
    _topView.myLabel.text = @"员工离任,其他企业查看该评价,您公司可获得10元";
    _topView.myLabel.font = [UIFont systemFontOfSize:13.0];
//    [self.view addSubview:_topView];
    
    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    
    JXFooterView * footerView = [JXFooterView footerView];
    footerView.delegate = self;
    footerView.nextLabel.text = @"提交";
    self.jxTableView.tableFooterView = footerView;
    
    UILabel * myLbel = [UILabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(footerView.nextLabel.frame) + 20, SCREEN_WIDTH, 13) title:@"审核生效后将发送短信告知员工" titleColor:[PublicUseMethod setColor:KColor_Text_EumeColor] fontSize:13.0 numberOfLines:1];
    myLbel.textAlignment = NSTextAlignmentCenter;
//    [footerView addSubview:myLbel];
    
    [self.jxTableView registerNib:[UINib nibWithNibName:@"WorkCommentsImageCell" bundle:nil] forCellReuseIdentifier:@"workCommentsImageCell"];
    _countDownLabel = [[UILabel alloc] init];
    _blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _blackView.backgroundColor = [UIColor blackColor];
    _blackView.alpha = .5;
    _blackView.hidden = YES;
    [self.view addSubview:_blackView];
    _soundView = [SoundView soundView];
    _soundView.frame = CGRectMake(0, SCREEN_HEIGHT - 325 - 64, SCREEN_WIDTH, 325);
    _soundView.delegate = self;
    _soundView.hidden = YES;
    _countDownLabel = _soundView.statusLabel;
    [self.view addSubview:_soundView];
    _soundTouchQueue = [[NSOperationQueue alloc]init];
    _soundTouchQueue.maxConcurrentOperationCount = 1;
    
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *path = [NSString stringWithFormat:@"%@/Voice",documentDir];
    NSString *recordedStr = [NSString stringWithFormat:@"%@/RecordingFile.wav",path];
    recordedFile = [[NSURL alloc] initFileURLWithPath:recordedStr];
    _timeManager = [DotimeManage DefaultManage];
    [_timeManager setDelegate:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 5) {
        return self.reviewPeopleArray.count+1+1;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {//选择员工档案
        
        WorkCommentsImageCell * imageCell = [tableView dequeueReusableCellWithIdentifier:@"workCommentsImageCell" forIndexPath:indexPath];
        imageCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_nameStr == nil) {
            imageCell.nameLabel.hidden = YES;
            imageCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        }else{
            imageCell.checkRecodeLabel.hidden = YES;
            imageCell.accessoryType = UITableViewCellAccessoryNone;
            imageCell.nameLabel.hidden = NO;
            imageCell.nameLabel.text = _nameStr;
            [imageCell.iconImageView sd_setImageWithURL:[NSURL URLWithString:_imageStr] placeholderImage:Default_Image];
        }
        return imageCell;
    }
    if (indexPath.section == 1) {//阶段工作评价title
        static NSString *commentTitleID = @"commentTitleID";
        UITableViewCell *commentTitleCell = [tableView dequeueReusableCellWithIdentifier:commentTitleID];
        if (!commentTitleCell) {
            commentTitleCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentTitleID];
        }
        commentTitleCell.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
        commentTitleCell.textLabel.text = self.sectionArray[indexPath.section];
        commentTitleCell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
        commentTitleCell.textLabel.font = [UIFont systemFontOfSize:15];
        commentTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return commentTitleCell;
    }
    if (indexPath.section == 2) {//选择时间段
        static NSString *timeSelectID = @"timeSelectID";
        TimeCell *timeSelectCell = [tableView dequeueReusableCellWithIdentifier:timeSelectID];
        
        if (!timeSelectCell) {
            [tableView registerNib:[UINib nibWithNibName:@"TimeCell" bundle:nil] forCellReuseIdentifier:timeSelectID];
            timeSelectCell = [tableView dequeueReusableCellWithIdentifier:timeSelectID];
            [timeSelectCell initSubviewsWithID:timeSelectID with:nil];
        }
        _timeSelectCell = timeSelectCell;//SC.XJH.1.6
        timeSelectCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        timeSelectCell.resonLabel.text = @"选择时间阶段";
        timeSelectCell.delegate = self;
        timeSelectCell.seachLabel.text = _yearStr;
        if (self.detailComment.StageYear.length > 0) {
            timeSelectCell.seachLabel.text = _detailComment.StageYear;
        }
        //SC.XJH.12.22
        if (self.detailComment.StageSectionText.length>0) {
            self.checkTimeStr = _detailComment.StageSection;//SC.XJH.1.4
            timeSelectCell.detailComment = _detailComment;
        }
        return timeSelectCell;
    }
    
    if (indexPath.section == 3) {//工作评价
        
        static NSString *generalCommentID = @"generalCommentID";
        SliderTableViewCell *generalCommentcell = [tableView dequeueReusableCellWithIdentifier:generalCommentID];
        if (!generalCommentcell) {
            [tableView registerNib:[UINib nibWithNibName:@"SliderTableViewCell" bundle:nil] forCellReuseIdentifier:generalCommentID];
            generalCommentcell = [tableView dequeueReusableCellWithIdentifier:generalCommentID];
            generalCommentcell.delegate = self;
        }
        generalCommentcell.selectionStyle = UITableViewCellSelectionStyleNone;
        //SC.XJH.12.17
        if (_detailComment) {
            _abilityScore = _detailComment.WorkAbility;
            _attitudeScore = _detailComment.WorkAttitude;
            _achievementScore = _detailComment.WorkPerformance;
            generalCommentcell.abilitySlider.value = _detailComment.WorkAbility;
            generalCommentcell.attitudeSlider.value = _detailComment.WorkAttitude;
            generalCommentcell.achievementSlider.value = _detailComment.WorkPerformance;
        }
        return generalCommentcell;
    }
    
    if (indexPath.section == 4) {//工作评语
        static NSString *commentsContentID = @"commentsContentID";
        CommentsContentCell *commentsContentCell = [tableView dequeueReusableCellWithIdentifier:commentsContentID];
        if (!commentsContentCell) {
            commentsContentCell = [[CommentsContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentsContentID];
            commentsContentCell.delegate = self;
            _photosView = commentsContentCell.photosView;
            _camerBtn = commentsContentCell.camerBtn;
            _voiceBtn = commentsContentCell.voiceBtn;
            _voiceImageBtn = commentsContentCell.voiceImageBtn;
            _deleteVoiceBtn = commentsContentCell.deleteVoiceBtn;
        }
        commentsContentCell.myTextView.delegate = self;
        self.mytexiView = commentsContentCell.myTextView;
        self.lenthLabel = commentsContentCell.lenthLabel;
        //SC.XJH.12.17
        if (_detailComment) {
            commentsContentCell.myTextView.text = _detailComment.WorkComment;
            _lenthLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)commentsContentCell.myTextView.text.length];
            
            //SC.XJH.12.20
            if (_detailComment.WorkCommentImages.count>0) {
                [self.photosView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                
                //jam
                if (self.originalPhotos.count>0) {
                    [self.originalPhotos enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [self.photosView addPhoto:obj];
                        self.photosView.imageView.delegate = self;
                        
                    }];
                }else{
                    for (NSString *imageStr in _detailComment.WorkCommentImages) {
                        
                        [self.photosView addPhoto:nil imageUrl:imageStr];
                        self.photosView.imageView.delegate = self;
                    }
                    self.originalPhotos = self.photosView.photos.mutableCopy;
                }
                //jam
            }
        }
        commentsContentCell.detaiComment = _detailComment;
        return commentsContentCell;
    }
    
    // 审核人
    if (indexPath.section == 5) {
        if (indexPath.row == 0) {
            static NSString *reviewedTitleID = @"reviewedTitleID";
            UITableViewCell *reviewedTitleCell = [tableView dequeueReusableCellWithIdentifier:reviewedTitleID];
            if (!reviewedTitleCell) {
                reviewedTitleCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reviewedTitleID];
            }
            reviewedTitleCell.textLabel.font =[UIFont systemFontOfSize:15.0];
            NSString * myStr = @"添加评价审核人(一人通过审核即生效)";
            NSRange range = [myStr rangeOfString: @"(一人通过审核即生效)"];
            NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:myStr];
            [str addAttribute:NSForegroundColorAttributeName value:[PublicUseMethod setColor:KColor_Text_EumeColor] range:range];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range];
            reviewedTitleCell.textLabel.attributedText = str;
            reviewedTitleCell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
            return reviewedTitleCell;
        }else if (indexPath.row == self.reviewPeopleArray.count+1){
            static NSString *addID = @"addID";
            UITableViewCell *addCell = [tableView dequeueReusableCellWithIdentifier:addID];
            if (!addCell) {
                addCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addID];
                UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 44, 44)];
                [addBtn setImage:[UIImage imageNamed:@"huiadd"] forState:UIControlStateNormal];
                [addBtn addTarget:self action:@selector(addReviewedPeople) forControlEvents:UIControlEventTouchUpInside];
                [addCell.contentView addSubview:addBtn];
            }
            return addCell;
        }else{
            static NSString *reviewedPeopleID = @"reviewedPeopleID";
            ReviewedPeopleCell *reviewedPeopleCell = [tableView dequeueReusableCellWithIdentifier:reviewedPeopleID];
            if (!reviewedPeopleCell) {
                reviewedPeopleCell = [[ReviewedPeopleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reviewedPeopleID];
                reviewedPeopleCell.delegate = self;
            }
            reviewedPeopleCell.indexPath = indexPath;//SC.XJH.12.25
            reviewedPeopleCell.textLabel.text = self.reviewPeopleArray[indexPath.row-1];
            reviewedPeopleCell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
            reviewedPeopleCell.textLabel.font =[UIFont systemFontOfSize:15.0];
            
            if (indexPath.row == 1) {
                reviewedPeopleCell.deletePeopleBtn.hidden = YES;
                reviewedPeopleCell.deletePeopleBtn.enabled = NO;
            }else{
                reviewedPeopleCell.deletePeopleBtn.hidden = NO;
                reviewedPeopleCell.deletePeopleBtn.enabled = YES;

            }
            return reviewedPeopleCell;
        }
    }
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = self.sectionArray[indexPath.section];
    return cell;
}



- (void)sliderCell:(SliderTableViewCell *)sliderCell WithIndexPath:(NSIndexPath *)indexPath slider:(UISlider *)slider score:(NSString *)score{
    
    if (slider == sliderCell.abilitySlider) {
        _abilityScore = _detailComment.WorkAbility = [score intValue];
    }
    if (slider == sliderCell.attitudeSlider) {
        _attitudeScore = _detailComment.WorkAttitude = [score intValue];
    }
    if (slider == sliderCell.achievementSlider) {
        _achievementScore = _detailComment.WorkPerformance = [score intValue];
    }
}

#pragma mark -- 选择时间锻
- (void)timeCellClickTimeBtnWith:(NSInteger)index WithCode:(NSString *)codeStr WithIndexPath:(NSIndexPath *)indexPath andView:(TimeCell *)resonCell{
    //SC.XJH.1.1
    UIButton * but = [resonCell viewWithTag:index + 100];
    self.checkTimeStr = codeStr;
    NSLog(@"codeStr===%@",codeStr);
    
    _detailComment.StageSectionText = but.titleLabel.text;
    _detailComment.StageSection = codeStr;
}

#pragma mark -- 选择年
- (void)timeCellClickTchoiceYearBtnView:(TimeCell *)resonCell{
    XJHYearPicker *yearDate = [[XJHYearPicker alloc]init];
    // 预选
    if (_yearStr.length>0) {
        [yearDate.pickerView selectRow:[NSCalendar currentYear]-_yearStr.integerValue inComponent:0 animated:NO];
    }
    [yearDate setDelegate:self];
    [yearDate show];
}
#pragma mark -- 阶段时间
- (void)pickerDate:(XJHYearPicker *)pickerDate year:(NSInteger)year{

    _yearStr= [NSString stringWithFormat:@"%ld年",(long)year];
    _detailComment.StageYear = _yearStr;//SC.XJH.1.4
    
    //取出阶段时间字典
    NSArray *PeriodModelA = [DictionaryRepository getComment_PeriodModelArray];
    NSMutableArray *periodModelArray = [NSMutableArray array];
    for (PeriodModel *periodModel in PeriodModelA) {
        [periodModelArray addObject:periodModel.Name];
        //        [self.codeArray addObject:periodModel.Code];
    }
    
    //SC.XJH.1.6
    for (UIView *view in _timeSelectCell.bgView.subviews) {
        //SC.XJH.2.8
        if ([view isKindOfClass:[CellViewButton class]]) {
            CellViewButton *btn = (CellViewButton *)view;
            int i=0;
            
            for (ExistsStageSectionEntity * model in _sectionDateArray) {
                if ([model.StageYear isEqualToString:_yearStr]) {
                    
                    for (NSString *title in model.StageSection) {
                        if ([btn.code isEqualToString:title]) {//SC.XJH.1.6
                            
                            [btn setTitle:[NSString stringWithFormat:@"%@已评",btn.name] forState:UIControlStateNormal];//SC.XJH.1.6
                            
                            [btn setTitleColor:[PublicUseMethod setColor:KColor_Text_EumeColor] forState:UIControlStateNormal];
                            btn.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
                            btn.enabled = NO;
                            i++;
                        }
                    }
                    
                }
            }
            
            
            if (i>0) {
            }else{
                [btn setTitle:btn.name forState:UIControlStateNormal];//SC.XJH.1.6
                [btn setTitleColor:[PublicUseMethod setColor:KColor_Text_BlackColor] forState:UIControlStateNormal];
                btn.enabled = YES;
                btn.backgroundColor = [PublicUseMethod setColor:@"F6F3EB"];
                
            }
        }
    }
    [self.jxTableView reloadData];
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length > 500) {
        _lenthLabel.textColor = [UIColor redColor];
    }else{
        _lenthLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
        _detailComment.WorkComment = _mytexiView.text;
    }
    _lenthLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)textView.text.length];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
        if (!_detailComment.CommentId && !_employeArchive.ArchiveId) {
            StaffListVC * stafflist = [[StaffListVC alloc] init];
            stafflist.secondVC = self;
            stafflist.companyId = self.companyId;
            
            stafflist.block = ^(NSString * nameStr,NSString *imageStr,long ArchiveId){
                _nameStr = nameStr;
                _imageStr = imageStr;
                _archiveId = ArchiveId;
                
                [self initRequset];
                
                [self.jxTableView reloadData];
            };
            [self.navigationController pushViewController:stafflist animated:YES];
        }
    }else{}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2) {
        return 136;
    }else if (indexPath.section == 3){
        return 330;
    }else if (indexPath.section == 4){
        //SC.XJH.12.4动态设置cell高度，这样去设置可以避免iOS7这个方法先于cellForRowAtIndexPath调用而导致的cell高度不能正确返回。iOS8及以后，这个方法都会先于cellForRowAtIndexPath调用一次，待cellForRowAtIndexPath调用之后会再调用一次。
        //SC.XJH.12.20
        return [CommentsContentCell cellHeightWithArchiveCommentModel:self.detailComment];
        //        return [CommentsContentCell cellHeightWithModel:self.model];
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if ( section == 3 || section == 4 || section == 5 || section == 6) {
        return 10;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 5) {
        if ((_myEntity.Role == Role_Boss || _isEquil == YES) && !_detailComment.CommentId) {
            return 45;
        }else{return 0;}
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 5) {
        
        JXShortMessage * shortmessage = [JXShortMessage shortMessage];
        shortmessage.clinkBtn.selected = shortmessage.imageBtn.selected = !_isSendMes;
        shortmessage.delegate = self;
        return shortmessage;
    }
    return nil;
}

#pragma mark -- 短信是否发送
- (void)shortMessageDidClickedWith:(UIButton *)button shortMessage:(JXShortMessage *)shortMessage{
    if (shortMessage.clinkBtn.selected == YES) {
        _isSendMes = NO;
    }else{
        _isSendMes = YES;
    }
}

- (void)composePicAdd{
    if (self.photosView.photos.count >= 9) {
        [PublicUseMethod showAlertView:@"最多只能上传9张照片"];
        return;
    }
    FTImagePickerController* pickerVc = [[FTImagePickerController alloc]init];
    pickerVc.allowsMultipleSelection = YES;
    pickerVc.delegate = self;
    pickerVc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerVc.allowsEditing = NO;
    [self presentViewController:pickerVc animated:YES completion:^{
        
    }];
    
}

//SC.XJH.12.4点击录音按钮的代理方法，点击录音执行
- (void)goToRecordVoice{
    
//    SoundRecordingVC * ff = [[SoundRecordingVC alloc] init];
//    [self.navigationController pushViewController:ff animated:YES];
    
    _blackView.hidden = NO;
    _soundView.hidden = NO;
}

#pragma mark -- 录音代理
- (void)soundViewDidClickedCacelWithbutton:(UIButton *)btn WithView:(SoundView *)jxFooterView{
    //取消就是结束录音 并且把当前View隐退
    [self deleteVoice];
    [_timeManager stopTimer];
    [[Recorder shareRecorder] stopRecord];
    _countDownLabel.text = @"点击开始录音，最多录制120秒";
    _miao = 0;
    _blackView.hidden = YES;
    _soundView .hidden = YES;
}
- (void)soundViewDidClickedSurelWithbutton:(UIButton *)btn WithView:(SoundView *)jxFooterView{
    //确定就是结束录音
    [self cancelRecordBtnClick];
}

#pragma mark -- 开始录音
- (void)soundViewDidClickedRecodelWithbutton:(UIButton *)btn WithView:(SoundView *)jxFooterView{
        _playBtn = btn;
    if ([_countDownLabel.text isEqualToString:@"点击开始录音，最多录制120秒"]) {
        [btn setImage:[UIImage imageNamed:@"zanting"] forState:UIControlStateNormal];
        [_soundTouchQueue cancelAllOperations];
        [self stopAudio];
        _countDownLabel.text = @"点击开始录音，最多录制120秒";
        [_timeManager setTimeValue:30];
        [_timeManager startTime];
        [[Recorder shareRecorder]startRecord];
        
    }else{
        [btn setImage:[UIImage imageNamed:@"mysound"] forState:UIControlStateNormal];
        [self cancelRecordBtnClick];
    }
}

//停止播放
- (void)stopAudio {
    if (_audioPalyer) {
        [_audioPalyer stop];
        _audioPalyer = nil;
        [_voiceImageBtn.imageView stopAnimating];//SC.XJH.1.6
    }
}

//SC.XJH.2.9
- (void)cancelRecordBtnClick{
    [_playBtn setImage:[UIImage imageNamed:@"mysound"] forState:UIControlStateNormal];

    [_timeManager stopTimer];
    [[Recorder shareRecorder]stopRecord];

    //SC.XJH.3.7
    if (_miao<=5) {

        [PublicUseMethod showAlertView:@"录音时长最少5秒"];
        
        [self deleteVoice];
        [_timeManager stopTimer];
        [[Recorder shareRecorder] stopRecord];
        _countDownLabel.text = @"点击开始录音，最多录制120秒";
        _miao = 0;
        _blackView.hidden = YES;
        _soundView .hidden = YES;
    }
    //停止记录  关闭路径
    NSData *data = [NSData dataWithContentsOfFile:[Recorder shareRecorder].filePath];
    if (_miao > 120) {
        _countDownLabel.text = @"录音结束，超过120秒，请重新录音";
        //SC.XJH.3.7
        _blackView.hidden = NO;
        _soundView .hidden = NO;
    }
    
    if ([Recorder shareRecorder].filePath != nil && _miao <= 120 && _miao > 5) {
        NSString *mp3Str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSString * timeStr = _countDownLabel.text;
        
        //SC.XJH.12.20
        _detailComment.WorkCommentVoice = mp3Str;
        _timeStr = timeStr;
        _countDownLabel.text = @"点击开始录音，最多录制120秒";
        _blackView.hidden = YES;
        _soundView .hidden = YES;
    }
    [self.jxTableView reloadData];
}
//SC.XJH.2.9
- (void)wavToMP3{
    transcoding = YES;
    NSData *data = [NSData dataWithContentsOfFile:[Recorder shareRecorder].filePath];
    MySountTouchConfig config;
    config.sampleRate = 44100.0;
    config.tempoChange = 0;
    config.pitch = 0;
    config.rate = 0;
    
    SoundTouchOperation *manSTO = [[SoundTouchOperation alloc]initWithTarget:self action:@selector(convertToMP3) SoundTouchConfig:config soundFile:data];
    [manSTO start];
}
//SC.XJH.2.9
- (void)convertToMP3{
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *wavFile = [NSString stringWithFormat:@"%@/SoundTouch",documentDir];
    
    _WAVFilePath = [NSString stringWithFormat:@"%@/voiceFile.wav",wavFile];
    _mp3FilePath = [NSString stringWithFormat:@"%@/MP3File.mp3",wavFile];
    
    NSFileManager* fileManager=[NSFileManager defaultManager];
    if([fileManager removeItemAtPath:_mp3FilePath error:nil])
    {
        NSLog(@"删除");
    }
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([_WAVFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([_mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 22050.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    
    
}
//时间改变
- (void)TimerActionValueChange:(int)time
{
    if (time > 120) time = 120;
    _miao = time;
    _countDownLabel.text = [NSString stringWithFormat:@"已录制：%2.dS",time];
    if (time == 120) {
        [self cancelRecordBtnClick];
        [_timeManager stopTimer];
        [[Recorder shareRecorder] stopRecord];
    }
}
//SC.XJH.12.23
- (void)createStreamer
{
    [self destroyStreamer];
    NSString *escapedValue =
    ( NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                           nil,
                                                                           (CFStringRef)_detailComment.WorkCommentVoice,
                                                                           NULL,
                                                                           NULL,
                                                                           kCFStringEncodingUTF8)) ;
    ;
    
    NSURL *url = [NSURL URLWithString:escapedValue];
    _streamer = [[AudioStreamer alloc] initWithURL:url];
}
//SC.XJH.12.23
- (void)destroyStreamer
{
    if (_streamer)
    {
        [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:_streamer];
        
        [_streamer stop];
        _streamer = nil;
        [_voiceImageBtn.imageView stopAnimating];//SC.XJH.1.6
    }
}

//SC.XJH.1.6
- (void)playVoice:(CommentsContentCell *)cell withVoiceImageBtn:(UIButton *)btn{
    
    if (btn.selected == YES) {
        [self destroyStreamer];
        [self stopAudio];
        btn.selected = !btn.selected;
    }else{
        btn.selected = !btn.selected;
        
        NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *wavFile = [NSString stringWithFormat:@"%@/SoundTouch",documentDir];
        NSString * mp3FilePath = [NSString stringWithFormat:@"%@/MP3File.mp3",wavFile];
        
        //SC.XJH.12.20语音写入文件路径//SC.XJH.12.23
        if (_detailComment.WorkCommentVoice.length>0) {
            if ([_detailComment.WorkCommentVoice hasPrefix:@"http"]) {
                if (!_streamer) {
                    [self createStreamer];
                }
                [_streamer start];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endPlaying:) name:ASStatusChangedNotification object:nil];
                
                [btn.imageView startAnimating];//SC.XJH.1.6
            }else{
                //SC.XJH.2.9
//                NSData *data = [[NSData alloc]initWithBase64EncodedString:_detailComment.WorkCommentVoice options:NSDataBase64DecodingIgnoreUnknownCharacters];
//                [data writeToFile:mp3FilePath atomically:YES];
                
                NSError *playerError;
                //SC.XJH.2.9
                AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:[Recorder shareRecorder].filePath]error:&playerError];
                _audioPalyer = audioPlayer;
                _audioPalyer.volume = 1.0f;
                if (_audioPalyer == nil)
                {
                    NSLog(@"ERror creating player: %@", [playerError description]);
                }
                [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
                _audioPalyer.delegate = self;
                //SC.XJH.2.9
                if ([Recorder shareRecorder].filePath != nil) {
                    [self playing];
                    [btn.imageView startAnimating];//SC.XJH.1.6
                }
            }
        }
    }
}

//SC.XJH.1.9
#pragma mark - 监听停止播放
- (void)endPlaying:(NSNotification *)notification{
    AudioStreamer *streamerT = notification.object;
    if (streamerT.state == AS_STOPPED) {
        [self destroyStreamer];
    }
}

- (void)playing
{
    if([_audioPalyer isPlaying])
    {
        [_audioPalyer pause];
    }
    else
    {
        [_audioPalyer play];
    }
}

//SC.XJH.1.6
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag{
    _audioPalyer = nil;
    [_voiceImageBtn.imageView stopAnimating];
}

//SC.XJH.12.4删除语音的点击代理，删除语音点击调用
- (void)deleteVoice{
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *wavFile = [NSString stringWithFormat:@"%@/SoundTouch",documentDir];
    NSString * mp3FilePath = [NSString stringWithFormat:@"%@/MP3File.mp3",wavFile];
    //SC.XJH.2.9
    NSString * wavFilePath = [NSString stringWithFormat:@"%@/voiceFile.wav",wavFile];
    NSFileManager* fileManager=[NSFileManager defaultManager];
    [fileManager removeItemAtPath:wavFilePath error:nil];
    [fileManager removeItemAtPath:[Recorder shareRecorder].filePath error:nil];
    if([fileManager removeItemAtPath:mp3FilePath error:nil])
    {
        NSLog(@"删除");
    }
    
    [self destroyStreamer];
    [self stopAudio];//SC.XJH.12.29修复点击删除语音不停止播放的bug
    //SC.XJH.12.20删除语音
    _detailComment.WorkCommentVoice = nil;
    
    _mp3Str = nil;
    //SC.XJH.12.4更新model，刷新UI
    [self.jxTableView reloadData];
    self.voiceBtn.enabled = YES;
    [self.voiceBtn setImage:[UIImage imageNamed:@"yuyin"] forState:UIControlStateNormal];
}

//SC.XJH.12.4删除图片的点击代理，删除图片按钮点击调用
- (void)deleteImage{
    //SC.XJH.12.4更新model，刷新UI
    //    self.model.photos = _photosView.photos;
    //SC.XJH.12.20
    NSMutableArray *arrayTemp = [NSMutableArray array];
    [self.originalPhotos removeAllObjects];
    for (UIImage *image in _photosView.photos) {
        
        // jam
        // 修改原图数组
        [self.originalPhotos addObject:image];
        
        // 取出原图
        UIImage *UserSelectImage = [PublicUseMethod fixOrientationForImage:image];
        // 等比压缩
        UIImage *comImage = [PublicUseMethod thumbnailWithImageWithoutScale:UserSelectImage size:self.camerBtn .bounds.size];
        // jam
        
        NSData *data = UIImageJPEGRepresentation(comImage, 1.0);
        NSString *imageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [arrayTemp addObject:imageStr];
    }
    _detailComment.WorkCommentImages = [arrayTemp copy];
    [self.jxTableView reloadData];
}

#pragma mark - imagepickerCtrl delegate
- (void)assetsPickerController:(FTImagePickerController *)picker didFinishPickingImages:(NSArray <UIImage *>*)images{
    
    if((images.count + self.photosView.photos.count) >9){
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"最多只能选择9张图片" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    self.originalPhotos = self.photosView.photos.mutableCopy;
    
    for (UIImage* image in images) {
        
        UIImage* newImage = [PublicUseMethod thumbnailWithImageWithoutScale:image size:CGSizeMake(image.size.width * 0.1, image.size.height * 0.1)];
        
        NSData *data = UIImageJPEGRepresentation(newImage, 1);
        NSString *photoString = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [self.photoArray addObject:photoString];
        NSMutableArray *arrayTemp = [NSMutableArray array];
        arrayTemp = [NSMutableArray arrayWithArray:_detailComment.WorkCommentImages];
        [arrayTemp addObject:photoString];
        
        //jam
        [self.originalPhotos addObject:image];
        //jam
        _detailComment.WorkCommentImages = [arrayTemp copy];
        
    }
    
    [self.jxTableView reloadData];
    self.photosView.size = CGSizeMake(SCREEN_WIDTH - 20, 60 + 60 / 4);
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark-- 提交工作评价
- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{
    
    self.auditPersonsArray = (NSArray *)_personArray;
    NSArray * myPhotoArray = _detailComment.WorkCommentImages;
    
    if (self.archiveId < 0) {
        [PublicUseMethod showAlertView:@"请选择员工档案"];
        return;
    }
    
    if (_nameStr == nil) {
        
        [PublicUseMethod showAlertView:@"请选择员工档案"];
        return;
    }
    
    if (self.checkTimeStr == nil) {
        [PublicUseMethod showAlertView:@"请选择时间阶段"];
        return;
    }
    if (_yearStr == nil) {
        [PublicUseMethod showAlertView:@"请选择时间阶段"];
        return;
    }
    
    if (_abilityScore == 0 || _attitudeScore== 0 || _achievementScore == 0) {
        [PublicUseMethod showAlertView:@"请选择工作综合评价"];
        return;
    }
    if (_mytexiView.text.length == 0) {
        [PublicUseMethod showAlertView:@"请输入工作评语"];
        return;
    }
    if ([_mytexiView.text isContainsEmoji]) {
        [PublicUseMethod showAlertView:@"工作评语不可以输入表情"];
        return;
    }
    if (_mytexiView.text.length > 500) {
        [PublicUseMethod showAlertView:@"工作评语不能超过500"];
        return;
    }
    ArchiveCommentEntity * archiveEntity = [[ArchiveCommentEntity alloc] init];
    if (_detailComment.CommentId) {
        archiveEntity.CommentId = _detailComment.CommentId;
        archiveEntity.ArchiveId = _detailComment.ArchiveId;
        archiveEntity.CompanyId = _detailComment.CompanyId;
    }else{
        //档案id
        archiveEntity.ArchiveId = self.archiveId;
        archiveEntity.CompanyId = _membeEntity.CompanyId;
    }
    archiveEntity.WorkAbility = _abilityScore;
    archiveEntity.WorkAttitude = _attitudeScore;
    archiveEntity.WorkPerformance = _achievementScore;
    archiveEntity.StageYear = _yearStr;
    archiveEntity.StageSection = self.checkTimeStr;
    archiveEntity.WorkComment = _mytexiView.text;
    archiveEntity.WorkCommentImages = myPhotoArray;
    archiveEntity.WorkCommentVoice = _detailComment.WorkCommentVoice;
    //    archiveEntity.WorkCommentVoice = _mp3Str;//SC.XJH.12.20
    archiveEntity.AuditPersons = self.auditPersonsArray;
    archiveEntity.CommentType = 0;
    archiveEntity.WorkCommentVoiceSecond = _miao;
    archiveEntity.IsSendSms = _isSendMes;
    //    [archiveEntity toJSONString];
    NSString * str;
    NSString *message;
    NSString *cancelButtonTitle;
    NSString *otherButtonTitle;
    
    for (int i = 0; i < self.auditPersonsArray.count; i++) {
        if (_myEntity.PassportId == [self.auditPersonsArray[i] longLongValue]) {
            _isEquil = YES;
        }
    }
    if (_isEquil) {//代表提交人就是审核人
        str = @"确定提交吗？";
        message = @"审核生效后将发送短信告知员工,发现您是审核人，提交后将自动生效";
        cancelButtonTitle = @"关闭";
        otherButtonTitle = @"提交";
        
    }else{
        str = @"确定提交吗？";
        message = @"审核生效后将发送短信告知员工";
        cancelButtonTitle = @"关闭";
        otherButtonTitle = @"提交";
    }
    
    [self subCommtent:archiveEntity];
//    [self alertWithTitle:str message:message cancelTitle:cancelButtonTitle okTitle:otherButtonTitle CommentEntity:archiveEntity];
}

#pragma mark -- 封装elert
- (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle okTitle:(NSString *)okTitle CommentEntity:(ArchiveCommentEntity *)comment{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    //取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        if (_detailComment.CommentId) {//修改 -- > 我知道了
            
            [self.navigationController popViewControllerAnimated:YES];

        }else{
            //我的评价列表
            JXJudgeListVC * listVC = [[JXJudgeListVC alloc] init];
            [self.navigationController pushViewController:listVC animated:YES];
        }
    }];
    [cancelAction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
    [cancelAction setValue:[NSNumber numberWithInteger:NSTextAlignmentCenter] forKey:@"titleTextAlignment"];
    [alertController addAction:cancelAction];
    
    if (okTitle != nil) {
        //确定
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //先退出了
            CommentsListVC *commentsVC;
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[CommentsListVC class]]) {
                    commentsVC = (CommentsListVC *)vc;
                    commentsVC.companyId = comment.CompanyId;
                }
            }
            [self.navigationController popViewControllerAnimated:NO];
            WorkCommentsVC * workVC = [[WorkCommentsVC alloc] init];
            workVC.title = @"添加阶段工作评价";
            workVC.companyId = commentsVC.companyId;
            [commentsVC.navigationController pushViewController:workVC animated:NO];
        }];
        
        
        [otherAction setValue:[PublicUseMethod setColor:KColor_Text_BlackColor] forKey:@"titleTextColor"];
        [alertController addAction:otherAction];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)subCommtent:(ArchiveCommentEntity *)archiveEntity{
    if (_detailComment.CommentId) {//修改
        
        [self showLoadingIndicator];
        
        //SC.XJH.2.9
        if (archiveEntity.WorkCommentVoice.length>0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self wavToMP3];
                
                NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *wavFile = [NSString stringWithFormat:@"%@/SoundTouch",documentDir];
                NSString * mp3FilePath = [NSString stringWithFormat:@"%@/MP3File.mp3",wavFile];
                NSData *data = [NSData dataWithContentsOfFile:mp3FilePath];
                archiveEntity.WorkCommentVoice = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                
                [self commentUpdate:archiveEntity];
            });
        }else{
            [self commentUpdate:archiveEntity];
        }

        
    }else{
        [self showLoadingIndicator];
        //SC.XJH.2.9
        if (archiveEntity.WorkCommentVoice.length>0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self wavToMP3];
                
                NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *wavFile = [NSString stringWithFormat:@"%@/SoundTouch",documentDir];
                NSString * mp3FilePath = [NSString stringWithFormat:@"%@/MP3File.mp3",wavFile];
                NSData *data = [NSData dataWithContentsOfFile:mp3FilePath];
                archiveEntity.WorkCommentVoice = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                
                [self addArchiveComment:archiveEntity];
                
            });
        }else{
            [self addArchiveComment:archiveEntity];
        }
    }
}

- (void)commentUpdate:(ArchiveCommentEntity *)archiveEntity{
    NSString * str;
    NSString *message;
    NSString *cancelButtonTitle;
    NSString *otherButtonTitle;
    if (_isEquil) {//代表提交人就是审核人
        str = @"操作成功";
        message = @"您是审核人,阶段评价已生效";
        cancelButtonTitle = @"我知道了";
        otherButtonTitle = @"继续添加";
        
    }else{
        str = @"操作成功";
        message = @"审核通过后,阶段评价将生效";
        cancelButtonTitle = @"我知道了";
        otherButtonTitle = @"继续添加";
    }
    [WorkbenchRequest postCommentUpdateWith:archiveEntity success:^(id result) {
        [self dismissLoadingIndicator];
        if ([result intValue] > 0) {
            //XJH 2.7
            //                [PublicUseMethod showAlertView:@"修改成功"];
            [self alertWithTitle:str message:message cancelTitle:cancelButtonTitle okTitle:nil CommentEntity:archiveEntity];
            
            if ([self.navigationController.viewControllers[2] isKindOfClass:[CommentsListVC class]]) {
                CommentsListVC *listVC =  self.navigationController.viewControllers[2];
                [listVC.jxTableView.mj_header beginRefreshing];
            }
            //                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                    [self.navigationController popViewControllerAnimated:YES];
            //                });
        }
    } fail:^(NSError *error) {
        [self dismissLoadingIndicator];
        NSLog(@"%@",error);
    }];
}

//SC.XJH.2.9
- (void)addArchiveComment:(ArchiveCommentEntity *)archiveEntity{
    
    NSString * str;
    NSString *message;
    NSString *cancelButtonTitle;
    NSString *otherButtonTitle;
    
    if (_isEquil) {//代表提交人就是审核人
        str = @"操作成功";
        message = @"您是审核人,阶段评价已生效";
        cancelButtonTitle = @"去查看";
        otherButtonTitle = @"继续添加";
        
        
    }else{
        str = @"操作成功";
        message = @"审核通过后,阶段评价将生效";
        cancelButtonTitle = @"去查看";
        otherButtonTitle = @"继续添加";
    }
    [WorkbenchRequest postAddArchiveCommentWith:archiveEntity success:^(id result) {
        [self dismissLoadingIndicator];
        //            Log(@"result===%@",result);
        
        if (result > 0) {
            //                [PublicUseMethod showAlertView:@"提交成功!\n请到我的->我的评价中查看"];
            [self alertWithTitle:str message:message cancelTitle:cancelButtonTitle okTitle:otherButtonTitle CommentEntity:archiveEntity];
            
            
            if ([self.navigationController.viewControllers[1] isKindOfClass:[CommentsListVC class]]) {

            }else if ([self.navigationController.viewControllers[1] isKindOfClass:[StaffListVC class]]){
                
                StaffListVC *listVC =  self.navigationController.viewControllers[1];
                [listVC.jxTableView.mj_header beginRefreshing];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
                });
            }
        }
    } fail:^(NSError *error) {
        [self dismissLoadingIndicator];
        NSLog(@"%@",error);
    }];
}


#pragma mark -- 右上角提交成功
- (void)rightButtonAction:(UIButton *)button{
    
    [self jxFooterViewDidClickedNextBtn:nil];
}


#pragma mark -- 添加审核
- (void)addReviewedPeople{
    
    AddAuditiPersonVC * addAuditiVC = [[AddAuditiPersonVC alloc] init];
    
    addAuditiVC.block = ^(NSString *nameStr ,NSString * passportId,NSString * jobTitle){
        
        //添加的审核人正是当前用户显示发送短信
        if (_myEntity.PassportId == [passportId longLongValue]) {
            _isEquil = YES;
        }
        for (int i = 0; i < _reviewPeopleArray.count; i++) {
            
            NSString * passport = self.personArray[i];
            
            if ([passport isEqualToString:passportId]) {
                _isEqualName = YES;
            }else{
                _isEqualName = NO;
            }
            
        }
        
        if (_isEqualName == YES) {

        }else{
            
            [self.reviewPeopleArray addObject:[NSString stringWithFormat:@"%@(%@)",nameStr,jobTitle]];
            [self.personArray addObject:passportId];
            [self.jxTableView reloadData];
            [self.jxTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.reviewPeopleArray.count+1 inSection:5]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    };
    
    [self.navigationController pushViewController:addAuditiVC animated:YES];
    /*
     [self.reviewPeopleArray addObject:@"夏老板（CEO）"];
     [self.jxTableView reloadData];
     [self.jxTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.reviewPeopleArray.count+1 inSection:5]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
     */
}


//SC.XJH.12.25
#pragma mark -- 删除审核人
- (void)reviewedPeopleCell:(ReviewedPeopleCell *)cell deletePeopleBtnClick:(UIButton *)button{
    
    //当前用户是审核人 审核人列表中删除的是审核人 则不显示是否发送短信字样
    if ([_personArray[cell.indexPath.row - 1] longLongValue] == _myEntity.PassportId) {
        _isEquil = NO;
    }
    [self.reviewPeopleArray removeObjectAtIndex:cell.indexPath.row-1];
    [_personArray removeObjectAtIndex:cell.indexPath.row - 1];
    [self.jxTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:cell.indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.jxTableView reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationFade];//SC.XJH.12.29刷新修复不从最后一个cell删除审核人的bug
}

#pragma mark -- 关闭最上面的可以获得收益的View
- (void)topAlertViewDidClickedOffBtn:(TopAlertView *)alertView{
    [_topView removeFromSuperview];
    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    [self.jxTableView reloadData];
}

#pragma mark -- 在pc端创建简历在这不需要写
- (void)topAlertViewAddRecodeOnPc:(TopAlertView *)alertView{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//SC.XJH.12.23
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self destroyStreamer];
    [self stopAudio];
}

- (NSMutableArray *)originalPhotos{
    
    if (_originalPhotos == nil) {
        _originalPhotos = [[NSMutableArray alloc] init];
    }
    return _originalPhotos;
}

- (void)leftButtonAction:(UIButton *)button{
    if ([self.secondVC isKindOfClass:[AddStaffRecordVC class]]) {//从添加档案过来的
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }else{
   
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end





