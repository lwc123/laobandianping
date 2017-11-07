//
//  ApplyAccountTwoVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/18.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "ApplyAccountTwoVC.h"
#import "ApplyAccountThreeVC.h"
#import "MineDataRequest.h"

@interface ApplyAccountTwoVC ()<JXFooterViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong)UIImageView * IdImageView;
@property (nonatomic,strong)NSMutableArray *photoArray;
@property (nonatomic,strong)UIImagePickerController *imagePicker;
@property (nonatomic,strong)UIButton *photoBt;
@property (nonatomic,strong)AnonymousAccount * temAccount;

@end

@implementation ApplyAccountTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavView];
    [self initUI];
    _temAccount = [UserAuthentication GetCurrentAccount];
}

- (void)initNavView{
    self.title = @"企业认证";
    [self isShowLeftButton:NO];
    [self.navigationItem setHidesBackButton:YES];
//    self.navigationItem.leftBarButtonItem.;
//    self.navigationItem.leftBarButtonItem
    _imagePicker.delegate = self;
}

- (NSMutableArray *)photoArray{
    
    if (!_photoArray) {
        _photoArray = [[NSMutableArray alloc] init];
    }
    return _photoArray;
}


- (void)initUI{

    JXBecomeHunterView * headerView = [JXBecomeHunterView becomeHunterView];
    headerView.frame = CGRectMake(0, 30, SCREEN_WIDTH, 65);
    [self.view addSubview:headerView];


    
    CGFloat idImageW = 210;
    CGFloat idImageH = 160;
    CGFloat idImageX = (SCREEN_WIDTH - idImageW) * 0.5;
    CGFloat idImageY = CGRectGetMaxY(headerView.frame) + 40;
    
    _IdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(idImageX,idImageY,idImageW,idImageH)];
    _IdImageView.image = [UIImage imageNamed:@"tianjia"];
    _IdImageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:_IdImageView];
    
    _photoBt = [[UIButton alloc] initWithFrame:_IdImageView.frame];
    [_photoBt addTarget:self action:@selector(addPhoto:) forControlEvents:UIControlEventTouchUpInside];
    _photoBt.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_photoBt];
    
    UILabel * photoLabel = [UILabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(_IdImageView.frame), SCREEN_WIDTH, 17) title:@"法人身份证正面照片" titleColor:[PublicUseMethod setColor:KColor_Text_EumeColor] fontSize:11.0 numberOfLines:1];
        
    photoLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:photoLabel];
    
    JXFooterView * footerView = [JXFooterView footerView];
    footerView.frame = CGRectMake((SCREEN_WIDTH - 270) * 0.5, CGRectGetMaxY(photoLabel.frame) + 45, 270, 44);
    footerView.delegate = self;
    footerView.nextLabel.text = @"下一步";
    [self.view addSubview:footerView];
}

#pragma mark -- 添加身份证照片
- (void)addPhoto:(UIButton *)btn{
    
    [self pickerImageChannel];
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


#pragma mark - UINavigationControllerDelegate, UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *originalImage = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    UIImage *UserSelectImage = [PublicUseMethod fixOrientationForImage:originalImage];
    //等比压缩
    UIImage *comImage = [PublicUseMethod thumbnailWithImageWithoutScale:UserSelectImage size:_photoBt.bounds.size];
    
    NSData *data = UIImageJPEGRepresentation(comImage, 1);
    NSString *photoString = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//    NSString *photoStringd = [data base64Encoding];
    [self.photoArray addObject:photoString];
    
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.frame = _photoBt.frame;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor purpleColor];
  imageView.image = [self watermarkImage:comImage withName:@"仅供认证参考"];
//    imageView.image = comImage;
    
//    [self.buttonView addSubview:imageView];
    [self.view addSubview:imageView];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


-(UIImage *)watermarkImage:(UIImage *)img withName:(NSString *)name

{
    NSString* mark = name;
    
    int w = img.size.width;
    
    int h = img.size.height;
    
    UIGraphicsBeginImageContext(img.size);
    
    [img drawInRect:CGRectMake(0, 0, w, h)];
    
    NSDictionary *attr = @{
                           
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:20],  //设置字体
                           NSForegroundColorAttributeName : [UIColor redColor]   //设置字体颜色
                           };
    
    [mark drawInRect:CGRectMake(0, 0, w, h) withAttributes:attr];         //左上角
//    [mark drawInRect:CGRectMake(w - , , , ) withAttributes:attr];      //右上角
//    [mark drawInRect:CGRectMake(w - , h - - , , ) withAttributes:attr];  //右下角
//    [mark drawInRect:CGRectMake(, h - - , , ) withAttributes:attr];    //左下角
    
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return aimg;
    
}

// 画水印
//- (UIImage *) imageWithWaterMask:(UIImage*)mask inRect:(CGRect)rect
//{
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
//    {
//        UIGraphicsBeginImageContextWithOptions([self size], NO, 0.0); // 0.0 for scale means "scale for device's main screen".
//    }
//#else
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.0)
//    {
//        UIGraphicsBeginImageContext([self size]);
//    }
//#endif
//    //原图
//    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
//    //水印图
//    [mask drawInRect:rect];
//    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newPic; 
//}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{
    
    
    if (self.photoArray.count==0 ) {
        [PublicUseMethod showAlertView:@"身份证照片不能为空"];
        return;
    }else{
    
//        for (int i = 0; i < self.photoArray.count; i++) {
//            self.temAccount.UserProfile.CurrentImages = self.photoArray[i];
//        }
    }
    
    
//    ApplyAccountThreeVC * threeVC = [[ApplyAccountThreeVC alloc] init];
//    threeVC.photoArray = self.photoArray;
//    [self.navigationController pushViewController:threeVC animated:YES];
//    
//    //保存
////    [self showLoadingIndicator];
//    [MineDataRequest UserChangeProfileWith:self.temAccount.UserProfile success:^(id result) {
//        if (result) {
//            
//            [self dismissLoadingIndicator];
//            [UserAuthentication SaveCurrentAccount:self.temAccount];
////            [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
//            ApplyAccountThreeVC * threeVC = [[ApplyAccountThreeVC alloc] init];
//            [self.navigationController pushViewController:threeVC animated:YES];
//            
//        }
//        
//    } fail:^(NSError *error) {
//        [self dismissLoadingIndicator];
//        NSLog(@"保存失败%@",error);
//    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
