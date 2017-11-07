
//
//  CommentsWorkerVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/22.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "CommentsWorkerVC.h"
#import "JXMineModel.h"
#import "TggStarEvaluationView.h"
#import "CommentsView.h"
#import "IWComposePhotosView.h"
#import "BossCommentsEntity.h"
#import "SoundRecordingVC.h"
#import "MineAccountViewController.h"
#import "BossCommentTabBarCtr.h"
#import "BossReviewRechargeVC.h"
//滑动的
#import "SliderView.h"

@interface CommentsWorkerVC ()<UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,JXFooterViewDelegate,AVAudioPlayerDelegate>{

    UIScrollView * _myScrollView;
    AVAudioPlayer *_audioPalyer;


}

@property (nonatomic,strong)NSArray * groupArray;
@property (nonatomic,strong)NSArray * starArray;
@property (nonatomic,strong)UITextField *allFieldTex;

@property (weak ,nonatomic) TggStarEvaluationView *tggStarEvaView;
@property (weak ,nonatomic) TggStarEvaluationView *tggStar;
//@property (nonatomic,strong)UILabel * resultLabel;
@property (nonatomic,assign)NSUInteger ability;
@property (nonatomic,assign)NSUInteger manner;
@property (nonatomic,assign)NSUInteger achievement;
@property (nonatomic,strong)NSString * mp3Str;
@property (nonatomic,strong)NSString * timeStr;


/**
 *  相册
 */
@property (nonatomic, weak) IWComposePhotosView *photosView;
@property (nonatomic, strong) UIButton *yuYinBtn;
@property (nonatomic, strong) UIButton *comerBtn;

@property (nonatomic,strong)NSMutableArray *photoArray;
@property (nonatomic,strong)CommentsView * commentsView;
@property (nonatomic,strong)JXFooterView * footerView;

@property (nonatomic,strong)SliderView * sliderView;


@end

@implementation CommentsWorkerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavView];
    [self initData];
    
//  [IWNotificationCenter addObserver:self selector:@selector(emotionDeleteBtnClick:) name:IWEmotionDeleteBtnClickNoti object:nil];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    

    UIButton   *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.enabled = YES;
    
//    if (self.photosView.photos.count > 8) {
//        [PublicUseMethod showAlertView:@"最多只能选择9张照片"];
//        button.enabled = NO;
//    }
    
