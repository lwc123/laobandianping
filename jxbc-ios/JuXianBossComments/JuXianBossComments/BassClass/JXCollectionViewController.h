//
//  JXCollectionViewController.h
//  JuXianTalentBank
//
//  Created by juxian on 16/8/9.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "JXBasedViewController.h"
#import "JXCollectionView.h"
@interface JXCollectionViewController : JXBasedViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)JXCollectionView * jxCollectionView;

@property (nonatomic,strong)UICollectionViewFlowLayout * layout;

@end
