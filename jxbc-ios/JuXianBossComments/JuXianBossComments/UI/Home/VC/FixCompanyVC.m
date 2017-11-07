//
//  FixCompanyVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/17.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "FixCompanyVC.h"
#import "XJHMineView.h"
#import "TextfieldCell.h"
#import "SearchViewController.h"
#import "DegreeView.h"
#import "ChoiceIndustryViewController.h"
@interface FixCompanyVC ()<XJHMineViewDelegate,JXFooterViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    
    NSString * _imageStr;
    
}
@property (nonatomic,strong)NSArray * textArray;
@property (nonatomic,strong)UITextField * shortTf;
@property (nonatomic,strong)UITextField * scaleTf;
@property (nonatomic,strong)UITextField * industryTf;
@property (nonatomic,strong)CompanyMembeEntity * myInformation;
@property (nonatomic,strong)CompanyMembeEntity * bossInformation;
@property (nonatomic,strong)NSMutableArray *photoArray;
@property (nonatomic,strong)UIImageView * tempImageView;
@property (nonatomic,strong) XJHMineView * mineView;
@property (nonatomic,copy)NSString *sizeCodeStr;//规模
@property (nonatomic,strong)NSMutableArray * sizeArray;//规模

@end

@implementation FixCompanyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公司信息";
    [self initData];
    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    [self isShowLeftButton:YES];
    [self initUI];
    [self initCompanySizeDic];
}

- (void)initData{
    
    _myInformation = [UserAuthentication GetMyInformation];
    _bossInformation = [UserAuthentication GetBossInformation];
}

- (NSMutableArray *)photoArray{
    
    if (!_photoArray) {
        _photoArray = [[NSMutableArray alloc] init];
    }
    return _photoArray;
}

- (NSMutableArray *)sizeArray{
    
    if (!_sizeArray) {
        _sizeArray = [[NSMutableArray alloc] init];
    }
    return _sizeArray;
}

#pragma mark -- 规模字典
- (void)initCompanySizeDic{
    
    [WebAPIClient getJSONWithUrl:API_Dictionary_Size parameters:nil success:^(id result) {
        
        JSONModelArray *modelArray = [[JSONModelArray alloc]initWithArray:result[@"CompanySize"] modelClass:[AcademicModel class]];
        self.sizeArray = modelArray.mutableCopy;
        
    } fail:^(NSError *error) {
    }];
    
}


