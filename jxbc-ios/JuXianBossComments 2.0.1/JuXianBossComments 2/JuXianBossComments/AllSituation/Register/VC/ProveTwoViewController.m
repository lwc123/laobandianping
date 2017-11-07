

//
//  ProveTwoViewController.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/18.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "ProveTwoViewController.h"
#import "ApplyAccountFourVC.h"
#import "AccountRepository.h"
#import "IWComposePhotosView.h"
#import "FTImagePickerController.h"

@interface ProveTwoViewController ()<UITextFieldDelegate,UINavigationControllerDelegate,FTImagePickerControllerDelegate,IWComposePhotoViewDelegate>{
    
    dispatch_source_t _timer;
}

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UILabel *photoLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIImageView *idImageView;
@property (nonatomic,strong)UIButton *photoBt;
@property (nonatomic,strong)NSMutableArray *photoArray;
@property (weak, nonatomic) IBOutlet ColorButton *sendBtn;
@property (weak, nonatomic) IBOutlet ColorButton *tiJiaoBtn;
@property (nonatomic, strong) IWComposePhotosView *photosView;


@end

@implementation ProveTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"企业认证";
    [self isShowLeftButton:YES];
    [self initUI];
    //监听文本框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeText) name:UITextFieldTextDidChangeNotification object:self.phoneNumTF];
}

- (NSMutableArray *)photoArray{
    
    if (!_photoArray) {
        _photoArray = [[NSMutableArray alloc] init];
    }
    return _photoArray;
}

- (UIButton *)photoBt{
    if (!_photoBt) {
        _photoBt = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoBt.frame = CGRectMake((_photosView.photos.count * 30), 30, 30, 30);
        _photoBt.enabled = YES;
        [_photoBt setImage:[UIImage imageNamed:@"jhaad"] forState:UIControlStateNormal];
        NSLog(@"%lu",_photosView.photos.count);
        _photoBt.tag = 300;
        [_photoBt addTarget:self action:@selector(composePicAdd) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _photoBt;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.photosView addSubview:self.photoBt];
    if (_photosView.photos.count == 3) {
        [self.photoBt removeFromSuperview];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.photoBt removeFromSuperview];
}

- (void)initUI{
    JXBecomeHunterView * headerView = [JXBecomeHunterView becomeHunterView];
    headerView.frame = CGRectMake(0, 20, SCREEN_WIDTH, 72);
    [self.view addSubview:headerView];
    
    self.idImageView.hidden = YES;
    IWComposePhotosView *photosView = [[IWComposePhotosView alloc] init];
    self.photosView = photosView;
    
    //设置位置
    photosView.y = CGRectGetMaxY(_photoLabel.frame) + 15;
    photosView.x = 35;
    photosView.size = CGSizeMake(SCREEN_WIDTH - 45*2, 72);
    [self.view addSubview:photosView];
    
    _phoneNumTF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNumTF.delegate = self;
    _nameTF.delegate = self;
    self.phoneNumTF.keyboardType = UIKeyboardTypeNumberPad;
    
    if (_fixAudit) {
        _nameTF.text = _fixAudit.Company.LegalName;
        _phoneNumTF.text = _fixAudit.MobilePhone;
        
        for (NSString *imageStr in _fixAudit.Images) {
            
            [self.photosView addPhoto:nil imageUrl:imageStr];
            self.photosView.imageView.delegate = self;
            [self.photoArray addObject:imageStr];
        }
        
    }
    
}


#pragma mark -- TextField  delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneNumTF)
    {
        if ([textField.text length] > 11)
        {
            textField.text = [textField.text substringToIndex:11];
            [PublicUseMethod showAlertView:@"请输入11位正确的手机号码"];
            return NO;
        }
    }
    
    return YES;
}
- (void)changeText{
    
    if (self.phoneNumTF.text.length > 11)
    {
        self.phoneNumTF.text = [self.phoneNumTF.text substringToIndex:11];
        [PublicUseMethod showAlertView:@"请输入11位正确的手机号码"];
        return;
    }
}


- (void)composePicAdd{
    if (self.photosView.photos.count >= 3) {
        [PublicUseMethod showAlertView:@"最多只能选择2张照片"];
        return;
    }
    FTImagePickerController *imagePicker = [[FTImagePickerController alloc]init];
    imagePicker.allowsEditing = NO;
    imagePicker.allowsMultipleSelection = YES;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)deleteImage{
    
    //SC.XJH.1.3
    NSMutableArray *arrayTemp = [NSMutableArray array];
    for (UIImage *image in _photosView.photos) {
        if (![image isKindOfClass:[NSNull class]]) {
            NSData *data = UIImageJPEGRepresentation(image, 1.0);
            NSString *imageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [arrayTemp addObject:imageStr];
        }
    }
    _photoArray = arrayTemp.mutableCopy;
    
    if (_photosView.photos.count == 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.photosView addSubview:self.photoBt];
        });
    }else{
        [self.photosView addSubview:self.photoBt];
    }
    
    if (_photosView.photos.count == 3) {
        [self.photoBt removeFromSuperview];
    }
    //    [self.photosView addSubview:self.photoBt];
}
#pragma mark - FTImagePickerControllerDelegate

