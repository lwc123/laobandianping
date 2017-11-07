//
//  ProveOneViewController.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/18.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "ProveOneViewController.h"
#import "ProveTwoViewController.h"
#import "DegreeView.h"
#import "ChoiceIndustryViewController.h"
#import "SearchCitiVC.h"
#import "SearchViewController.h"
#import "CompanyInformationEntity.h"
#import "CompanyAuditEntity.h"
#import "ContactUsViewController.h"
//SC.XJH.12.13
//#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>

//城市的model
#import "CityModel.h"


@interface ProveOneViewController ()<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    
    CGRect _temRect;
    UIButton * _delegateBtn;
    NSString * _imageStr;
}
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;

@property (weak, nonatomic) IBOutlet UIView *threeView;
@property (weak, nonatomic) IBOutlet UIView *fourView;
@property (weak, nonatomic) IBOutlet UIView *fiveView;
@property (weak, nonatomic) IBOutlet UIImageView *idImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

/**行业*/
@property (weak, nonatomic) IBOutlet UITextField *industryTF;
/**规模*/
@property (weak, nonatomic) IBOutlet UITextField *scaleTF;
@property (nonatomic,copy)NSString *industryCode;
@property (nonatomic,copy)NSString *jobCode;

@property (weak, nonatomic) IBOutlet UIImageView *zhiZhaoPhotoImageV;
@property (nonatomic,strong)UIButton *photoBt;
@property (nonatomic,strong)NSMutableArray *photoArray;
@property (nonatomic,strong)UIImageView * tempImageView;

/**企业名称*/
@property (weak, nonatomic) IBOutlet UITextField *companyTf;
/**简称*/
@property (weak, nonatomic) IBOutlet UITextField *shortTf;
@property (weak, nonatomic) IBOutlet ColorButton *nextBtn;
@property (nonatomic,strong)CompanyAuditEntity * companyEntity;
@property (nonatomic,strong)NSMutableArray * sizeArray;
@property (nonatomic,strong) UILabel * bgLabel;
@property (nonatomic, strong)  JXBecomeHunterView * headerView;


//规模字典数组


@end

@implementation ProveOneViewController


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.myScrollView endEditing:YES];
}

- (NSMutableArray *)photoArray{
    
    if (!_photoArray) {
        _photoArray = [[NSMutableArray alloc] init];
    }
    return _photoArray;
}

- (NSMutableArray *)sizeArray{
    if (!_sizeArray) {
        _sizeArray = [NSMutableArray array];
    }
    return _sizeArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"企业认证";
    [self isShowLeftButton:NO];
    [self initData];
    NSString * companyIdStr = [[NSUserDefaults standardUserDefaults] valueForKey:CompanyChoiceKey];
    self.companyId = [companyIdStr longLongValue];
    if (_companyModel.AuditStatus == 9) {
        //修改企业认证
        [self initInformationRequest];
        [_myScrollView addSubview:_bgLabel];
    }
    [self initCompanySizeDic];
    [self initUI];
}

- (void)initData{
    
    _companyEntity = [[CompanyAuditEntity alloc] init];
    
}
#pragma mark -- 修改企业
- (void)initInformationRequest{
    //getCompanyMyAuditInfoWithCompanyId
    [self showLoadingIndicator];
    MJWeakSelf
    [MineDataRequest getCompanyMyAuditInfoWithCompanyId:self.companyId success:^(CompanyAuditEntity *auditEntity) {
        [weakSelf dismissLoadingIndicator];
        _companyEntity = auditEntity;
        _companyTf.text = auditEntity.Company.CompanyName;
        _shortTf.text = auditEntity.Company.CompanyAbbr;
        _industryTF.text = auditEntity.Company.Industry;
        _scaleTF.text = auditEntity.Company.CompanySizeText;
        _cityTF.text = auditEntity.Company.RegionText;
        _cityCodeStr = auditEntity.Company.Region;
        _sizeCodeStr = auditEntity.Company.CompanySize;
        [_zhiZhaoPhotoImageV sd_setImageWithURL:[NSURL URLWithString:auditEntity.Licence] placeholderImage:LOADing_Image];
        _delegateBtn.hidden = NO;
        _imageStr= auditEntity.Licence;
        _bgLabel.hidden = NO;
        _bgLabel.text = [NSString stringWithFormat:@"审核未通过原因:%@",auditEntity.RejectReason];
        _headerView.frame = CGRectMake(0, CGRectGetMaxY(_bgLabel.frame) + 10, SCREEN_WIDTH, 50);

    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        if (error.code == -1001) { // 请求超时
            [PublicUseMethod showAlertView:@"网络链接超时,请稍后再试"];
            
        }else if (error.code == -1009) {// 没有网络
            
            [PublicUseMethod showAlertView:@"网络好像断开了,请检查网络设置"];
            
        }else{// 其他
            [PublicUseMethod showAlertView:[NSString stringWithFormat:@"%@",error.localizedDescription]];
        }
        
    }];
    
}

