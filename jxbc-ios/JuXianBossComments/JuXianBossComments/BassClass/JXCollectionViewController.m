//
//  JXCollectionViewController.m
//  JuXianTalentBank
//
//  Created by juxian on 16/8/9.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "JXCollectionViewController.h"
#import "MacroDefinition.h"

@interface JXCollectionViewController ()

@end

@implementation JXCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self isShowLeftButton:YES];

//    self.view.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initConllectionView];
}

- (void)initConllectionView{

    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    _jxCollectionView = [[JXCollectionView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:_layout];
    _jxCollectionView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
    _jxCollectionView.delegate = self;
    _jxCollectionView.dataSource = self;
    _jxCollectionView.showsVerticalScrollIndicator = NO;

    [self.view addSubview:_jxCollectionView];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return 1;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

   static NSString * collectionCellId = @"collectionCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellId forIndexPath:indexPath];
    
    if (!cell) {
        
        cell = [[UICollectionViewCell alloc] init];
    }
    
    return cell;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
