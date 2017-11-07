//
//  SoundRecordingVC.h
//  JuXianBossComments
//
//  Created by juxian on 16/11/1.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXBasedViewController.h"

typedef void(^imp3Block)(NSString * mp3Str,NSString * timeStr);

//录音界面
@interface SoundRecordingVC : JXBasedViewController
@property (nonatomic,copy)imp3Block block;

@end
