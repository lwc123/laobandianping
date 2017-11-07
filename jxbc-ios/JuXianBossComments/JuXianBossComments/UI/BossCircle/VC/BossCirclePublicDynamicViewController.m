//
//  BossCirclePublicDynamicVCViewController.m
//  JuXianBossComments
//
//  Created by Jam on 16/12/27.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "BossCirclePublicDynamicViewController.h"
#import "BossDynamicPublicImgCell.h"
#import "IWTextView.h"
#import "BossDynamicEntity.h"
#import "BossCircleRequest.h"
#import "BossCirclePrivateViewController.h"
#import "FTImagePickerController.h"
#import "XHImageViewer.h"

@interface BossCirclePublicDynamicViewController () <UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,JXFooterViewDelegate,UINavigationControllerDelegate,FTImagePickerControllerDelegate>

// 输入框
@property (nonatomic, strong) IWTextView *inputView;
// 图片九宫格
@property (nonatomic, strong) UICollectionView *photoListView;
// 发布按钮
@property (nonatomic, strong) JXFooterView *publicButton;
// 开启法人姓名按钮
@property (nonatomic, strong) UIButton *showBossNameButton;
@property (nonatomic, strong) UILabel *showBossNameLable;

@property (nonatomic, strong) NSMutableArray *photoArray;

// 添加照片按钮
@property (nonatomic, strong) UIButton *addPhotosButton;

@property (nonatomic, strong) NSMutableArray *photoAddressArr;


// 发布完成回调
@property (nonatomic, copy) CompletePublicBlock completePublicBlock;

@end

@implementation BossCirclePublicDynamicViewController

static NSString * reuseID = @"Photo";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"老板圈";
    [self isShowLeftButton:YES];
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self setup];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}


- (void)setup{
    
    [self.view addSubview:self.inputView];
    [self.view addSubview:self.photoListView];
    [self.view addSubview:self.publicButton];
//    [self.view addSubview:self.showBossNameButton];
//    [self.view addSubview:self.showBossNameLable];
    
    // 设置约束
    [self setupConstraint];
    
}

#pragma mark - textField delegat
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
}

#pragma mark - collectionView delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BossDynamicPublicImgCell* cell = (BossDynamicPublicImgCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    NSMutableArray* imgViewArray = @[].mutableCopy;
    for (NSInteger i = 0;i < self.photoArray.count; i++) {
        
        BossDynamicPublicImgCell* cell = (BossDynamicPublicImgCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [imgViewArray addObject:cell.photoView];
    }
    
    XHImageViewer *imageViewer = [[XHImageViewer alloc]init];
    [imageViewer showWithImageViews:imgViewArray selectedView:cell.photoView];
}
#pragma mark - collectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    if (self.photoArray.count == 0) {
        return 1;
    }else if (self.photoArray.count <9){
        return self.photoArray.count + 1;
    }else{
    
        return 9;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    BossDynamicPublicImgCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    
    if (self.photoArray.count == 0) {
        [cell.contentView addSubview:self.addPhotosButton];

    }else if (self.photoArray.count <9){
        if (indexPath.item < self.photoArray.count) {
            cell.image = self.photoArray[indexPath.item];
        }else{
            cell.image = nil;
            [cell.contentView addSubview:self.addPhotosButton];
        }
        
    }else{
        cell.image = self.photoArray[indexPath.item];
        [self.addPhotosButton removeFromSuperview];
    }
    
    self.addPhotosButton.y = cell.contentView.height - self.addPhotosButton.height;
    
    // 删除按钮点击事件
    MJWeakSelf
    [cell deleteButtonClickCompletion:^{
       NSIndexPath * index = [collectionView indexPathForCell:cell];
        [weakSelf.photoArray removeObjectAtIndex:index.item];
        [weakSelf.photoAddressArr removeObjectAtIndex:index.item];
        // 刷新数据 修改约束
        [weakSelf.photoListView reloadData];
        [weakSelf changePhotoListViewContraint];
    }];
    
    
    return cell;
}



#pragma mark - function

// 添加照片按钮点击
- (void)addPhotoButtonClick{
    
    FTImagePickerController* pickerVc = [[FTImagePickerController alloc]init];

    pickerVc.allowsMultipleSelection = YES;
    pickerVc.delegate = self;
    pickerVc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerVc.allowsEditing = NO;
    
    
    [self presentViewController:pickerVc animated:YES completion:^{
        
    }];

    [self changePhotoListViewContraint];

}