#pragma mark -- 规模字典
- (void)initCompanySizeDic{
    
    [WebAPIClient getJSONWithUrl:API_Dictionary_Size parameters:nil success:^(id result) {
        
        JSONModelArray *modelArray = [[JSONModelArray alloc]initWithArray:result[@"CompanySize"] modelClass:[AcademicModel class]];
        _sizeArray = modelArray.mutableCopy;
        
    } fail:^(NSError *error) {

    }];
    
}

- (void)initUI{
    
    self.nextBtn.layer.cornerRadius = 4;
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.layer.borderWidth = 2;
    self.nextBtn.layer.borderColor = [PublicUseMethod setColor:KColor_GoldColor].CGColor;
    
    self.copanyName = [[NSUserDefaults standardUserDefaults] valueForKey:CompanyNameKey];
    
    self.companyTf.text = self.copanyName;
    _myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + 100);
    self.myScrollView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMyKeybod:)];
    [self.myScrollView addGestureRecognizer:tap];
    
    _bgLabel= [[UILabel alloc] initWithFrame:CGRectMake(45, 0, SCREEN_WIDTH - 90, 20)];
    _bgLabel.textColor = [PublicUseMethod setColor:@"F29434"];
    _bgLabel.font = [UIFont systemFontOfSize:13.0];
    _bgLabel.backgroundColor = [PublicUseMethod setColor:@"F9E6D8"];
    _bgLabel.textAlignment = NSTextAlignmentCenter;
    _bgLabel.hidden = YES;
    [_myScrollView addSubview:_bgLabel];
    
    _headerView = [JXBecomeHunterView becomeHunterView];    
    if (_bgLabel.hidden) {
        _headerView.frame = CGRectMake(0, 10, SCREEN_WIDTH, 50);
    }
    [_myScrollView addSubview:_headerView];
    

    
    self.oneView.y = CGRectGetMaxY(_headerView.frame) +30;
    
    _tempImageView = [[UIImageView alloc] init];
    
    _photoBt = [[UIButton alloc] initWithFrame:_zhiZhaoPhotoImageV.frame];
    [_photoBt addTarget:self action:@selector(addPhoto:) forControlEvents:UIControlEventTouchUpInside];
    _photoBt.backgroundColor = [UIColor clearColor];
    [_myScrollView addSubview:_photoBt];
    _delegateBtn = [UIButton buttonWithFrame:CGRectMake((_zhiZhaoPhotoImageV.frame.size.width - 14) + _zhiZhaoPhotoImageV.frame.origin.x + 10, _zhiZhaoPhotoImageV.frame.origin.y - 10, 14, 14) title:nil fontSize:0 titleColor:nil imageName:@"delete" bgImageName:nil];
    [_delegateBtn addTarget:self action:@selector(deldegateClick:) forControlEvents:UIControlEventTouchUpInside];
    _delegateBtn.hidden = YES;
    [self.myScrollView addSubview:_delegateBtn];
    _temRect = _zhiZhaoPhotoImageV.frame;
    _cityTF.delegate = self;
    _cityTF.enabled = NO;
    _industryTF.tag = 10;
    _scaleTF.tag = 300;
    
    if (self.model) {
        _cityTF.text = _model.Location;
        _industryTF.text = [NSString stringWithFormat:@"%@ %@",self.model.IndustryText,self.model.JobCategoryText];
    }
    
    // 返回按钮
    if (self.canPop) {
        [self isShowLeftButton:YES];
    }
    
}