- (void)initUI{
    _textArray = @[@"公司简称",@"公司所属行业",@"公司人员规模",@"公司所在城市",];
    
    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    _mineView = [XJHMineView jhMineView];
    _mineView.iconImageVIew.height = 80;
    _mineView.iconImageVIew.width = 80;
    _mineView.nameLabel.text = _companySummary.CompanyName;
    _mineView.positionLabel.text = [NSString stringWithFormat:@"%@(%@)公司法人",_bossInformation.RealName,_bossInformation.MobilePhone];
    _mineView.positionLabel.text = _bossInformation.myCompany.CompanyName;
    _mineView.myInfoBtn.hidden = NO;
    [_mineView.iconImageVIew sd_setImageWithURL:[NSURL URLWithString:_companySummary.CompanyLogo] placeholderImage:Company_LOGO_Image];
    _mineView.delegate = self;
    self.jxTableView.tableHeaderView = _mineView;
    JXFooterView * footerView = [JXFooterView footerView];
    footerView.delegate = self;
    footerView.nextLabel.text = @"保存";
    
    if (_myInformation.Role == Role_Boss || _myInformation.Role == Role_manager) {//只有老板和管理员可见
        self.jxTableView.tableFooterView = footerView;
    }else{
        self.jxTableView.tableFooterView = [[UIView alloc] init];
    }
    [self.jxTableView registerNib:[UINib nibWithNibName:@"TextfieldCell" bundle:nil] forCellReuseIdentifier:@"textfieldCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _textArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TextfieldCell * textCell = [tableView dequeueReusableCellWithIdentifier:@"textfieldCell" forIndexPath:indexPath];
    textCell.selectionStyle = UITableViewCellSelectionStyleNone;
    textCell.jhLabel.text = _textArray[indexPath.row];
    textCell.jhtextfield.delegate = self;
    textCell.jhtextfield.tag= 100 + indexPath.row;
    if (indexPath.row == 0) {//公司简称
        textCell.jhtextfield.enabled = YES;
        
        if (_companySummary) {
            textCell.jhtextfield.text = _companySummary.CompanyAbbr;
            _shortTf = textCell.jhtextfield;
        }
    }
    if (_companySummary) {
        if (indexPath.row == 1) {
            textCell.jhtextfield.text = _companySummary.Industry;
            _industryTf = textCell.jhtextfield;
            
        }else if (indexPath.row == 2){
            textCell.jhtextfield.text = _companySummary.CompanySizeText;
            _scaleTf = textCell.jhtextfield;
            _sizeCodeStr = _companySummary.CompanySize;
        }else if (indexPath.row == 3){
            textCell.jhtextfield.text = _companySummary.RegionText;
            _cityTf = textCell.jhtextfield;
            _cityCode = _companySummary.Region;
        }
    }
    return textCell;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField.tag == 100) {
        
        return YES;
    }else if (textField.tag == 101){//公司所属行业
        
        ChoiceIndustryViewController *signVC = [[ChoiceIndustryViewController alloc]init];
        signVC.block = ^(NSString * informationStr,NSString * cityCode){
            
            textField.text = informationStr;
            _industryTf =textField;
        };
        [self.navigationController pushViewController:signVC animated:YES];
        return NO;
    }else if (textField.tag == 102){//公司人员规模
        
        DegreeView *degreeView = [[DegreeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        degreeView.title = @"公司规模";
        NSMutableArray * nameArray = [NSMutableArray array];
        NSMutableArray * codeArray = [NSMutableArray array];
        for (AcademicModel *academicModel in self.sizeArray) {
            [nameArray addObject:academicModel.Name];
            [codeArray addObject:academicModel.Code];
        }
        degreeView.cellData = [nameArray copy];
        
        degreeView.block = ^(NSString *string,NSInteger index){
            textField.text = string;
            _scaleTf = textField;
            _sizeCodeStr = codeArray[index];
        };
        
        [degreeView loadDegreeView];
        if (_sizeCodeStr.length > 0) {
            NSInteger row = [codeArray indexOfObject:_sizeCodeStr];
            [degreeView.picker selectRow:row inComponent:0 animated:NO];
        }
        
        [self.view addSubview:degreeView];
        return NO;
    }else if(textField.tag == 103){//公司人员所在城市
        // 1.3.2 Jam
        SearchViewController *searchVC = [[SearchViewController alloc]init];
        
        searchVC.block = ^(CityModel* model){
            textField.text = model.Name;
            _cityTf = textField;
            _cityCode = model.Code;
        };
        
        [self.navigationController pushViewController:searchVC animated:YES];
        
        
        return NO;
    }
    
    return YES;
}


#pragma mark -- 保存
- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{
    
    
    //    if (_companySummary) {
    //        _shortTf.text = _companySummary.CompanyAbbr;
    //        _industryTf.text = _companySummary.Industry;
    //        _scaleTf.text = _companySummary.CompanySize;
    //        _cityTf.text = _companySummary.Region;
    //        _imageStr = _companySummary.CompanyLogo;
    //    }
    //
    //
    
    if (_shortTf.text.length == 0) {
        [PublicUseMethod showAlertView:@"公司简称不能为空"];
        return;
    }
    if (_shortTf.text.length > 10) {
        [PublicUseMethod showAlertView:@"公司简称超过了10个字"];
        return;
    }
    if (_industryTf.text.length == 0) {
        [PublicUseMethod showAlertView:@"公司行业不能为空"];
        return;
    }
    if (_scaleTf.text.length == 0) {
        [PublicUseMethod showAlertView:@"公司规模不能为空"];
        return;
    }
    if (_cityTf.text.length == 0) {
        [PublicUseMethod showAlertView:@"公司所在城市不能为空"];
        return;
    }
    self.companySummary.CompanyAbbr = _shortTf.text;
    self.companySummary.Industry = _industryTf.text;
    self.companySummary.CompanySize = _sizeCodeStr;
    self.companySummary.Region = _cityCode;
    self.companySummary.CompanyLogo = _imageStr;
    NSLog(@"toJSONString===%@",[self.companySummary toJSONString]);
    [self showLoadingIndicator];
    MJWeakSelf
    [MineRequest postCompanyUpdateWith:self.companySummary success:^(id result) {
        [weakSelf dismissLoadingIndicator];
        if (result > 0) {
            [PublicUseMethod showAlertView:@"保存成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
    }];
    
}


- (void)xjhMineViewDidClickUserInfoBtn:(XJHMineView *)jhMineView{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.allowsEditing = NO;
    imagePicker.delegate = self;
    [PublicUseMethod pickerImageChannelWithImageController:imagePicker andViewController:self];
}



#pragma mark - imagepickerCtrl delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    
    UIImage *originalImage = [editingInfo objectForKey: @"UIImagePickerControllerOriginalImage"];
    
    UIImage *UserSelectImage = [PublicUseMethod fixOrientationForImage:originalImage];
    //等比压缩
    UIImage *comImage = [PublicUseMethod thumbnailWithImageWithoutScale:UserSelectImage size:_mineView.iconImageVIew.bounds.size];
    NSData *data = UIImageJPEGRepresentation(comImage, 1);
    NSString *photoString = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    _imageStr = photoString;
    [self.photoArray addObject:photoString];
    
    _tempImageView = [[UIImageView alloc] init];
    _tempImageView.frame = _mineView.iconImageVIew.frame;
    _tempImageView.contentMode = UIViewContentModeScaleAspectFit;
    _tempImageView.image = comImage;
    _mineView.iconImageVIew.image = comImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY < 0) {
        
        _mineView.bgImageView.frame = CGRectMake(offsetY/2, offsetY, ScreenWidth - offsetY, 250 - offsetY);
        
        _mineView.systemSetBt.alpha = 0;
        _mineView.systemSetBt.transform = CGAffineTransformMakeTranslation(0,20);
    }else{
        
        [UIView animateWithDuration:.1 animations:^{
            _mineView.systemSetBt.alpha = 1;
            _mineView.systemSetBt.transform = CGAffineTransformIdentity;
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
