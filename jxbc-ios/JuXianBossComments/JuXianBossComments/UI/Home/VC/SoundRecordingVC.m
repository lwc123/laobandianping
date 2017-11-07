//
//  SoundRecordingVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/1.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "SoundRecordingVC.h"
#import "DotimeManage.h"
#import "Recorder.h"
#import "lame.h"
#import "SoundTouchOperation.h"
#import "AddDepartureReportVC.h"


//X Y W H
#define ButtonW  150
#define ButtonX  (self.view.frame.size.width - ButtonW) * 0.5
#define ButtonH  50

@interface SoundRecordingVC ()<DotimeManageDelegate,AVAudioPlayerDelegate,AVAudioSessionDelegate>{

    AVAudioPlayer *_audioPalyer;
    DotimeManage *_timeManager;
    /**
     *  状态
     */
    UILabel *_StateLable;
    UILabel *_countDownLabel;
    NSOperationQueue *_soundTouchQueue;
    NSString *_WAVFilePath;
    NSString *_mp3FilePath;
    /**
     *  原声播放提醒
     */
    UILabel *original;
    //是否正在转码
    BOOL transcoding;
    NSURL *recordedFile;
    AddDepartureReportVC * _addDepartVC;

}

@property (nonatomic,assign)int miao;
@property (nonatomic,strong)UILabel * descLabel;
@end

@implementation SoundRecordingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"老板点评";
    [self isShowLeftButton:YES];
    
    
    _soundTouchQueue = [[NSOperationQueue alloc]init];
    _soundTouchQueue.maxConcurrentOperationCount = 1;
    
    [self initUI];
    
    
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *path = [NSString stringWithFormat:@"%@/Voice",documentDir];
    NSString *recordedStr = [NSString stringWithFormat:@"%@/RecordingFile.wav",path];
    recordedFile = [[NSURL alloc] initFileURLWithPath:recordedStr];
    _timeManager = [DotimeManage DefaultManage];
    [_timeManager setDelegate:self];
    
}

