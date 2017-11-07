//
//  AddDepartureReportVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "AddDepartureReportVC.h"
//离任原因
#import "DepartureResonCell.h"
#import "SliderTableViewCell.h"
#import "NSString+RegexCategory.h"
#import "RsonCell.h"
#import "IWComposePhotosView.h"
#import "SoundRecordingVC.h"//录音
#import "STPickerDate.h"
#import "RecodeCheckVC.h"
#import "ChoickJodVC.h"
#import "WorkCommentsImageCell.h"
//档案 员工列表
#import "StaffListVC.h"
#import "TextfieldCell.h"
#import "CommentsContentCell.h"

//工作评语
#import "CommentsContentModel.h"
#import "AddAuditiPersonVC.h"
#import "ReportListVC.h"

//录音
#import "SoundView.h"
#import "DotimeManage.h"
#import "Recorder.h"
#import "lame.h"
#import "SoundTouchOperation.h"
#import "AddDepartureReportVC.h"
#import "CommentsListVC.h"
#import "AudioStreamer.h"//SC.XJH.12.23
#import "ReviewedPeopleCell.h"

#import "TopAlertView.h"//最上面收益的可关闭的View
#import "DepartureDetail.h"
#import "FTImagePickerController.h"

#import "JXJudgeListVC.h"//我的评价列表
#import "AddStaffRecordVC.h"
//是否
#import "JXShortMessage.h"

@interface AddDepartureReportVC ()<DepartureResonCellDelegate,UITextViewDelegate,JXFooterViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate, FTImagePickerControllerDelegate,AVAudioPlayerDelegate,STPickerDateDelegate,CommentsContentCellDelegate,IWComposePhotoViewDelegate,SliderTableViewCellDelegate,RsonCellCellDelegate,SoundViewDelegate,DotimeManageDelegate,ReviewedPeopleCellDelegate,TopAlertViewDelegate,JXShortMessageDelagate>{
    
    AVAudioPlayer *_audioPalyer;
    NSString * _fanPinCodeStr;//返聘意愿
    NSString * _resonCodeStr;//离任原因
    int _abilityScore;//工作能力分数
    int _attitudeScore;//工作态度
    int _achievementScore;//工作业绩
    
    int _timely;//交接及时性
    int _overall;//交接全面性
    int _support;//交接后续支持
    NSString * _explainStr;//离任原因说明
    NSString * _changeStr;//改变的字
    
    ///12.23录音
    AVAudioPlayer *_myaudioPalyer;
    DotimeManage *_timeManager;
    UILabel *_countDownLabel;
    NSOperationQueue *_soundTouchQueue;
    NSString *_WAVFilePath;
    NSString *_mp3FilePath;
    //是否正在转码
    BOOL transcoding;
    NSURL *recordedFile;
    TopAlertView * _topView;
    BOOL _isEqualName;
    BOOL _isEquil;
    UIButton * _palyBtn;
}

//@property (nonatomic,strong)UITextView * hhTextView;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong)UITextField * allFieldTex;
@property (nonatomic,strong)UITextField * sectionOneTf;

@property (nonatomic,strong)NSArray * oneDataArray;
@property (nonatomic,strong)NSArray * liZhiDataArray;
//有两个动态的高度暂时先定义一个
@property (nonatomic,assign)CGFloat cellHeight;
@property (nonatomic,assign)CGFloat fourHeight;
@property (nonatomic,strong)UILabel * lenthLabel;
/**离任时间*/
@property (nonatomic,strong)UITextField * liZhiDateTf;
/**离任薪资*/
@property (nonatomic,strong)UITextField * moneyTf;

/**
 *  相册
 */
@property (nonatomic, weak) IWComposePhotosView *photosView;
//@property (nonatomic, strong) UIButton *comerBtn;
@property (nonatomic, strong) UIButton *camerBtn;
@property (nonatomic, strong) UIButton *voiceBtn;
@property (nonatomic, strong) UIButton *voiceImageBtn;
@property (nonatomic, strong) UIButton *deleteVoiceBtn;
@property (nonatomic,strong)IWTextView * mytexiView;
@property (nonatomic,strong)NSMutableArray *photoArray;
@property (nonatomic, strong) CommentsContentModel *model;
@property (nonatomic,strong)NSString * mp3Str;
@property (nonatomic,strong)NSString * timeStr;

@property (nonatomic,strong)CompanyMembeEntity * bossMembe;

//赋值给model的审核人id
@property (nonatomic,strong)NSArray * auditPersonsArray;
//可变审核人ID
@property (nonatomic,strong) NSMutableArray * personArray;
//审核人的名字
@property (nonatomic, strong) NSMutableArray *reviewPeopleArray;
//录音
@property (nonatomic,assign)int miao;
@property (nonatomic,strong) UIView * blackView;
@property (nonatomic,strong)SoundView * soundView;
@property (nonatomic, strong) AudioStreamer *streamer;
//返聘意愿数组
@property (nonatomic,strong)NSMutableArray * backMArray;
//离任原因
@property (nonatomic,strong)NSMutableArray * resonMArray;
@property (nonatomic, strong) NSMutableArray *originalPhotos;
@property (nonatomic, strong) CompanyMembeEntity *myEntity;
@property (nonatomic, assign) BOOL isSendMes;

@end



@implementation AddDepartureReportVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //SC.XJH.12.17
    [self isShowLeftButton:YES];
    [self isShowRightButton:YES with:@"提交"];
    [self initData];
    [self initUI];
    [self initDictionaryReuest];//获取字典
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 关闭右滑pop
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}


