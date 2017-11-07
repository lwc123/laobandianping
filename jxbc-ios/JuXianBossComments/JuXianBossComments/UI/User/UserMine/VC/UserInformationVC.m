//
//  UserInformationVC.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/21.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "UserInformationVC.h"
#import "TextfieldCell.h"
#import "XJHMineView.h"
#import "NSString+RegexCategory.h"

@interface UserInformationVC ()<JXFooterViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>{

    NSString * _imageStr;

}
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic,strong) XJHMineView * mineView;
@property (nonatomic,strong)AnonymousAccount * account;


@end

@implementation UserInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    [self isShowLeftButton:YES];
    _account = [UserAuthentication GetCurrentAccount];

    [self initUI];
    
}

- (void)initUI{

    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.jxTableView.tableHeaderView = self.mineView;
    
    self.mineView.nameLabel.text =_account.UserProfile.RealName;
    [self.mineView.iconImageVIew sd_setImageWithURL:[NSURL URLWithString:_account.UserProfile.Avatar] placeholderImage:UserImage];
    [self.jxTableView registerNib:[UINib nibWithNibName:@"TextfieldCell" bundle:nil] forCellReuseIdentifier:@"textfieldCell"];
    
    JXFooterView * footerView = [JXFooterView footerView];
    footerView.nextLabel.text = @"保存";
    footerView.delegate = self;
    self.jxTableView.tableFooterView = footerView;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TextfieldCell * textCell = [tableView dequeueReusableCellWithIdentifier:@"textfieldCell" forIndexPath:indexPath];
    
    textCell.selectionStyle = UITableViewCellSelectionStyleNone;
    textCell.jhtextfield.userInteractionEnabled = NO;
    textCell.jhLabel.text = self.dataArray[indexPath.row];
    textCell.jhtextfield.tag = indexPath.row + 20;
    if (indexPath.row == 0) {
       textCell.jhtextfield.placeholder = @"您的昵称";
        textCell.jhtextfield.userInteractionEnabled = YES;
        textCell.jhtextfield.text = _account.UserProfile.RealName;

    }else if(indexPath.row == 1){
        textCell.jhtextfield.text = _account.UserProfile.Email;
        textCell.jhtextfield.placeholder = @"请输入您的邮箱";
        textCell.jhtextfield.userInteractionEnabled = YES;

    }else{
    
        textCell.jhtextfield.text = _account.UserProfile.MobilePhone;
        textCell.jhtextfield.userInteractionEnabled = NO;
    }
    
    
        return textCell;
}

#pragma mark -- 保存
- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{

    UITextField * realNameTf = [self.view viewWithTag:20];
    UITextField * emailTf = [self.view viewWithTag:21];

    if (realNameTf.text.length == 0) {
        [PublicUseMethod showAlertView:@"请输入昵称"];
        
        return;
    }
    if (realNameTf.text.length > 5) {
        [PublicUseMethod showAlertView:@"昵称不能超过5个字"];
        return;
    }
    if (![emailTf.text isEmailAddress]) {
        [self alertString:@"请输入正确的邮箱地址" duration:1];
        return;
    }

    if ([emailTf.text  isContainsEmoji]) {
        [self alertString:@"邮箱地址不能含有表情" duration:1];
        return;
    }
    
    _account.UserProfile.RealName = realNameTf.text;
    _account.UserProfile.Email = emailTf.text;
    
    [self showLoadingIndicator];
    MJWeakSelf
    [MineDataRequest UserChangeProfileWith:_account.UserProfile success:^(id result) {
        [weakSelf dismissLoadingIndicator];
        
        if (result) {
            [UserAuthentication SaveCurrentAccount:weakSelf.account];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
    
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
    UIImage *comImage = [PublicUseMethod thumbnailWithImageWithoutScale:UserSelectImage size:self.mineView.iconImageVIew.bounds.size];
    NSData *data = UIImageJPEGRepresentation(comImage, 1);
    NSString *photoString = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    _imageStr = photoString;

    
    MJWeakSelf
    [self showLoadingIndicator];
    [MineDataRequest ChangeAvatarWithAvatarStream:_imageStr withFileName:@"真的不用管" success:^(id result) {
        [weakSelf dismissLoadingIndicator];
        weakSelf.mineView.iconImageVIew.image = comImage;
        weakSelf.account.UserProfile.Avatar = [NSString stringWithFormat:@"%@",result];
        [UserAuthentication SaveCurrentAccount:self.account];
        
    } fail:^(NSError *error) {
        [PublicUseMethod showAlertView:[NSString stringWithFormat:@"头像上传：%@",error.localizedDescription]];
        [weakSelf dismissLoadingIndicator];
    }];

    [self dismissViewControllerAnimated:YES completion:^{
    }];

}

- (NSArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = @[@"昵称",@"邮箱",@"手机"];
    }
    return _dataArray;
}


- (XJHMineView *)mineView{

    if (_mineView == nil) {
        
        _mineView = [XJHMineView jhMineView];
        _mineView.height = 154;
        _mineView.iconImageVIew.layer.masksToBounds = YES;
        _mineView.iconImageVIew.layer.cornerRadius = 65 * 0.5;
        _mineView.iconImageVIew.layer.borderWidth = 2;
        _mineView.iconImageVIew.layer.borderColor = [PublicUseMethod setColor:KColor_GoldColor].CGColor;
        _mineView.comerIma.hidden = NO;
        _mineView.iconImageVIew.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_mineView.iconImageVIew addGestureRecognizer:tap];
    }
    return _mineView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