- (void)assetsPickerController:(FTImagePickerController *)picker didFinishPickingImages:(NSArray<UIImage *> *)images{
    [self.photoBt removeFromSuperview];
    
    if ((images.count + self.photosView.photos.count) >2) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"只能选择2张图片" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    for (UIImage* photo in images) {
        UIImage *UserSelectImage = [PublicUseMethod fixOrientationForImage:photo];
        //等比压缩
        UIImage *comImage = [PublicUseMethod thumbnailWithImageWithoutScale:UserSelectImage size:_photoBt.size];
        
        //    NSData *data = UIImageJPEGRepresentation(image, 1);
        NSData *data = UIImageJPEGRepresentation(comImage, 1);
        
        NSString *photoString = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [self.photosView addPhoto:UserSelectImage];
        self.photosView.imageView.delegate = self;
        [self.photoArray addObject:photoString];
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)assetsPickerControllerDidCancel:(FTImagePickerController *)picker{
    NSLog(@"用户点取消啦");
    [self.photoBt  removeFromSuperview];
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
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aimg;
}

#pragma mark -- 获取验证码
- (IBAction)getCodeBtnClick:(UIButton *)sender {
    
    if (sender.selected) {
        
        sender.selected = NO;
    }else{
        
        //判断手机号是否注册  写要执行的语句
        if ([PublicUseMethod textField:self.phoneNumTF length:11]==NO)
        {
            [SVProgressHUD showInfoWithStatus:@"手机号为11位数字"];
            return;
        }
        
        if ([PublicUseMethod isMobileNumber:self.phoneNumTF.text]==NO)
        {
            return;
        }
        
        [self sendEnsureCode];
        [SVProgressHUD dismiss];
    }
}

-(void)isExistsFail:(NSError *)error
{
    NSLog(@"验证码不存在,原因是:%@",error.localizedDescription);
}

- (void)sendEnsureCode
{
    [AccountRepository signUpSendGetCode:self.phoneNumTF.text success:^(id result) {
        if (result) {
            //停止计时
            [SVProgressHUD showInfoWithStatus:@"发送成功"];
        }
    } fail:^(NSError *error) {
        if (error.code == -1001) { // 请求超时
            [PublicUseMethod showAlertView:@"网络链接超时,请稍后再试"];
            
        }else if (error.code == -1009) {// 没有网络
            
            [PublicUseMethod showAlertView:@"网络好像断开了,请检查网络设置"];
            
        }else{// 其他
            [PublicUseMethod showAlertView:[NSString stringWithFormat:@"%@",error.localizedDescription]];
        }

    }];
    //把按钮改变倒计时
    [self startTime];
    
}

#pragma 按钮只点击一次方法
-(void)startTime
{
    __block int timeout=120; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            [self endTimer];
        }else{
            //int minutes = timeout / 60;
            int seconds = timeout %121;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [self.sendBtn setTitle:[NSString stringWithFormat:@"获取%@s",strTime] forState:UIControlStateNormal];
                
                self.sendBtn.userInteractionEnabled = NO;
                self.sendBtn.backgroundColor = [PublicUseMethod setColor:KColor_CodeColor];
                [self.sendBtn setBackgroundImage:nil forState:UIControlStateNormal];
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)endTimer
{
    dispatch_source_cancel(_timer);
    dispatch_async(dispatch_get_main_queue(), ^{
        //设置界面的按钮显示 根据自己需求设置
        [self.sendBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        self.sendBtn.userInteractionEnabled = YES;
        [self.sendBtn setBackgroundColor:[PublicUseMethod setColor:KColor_SubColor]];
        [self.sendBtn setBackgroundImage:[UIImage imageNamed:@"codebutton"] forState:UIControlStateNormal];
    });
}

- (IBAction)nextClick:(UIButton *)sender {
    
    if (sender.selected) {
        sender.selected = NO;
    }else{
        
        if (self.nameTF.text.length == 0) {
            [PublicUseMethod showAlertView:@"请输入法人姓名"];
            return;
        }
        
        if (self.nameTF.text.length > 5) {
            [PublicUseMethod showAlertView:@"法人姓名超过5个字"];
            return;
        }
        if (self.phoneNumTF.text.length == 0) {
            [PublicUseMethod showAlertView:@"请输入手机号码"];
            return;
        }
        if ([PublicUseMethod textField:self.phoneNumTF length:11]==NO)
        {
            [SVProgressHUD showInfoWithStatus:@"手机号为11位数字"];
            return;
        }
        
        if ([PublicUseMethod isMobileNumber:self.phoneNumTF.text]==NO)
        {
            return;
        }
        if (self.codeTF.text.length == 0) {
            [PublicUseMethod showAlertView:@"验证码不能为空"];
            return;
        }
        
        if (self.photoArray.count!=2) {
            
            [PublicUseMethod showAlertView:@"请上传法人身份证照片"];
            return;
        }
        
        
        self.companyAuditEntity = [[CompanyAuditEntity alloc] init];
        self.companyAuditEntity.Licence = self.imageStr;
        self.informationEntity.LegalName = self.nameTF.text;
        self.companyAuditEntity.MobilePhone = self.phoneNumTF.text;
        self.companyAuditEntity.ValidationCode = self.codeTF.text;
        self.companyAuditEntity.Images = self.photoArray;
        self.companyAuditEntity.Company = self.informationEntity;
        self.companyAuditEntity.CompanyId = self.companyId;
        NSString * st = [self.companyAuditEntity toJSONString];
        NSLog(@"===st%@",st);
        [self showLoadingIndicator];
        [MineDataRequest companyAuditWith:self.companyAuditEntity success:^(ResultEntity *resultEntity) {
            [self dismissLoadingIndicator];
            if (resultEntity.Success) {
                [PublicUseMethod showAlertView:@"提交成功"];
                
                ApplyAccountFourVC * fourVC = [[ApplyAccountFourVC alloc] init];
                [PublicUseMethod changeRootNavController:fourVC];
            }else{
                [PublicUseMethod showAlertView:resultEntity.ErrorMessage];
            }
            
        } fail:^(NSError *error) {
            [self dismissLoadingIndicator];
            NSLog(@"error%@",error);
            [PublicUseMethod showAlertView:error.localizedDescription];
        }];
    }
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