- (void)initData{
    _isSendMes = YES;
    _myEntity = [UserAuthentication GetMyInformation];
    _isSendMes = YES;
    _oneDataArray = @[@"离任时间",@"离任薪资"];
    _liZhiDataArray = @[@"添加0",@"添加1",@"添加2",@"添加3",@"添加4",@"添加5"];
    
    int count = (int)_liZhiDataArray.count;
    int allRow = count / 3 + 1;
    self.cellHeight =allRow * (30 + 10) + 10 + 45;
    
    //SC.XJH.12.17可能会修改，直接使用_detaiComment是不是更好呢，不用再定义_nameStr之类的了
    
    if (_recodeEntity.ArchiveId > 0) {
        _nameStr = _recodeEntity.RealName;
        _imageStr = _recodeEntity.Picture;
        _archiveId = _recodeEntity.ArchiveId;
        _departmenStr = _recodeEntity.WorkItem.Department;
        _postTitleStr = _recodeEntity.WorkItem.PostTitle;
    }
    
    if (_detaiComment.CommentId > 0) {
        _nameStr = _detaiComment.EmployeArchive.RealName;
        _imageStr = _detaiComment.EmployeArchive.Picture;
        _postTitleStr = _detaiComment.EmployeArchive.WorkItem.PostTitle;
        _departmenStr = _detaiComment.EmployeArchive.WorkItem.Department;
        self.mytexiView.text = _detaiComment.WorkComment;
        _fanPinCodeStr = _detaiComment.WantRecall;
        _photoArray = [NSMutableArray arrayWithArray:_detaiComment.WorkCommentImages];
    }
    
    _bossMembe = [UserAuthentication GetBossInformation];
    _personArray = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%ld",_bossMembe.PassportId], nil];
    NSString * bossStr = [NSString stringWithFormat:@"%@(法人)",_bossMembe.RealName];
    
    //SC.XJH.12.30
#pragma mark -- 修改报告审核人列表展示
    _reviewPeopleArray = [NSMutableArray array];
    if (self.detaiComment.AuditPersonList!=nil) {
        for (NSDictionary *dict in _detaiComment.AuditPersonList) {
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
    _backMArray = [NSMutableArray array];
    _resonMArray = [NSMutableArray array];
}

- (IWTextView *)mytexiView{

    if (_mytexiView == nil) {
        
        _mytexiView = [[IWTextView alloc] init];
    }
    return _mytexiView;
}


//SC.XJH.1.3
- (ArchiveCommentEntity *)detaiComment{
    if (!_detaiComment) {
        _detaiComment = [[ArchiveCommentEntity alloc]init];
        _detaiComment.EmployeArchive = [[EmployeArchiveEntity alloc]init];
    }
    return _detaiComment;
}

- (NSMutableArray *)photoArray{
    
    if (!_photoArray) {
        _photoArray = [[NSMutableArray alloc] init];
    }
    return _photoArray;
}

- (NSArray *)auditPersonsArray{
    
    if (_auditPersonsArray == nil) {
        
        _auditPersonsArray = [[NSArray alloc] init];
    }
    return _auditPersonsArray;
}

- (CommentsContentModel *)model{
    if (!_model) {
        _model = [[CommentsContentModel alloc]init];
    }
    return _model;
}

- (void)initUI{
    
    _topView = [TopAlertView topAlertView];
    _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    _topView.delegate = self;
    [_topView.delagateBtn setImage:[UIImage imageNamed:@"offjh"] forState:UIControlStateNormal];
    _topView.myLabel.text = @"员工离任,其他企业查看该评价,您公司可获得15元";
    _topView.myLabel.font = [UIFont systemFontOfSize:13.0];
//    [self.view addSubview:_topView];
    
    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    JXFooterView * footer = [JXFooterView footerView];
    footer.nextLabel.text = @"提交";
    footer.delegate = self;
    
    UILabel * myLbel = [UILabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(footer.nextLabel.frame) + 20, SCREEN_WIDTH, 13) title:@"审核生效后将发送短信告知员工" titleColor:[PublicUseMethod setColor:KColor_Text_EumeColor] fontSize:13.0 numberOfLines:1];
    myLbel.textAlignment = NSTextAlignmentCenter;
//    [footer addSubview:myLbel];
    
    self.jxTableView.tableFooterView = footer;
    
    //选择员工档案
    [self.jxTableView registerNib:[UINib nibWithNibName:@"WorkCommentsImageCell" bundle:nil] forCellReuseIdentifier:@"workCommentsImageCell"];
    //离任薪资 日期
    [self.jxTableView registerNib:[UINib nibWithNibName:@"TextfieldCell" bundle:nil] forCellReuseIdentifier:@"textfieldCell"];
    //工作评价
    [self.jxTableView registerNib:[UINib nibWithNibName:@"SliderTableViewCell" bundle:nil] forCellReuseIdentifier:@"sliderTableViewCell"];
    //交接评价
    [self.jxTableView registerNib:[UINib nibWithNibName:@"SliderTableViewCell" bundle:nil] forCellReuseIdentifier:@"sliderTableViewCellTwo"];
    //原因
    [self.jxTableView registerNib:[UINib nibWithNibName:@"RsonCell" bundle:nil] forCellReuseIdentifier:@"rsonCell"];
    
    
    //12.23录音
    //12.23录音
    _countDownLabel = [[UILabel alloc] init];//SC.XJH.12.29
    _blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _blackView.backgroundColor = [UIColor blackColor];
    _blackView.alpha = .5;
    _blackView.hidden = YES;
    [self.view addSubview:_blackView];
    _soundView = [SoundView soundView];
    _soundView.frame = CGRectMake(0, SCREEN_HEIGHT - 325 - 64, SCREEN_WIDTH, 325);
    _soundView.delegate = self;
    _soundView.hidden = YES;
    _countDownLabel = _soundView.statusLabel;//SC.XJH.12.29
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


#pragma mark -- 获取字典
- (void)initDictionaryReuest{
    
    [WebAPIClient getJSONWithUrl:API_Dictionary_leaving parameters:nil success:^(id result) {
        JSONModelArray *modelArray = [[JSONModelArray alloc]initWithArray:result[@"leaving"] modelClass:[AcademicModel class]];
        JSONModelArray *modelPanicked = [[JSONModelArray alloc]initWithArray:result[@"panicked"] modelClass:[AcademicModel class]];
        _resonMArray = modelArray.mutableCopy;
        _backMArray = modelPanicked.mutableCopy;
        [self.jxTableView reloadData];
    } fail:^(NSError *error) {
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return _nameStr == nil?1:2;
    }else if (section == 1){
        return 2;
    }else if (section == 9){
        return self.reviewPeopleArray.count+1;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0 || section == 1 || section == 3 || section == 8 || section == 9) {
        
        return 0;
    }
    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.section == 1) {
        return 44;
        
    }else if (indexPath.section == 2){//离任原因
        
        return 135;
        
    }else if (indexPath.section == 3){//离任原因说明
        
        return 172;
        
    }else if (indexPath.section == 4 || indexPath.section == 5){//工作交接 工作能力
        return 330;
    }else if (indexPath.section == 6){//评语
        //SC.XJH.12.17重设cell的高度
        //        return [CommentsContentCell cellHeightWithModel:self.model];
        return [CommentsContentCell cellHeightWithArchiveCommentModel:self.detaiComment];
    }else if (indexPath.section == 7){//返聘意愿
        
        return self.cellHeight;
    }else if (indexPath.section == 8){//添加评价审核人这一行
        
        return 44;
    }else{//添加
        
        return 44;
    }
}


//短信
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 9) {
        //如果是老板 必须要显示 如果是高管 审核人里有该高管也显示
        if ((_myEntity.Role == Role_Boss || _isEquil == YES) && !_detaiComment.CommentId) {
            return 45;
        }else{
            return 0;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    if (section == 9) {
        
        JXShortMessage * shortmessage = [JXShortMessage shortMessage];
        shortmessage.delegate = self;
        shortmessage.clinkBtn.selected = shortmessage.imageBtn.selected = !_isSendMes;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {//选择员工档案
        if (indexPath.row == 0) {
            WorkCommentsImageCell * imageCell = [tableView dequeueReusableCellWithIdentifier:@"workCommentsImageCell" forIndexPath:indexPath];
            //SC.XJH.12.17
            imageCell.selectionStyle = UITableViewCellSelectionStyleNone;
            imageCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (_nameStr == nil) {
                imageCell.nameLabel.hidden = YES;
                
            }else{
                imageCell.checkRecodeLabel.hidden = YES;
                imageCell.nameLabel.hidden = NO;
                imageCell.nameLabel.text = _nameStr;
                [imageCell.iconImageView sd_setImageWithURL:[NSURL URLWithString:_imageStr] placeholderImage:Default_Image];//SC.XJH.12.17在PCH宏定义了个占位图5
            }
            return imageCell;
        }else{
            
            static NSString * cellId = @"myCellId";
            UITableViewCell * departMentCell = [tableView dequeueReusableCellWithIdentifier:cellId];
            
            if (!departMentCell) {
                departMentCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                UIButton * fixBtn = [UIButton buttonWithFrame:CGRectMake(SCREEN_WIDTH-100-10, 0, 100, 44) title:@"修改离任时职务" fontSize:14.0 titleColor:[PublicUseMethod setColor:KColor_Text_EumeColor] imageName:nil bgImageName:nil];
                [fixBtn addTarget:self action:@selector(fixClick) forControlEvents:UIControlEventTouchUpInside];
                fixBtn.hidden = YES;
                fixBtn.enabled = NO;
                [departMentCell.contentView addSubview:fixBtn];
            }
            departMentCell.selectionStyle = UITableViewCellSelectionStyleNone;//SC.XJH.12.17
            
            departMentCell.textLabel.font = [UIFont systemFontOfSize:15.0];
            departMentCell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
            if (_nameStr == nil) {//没有隐藏
                departMentCell.hidden = YES;
            }else{
                departMentCell.hidden = NO;
                departMentCell.textLabel.text = [NSString stringWithFormat:@"%@  |  %@",_postTitleStr,_departmenStr];
            }
            return departMentCell;
        }
    }else if (indexPath.section == 1){
        
        TextfieldCell * textCell = [tableView dequeueReusableCellWithIdentifier:@"textfieldCell" forIndexPath:indexPath];
        textCell.selectionStyle = UITableViewCellSelectionStyleNone;
        textCell.jhLabel.text = _oneDataArray[indexPath.row];
        textCell.jhtextfield.placeholder = [NSString stringWithFormat:@"请输入%@",_oneDataArray[indexPath.row]];
        if (indexPath.row == 0) {
            textCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            textCell.jhtextfield.enabled = NO;
            textCell.jhtextfield.tag = 2002;
            textCell.jhtextfield.placeholder = @"请选择离任时间";
            _liZhiDateTf =textCell.jhtextfield;
            //SC.XJH.12.17
            if (_detaiComment) {
                textCell.jhtextfield.text = [JXJhDate stringFromDate:_detaiComment.EmployeArchive.DimissionTime];
            }
            
        }else{//离任薪资
            textCell.jhtextfield.enabled = YES;
            textCell.jhtextfield.tag = 2003;
            textCell.jhtextfield.placeholder = @"请填写年薪收入(万元),可不填";
            textCell.jhtextfield.delegate = self;
            textCell.jhtextfield.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            //SC.XJH.12.17
            if (_detaiComment) {
                textCell.jhtextfield.text = _detaiComment.DimissionSalary;
            }
        }
        return textCell;
    }else if (indexPath.section == 2){//离任原因
        _index = 2;
        //SC.XJH.1.1
        static NSString *depatCellID = @"departureResonCell";
        DepartureResonCell *depatCell = [tableView dequeueReusableCellWithIdentifier:depatCellID];
        if (!depatCell) {
            [tableView registerNib:[UINib nibWithNibName:@"DepartureResonCell" bundle:nil] forCellReuseIdentifier:depatCellID];
            depatCell = [tableView dequeueReusableCellWithIdentifier:depatCellID];
            [depatCell initSubviewsWithID:depatCellID with:_resonMArray];
        }

        depatCell.selectionStyle = UITableViewCellSelectionStyleNone;
        depatCell.delegate = self;
        //        depatCell.dataArray = [self.oneDataArray copy];//SC.XJH.12.17这从服务器取到数组后赋值给cell的array，cell的array已重写set方法，会调用，在set方法中设置
        depatCell.seachLabel.hidden = YES;
        depatCell.fuHaoLabel.hidden = YES;
        depatCell.indexPath = indexPath;
        depatCell.lirenComment = _detaiComment;
        _resonCodeStr = _detaiComment.DimissionReason;
        return depatCell;
    }else if (indexPath.section == 3){//离任原因说明
        
        RsonCell * resonCell = [tableView dequeueReusableCellWithIdentifier:@"rsonCell" forIndexPath:indexPath];
        resonCell.delegate = self;
        //SC.XJH.12.17
        if (_detaiComment.DimissionReason) {
            resonCell.explanTextView.text = _detaiComment.DimissionSupply;
            resonCell.changeLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)resonCell.explanTextView.text.length];
        }
        return resonCell;
        
    }else if (indexPath.section == 4){//在职期间工作评价
        _index = 4;
        SliderTableViewCell * sliderCell = [tableView dequeueReusableCellWithIdentifier:@"sliderTableViewCell" forIndexPath:indexPath];
        sliderCell.selectionStyle = UITableViewCellSelectionStyleNone;
        sliderCell.delegate = self;
        sliderCell.myLabel.text = @"在职期间工作评价";
        
        sliderCell.indexPath = indexPath;
        //SC.XJH.12.17
        if (_detaiComment) {
            _abilityScore = _detaiComment.WorkAbility;
            _attitudeScore = _detaiComment.WorkAttitude;
            _achievementScore = _detaiComment.WorkPerformance;
            sliderCell.abilitySlider.value = _detaiComment.WorkAbility;
            sliderCell.attitudeSlider.value = _detaiComment.WorkAttitude;
            sliderCell.achievementSlider.value = _detaiComment.WorkPerformance;
        }
        
        return sliderCell;
        
    }else if (indexPath.section == 5){//工作交接情况
        _index = 5;
        SliderTableViewCell * twoSliderCell = [tableView dequeueReusableCellWithIdentifier:@"sliderTableViewCellTwo" forIndexPath:indexPath];
        twoSliderCell.myLabel.text = @"工作交接情况";
        twoSliderCell.selectionStyle = UITableViewCellSelectionStyleNone;
        twoSliderCell.abilityLabel.text = @"及时性";
        twoSliderCell.attitudeLabel.text = @"全面性";
        twoSliderCell.achievementLabel.text = @"后续支持";
        twoSliderCell.delegate = self;
        twoSliderCell.indexPath = indexPath;
        //SC.XJH.12.17
        if (_detaiComment) {
            _timely = _detaiComment.HandoverTimely;
            _overall = _detaiComment.HandoverOverall;
            _support = _detaiComment.HandoverSupport;
            
            twoSliderCell.abilitySlider.value = _detaiComment.HandoverTimely;
            twoSliderCell.attitudeSlider.value = _detaiComment.HandoverOverall;
            twoSliderCell.achievementSlider.value = _detaiComment.HandoverSupport;
        }
        return twoSliderCell;
        
    }else if (indexPath.section == 6){//离任评语
        
        static NSString *commentsContentID = @"commentsContentID";
        CommentsContentCell *commentsContentCell = [tableView dequeueReusableCellWithIdentifier:commentsContentID];
        if (!commentsContentCell) {
            commentsContentCell = [[CommentsContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentsContentID];
            commentsContentCell.delegate = self;
            commentsContentCell.titleLabel.text = @"   离任评语";
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
        if (_detaiComment) {
            commentsContentCell.myTextView.text = _detaiComment.WorkComment;
            commentsContentCell.lenthLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)commentsContentCell.myTextView.text.length];
            //SC.XJH.12.20
            if (_detaiComment.WorkCommentImages.count>0) {
                
                [self.photosView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                /*
                for (NSString *imageStr in _detaiComment.WorkCommentImages) {
                    if ([imageStr hasPrefix:@"http"]) {
                        [self.photosView addPhoto:nil imageUrl:imageStr];
                        self.photosView.imageView.delegate = self;
                    }else{
                        NSData *imageData = [[NSData alloc]initWithBase64EncodedString:imageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
                        [self.photosView addPhoto:[UIImage imageWithData:imageData]];
                        self.photosView.imageView.delegate = self;
                    }
                }
                */
                if (self.originalPhotos.count>0) {
                    [self.originalPhotos enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [self.photosView addPhoto:obj];
                        self.photosView.imageView.delegate = self;
                        
                    }];
                }else{
                    for (NSString *imageStr in _detaiComment.WorkCommentImages) {
                        
                        [self.photosView addPhoto:nil imageUrl:imageStr];
                        self.photosView.imageView.delegate = self;
                    }
                    self.originalPhotos = self.photosView.photos.mutableCopy;
                }
                
            }
        }
        //SC.XJH.12.22调用model的set方法，设置图片和语音的frame
        commentsContentCell.detaiComment = _detaiComment;
        return commentsContentCell;
    }else if (indexPath.section == 7){//返聘意愿
        
        _index = 7;
        //SC.XJH.1.1
        static NSString *liZhiDepatID = @"departureResonCellLiZhi";
        DepartureResonCell *liZhiDepatCell = [tableView dequeueReusableCellWithIdentifier:liZhiDepatID];
        
        if (!liZhiDepatCell) {
            [tableView registerNib:[UINib nibWithNibName:@"DepartureResonCell" bundle:nil] forCellReuseIdentifier:liZhiDepatID];
            liZhiDepatCell = [tableView dequeueReusableCellWithIdentifier:liZhiDepatID];
            [liZhiDepatCell initSubviewsWithID:liZhiDepatID with:_backMArray];
        }

        liZhiDepatCell.selectionStyle = UITableViewCellSelectionStyleNone;
        liZhiDepatCell.resonLabel.text = @"返聘意愿";
        liZhiDepatCell.seachLabel.hidden = YES;
        liZhiDepatCell.fuHaoLabel.hidden = YES;
        liZhiDepatCell.delegate = self;
        //        liZhiDepatCell.dataArray = self.liZhiDataArray;//SC.XJH.1.1
        liZhiDepatCell.indexPath = indexPath;
        
        liZhiDepatCell.pinComment = _detaiComment;
        _fanPinCodeStr = _detaiComment.WantRecall;
        return liZhiDepatCell;
        
    }else if (indexPath.section == 8){//添加评价审核人
        
        static NSString * cellId = @"addCommentCellId";
        UITableViewCell * addCommentCell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!addCommentCell) {
            addCommentCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        addCommentCell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
        addCommentCell.textLabel.font = [UIFont systemFontOfSize:15.0];
        NSString * myStr = @"添加审核人(一人通过审核即生效)";
        NSRange range = [myStr rangeOfString: @"(一人通过审核即生效)"];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:myStr];
        [str addAttribute:NSForegroundColorAttributeName value:[PublicUseMethod setColor:KColor_Text_EumeColor] range:range];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range];
        addCommentCell.textLabel.attributedText = str;
        return addCommentCell;
        
    }else{//评价审核人
        
        if (indexPath.row == self.reviewPeopleArray.count) {
            
            static NSString * cellId = @"personalCellId";
            UITableViewCell * personalCell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!personalCell) {
                personalCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 44, 44)];
                [addBtn setImage:[UIImage imageNamed:@"huiadd"] forState:UIControlStateNormal];
                [addBtn addTarget:self action:@selector(addReviewedPeople) forControlEvents:UIControlEventTouchUpInside];
                [personalCell.contentView addSubview:addBtn];
            }
            return personalCell;
            
        }else{
            
            static NSString *reviewedPeopleID = @"reviewedPeopleID";
            ReviewedPeopleCell *reviewedPeopleCell = [tableView dequeueReusableCellWithIdentifier:reviewedPeopleID];
            if (!reviewedPeopleCell) {
                reviewedPeopleCell = [[ReviewedPeopleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reviewedPeopleID];
                reviewedPeopleCell.delegate = self;
            }
            reviewedPeopleCell.indexPath = indexPath;//SC.XJH.12.25
            reviewedPeopleCell.textLabel.text = self.reviewPeopleArray[indexPath.row];
            reviewedPeopleCell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
            reviewedPeopleCell.textLabel.font =[UIFont systemFontOfSize:15.0];
            
            
            if (indexPath.row == 0) {
                reviewedPeopleCell.deletePeopleBtn.hidden = YES;
                reviewedPeopleCell.deletePeopleBtn.enabled = NO;
            }else{
                reviewedPeopleCell.deletePeopleBtn.hidden = NO;
                reviewedPeopleCell.deletePeopleBtn.enabled = YES;
            }
            return reviewedPeopleCell;
            
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //修改的时候不能选择
            if (!_detaiComment.CommentId) {
                StaffListVC * staffVC = [[StaffListVC alloc] init];
                staffVC.secondVC = self;
                staffVC.companyId = _bossMembe.CompanyId;
                staffVC.departBlock = ^(EmployeArchiveEntity * recodelEntity){
                    _nameStr = recodelEntity.RealName;
                    _imageStr = recodelEntity.Picture;
                    _archiveId = recodelEntity.ArchiveId;
                    _departmenStr = recodelEntity.WorkItem.Department;
                    _postTitleStr = recodelEntity.WorkItem.PostTitle;
                    _recodeEntity = recodelEntity;
                    [self.jxTableView reloadData];
                };
                [self.navigationController pushViewController:staffVC animated:YES];
            }
        }
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {//离任日期
            STPickerDate *pickerDate = [[STPickerDate alloc]init];
            [pickerDate setDelegate:self];
            [pickerDate show];
            [pickerDate selectedDateWithString:_liZhiDateTf.text];
            
        }
    }
}

