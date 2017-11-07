//
//  AddAuditiPersonVC.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/12.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXBasedViewController.h"
#import "JCTagListView.h"

typedef void(^block)(NSString * nameStr,NSString * passportId, NSString * jobTitle);

//添加审核人
@interface AddAuditiPersonVC : JXBasedViewController

@property (nonatomic,strong)NSArray * array;
@property (nonatomic,strong)NSMutableArray *mutableArray;
@property (nonatomic, strong)JCTagListView *signView;
@property (nonatomic,copy)block block;
@property (nonatomic,copy)NSString * str;
@property (nonatomic,strong)UIViewController * scondVC;

@end