- (IBAction)nexClick:(id)sender {
    if (self.companyTf.text.length == 0) {
        
        [PublicUseMethod showAlertView:@"请输入公司名称"];
        return;
    }
    if (self.companyTf.text.length > 30) {
        [PublicUseMethod showAlertView:@"企业名称超过30个字"];
        return;
    }
    if (self.shortTf.text.length == 0) {
        
        [PublicUseMethod showAlertView:@"请输入公司简称"];
        return;
    }
    if (self.shortTf.text.length > 10) {
        [PublicUseMethod showAlertView:@"企业简称超过10个字"];
        return;
    }
    if (self.industryTF.text.length == 0) {
        [PublicUseMethod showAlertView:@"请选择公司行业"];
        return;
    }
    if (self.scaleTF.text.length == 0) {
        [PublicUseMethod showAlertView:@"请选择公司人员规模"];
        return;
    }
    if (self.cityTF.text.length == 0) {
        [PublicUseMethod showAlertView:@"请选择公司所在城市"];
        return;
    }
    if (_imageStr == 0) {
        [PublicUseMethod showAlertView:@"请上传营业执照图片"];
        return;
    }
    
    
    NSString * companyAuditId = [NSString stringWithFormat:@"%ld",self.companyId];
    [[NSUserDefaults standardUserDefaults]setObject:companyAuditId forKey:CompanyChoiceKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    if (![self.companyTf.text isEqualToString:self.copanyName]) {
        [self alertWithTitle:nil message:@"您输入的企业名称与支付时填写的不一致,请确认是否提交" cancelTitle:@"重新修改" okTitle:@"确认" with:nil];
        
    }else{
        [self exetCompay];
    }
    
}


#pragma mark -- 封装elert
- (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle okTitle:(NSString *)okTitle with:(CompanyInformationEntity *)companyInformation{
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    //确定
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self jhexetCompay];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)jhexetCompay{
    [self showLoadingIndicator];
    MJWeakSelf
    [MineDataRequest getExistsCompanyWith:self.companyTf.text success:^(id result) {
        [self dismissLoadingIndicator];
        if ([result integerValue] > 0) {
            [weakSelf alertWithXJhTitle:nil message:@"您输入的公司已开通服务！请联系该公司管理员" cancelTitle:@"确定" okTitle:nil with:nil];
        }else{
            [weakSelf exetCompay];
        }
        
    } fail:^(NSError *error) {
        
        [self dismissLoadingIndicator];
        NSLog(@"error%@",error);
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
    
}


- (void)alertWithXJhTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle okTitle:(NSString *)okTitle with:(CompanyInformationEntity *)companyInformation{
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)exetCompay{
    
    ProveTwoViewController * twoVC = [[ProveTwoViewController alloc] init];
    //营业执照
    twoVC.imageStr = _imageStr;
    CompanyInformationEntity * companyEntity = [[CompanyInformationEntity alloc] init];
    companyEntity.CompanyName = self.companyTf.text;
    companyEntity.CompanyAbbr = self.shortTf.text;
    companyEntity.Industry = self.industryTF.text;
    companyEntity.CompanySize = self.sizeCodeStr;
    companyEntity.Region = self.cityCodeStr;
    companyEntity.CompanyId = self.companyId;
    twoVC.informationEntity = companyEntity;
    twoVC.companyId = self.companyId;
    twoVC.fixAudit = _companyEntity;
    [self.navigationController pushViewController:twoVC animated:YES];
}

#pragma mark -- 选择城市
- (IBAction)cityBtnClick:(id)sender {
    //    SearchCitiVC *signVC = [[SearchCitiVC alloc]init];
    //    signVC.sencondVC = self;
    //    signVC.block = ^(NSString * informationStr,NSString * cityCode){
    //        if (informationStr) {
    //            _cityTF.text = informationStr;
    //            _cityCodeStr = cityCode;
    //        }
    //    };
    //
    //    [self.navigationController pushViewController:signVC animated:YES];
    
    // 1.3.2 Jam
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    searchVC.block = ^(CityModel* model){
        _cityTF.text = model.Name;
        _cityCodeStr = model.Code;
        
    };
    
    [self.navigationController pushViewController:searchVC animated:YES];
    
}

#pragma mark -- 选择规模
- (IBAction)scaleBtnClick:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    [self.myScrollView endEditing:YES];//SC.XJH.1.9
    DegreeView *degreeView = [[DegreeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    degreeView.title = @"企业规模";
    NSMutableArray * nameArray = [NSMutableArray array];
    NSMutableArray * codeArray = [NSMutableArray array];
    for (AcademicModel *academicModel in _sizeArray) {
        [nameArray addObject:academicModel.Name];
        [codeArray addObject:academicModel.Code];
    }
    degreeView.cellData = nameArray.mutableCopy;
    degreeView.block = ^(NSString *string,NSInteger index){
        
        UILabel *label = (UILabel *)[weakSelf.view viewWithTag:300];
        label.text = string;
        label.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
        _sizeCodeStr = codeArray[index];
    };
    [degreeView loadDegreeView];
    if (_sizeCodeStr.length > 0) {
        NSInteger row = [codeArray indexOfObject:_sizeCodeStr];
        [degreeView.picker selectRow:row inComponent:0 animated:NO];
    }
    [self.view addSubview:degreeView];
}

#pragma mark -- 选择行业
- (IBAction)industryBtnClick:(id)sender {
    
    ChoiceIndustryViewController *signVC = [[ChoiceIndustryViewController alloc]init];
    signVC.block = ^(NSString * informationStr,NSString * cityCode){
        _industryTF.text = informationStr;
    };
    [self.navigationController pushViewController:signVC animated:YES];
    
}

- (void)addPhoto:(UIButton *)btn{
    
    if (_photoArray.count == 0) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.allowsEditing = NO;
        imagePicker.delegate = self;
        [PublicUseMethod pickerImageChannelWithImageController:imagePicker andViewController:self];
    }else{
        
        static BOOL isRollBack = NO;
        [UIView animateWithDuration:.5 animations:^{
            if (isRollBack == NO) {
                ///不需要滚回阿里
                
                // 头像慢慢变大,慢慢移动到屏幕的中间
                CGFloat iconW = self.view.frame.size.width;
                CGFloat iconH = iconW;
                CGFloat iconY = (self.view.frame.size.height - iconH) * 0.5;
                _zhiZhaoPhotoImageV.frame = CGRectMake(0, iconY, iconW, iconH);
                _photoBt.frame = _zhiZhaoPhotoImageV.frame;
                _tempImageView.frame= _zhiZhaoPhotoImageV.frame;
                _delegateBtn.hidden = YES;
                
            }else{
                //需要滚回来
                _zhiZhaoPhotoImageV.frame = _temRect;
                _photoBt.frame = _zhiZhaoPhotoImageV.frame;
                _tempImageView.frame = _zhiZhaoPhotoImageV.frame;
                
            }
            
        } completion:^(BOOL finished) {
            if (isRollBack == YES) {
                _delegateBtn.hidden = NO;
            }
            isRollBack ^= 1;//是否需要回滚 状态切换
        }];
        
    }
    
}


#pragma mark - imagepickerCtrl delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    
    UIImage *originalImage = [editingInfo objectForKey: @"UIImagePickerControllerOriginalImage"];
    
    UIImage *UserSelectImage = [PublicUseMethod fixOrientationForImage:originalImage];
    //等比压缩
    UIImage *comImage = [PublicUseMethod thumbnailWithImageWithoutScale:UserSelectImage size:_photoBt.bounds.size];
    //SC
    NSData *data = UIImageJPEGRepresentation(UserSelectImage, 1);
    //压缩图片
        while ((data.length/1000)>500) {
            UIImage *imageTemp = [UIImage imageWithData:data];
            data = UIImageJPEGRepresentation(imageTemp, 0.8);
        }
    
    NSString *photoString = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    _imageStr = photoString;
    [self.photoArray addObject:photoString];
    
    
    _tempImageView.frame = _photoBt.frame;
    _tempImageView.contentMode = UIViewContentModeScaleAspectFit;
    //    imageView.image = [self watermarkImage:comImage withName:@"仅供认证参考"];
    _zhiZhaoPhotoImageV.image = comImage;
    //SC
    //    _tempImageView.image = [UIImage imageWithData:data];
    
    //    [self.myScrollView addSubview:_tempImageView];
    _delegateBtn.hidden = NO;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)deldegateClick:(UIButton *)btn{
    
    [UIView animateWithDuration:0.25 animations:^{
        //        self.alpha = 0;
    } completion:^(BOOL finished) {
        //在动画执行完成之后去移除
        //        [_tempImageView removeFromSuperview];
        _zhiZhaoPhotoImageV.image = [UIImage imageNamed:@"jhaad"];
        [_photoBt setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_photoArray removeAllObjects];
        _delegateBtn.hidden = YES;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (_shortTf == textField) {
        [_shortTf canResignFirstResponder];
    }
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason{
    
    [textField resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.myScrollView endEditing:YES];
}

- (void)dismissMyKeybod:(UITapGestureRecognizer *)tap{
    
    [self.myScrollView endEditing:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)contactUsButtonClick:(UIButton*)sender{
    
    ContactUsViewController* contactVc = [[ContactUsViewController alloc]init];
    [self.navigationController pushViewController:contactVc animated:YES];
    
}



@end