#pragma mark -- 修改离任职务
- (void)fixClick{
    
    ChoickJodVC * choickVC = [[ChoickJodVC alloc] init];
    [self.navigationController pushViewController:choickVC animated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField.tag == 2002) {
        STPickerDate *pickerDate = [[STPickerDate alloc]init];
        [pickerDate selectedDateWithString:_liZhiDateTf.text];
        [pickerDate setDelegate:self];
        [pickerDate show];
        return NO;
    }
    if (textField.tag == 2003) {
    }
    return YES;
}

//SC.XJH.12.30
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 2003) {
        _detaiComment.DimissionSalary = textField.text;
    }
}

#pragma mark -- 添加审核
- (void)addReviewedPeople{
    AddAuditiPersonVC * addAuditiVC = [[AddAuditiPersonVC alloc] init];
    addAuditiVC.block = ^(NSString *nameStr ,NSString * passportId,NSString * jobTitle){
        
        
        //添加的审核人正是当前用户显示发送短信
        if (_myEntity.PassportId == [passportId longLongValue]) {
            _isEquil = YES;
        }
        
        for (int i = 0; i < self.personArray.count; i++) {
            NSString * passport = self.personArray[i];
            if ([passport isEqualToString:passportId]) {
                //标记
                _isEqualName = YES;
            }else{
                _isEqualName = NO;
            }
        }
        if (_isEqualName == YES) {
            
        }else{
            [self.reviewPeopleArray addObject:[NSString stringWithFormat:@"%@(%@)",nameStr,jobTitle]];
            [self.personArray addObject:passportId];
//            _isEquil = YES;
            [self.jxTableView reloadData];
            [self.jxTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.reviewPeopleArray.count inSection:9]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    };
    [self.navigationController pushViewController:addAuditiVC animated:YES];
}

//SC.XJH.12.25
#pragma mark -- 删除审核人
- (void)reviewedPeopleCell:(ReviewedPeopleCell *)cell deletePeopleBtnClick:(UIButton *)button{
    //当前用户是审核人 审核人列表中删除的是审核人 则不显示是否发送短信字样
    if ([_personArray[cell.indexPath.row] longLongValue] == _myEntity.PassportId) {
        _isEquil = NO;
    }
    [self.reviewPeopleArray removeObjectAtIndex:cell.indexPath.row];
    [_personArray removeObjectAtIndex:cell.indexPath.row];
    
    [self.jxTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:cell.indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.jxTableView reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationFade];//SC.XJH.12.29刷新修复不从最后一个cell删除审核人的bug
}


- (void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    
    NSString * dateStr = [NSString stringWithFormat:@"%zd年%02zd月%02zd日", year, month, day];
    _liZhiDateTf = [self.view viewWithTag:2002];
    _liZhiDateTf.text = dateStr;
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *starDate = [JXJhDate getNowDateFromatAnDate:[outputFormatter dateFromString:_liZhiDateTf.text]];
    self.detaiComment.EmployeArchive.DimissionTime = starDate;//SC.XJH.1.3
}
//SC.XJH.12.4点击录音按钮的代理方法，点击录音执行
- (void)goToRecordVoice{
    _blackView.hidden = NO;
    _soundView.hidden = NO;
}

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
- (void)soundViewDidClickedRecodelWithbutton:(UIButton *)btn WithView:(SoundView *)jxFooterView{
    _palyBtn = btn;

    if ([_countDownLabel.text isEqualToString:@"点击开始录音，最多录制120秒"]) {
        [_soundTouchQueue cancelAllOperations];
        [self stopAudio];
        [btn setImage:[UIImage imageNamed:@"zanting"] forState:UIControlStateNormal];
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
        [_voiceImageBtn.imageView stopAnimating];//SC.XJH.1.6
        _audioPalyer = nil;
    }
}

#pragma mark -- 结束录音
- (void)cancelRecordBtnClick{
    [_palyBtn setImage:[UIImage imageNamed:@"mysound"] forState:UIControlStateNormal];

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
    if (_miao > 120) {
        _countDownLabel.text = @"录音结束，超过120秒，请重新录音";
        //SC.XJH.3.7
        _blackView.hidden = NO;
        _soundView .hidden = NO;
    }
    if ([Recorder shareRecorder].filePath != nil && _miao <= 120 && _miao > 5) {
        NSData *mp3Data = [NSData dataWithContentsOfFile:[Recorder shareRecorder].filePath];
        NSString *mp3Str = [mp3Data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSString * timeStr = _countDownLabel.text;
        //SC.XJH.12.20
        _detaiComment.WorkCommentVoice = mp3Str;
        _timeStr = timeStr;
        _countDownLabel.text = @"点击开始录音，最多录制120秒";
        _blackView.hidden = YES;
        _soundView .hidden = YES;
    }
    [self.jxTableView reloadData];
}

#pragma mark -- 转成MP3
//SC.XJH.2.10
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
    //SC.XJH.2.10
}


//时间改变
- (void)TimerActionValueChange:(int)time
{
    if (time > 120) time = 120;
    _miao = time;
    _countDownLabel.text = [NSString stringWithFormat:@"正在录音中：%2.dS",time];
    if (time == 120) {
        [_timeManager stopTimer];
        [[Recorder shareRecorder] stopRecord];
        [self cancelRecordBtnClick];
    }
}

//SC.XJH.12.23
- (void)createStreamer
{
    [self destroyStreamer];
    NSString *escapedValue =
    ( NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                           nil,
                                                                           (CFStringRef)_detaiComment.WorkCommentVoice,
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
//SC.XJH.12.4删除语音的点击代理，删除语音点击调用
- (void)deleteVoice{
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *wavFile = [NSString stringWithFormat:@"%@/SoundTouch",documentDir];
    NSString * mp3FilePath = [NSString stringWithFormat:@"%@/MP3File.mp3",wavFile];
    NSFileManager* fileManager=[NSFileManager defaultManager];
    
    //SC.XJH.2.10
    NSString * wavFilePath = [NSString stringWithFormat:@"%@/voiceFile.wav",wavFile];
    [fileManager removeItemAtPath:wavFilePath error:nil];
    [fileManager removeItemAtPath:[Recorder shareRecorder].filePath error:nil];
    
    if([fileManager removeItemAtPath:mp3FilePath error:nil])
    {
        NSLog(@"删除");
    }
    
    [self destroyStreamer];
    [self stopAudio];//SC.XJH.12.29修复点击删除语音不停止播放的bug
    //SC.XJH.12.29删除语音
    _detaiComment.WorkCommentVoice = nil;
    
    _mp3Str = nil;
    //SC.XJH.12.4更新model，刷新UI
    self.model.mp3Str = _mp3Str;
    [self.jxTableView reloadData];
    self.voiceBtn.enabled = YES;
    [self.voiceBtn setImage:[UIImage imageNamed:@"yuyin"] forState:UIControlStateNormal];
}

//SC.XJH.12.4删除图片的点击代理，删除图片按钮点击调用
- (void)deleteImage{
    //SC.XJH.12.29
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
        /*
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        NSString *imageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [arrayTemp addObject:imageStr];
        */
    }
    _detaiComment.WorkCommentImages = [arrayTemp copy];
    [self.jxTableView reloadData];
}
- (void)composePicAdd{
    if (self.photosView.photos.count >= 11) {
        [PublicUseMethod showAlertView:@"最多只能选择9张照片"];
        return;
    }
    FTImagePickerController* pickerVc = [[FTImagePickerController alloc]init];
    pickerVc.allowsMultipleSelection = YES;
    pickerVc.delegate = self;
    pickerVc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerVc.allowsEditing = NO;
    [self presentViewController:pickerVc animated:YES completion:nil];
}

#pragma mark - imagepickerCtrl delegate
- (void)assetsPickerController:(FTImagePickerController *)picker didFinishPickingImages:(NSArray<UIImage *> *)images{

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
        arrayTemp = [NSMutableArray arrayWithArray:_detaiComment.WorkCommentImages];
        [arrayTemp addObject:photoString];
        
        //jam
        [self.originalPhotos addObject:image];
        //jam
        _detaiComment.WorkCommentImages = [arrayTemp copy];
    }
    [self.jxTableView reloadData];
    self.photosView.size = CGSizeMake(SCREEN_WIDTH - 20, 60 + 60 / 4);
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -- 播放
//SC.XJH.1.6
- (void)playVoice:(CommentsContentCell *)cell withVoiceImageBtn:(UIButton *)btn{
    
    if (btn.selected == YES) {
        [self destroyStreamer];
        [self stopAudio];
        btn.selected = !btn.selected;
    }else{
        btn.selected = !btn.selected;
        
//        NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
//        NSString *wavFile = [NSString stringWithFormat:@"%@/SoundTouch",documentDir];
//        NSString * mp3FilePath = [NSString stringWithFormat:@"%@/MP3File.mp3",wavFile];
        
        //SC.XJH.12.20语音写入文件路径//SC.XJH.12.23
        if (_detaiComment.WorkCommentVoice.length>0) {
            if ([_detaiComment.WorkCommentVoice hasPrefix:@"http"]) {
                //SC.XJH.12.20下载语音，由于这个方法在主线程，在网不好时会卡UI，所以会查找其他的异步下载方式处理，同时设置下载状态。先注释
//                _detaiComment.WorkCommentVoice = @"http://202.204.208.83/gangqin/download/music/02/03/02/Track08.mp3";
                if (!_streamer) {
                    [self createStreamer];
                }
                [_streamer start];
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endPlaying:) name:ASStatusChangedNotification object:nil];
                
                [btn.imageView startAnimating];//SC.XJH.1.6
                
            }else{
//                NSData *data = [[NSData alloc]initWithBase64EncodedString:_detaiComment.WorkCommentVoice options:NSDataBase64DecodingIgnoreUnknownCharacters];
//                [data writeToFile:mp3FilePath atomically:YES];
                NSError *playerError;
                //SC.XJH.2.10
                AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:[Recorder shareRecorder].filePath]error:&playerError];
                _audioPalyer = audioPlayer;
                _audioPalyer.volume = 1.0f;
                if (_audioPalyer == nil)
                {
                    NSLog(@"ERror creating player: %@", [playerError description]);
                }
                [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
                _audioPalyer.delegate = self;
                //SC.XJH.2.10
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

- (void)playing{
    if([_audioPalyer isPlaying]){
        [_audioPalyer pause];
    }
    else{
        [_audioPalyer play];
    }
}

//SC.XJH.1.6
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag{
    _audioPalyer = nil;
    [_voiceImageBtn.imageView stopAnimating];
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 500) {
        _lenthLabel.textColor = [UIColor redColor];
    }else{
        _lenthLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
        //SC.XJH.1.4
        _detaiComment.WorkComment = self.mytexiView.text;
    }
    _lenthLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)textView.text.length];
}
#pragma mark -- 提交
- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{
    if (_nameStr == nil) {
        [PublicUseMethod showAlertView:@"请选择员工档案"];
        return;
    }
    if (_liZhiDateTf.text.length == 0) {
        [PublicUseMethod showAlertView:@"请输入离任时间"];
        return;
    }
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString * dateStr = [JXJhDate JHFormatDateWith:_recodeEntity.EntryTime];
    NSDate * lirenDate = [JXJhDate getNowDateFromatAnDate:[outputFormatter dateFromString:dateStr]];
    
    NSDate *starDate = [JXJhDate getNowDateFromatAnDate:[outputFormatter dateFromString:_liZhiDateTf.text]];
    
    if ([starDate timeIntervalSinceDate:lirenDate]<0.0) {
        [PublicUseMethod showAlertView:@"离任时间小于入职时间，请重新填写"];
        return;
    }
//    NSArray * myPhotoArray = (NSArray *)_photoArray;
    NSArray * myPhotoArray = _detaiComment.WorkCommentImages;

    self.auditPersonsArray = (NSArray *)_personArray;
    if (_resonCodeStr.length == 0) {
        [PublicUseMethod showAlertView:@"请选择离任原因"];
        return;
    }
    if (_changeStr.length > 100) {
        [PublicUseMethod showAlertView:@"离任原因补充说明不得超过100字"];
        return;
    }
    if (self.mytexiView.text.length == 0) {
        [PublicUseMethod showAlertView:@"请输入离任评语"];
        return;
    }
    
    if ([self.mytexiView.text isContainsEmoji] ){
        [PublicUseMethod showAlertView:@"离任评语不可以输入表情"];
        return;
    }
    
    if (self.mytexiView.text.length > 500) {
        [PublicUseMethod showAlertView:@"工作评语不得超过500个字"];
        return;
    }
    if (_fanPinCodeStr.length == 0) {
        [PublicUseMethod showAlertView:@"请选择返聘意愿"];
        return;
    }
        
    UITextField * salaryTf = [self.view viewWithTag:2003];
    if (salaryTf.text.length >0) {
        // 正则判断
        NSString *salaryRegex = @"[0-9]{1,3}(\\.[0-9]{0,2})?";
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",salaryRegex];
        
        if (![pre evaluateWithObject:salaryTf.text]) {
            [PublicUseMethod showAlertView:@"请输入正确的年薪哦\n年薪为3~999之间的两位小数或整数"];
            return;
        }
        if (salaryTf.text.floatValue >=1000 || salaryTf.text.floatValue < 3 ) {
            [PublicUseMethod showAlertView:@"年薪为3~999之间的两位小数或整数"];
            return;
        }
    }
    ArchiveCommentEntity * archiveEntity = [[ArchiveCommentEntity alloc] init];
    if (_detaiComment.CommentId) {//修改
        archiveEntity.CommentId = _detaiComment.CommentId;
        archiveEntity.ArchiveId = _detaiComment.ArchiveId;
        archiveEntity.CompanyId = _detaiComment.CompanyId;
        
    }else{
        archiveEntity.ArchiveId = self.archiveId;
        archiveEntity.CompanyId = _bossMembe.CompanyId;
    }
    //档案id
    archiveEntity.DimissionTime = starDate;
    archiveEntity.DimissionReason = _resonCodeStr;//离任原因
    archiveEntity.DimissionSupply = _explainStr;//离任原因补充
    //工作能力
    archiveEntity.WorkAbility = _abilityScore;
    archiveEntity.WorkAttitude = _attitudeScore;
    archiveEntity.WorkPerformance = _achievementScore;
    //交接情况
    archiveEntity.HandoverTimely = _timely;//交接及时性
    archiveEntity.HandoverOverall = _overall;//交接全面性
    archiveEntity.HandoverSupport = _support;//交接后续支持
    
    archiveEntity.WorkComment = self.mytexiView.text;//评价文字
    archiveEntity.WorkCommentImages = myPhotoArray;//评价图片
    //    archiveEntity.WorkCommentVoice = _mp3Str;//评价录音
    archiveEntity.WorkCommentVoice = _detaiComment.WorkCommentVoice;
    archiveEntity.WantRecall = _fanPinCodeStr;//返聘意愿
    archiveEntity.AuditPersons = self.auditPersonsArray;//审核人
    archiveEntity.DimissionSalary = salaryTf.text;
    //离任
    archiveEntity.CommentType = 1;
    archiveEntity.WorkCommentVoiceSecond = _miao;
    archiveEntity.IsSendSms = _isSendMes;
    
//    NSString * str = @"确定提交吗？";
    NSString *message = @"提交审核后离任报告将生效\n并将短信告知员工";
    NSString *cancelButtonTitle = @"关闭";
    NSString *otherButtonTitle = @"提交";
    
    for (int i = 0; i < self.auditPersonsArray.count; i++) {
        
        if (_myEntity.PassportId == [self.auditPersonsArray[i] longLongValue]) {
            _isEquil = YES;
        }
    }
    if (_isEquil) {//代表提交人就是审核人
        message = @"审核生效后将发送短信告知员工发现您是审核人，提交后将自动生效";
        cancelButtonTitle = @"关闭";
        otherButtonTitle = @"提交";
    }else{
        message = @"提交后，审核通过离任报告将生效并将发消息、短信告知员工";
        cancelButtonTitle = @"关闭";
        otherButtonTitle = @"提交";
    }
    
    [self subCommtent:archiveEntity];

}