- (void)initUI{

    UIButton * recodeBtn = [UIButton buttonWithFrame:CGRectMake((SCREEN_WIDTH - 100) * 0.5, (SCREEN_HEIGHT -100) * 0.5 - 80, 100, 100) title:nil fontSize:0 titleColor:nil imageName:@"yuyin" bgImageName:nil];
    recodeBtn.backgroundColor = [PublicUseMethod setColor:KColor_MainColor];
    recodeBtn.layer.cornerRadius = 50;
    [recodeBtn addTarget:self action:@selector(recodeVoiceClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recodeBtn];
    
    _descLabel = [UILabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(recodeBtn.frame) + 20, SCREEN_WIDTH, 17) title:@"点击开始录音" titleColor:[PublicUseMethod setColor:KColor_Text_BlackColor] fontSize:14.0 numberOfLines:1];
    _descLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_descLabel];
    
   _countDownLabel = [[UILabel alloc]initWithFrame:CGRectMake(ButtonX, CGRectGetMinY(recodeBtn.frame) - 50, ButtonW, ButtonH)];
    _countDownLabel.text = @"";
    _countDownLabel.font = [UIFont systemFontOfSize:13.0];
    _countDownLabel.textColor = [UIColor grayColor];
    _countDownLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_countDownLabel];


    UIButton *recordBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 30, 50, 30)];
    [recordBtn setTitle:@"录音" forState:UIControlStateNormal];
    recordBtn.backgroundColor = [UIColor blueColor];
    [recordBtn addTarget:self action:@selector(recodeVoiceClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recordBtn];
    
    UIButton *cancelRecordBtn = [[UIButton alloc]initWithFrame:CGRectMake(70, 30, 100, 30)];
    [cancelRecordBtn setTitle:@"结束录音" forState:UIControlStateNormal];
    cancelRecordBtn.backgroundColor = [UIColor blueColor];
    [cancelRecordBtn addTarget:self action:@selector(cancelRecordBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelRecordBtn];
    
    UIButton *playBtn = [[UIButton alloc]initWithFrame:CGRectMake(180, 30, 50, 30)];
    [playBtn setTitle:@"播放" forState:UIControlStateNormal];
    playBtn.backgroundColor = [UIColor blueColor];
    [playBtn addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
    
    UIButton *getDataBtn = [[UIButton alloc]initWithFrame:CGRectMake(240, 30, 50, 30)];
    [getDataBtn setTitle:@"转data" forState:UIControlStateNormal];
    getDataBtn.backgroundColor = [UIColor blueColor];
    [getDataBtn addTarget:self action:@selector(getDataBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getDataBtn];
}

- (void)getDataBtnClick{
    if (_mp3FilePath != nil) {
        
        NSData *mp3Data = [NSData dataWithContentsOfFile:_mp3FilePath];
//        NSString *mp3DataStr = [[NSString alloc]initWithData:mp3Data encoding:NSUTF8StringEncoding];
//        NSString *mp3DataStr2 = [mp3Data base64Encoding];
//        NSString *mp3DataStr3 = [mp3DataStr2 stringByRemovingPercentEncoding];

        NSString *mp3Str = [mp3Data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSLog(@"mp3Data===%@",mp3Data);
        NSLog(@"mp3Str===%@",mp3Str);
        NSString * timeStr = _countDownLabel.text;
        if (_block) {
            
            self.block(mp3Str,timeStr);
        }
        
//        NSLog(@"mp3DataStr2===%@",mp3DataStr2);
//        NSLog(@"mp3DataStr3===%@",mp3DataStr3);

    }
}

- (void)leftButtonAction:(UIButton *)button{

    if (_miao > 120) {
        
        [PublicUseMethod showAlertView:@"录音超过20秒 请重新录音"];
        return;
    }
    
    if (_mp3FilePath != nil) {
        
        NSData *mp3Data = [NSData dataWithContentsOfFile:_mp3FilePath];
        NSString *mp3Str = [mp3Data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSLog(@"mp3Data===%@",mp3Data);
        NSLog(@"mp3Str===%@",mp3Str);
        
        NSString * timeStr = _countDownLabel.text;
        if (_block) {
            
            self.block(mp3Str,timeStr);
            [_addDepartVC.jxTableView reloadData];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelRecordBtnClick{
    _StateLable.text = @"录音结束";
    [_timeManager stopTimer];
    [[Recorder shareRecorder]stopRecord];
    //停止记录  关闭路径
    //    [recorder stop];
    
    transcoding = YES;
    
    
    NSData *data = [NSData dataWithContentsOfFile:[Recorder shareRecorder].filePath];
    
    MySountTouchConfig config;
    config.sampleRate = 44100.0;
    config.tempoChange = 0;
    config.pitch = 0;
    config.rate = 0;
    
    SoundTouchOperation *manSTO = [[SoundTouchOperation alloc]initWithTarget:self action:@selector(convertToMP3) SoundTouchConfig:config soundFile:data];
    
    [_soundTouchQueue cancelAllOperations];
    [_soundTouchQueue addOperation:manSTO];
    
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

}

- (void)playBtnClick{
    NSError *playerError;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:_mp3FilePath]error:&playerError];
    _audioPalyer = audioPlayer;
    _audioPalyer.volume = 1.0f;
    if (_audioPalyer == nil)
    {
        NSLog(@"ERror creating player: %@", [playerError description]);
    }
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
    _audioPalyer.delegate = self;
    
    if (_mp3FilePath != nil) {
        [self playing];
    }
}




- (void)recodeVoiceClick:(UIButton *)btn{
    btn.selected ^= 1;
    if (btn.selected) {
        [_soundTouchQueue cancelAllOperations];
        [self stopAudio];
        _StateLable.text = @"开始录音--松开结束录音";
        _descLabel.text = @" ";

        [_timeManager setTimeValue:30];
        [_timeManager startTime];
        [[Recorder shareRecorder]startRecord];
    }else{
    
        [self cancelRecordBtnClick];
        if (_miao > 10) {
            
            _descLabel.text = @"录音结束，超过120秒，请重新录音";
            _countDownLabel.text = @" ";

        }else{
        
            _descLabel.text = @"";
            btn.enabled = NO;

        }
        
    }
}

//停止录音
- (void)buttonSayEnd
{
    _StateLable.text = @"录音结束";
    [_timeManager stopTimer];
    [[Recorder shareRecorder]stopRecord];
    //停止记录  关闭路径
    //    [recorder stop];
    
}

//停止播放
- (void)stopAudio {
    if (_audioPalyer) {
        [_audioPalyer stop];
        _audioPalyer = nil;
    }
    //    [self.actView stopAnimating];
    
}

- (void)MachineMp3Play{
    NSLog(@"播放机器声");
    
    [self stopAudio];
    
    [_StateLable setText:@"转码处理。。"];
//    [MBProgressHUD showMessage:@"正在转码"];
    transcoding = YES;
    
    
    NSData *data = [NSData dataWithContentsOfFile:[Recorder shareRecorder].filePath];
    
    MySountTouchConfig config;
    config.sampleRate = 44100.0;
    config.tempoChange = 0;
    config.pitch = 0;
    config.rate = 0;
    
    SoundTouchOperation *manSTO = [[SoundTouchOperation alloc]initWithTarget:self action:@selector(SoundTouchFinish:) SoundTouchConfig:config soundFile:data];
    
    [_soundTouchQueue cancelAllOperations];
    [_soundTouchQueue addOperation:manSTO];

}

#pragma mark - 处理录音结束
- (void)SoundTouchFinish:(NSString *)path{

    [self stopAudio];
    
    //播放
    [self playAudio:path];
}

//播放
- (void)playAudio:(NSString *)path {
    
//    [MBProgressHUD hideHUD];
    transcoding = NO;
    [_StateLable setText:@"此时播放的是 WAV 格式音效"];
    NSURL *url = [NSURL URLWithString:path];
    NSError *err = nil;
    _audioPalyer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
    _audioPalyer.delegate = self;
    [_audioPalyer prepareToPlay];
    [_audioPalyer play];
}

#pragma mark 播放
- (void)pushAct{

    [_StateLable setText:@"在\"发送\"方法中删除缓存文件"];
    
    [self audio_PCMtoMP3];


}





#pragma mark - wav转MP3 -
- (void)audio_PCMtoMP3
{
//    [MBProgressHUD showMessage:@"正在转换MP3"];
    
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
    @finally {
        NSError *playerError;
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:_mp3FilePath]error:&playerError];
        _audioPalyer = audioPlayer;
        _audioPalyer.volume = 1.0f;
        if (_audioPalyer == nil)
        {
            NSLog(@"ERror creating player: %@", [playerError description]);
        }
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
                _audioPalyer.delegate = self;
        //xjh
//        _audioPalyer.delegate = nil;
        
        
    }
    
//    [MBProgressHUD hideHUD];
    if (_mp3FilePath != nil) {
        [self playing];
    }
}

- (void)playing
{
    if([_audioPalyer isPlaying])
    {
        [_audioPalyer pause];
        _StateLable.text = @"播放。。";
    }
    
    else
    {
        [_audioPalyer play];
        _StateLable.text = @"正在播放录音。。";
    }
    
}

#pragma mark -AVAudio 代理方法-
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"播放完成回调");
    [_StateLable setText:@"播放完成"];
    original.hidden = YES;
}



//时间改变
- (void)TimerActionValueChange:(int)time
{
    
    if (time == 30) {
        
        [_timeManager stopTimer];
        
        
        [[Recorder shareRecorder] stopRecord];
    }
    if (time > 30) time = 30;
    
    _miao = time;
    _countDownLabel.text = [NSString stringWithFormat:@"已录制：%2.dS",time];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
