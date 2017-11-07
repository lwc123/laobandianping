//
//  JXAccountInformationVC.m
//  JuXianBossComments
//
//  Created by juxian on 2017/2/6.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JXAccountInformationVC.h"
#import "ChoiceCompanyCell.h"
#import "JHPutVC.h"
#import "JXMineModel.h"
#import "XJHMineView.h"
#import "TextfieldCell.h"
@interface JXAccountInformationVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>{

    NSString * _imageStr;
}
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) NSString *roleStr;
@property (nonatomic, copy) NSString *nameStr;
@property (nonatomic,strong) XJHMineView * mineView;
@property (nonatomic,strong)UIImageView * tempImageView;
@property (nonatomic,strong)NSMutableArray *photoArray;
@property (nonatomic,strong)AnonymousAccount * temAccount;



@end

@implementation JXAccountInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    [self isShowLeftButton:YES];
    [self initUI];
}

- (NSArray *)dataArray{

    if (_dataArray == nil) {
        JXMineModel * mindeModel1 = [[JXMineModel alloc] init];
        mindeModel1.cellMessage =@[@"公司",@"职位",@"角色"];
        JXMineModel * mindeModel3 = [[JXMineModel alloc] init];
        mindeModel3.cellMessage =@[@"电话"];
        _dataArray = @[mindeModel1,mindeModel3];
    }
    return _dataArray;
}

- (void)initUI{
    _temAccount = [UserAuthentication GetCurrentAccount];

    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    
    _mineView = [XJHMineView jhMineView];
    _mineView.height = 154;
    _mineView.iconImageVIew.layer.masksToBounds = YES;
    _mineView.iconImageVIew.layer.cornerRadius = 65 * 0.5;
    _mineView.iconImageVIew.layer.borderWidth = 2;
    _mineView.iconImageVIew.layer.borderColor = [PublicUseMethod setColor:KColor_GoldColor].CGColor;
    _mineView.comerIma.hidden = NO;
    _mineView.delegate = self;
    _mineView.iconImageVIew.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_mineView.iconImageVIew addGestureRecognizer:tap];
    _mineView.nameLabel.text =_companySummary.MyInformation.RealName;
    [_mineView.iconImageVIew sd_setImageWithURL:[NSURL URLWithString:_temAccount.UserProfile.Avatar] placeholderImage:UserImage];
    
    self.jxTableView.tableHeaderView = _mineView;
    
    [self.jxTableView registerNib:[UINib nibWithNibName:@"ChoiceCompanyCell" bundle:nil] forCellReuseIdentifier:@"choiceCompanyCell"];
    [self.jxTableView registerNib:[UINib nibWithNibName:@"TextfieldCell" bundle:nil] forCellReuseIdentifier:@"textfieldCell"];
}

#pragma mark -- 拍照
- (void)tapAction{
    
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
    
    MJWeakSelf
    [self showLoadingIndicator];
        [MineDataRequest ChangeAvatarWithAvatarStream:_imageStr withFileName:@"真的不用管" success:^(id result) {
            [weakSelf dismissLoadingIndicator];
            _tempImageView.image = comImage;
            _mineView.iconImageVIew.image = comImage;
            weakSelf.temAccount.UserProfile.Avatar = [NSString stringWithFormat:@"%@",result];
            [UserAuthentication SaveCurrentAccount:self.temAccount];

        } fail:^(NSError *error) {
            [PublicUseMethod showAlertView:[NSString stringWithFormat:@"头像上传：%@",error.localizedDescription]];
            [weakSelf dismissLoadingIndicator];
            
        }];
        
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            
        }];
//    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    JXMineModel * model = self.dataArray[section];
    return model.cellMessage.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TextfieldCell * textCell = [tableView dequeueReusableCellWithIdentifier:@"textfieldCell" forIndexPath:indexPath];
    textCell.selectionStyle = UITableViewCellSelectionStyleNone;
    textCell.jhtextfield.userInteractionEnabled = NO;
    JXMineModel * mindeModel = self.dataArray[indexPath.section];
    textCell.jhLabel.text = mindeModel.cellMessage[indexPath.row];
    
    if (indexPath.section ==0) {
        if (indexPath.row == 0) {
            textCell.jhtextfield.text = _companySummary.CompanyAbbr;
        }else if (indexPath.row == 1){
            textCell.jhtextfield.text = _companySummary.MyInformation.JobTitle;
        }else{
            if (_companySummary.MyInformation.Role == Role_Boss) {
                _roleStr = @"老板";
            }else if (_companySummary.MyInformation.Role == Role_manager){
                
                _roleStr = @"管理员";
            }else if (_companySummary.MyInformation.Role == Role_BuildMembers){
                _roleStr = @"建档员";
            }else{
                _roleStr = @"高管";
            }
            textCell.jhtextfield.text = _roleStr;
        }
    }else{//第二组
        textCell.jhtextfield.text = _companySummary.MyInformation.MobilePhone;
    }
    return textCell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY < 0) {
        
        _mineView.bgImageView.frame = CGRectMake(offsetY/2, offsetY, ScreenWidth - offsetY, 154 - offsetY);
        
        _mineView.systemSetBt.transform = CGAffineTransformMakeTranslation(0,20);
    }else{
        
        [UIView animateWithDuration:.1 animations:^{
            _mineView.systemSetBt.transform = CGAffineTransformIdentity;
        }];
    }
}


- (void)fixBtnClick:(UIButton *)btn{
    
    JHPutVC * putVC = [[JHPutVC alloc] init];
    putVC.title = @"修改姓名";
    putVC.secondVC = self;
    putVC.textStr = @"请输入姓名";
    putVC.nameStr = _companySummary.MyInformation.RealName;
    
    putVC.block = ^(NSString *dataStr){
        _nameStr = dataStr;
        [self.jxTableView reloadData];
    };
    [self.navigationController pushViewController:putVC animated:YES];
}

- (NSMutableArray *)photoArray{
    
    if (!_photoArray) {
        _photoArray = [[NSMutableArray alloc] init];
    }
    return _photoArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