#pragma mark -- 封装elert
- (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle okTitle:(NSString *)okTitle archiveEntity:(ArchiveCommentEntity *)archiveEntity{
    
    MJWeakSelf
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        if (_detaiComment.CommentId) {//修改 -- > 我知道了
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else if ([cancelButtonTitle isEqualToString:@"否"]){
           
         }else{
            //我的评价列表
            JXJudgeListVC * listVC = [[JXJudgeListVC alloc] init];
            [weakSelf.navigationController pushViewController:listVC animated:YES];
         }
    }];
    
    [cancelAction setValue:[PublicUseMethod setColor:KColor_Text_BlackColor] forKey:@"titleTextColor"];
    [cancelAction setValue:[NSNumber numberWithInteger:NSTextAlignmentCenter] forKey:@"titleTextAlignment"];
    [alertController addAction:cancelAction];

    if (okTitle != nil) {
        //确定
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

            if ([okTitle isEqualToString:@"是"]) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                //先退出了
                ReportListVC *reportList;
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[ReportListVC class]]) {
                        reportList = (ReportListVC *)vc;
                    }
                }
                [self.navigationController popViewControllerAnimated:NO];
                AddDepartureReportVC * reportVC = [[AddDepartureReportVC alloc] init];
                reportVC.title = @"添加离任报告";
                [reportList.navigationController pushViewController:reportVC animated:NO];
            }
        }];
        [otherAction setValue:[PublicUseMethod setColor:KColor_Text_BlackColor] forKey:@"titleTextColor"];
        [alertController addAction:otherAction];
    }
    [self presentViewController:alertController animated:YES completion:nil];
    
}
//SC.XJH.2.10
- (void)subCommtent:(ArchiveCommentEntity *)archiveEntity {
    if (_detaiComment.CommentId) {//修改
        [self showLoadingIndicator];
        
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
    NSString * str = @"操作成功";
    NSString *message = @" ";
    NSString *cancelButtonTitle = @" ";
    NSString *otherButtonTitle = @" ";
    
    CompanyMembeEntity *myEntity = [UserAuthentication GetMyInformation];
    for (int i = 0; i < self.auditPersonsArray.count; i++) {
        if (myEntity.PassportId == [self.auditPersonsArray[i] longLongValue]) {
            _isEquil = YES;
        }
    }
    if (_isEquil) {//代表提交人就是审核人
        otherButtonTitle = @"继续添加";
        message = @"您是审核人,离任报告已生效";
        cancelButtonTitle = @"我知道了";
    }else{
        otherButtonTitle = @"继续添加";
        message = @"审核通过后,离任报告将生效";
        cancelButtonTitle = @"我知道了";
    }
    
    [WorkbenchRequest postCommentUpdateWith:archiveEntity success:^(id result) {
        [self dismissLoadingIndicator];
        //            NSLog(@"result===%@",result);
        
        if ([result intValue] > 0) {
            [self alertWithTitle:str message:message cancelTitle:cancelButtonTitle okTitle:nil archiveEntity:archiveEntity];
            if ([self.navigationController.viewControllers[1] isKindOfClass:[ReportListVC class]]) {
                ReportListVC *listVC =  self.navigationController.viewControllers[1];
                [listVC.jxTableView.mj_header beginRefreshing];
            }
        }
    } fail:^(NSError *error) {
        [self dismissLoadingIndicator];
        Log(@"%@",error);
    }];
}

- (void)addArchiveComment:(ArchiveCommentEntity *)archiveEntity{
    NSString * str = @"操作成功";
    NSString *message = @" ";
    NSString *cancelButtonTitle = @" ";
    NSString *otherButtonTitle = @" ";
    
    CompanyMembeEntity *myEntity = [UserAuthentication GetMyInformation];;
    for (int i = 0; i < self.auditPersonsArray.count; i++) {
        
        if (myEntity.PassportId == [self.auditPersonsArray[i] longLongValue]) {
            _isEquil = YES;
        }
    }
    if (_isEquil) {//代表提交人就是审核人
        message = @"您是审核人,离任报告已生效";
        cancelButtonTitle = @"去查看";
        otherButtonTitle = @"继续添加";
    }else{
        message = @"审核通过后,离任报告将生效";
        cancelButtonTitle = @"去查看";
        otherButtonTitle = @"继续添加";
    }
    
    [WorkbenchRequest postAddArchiveCommentWith:archiveEntity success:^(id result) {
        [self dismissLoadingIndicator];
        //返回的是评价的自增idCommentId
        //            Log(@"result===%@",result);
        if (result > 0) {
            [self alertWithTitle:str message:message cancelTitle:cancelButtonTitle okTitle:otherButtonTitle archiveEntity:archiveEntity];
        }
    } fail:^(NSError *error) {
        [self dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];
        NSLog(@"%@",error);
    }];
}

#pragma mark --离任原因的cell  返聘意愿
- (void)departureResonCellClickTimeBtnWith:(NSInteger)index WithCode:(NSString *)codeStr WithIndexPath:(NSIndexPath *)indexPath andView:(DepartureResonCell *)resonCell{

    if (indexPath.section == 2) {//离任原因//SC.XJH.1.1
        UIButton * but = [resonCell viewWithTag:index + 100];
        _detaiComment.DimissionReasonText = but.titleLabel.text;
        _detaiComment.DimissionReason = codeStr;
        _resonCodeStr = codeStr;
        NSLog(@"codeStr===%@",codeStr);
        
    }
    if (indexPath.section == 7) {//返聘意愿//SC.XJH.1.1
        UIButton * but = [resonCell viewWithTag:index + 100];
        NSLog(@"b你猜===%@",but.titleLabel.text);
        _detaiComment.WantRecallText = but.titleLabel.text;
        _detaiComment.WantRecall = codeStr;
        _fanPinCodeStr = codeStr;
        NSLog(@"_fanPinStr===%@",codeStr);
    }
}

- (void)sliderCell:(SliderTableViewCell *)sliderCell WithIndexPath:(NSIndexPath *)indexPath slider:(UISlider *)slider score:(NSString *)score{
    
    if (indexPath.section == 4) {//综合评价
        if (slider == sliderCell.abilitySlider) {
            _abilityScore = _detaiComment.WorkAbility = [score intValue];
        }
        if (slider == sliderCell.attitudeSlider) {
            _attitudeScore = _detaiComment.WorkAttitude = [score intValue];
        }
        if (slider == sliderCell.achievementSlider) {
            _achievementScore = _detaiComment.WorkPerformance = [score intValue];
        }
    }
    if (indexPath.section == 5) {//交接
        
        if (slider == sliderCell.abilitySlider) {
            _timely = _detaiComment.HandoverTimely = [score intValue];
        }
        if (slider == sliderCell.attitudeSlider) {
            _overall = _detaiComment.HandoverOverall = [score intValue];
        }
        if (slider == sliderCell.achievementSlider) {
            _support = _detaiComment.HandoverSupport = [score intValue];
        }
    }
}

#pragma mark -- 离任原因补充
- (void)resonCell:(RsonCell *)sliderCell WithIndexPath:(NSIndexPath *)indexPath textView:(NSString *)myTest changeText:(NSString *)changeText{
    
    _explainStr = myTest;
    _changeStr = changeText;
    _detaiComment.DimissionSupply = myTest;//SC.XJH.1.4
    sliderCell.changeLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)myTest.length];
}