//    button.frame = CGRectMake((_photosView.photos.count * 30), 30, 30, 30);
    [button setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
//    button.backgroundColor = [UIColor purpleColor];
    NSLog(@"%lu",_photosView.photos.count);
    button.tag = 10;
    [button addTarget:self action:@selector(composePicAdd) forControlEvents:UIControlEventTouchUpInside];
    [self.photosView addSubview:button];
    self.comerBtn = button;
    
    if (_photosView.photos.count<4) {
        _photosView.size = CGSizeMake(SCREEN_WIDTH, 60);
    }else if (4<=_photosView.photos.count&_photosView.photos.count<8){
        _photosView.size = CGSizeMake(SCREEN_WIDTH, 120);
    }else{
        _photosView.size = CGSizeMake(SCREEN_WIDTH, 180);
    }
    
    _footerView.frame = CGRectMake(0, CGRectGetMaxY(_photosView.frame) + 25, SCREEN_WIDTH, 44);
    
    _myScrollView.contentSize =  CGSizeMake(0,CGRectGetMaxY(_footerView.frame)+89);
    
    UIButton   *yuYinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yuYinBtn.frame = CGRectMake(CGRectGetMaxX(button.frame)+10, 30, 30, 30);
    yuYinBtn.enabled = YES;
    if (_mp3Str!= nil) {
        [yuYinBtn setImage:[UIImage imageNamed:@"wuyuyin"] forState:UIControlStateNormal];
        yuYinBtn.enabled = NO;
        
    }else{
    
        [yuYinBtn setImage:[UIImage imageNamed:@"yuyin"] forState:UIControlStateNormal];
    }
    NSLog(@"%lu",_photosView.photos.count);
    
    
    yuYinBtn.tag = 1000;
    [yuYinBtn addTarget:self action:@selector(recodeVoceClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.photosView addSubview:yuYinBtn];
    self.yuYinBtn = yuYinBtn;
    
    
    if (_mp3Str != nil) {
        _commentsView.deleteVoiceBtn.hidden = NO;
        _commentsView.voiceImage.hidden = NO;
        [_commentsView.voiceImage setTitle:@"点击收听评价" forState:UIControlStateNormal];
        
        [_commentsView.voiceImage addTarget:self action:@selector(playVoice:) forControlEvents:UIControlEventTouchUpInside];
        [_commentsView.voiceImage setBackgroundImage:[UIImage imageNamed:@"qipao"] forState:UIControlStateNormal];
        [_commentsView.deleteVoiceBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [_commentsView.deleteVoiceBtn addTarget:self action:@selector(deleteVoiceClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [self.comerBtn removeFromSuperview];
    [self.yuYinBtn removeFromSuperview];
}

- (void)initNavView{

    self.title = @"添加老板点评";
    [self isShowLeftButton:YES];
}

- (void)initData{

    _starArray = @[@"工作能力",@"工作态度",@"工作业绩"];

}

- (NSArray *)groupArray{

    if (_groupArray == nil) {
        JXMineModel * model1 = [[JXMineModel alloc] init];
        model1.cellMessage = @[@"员工姓名",@"职位",@"身份证号",];
        _groupArray = @[model1];
    }
    return _groupArray;

}
- (NSMutableArray *)photoArray{
    
    if (!_photoArray) {
        _photoArray = [[NSMutableArray alloc] init];
    }
    return _photoArray;
}

- (void)initUI{

    _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _myScrollView.backgroundColor = [UIColor clearColor];
    _myScrollView.contentSize =  CGSizeMake(0,SCREEN_HEIGHT * 2);
    [self.view addSubview:_myScrollView];
    
    self.jxTableView.frame = CGRectMake(0, 10, SCREEN_WIDTH, 44 *3 +10);
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    
    [self.jxTableView.backgroundView addGestureRecognizer:tap];
    [_myScrollView addSubview:self.jxTableView];
    
    _sliderView = [SliderView sliderView];
    _sliderView.frame = CGRectMake(0, CGRectGetMaxY(self.jxTableView.frame), SCREEN_WIDTH, 332);
    [_myScrollView addSubview:_sliderView];
    
    _commentsView = [CommentsView commentsView];
    _commentsView.frame = CGRectMake(0, CGRectGetMaxY(_sliderView.frame) + 10, SCREEN_WIDTH, 220);
    _commentsView.deleteVoiceBtn.hidden = YES;
    _commentsView.voiceImage.hidden = YES;
//    _commentsView.voiceImage.image = [UIImage imageNamed:@"qipao"];

    [_myScrollView addSubview:_commentsView];
    //初始相册
    IWComposePhotosView *photosView = [[IWComposePhotosView alloc] init];
    //设置位置
    photosView.y = CGRectGetMaxY(_commentsView.frame);
    photosView.x = 0;
    photosView.backgroundColor = [UIColor whiteColor];
//    photosView.size = CGSizeMake(SCREEN_WIDTH - 20, self.view.height-photosView.y);
    photosView.size = CGSizeMake(SCREEN_WIDTH, 75);
    _photosView = photosView;    
    [_myScrollView addSubview:photosView];
    self.photosView = photosView;
    
    JXFooterView * footerView = [JXFooterView footerView];
    footerView.frame = CGRectMake(0, CGRectGetMaxY(photosView.frame) + 25, SCREEN_WIDTH, 44);
    footerView.nextLabel.text = @"提交";
    footerView.delegate = self;
    _footerView = footerView;
    [_myScrollView addSubview:footerView];
    
}

- (void)playVoice:(UIButton *)btn{
    
    NSLog(@"444444444");
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *wavFile = [NSString stringWithFormat:@"%@/SoundTouch",documentDir];
//    NSString * WAVFilePath = [NSString stringWithFormat:@"%@/voiceFile.wav",wavFile];
    NSString * mp3FilePath = [NSString stringWithFormat:@"%@/MP3File.mp3",wavFile];
    NSError *playerError;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:mp3FilePath]error:&playerError];
    _audioPalyer = audioPlayer;
    _audioPalyer.volume = 1.0f;
    if (_audioPalyer == nil)
    {
        NSLog(@"ERror creating player: %@", [playerError description]);
    }
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
    _audioPalyer.delegate = self;
    
    if (mp3FilePath != nil) {
        [self playing];
    }
}


- (void)playing
{
    if([_audioPalyer isPlaying])
    {
        [_audioPalyer pause];
//        _StateLable.text = @"播放。。";
    }
    
    else
    {
        [_audioPalyer play];
//        _StateLable.text = @"正在播放录音。。";
    }
    
}

- (void)deleteVoiceClick:(UIButton *)btn{
    
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *wavFile = [NSString stringWithFormat:@"%@/SoundTouch",documentDir];
//    NSString * WAVFilePath = [NSString stringWithFormat:@"%@/voiceFile.wav",wavFile];
    NSString * mp3FilePath = [NSString stringWithFormat:@"%@/MP3File.mp3",wavFile];
    NSFileManager* fileManager=[NSFileManager defaultManager];
    if([fileManager removeItemAtPath:mp3FilePath error:nil])
    {
        NSLog(@"删除");
    }
    _mp3Str = nil;
//    [_commentsView.deleteVoiceBtn removeFromSuperview];
//    [_commentsView.voiceImage removeFromSuperview];
    _commentsView.deleteVoiceBtn.hidden = YES;
    _commentsView.voiceImage.hidden = YES;
    [self.jxTableView reloadData];
    self.yuYinBtn.enabled = YES;
    [self.yuYinBtn setImage:[UIImage imageNamed:@"yuyin"] forState:UIControlStateNormal];
}

#pragma mark -- 提交
- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{

//        MineAccountViewController * accountVC = [[MineAccountViewController alloc] init];
//    BossCommentTabBarCtr * tar = [[BossCommentTabBarCtr alloc] init];
//    tar.selectedIndex = 1;
//    
//    BossReviewRechargeVC * vv = [[BossReviewRechargeVC alloc] init];
//    [self.navigationController pushViewController:vv animated:YES];
    
    if (jxFooterView.nextBtn.selected)
    {
        jxFooterView.nextBtn.selected = NO;
    }
    else
    {
        BossCommentsEntity * commentsEntity = [[BossCommentsEntity alloc] init];
        
        UITextField * nameTF = [self.view viewWithTag:100];
        UITextField * jobTF = [self.view viewWithTag:101];
        UITextField * idCardTF = [self.view viewWithTag:102];

        if (nameTF.text.length < 2) {
            [PublicUseMethod showAlertView:@"员工姓名至少为两个字符"];
            return;
        }
        if (jobTF.text.length < 2) {
            [PublicUseMethod showAlertView:@"职位不合法"];
            return;
        }
        if (idCardTF.text.length == 0) {
            [PublicUseMethod showAlertView:@"身份证号不能为空"];
            return;
        }
        
        if (self.ability == 0 || self.manner == 0 || self.achievement == 0) {
            
            [PublicUseMethod showAlertView:@"评论等级至少为一星"];
            return;
        }
        
        if (_commentsView.myTextView.text.length == 0) {
            
            [PublicUseMethod showAlertView:@"评语不能为空"];
            return;
        }

    
        commentsEntity.TargetName = nameTF.text;
        commentsEntity.TargetJobTitle = jobTF.text;
        commentsEntity.TargetIDCard = idCardTF.text;
        
        int myAbility = [[NSString stringWithFormat:@"%lu",(unsigned long)self.ability] intValue];
        int myManner = [[NSString stringWithFormat:@"%lu",(unsigned long)self.manner] intValue];
        int myAchievement = [[NSString stringWithFormat:@"%lu",(unsigned long)self.achievement] intValue];

        commentsEntity.WorkAbility = myAbility;
        commentsEntity.WorkManner = myManner;
        commentsEntity.WorkAchievement = myAchievement;
        commentsEntity.Text = _commentsView.myTextView.text;
        commentsEntity.Images = self.photoArray;
        if (_mp3Str != nil) {
            commentsEntity.Voice = _mp3Str;
        }
        commentsEntity.VoiceLength = _timeStr;
        
        [self showLoadingIndicator];
 
    }

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    JXMineModel * model = self.groupArray[section];
    return model.cellMessage.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        static NSString *identifier = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            //无色
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            CGFloat allFieldTexW = 180;
            _allFieldTex = [UITextField alloc];
            _allFieldTex = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-allFieldTexW-10, 0, allFieldTexW, 44)];
            _allFieldTex.textAlignment = NSTextAlignmentRight;
            _allFieldTex.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
            _allFieldTex.clearsOnBeginEditing = YES;
            _allFieldTex.font = [UIFont systemFontOfSize:14];
            //        _allFieldTex.placeholder = @"请填写";
            _allFieldTex.delegate = self;
            [cell.contentView addSubview:_allFieldTex];

        }
        
        JXMineModel * mindeModel = self.groupArray[indexPath.section];
        NSString * testStr = mindeModel.cellMessage[indexPath.row];
        _allFieldTex.placeholder = [NSString stringWithFormat:@"请填写%@",testStr];
        _allFieldTex.tag = indexPath.row + 100;
        cell.textLabel.text = testStr;
        cell.textLabel.text = testStr;
        cell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
        
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 10;
}


