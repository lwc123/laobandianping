//
//  DepartureDetail.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/16.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXBasedViewController.h"

//离任详情
@interface DepartureDetail : JXBasedViewController
@property (nonatomic,assign)long commentId;
@property (nonatomic,strong)UIWebView * webView;

@property (nonatomic,assign)long archiveId;

@end