#pragma mark -- 录音结束
//SC.XJH.12.23
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self destroyStreamer];
    [self stopAudio];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark -- 关闭最上面的可以获得收益的View
- (void)topAlertViewDidClickedOffBtn:(TopAlertView *)alertView{
    [_topView removeFromSuperview];
    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    [self.jxTableView reloadData];
}

- (void)rightButtonAction:(UIButton *)button{
    [self jxFooterViewDidClickedNextBtn:nil];
    
}

- (void)leftButtonAction:(UIButton *)button{
    
    if ([self.secondVC isKindOfClass:[AddStaffRecordVC class]]) {//从添加档案过来的
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }else{
        
        if (!_detaiComment.CommentId) {
            if (_nameStr != nil || _liZhiDateTf.text.length != 0 ||  _resonCodeStr.length != 0 || self.mytexiView.text.length != 0 || _changeStr.length > 0 || _fanPinCodeStr.length != 0) {
                [self alertWithTitle:@"温馨提示" message:@"信息尚未保存，是否离开？" cancelTitle:@"否" okTitle:@"是" archiveEntity:nil];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (NSMutableArray *)originalPhotos{
    
    if (_originalPhotos == nil) {
        _originalPhotos = [[NSMutableArray alloc] init];
    }
    return _originalPhotos;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
