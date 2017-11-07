//
//  JHMoreTagsVC.h
//  JuXianBossComments
//
//  Created by juxian on 2017/4/12.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JXBasedViewController.h"

@interface JHMoreTagsVC : JXBasedViewController
@property (nonatomic,strong) NSMutableArray    *selectedTags;
@property (nonatomic,copy  ) NSMutableArray           *orignalTags;
@property (nonatomic, strong) UICollectionView *myCollectionView;

@end