- (void)composePicAdd{

    if (self.photosView.photos.count >= 11) {
        [PublicUseMethod showAlertView:@"最多只能选择9张照片"];
        return;
    }
    [self pickerImageChannel];

}

#pragma mark - imagepickerCtrl delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    //    self.imageView.image = image;
    [self.photosView addPhoto:image];
    UIButton * btn = (UIButton *)[self.view viewWithTag:10];
    [btn removeFromSuperview];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
//    [self.photosView addPhoto:image];
//    UIButton * btn = (UIButton *)[self.view viewWithTag:10];
//    [btn removeFromSuperview];
    [self.comerBtn removeFromSuperview];
    [self.yuYinBtn removeFromSuperview];
    UIImage *originalImage = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    UIImage *UserSelectImage = [PublicUseMethod fixOrientationForImage:originalImage];
    //等比压缩
    UIImage *comImage = [PublicUseMethod thumbnailWithImageWithoutScale:UserSelectImage size:self.comerBtn .bounds.size];
    
    NSData *data = UIImageJPEGRepresentation(comImage, 1);
    NSString *photoString = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    //    NSString *photoStringd = [data base64Encoding];
    [self.photoArray addObject:photoString];
    [self.photosView addPhoto:comImage];
    self.photosView.size = CGSizeMake(SCREEN_WIDTH - 20, 60 + 60 / 4);
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"用户点取消啦");

    [self.comerBtn  removeFromSuperview];
    [self.yuYinBtn removeFromSuperview];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)pickerImageChannel
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"上传照片" message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"本地相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //UIImagePickerControllerSourceTypePhotoLibrary
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"去拍美照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [alertVC addAction:action3];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)recodeVoceClick:(UIButton *)btn{
    SoundRecordingVC * soundeVC = [[SoundRecordingVC alloc] init];
    soundeVC.block = ^(NSString * mp3Str,NSString * timeStr){
        _mp3Str = mp3Str;
        _timeStr = timeStr;
    };
    [self.navigationController pushViewController:soundeVC animated:YES];
}


#pragma mark --键盘消失
- (void)tap:(UITapGestureRecognizer *)tapGes{
    
    [self.jxTableView endEditing:YES];
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    [self.jxTableView endEditing:YES];
    
    return [self hitTest:point withEvent:event];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    if (![self.allFieldTex isExclusiveTouch]) {
        
        [self.allFieldTex resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