// 提示框
- (void)alertString:(NSString *)string{

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:string message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [UIView animateWithDuration:2 animations:^{
        [self.tabBarController presentViewController:alert animated:YES completion:^{
        }];

    } completion:^(BOOL finished) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
}

// 开启/关闭法人姓名
- (void)showBossNameButtonClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];

    if (sender.selected) {
        Log(@"开启");
        
        [userDefault setBool:NO forKey:@"BossCircleHideBossName"];
        
    }else{
        
        [userDefault setBool:YES forKey:@"BossCircleHideBossName"];
        
    }
    
    [userDefault synchronize];
    
}

#pragma mark - imagepickerCtrl delegate

- (void)assetsPickerController:(FTImagePickerController *)picker didFinishPickingImages:(NSArray <UIImage *>*)images{
    
    if((images.count + self.photoArray.count) >9){
    
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"最多只能选择9张图片哦" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    for (UIImage* photo in images) {
        UIImage *UserSelectImage = [PublicUseMethod fixOrientationForImage:photo];
        UserSelectImage = [PublicUseMethod thumbnailWithImageWithoutScale:photo size:CGSizeMake(photo.size.width * 0.2, photo.size.height * 0.2)];
        NSData *data = UIImageJPEGRepresentation(UserSelectImage, 1);
        NSString *photoString = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        [self.photoAddressArr addObject:photoString];
        
        // 添加照片到数组2
        [self.photoArray addObject:photo];

    }
    // 刷新九宫格
    [self.photoListView reloadData];
    
    // 更新约束
    [self changePhotoListViewContraint];
    
    [picker dismissViewControllerAnimated:YES completion:nil];

}


#pragma mark - 发布

- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{
    
    if (self.inputView.text.length == 0) {
        
        [PublicUseMethod showAlertView:@"您还没有写内容"];
        
        return;
    }
    
    [self.view endEditing:YES];
    
    [self showLoadingIndicator];
    // 获取状态信息
    BossDynamicEntity *dynamic = [[BossDynamicEntity alloc]init];
    CompanyEntity *company = [[CompanyEntity alloc]init];
    
    
    dynamic.Img = self.photoAddressArr.copy;
    dynamic.Content = self.inputView.text;
    
    // 获取公司信息
    CompanyMembeEntity * companyEntity= [UserAuthentication GetBossInformation];
    dynamic.CompanyId = companyEntity.CompanyId;
    
    dynamic.Company = company;
    
    [BossCircleRequest postPublicDynamicWith:dynamic success:^(long result) {
        
        Log(@"发布成功");
        
        [self dismissLoadingIndicator];
        [self.navigationController popToRootViewControllerAnimated:YES];

        if (self.completePublicBlock) {
            self.completePublicBlock();
        }
        
    } fail:^(NSError *error) {
        if(error.code == 3840){
            
            [self dismissLoadingIndicator];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            if (self.completePublicBlock) {
                self.completePublicBlock();
            }
            return ;
            
        }
        [self dismissLoadingIndicator];
        Log(@"  发布失败error %@",error.description);
        [PublicUseMethod showAlertView:[NSString stringWithFormat:@"%@",error.localizedDescription]];


    }];

}

#pragma mark - textView delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if ([text isEqualToString:@""] && range.length > 0) {
        //删除字符肯定是安全的
        return YES;
    }
    else {
        if (textView.text.length - range.length + text.length > 140) {
            [PublicUseMethod showAlertView:@"超出最大可输入长度140字"];
            return NO;
        }
        else {
            return YES;
        }
    }
}


#pragma mark - 约束
- (void)setupConstraint{
    
    // 输入框
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(120);
    }];
    
    // 图片列表
    [self.photoListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.inputView.mas_bottom).offset(12);
        make.height.mas_equalTo(KItemLength);
        make.width.mas_equalTo(KItemLength);
    }];
    
    // 发布按钮
    [self.publicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.photoListView.mas_bottom).offset(25);
        make.height.mas_equalTo(44);
    }];
    
}

// 修改照片视图约束
- (void)changePhotoListViewContraint{

    // 修改约束
    CGFloat viewWidth = 3 * KItemLength + 3 * KItemSpace;
    CGFloat viewHeight = (self.photoArray.count/ 3) * (KItemLength + KItemSpace)+ KItemLength + KItemSpace;
    if (self.photoArray.count == 9) {
        viewHeight = viewWidth;
    }
    [self.photoListView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(viewWidth);
        make.height.mas_equalTo(viewHeight);
    }];
}

