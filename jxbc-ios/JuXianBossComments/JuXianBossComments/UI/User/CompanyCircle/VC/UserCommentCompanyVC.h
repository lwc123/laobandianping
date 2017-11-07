//
//  UserCommentCompanyVC.h
//  JuXianBossComments
//
//  Created by juxian on 2017/4/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JXBasedViewController.h"

@interface UserCommentCompanyVC : JXBasedViewController

@property (nonatomic, strong) UIViewController *secondVC;

@property (nonatomic,copy  ) NSMutableArray           *orignalTags;
@property (nonatomic, strong) UICollectionView *myCollectionView;

@end