- (void)CompletePublicHandle:(CompletePublicBlock)completePublicBlock{

    self.completePublicBlock = completePublicBlock;
}

#pragma mark - 控件懒加载
// 输入框
- (IWTextView *)inputView{
    
    if (!_inputView) {
        _inputView = [[IWTextView alloc]initWithFrame:CGRectMake(0, 0, 200, 250)];
        _inputView.placeholder = @"说说老板的事儿";
        _inputView.placeholderColor = [UIColor lightGrayColor];
        _inputView.delegate = self;
        _inputView.showsVerticalScrollIndicator = NO;
        _inputView.showsHorizontalScrollIndicator = NO;
        _inputView.font = [UIFont systemFontOfSize:15];
    }
    return _inputView;
}

// 图片列表
- (UICollectionView *)photoListView{

    if (_photoListView == nil) {
        UICollectionViewFlowLayout* flow = [[UICollectionViewFlowLayout alloc]init];
        flow.itemSize = CGSizeMake(KItemLength, KItemLength);
        flow.minimumLineSpacing = KItemSpace;
        flow.minimumInteritemSpacing = KItemSpace;
        
        _photoListView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        
        _photoListView.backgroundColor = self.view.backgroundColor;
        
        [_photoListView registerClass:[BossDynamicPublicImgCell class] forCellWithReuseIdentifier:reuseID];
        
        [_photoListView setScrollsToTop:NO];
        
        _photoListView.showsVerticalScrollIndicator = NO;
        _photoListView.showsHorizontalScrollIndicator = NO;
        _photoListView.delegate = self;
        _photoListView.dataSource = self;
        
        // _photoListView.backgroundColor = [UIColor orangeColor];
        
    }
    return _photoListView;
}

// 发布按钮
- (JXFooterView *)publicButton{
    
    if (!_publicButton) {
        _publicButton = [JXFooterView footerView];
        _publicButton.delegate = self;
        _publicButton.nextLabel.text = @"发  布";
    }
    return _publicButton;
}

// 开启法人姓名按钮
- (UIButton *)showBossNameButton{
    
    if (_showBossNameButton == nil) {
        _showBossNameButton = [[UIButton alloc] init];
        _showBossNameButton.adjustsImageWhenHighlighted = NO;

        _showBossNameButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_showBossNameButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_showBossNameButton setImage:[UIImage imageNamed:@"灰勾.png"] forState:UIControlStateNormal];
        [_showBossNameButton setImage:[UIImage imageNamed:@"选中.png"] forState:UIControlStateSelected];
        
        [_showBossNameButton addTarget:self action:@selector(showBossNameButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    _showBossNameButton.selected = ![userDefault boolForKey:@"BossCircleHideBossName"];
    
    return _showBossNameButton;
    
}

- (UILabel *)showBossNameLable{
    
    if (_showBossNameLable == nil) {
        _showBossNameLable = [[UILabel alloc] init];
        _showBossNameLable.text = @"开启显示法人姓名(一开全开)";
        _showBossNameLable.textColor = [UIColor blackColor];
        _showBossNameLable.font = [UIFont systemFontOfSize:14];
    }
    return _showBossNameLable;
    
}

// 添加照片按钮

- (UIButton *)addPhotosButton{
    
    if (_addPhotosButton == nil) {
        _addPhotosButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KItemLength-KItemSpace, KItemLength-KItemSpace)];
        [_addPhotosButton setImage:[UIImage imageNamed:@"添加照片.jpg"] forState:UIControlStateNormal];
        [_addPhotosButton setImage:[UIImage imageNamed:@"添加照片.jpg"] forState:UIControlStateNormal];
        [_addPhotosButton addTarget:self action:@selector(addPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _addPhotosButton;
    
}



- (NSMutableArray *)photoArray{

    if (_photoArray == nil) {
        _photoArray = [[NSMutableArray alloc] init];
    }
    return _photoArray;
}

- (NSMutableArray *)photoAddressArr{

    if (_photoAddressArr == nil) {
        _photoAddressArr = [[NSMutableArray alloc] init];
    }
    return _photoAddressArr;
}


@end
