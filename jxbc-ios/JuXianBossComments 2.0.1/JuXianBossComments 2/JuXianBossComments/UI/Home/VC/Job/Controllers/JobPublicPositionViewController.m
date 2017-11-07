//
//  JobPublicPositionViewController.m
//  JuXianBossComments
//
//  Created by Jam on 17/1/12.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JobPublicPositionViewController.h"
#import "JobChangeCompanyInfoController.h"
#import "JobChangeJobNameController.h"
#import "JobEditSalaryController.h"
#import "SearchCitiVC.h"
#import "SearchViewController.h"
#import "JobEditAddressController.h"
#import "DegreeView.h"
#import "JobEditWorkDetailController.h"
#import "JobEditEmailController.h"
#import "JobEditPhoneNumberController.h"
#import "WorkBenchJobRequest.h"
#import "JobEntity.h"
#import "NSString+RegexCategory.h"

@interface JobPublicPositionViewController ()<JXFooterViewDelegate>

// 标题数组
@property (nonatomic, strong) NSArray *titleArray;
// 职位描述 对勾图片
@property (nonatomic, strong) UIImageView *jobDescriptionImageView;
// 是否有职位描述
@property (nonatomic, assign) BOOL isJobDescription;
// 是否是修改
@property (nonatomic, assign) bool isUpdate;

// 职位模型
@property (nonatomic, strong) JobEntity *jobEntity;

@end

@implementation JobPublicPositionViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self isShowLeftButton:YES];
    
    if (self.jobEntity.JobId) {
        self.isUpdate = YES;
    }else{
        self.isUpdate = NO;
    }
    [self initUI];
}

#pragma mark - init

- (instancetype)initWithJobEntity:(JobEntity *)jobEntity{
    
    self.jobEntity = jobEntity;
    return [self init];
}

- (void)initUI{
    self.title = self.isUpdate ? @"修改职位":@"发布职位";
    if (self.isUpdate) {
        [self isShowRightButton:YES with:@"确认修改"];
    }else{
        [self isShowRightButton:YES with:@"发布"];
    }
    self.jxTableView.tableFooterView = self.footerView;
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
}

#pragma mark - function
#pragma mark  发布
- (void)rightButtonAction:(UIButton* )sender{
    
    // 获取companyID
    self.jobEntity.CompanyId = [UserAuthentication GetBossInformation].CompanyId;
    
    //校验
    
    // 职位名称
    if (self.jobEntity.JobName.length == 0) {
        [self alertString:@"请填写职位名称" duration:1];
        return;
    }
    if ([self.jobEntity.JobName isContainsEmoji]) {
        [self alertString:@"职位名称不能含有表情" duration:1];
        return;
    }
    // 薪资范围
    if (!self.jobEntity.SalaryRangeMin || !self.jobEntity.SalaryRangeMax) {
        [self alertString:@"请填写薪资范围" duration:1];
        return;
    }
    // 经验要求
    if (self.jobEntity.ExperienceRequire.length == 0) {
        [self alertString:@"请填写经验要求" duration:1];
        return;
    }
    // 学历要求
    if (self.jobEntity.EducationRequire.length == 0) {
        [self alertString:@"请填写学历要求" duration:1];
        return;
    }
    // 工作城市
    if (self.jobEntity.JobCity.length == 0) {
        [self alertString:@"请填写工作城市" duration:1];
        return;
    }
    // 工作地点
    if (self.jobEntity.JobLocation.length == 0) {
        [self alertString:@"请填写工作地点" duration:1];
        return;
    }
    if ([self.jobEntity.JobLocation isContainsEmoji]) {
        [self alertString:@"工作地点不能含有表情" duration:1];
        return;
    }
    // 职位描述
    if (self.jobEntity.JobDescription.length == 0) {
        [self alertString:@"请填写职位描述" duration:1];
        return;
    }
    if ([self.jobEntity.JobDescription isContainsEmoji]) {
        [self alertString:@"职位描述不能含有表情" duration:1];
        return;
    }
    // 简历邮箱
    if (self.jobEntity.ContactEmail.length == 0) {
        [self alertString:@"请填写接收简历邮箱" duration:1];
        return;
    }
    if ([self.jobEntity.ContactEmail isContainsEmoji]) {
        [self alertString:@"邮箱地址不能含有表情" duration:1];
        return;
    }
    
    Log(@"%@",[self.jobEntity toDictionary]);
    
    [self showLoadingIndicator];
    
    if (self.isUpdate) {// 修改
        MJWeakSelf
        [WorkBenchJobRequest postJob_updateJobWith:self.jobEntity success:^(id result) {
            [weakSelf dismissLoadingIndicator];
            // 提示发布成功
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"修改成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
            }];
            [alert addAction:done];
            [self presentViewController:alert animated:YES completion:nil];
            
        } fail:^(NSError *error) {
            [weakSelf dismissLoadingIndicator];
            // 发布失败
            [weakSelf alertString:error.localizedDescription duration:1];
        }];
    }else{//发布
        MJWeakSelf
        [WorkBenchJobRequest postJob_publicJobWith:self.jobEntity success:^(id result) {
            [weakSelf dismissLoadingIndicator];
            // 提示发布成功
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"发布成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            [UIView animateWithDuration:1 animations:^{
                [weakSelf.navigationController presentViewController:alert animated:YES completion:nil];
                
            } completion:^(BOOL finished) {
                [weakSelf.navigationController dismissViewControllerAnimated:alert completion:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    
                }];
            }];
            
            
        } fail:^(NSError *error) {
            [weakSelf dismissLoadingIndicator];
            // 发布失败
            [weakSelf alertString:error.localizedDescription duration:1];
        }];
    }
    
    
    
}

- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{
    
    [self rightButtonAction:nil];
}

- (void)setIsJobDescription:(BOOL)isJobDescription{
    _isJobDescription = isJobDescription;
    if (_isJobDescription) {
        self.jobDescriptionImageView.image = [UIImage imageNamed:@"myok"];
    }else{
        self.jobDescriptionImageView.image = [UIImage imageNamed:@"灰勾"];
    }
    
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    MJWeakSelf
    
    switch (indexPath.row ) {
            
        case 0:// 公司信息
        {
            JobChangeCompanyInfoController *jobChangeCompanyInfoController = [[JobChangeCompanyInfoController alloc]init];
            [self.navigationController pushViewController:jobChangeCompanyInfoController animated:YES];
        }break;
            
        case 1:// 职位名称
        {
            JobChangeJobNameController *changeJobNameVc = [[JobChangeJobNameController alloc]initWithJobName:weakSelf.jobEntity.JobName];
            [changeJobNameVc completeEditText:^(NSString *text) {
                cell.detailTextLabel.text = text;
                weakSelf.jobEntity.JobName = text;
            }];
            [self.navigationController pushViewController:changeJobNameVc animated:YES];
        }break;
            
        case 2:// 薪资范围
        {
            JobEditSalaryController *editSalaryVC = [[JobEditSalaryController alloc]init];
            
            if (weakSelf.jobEntity.SalaryRangeMin) {
                editSalaryVC.minSalary = self.jobEntity.SalaryRangeMin.intValue;
            }
            if (weakSelf.jobEntity.SalaryRangeMax) {
                editSalaryVC.maxSalary = self.jobEntity.SalaryRangeMax.intValue;
            }
            
            [editSalaryVC completeEditText:^(int min, int max) {
                weakSelf.jobEntity.SalaryRangeMin = [NSString stringWithFormat:@"%d",min];
                weakSelf.jobEntity.SalaryRangeMax = [NSString stringWithFormat:@"%d",max];
                if (min/100 == max/100) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fk",min/1000.0];
                }else{
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fk-%.2fk",min/1000.0,max/1000.0];
                }
                
            }];
            [weakSelf.navigationController pushViewController:editSalaryVC animated:YES];
            
        }break;
            
        case 3:// 经验要求
        {
            DegreeView *degreeView = [[DegreeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
            degreeView.title = @"经验要求";
            degreeView.cellData = @[@"应届生",@"1-3年",@"3-5年",@"5-10年",@"10年以上",];
            NSArray * codeArray = @[@"FreshGraduate",@"1to3",@"3to5",@"5to10",@"10tomax"];
            degreeView.block = ^(NSString *string,NSInteger index){
                cell.detailTextLabel.text = string;
                weakSelf.jobEntity.ExperienceRequire = codeArray[index];
            };
            [degreeView loadDegreeView];
            // 预选中
            if (self.jobEntity.ExperienceRequire.length > 0) {
                NSInteger row = [codeArray indexOfObject:self.jobEntity.ExperienceRequire];
                [degreeView.picker selectRow:row inComponent:0 animated:NO];
            }
            [weakSelf.view addSubview:degreeView];
        }break;
            
        case 4:// 学历要求
        {
            DegreeView *degreeView = [[DegreeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
            degreeView.title = @"学历要求";
            degreeView.cellData = @[@"大专以下",@"大专",@"本科",@"硕士",@"博士"];
            degreeView.block = ^(NSString *string,NSInteger index){
                cell.detailTextLabel.text = string;
                weakSelf.jobEntity.EducationRequire = [NSString stringWithFormat:@"%d",(int)index+5];
            };
            [degreeView loadDegreeView];
            // 预选中
            if (self.jobEntity.EducationRequire.length > 0) {
                NSInteger row = self.jobEntity.EducationRequire.integerValue - 5;
                [degreeView.picker selectRow:row inComponent:0 animated:NO];
            }
            
            [self.view addSubview:degreeView];
        }break;
            
        case 5:// 工作城市
        {
            //            SearchCitiVC *searchCitiVC = [[SearchCitiVC alloc]init];
            //            searchCitiVC.title = @"工作城市";
            //
            //            searchCitiVC.block = ^(NSString * informationStr,NSString * cityCode){
            //                cell.detailTextLabel.text = informationStr;
            //                weakSelf.jobEntity.JobCity = cityCode;
            //            };
            //
            //            searchCitiVC.cityBlock = ^(CityModel * city){
            //                cell.detailTextLabel.text = city.Name;
            //                weakSelf.jobEntity.JobCity = city.Code;
            //                [weakSelf.navigationController popToViewController:self animated:YES];
            //            };
            
            // 1.3.2 Jam
            SearchViewController *searchVC = [[SearchViewController alloc]init];
            searchVC.title = @"工作城市";
            
            searchVC.block = ^(CityModel* model){
                cell.detailTextLabel.text = model.Name;
                weakSelf.jobEntity.JobCity = model.Code;
            };
            
            [self.navigationController pushViewController:searchVC animated:YES];
            
            
            
        }break;
            
        case 6:// 工作地点
        {
            JobEditAddressController* jobEditAddressController = [[JobEditAddressController alloc]initWithAddress:weakSelf.jobEntity.JobLocation];
            [jobEditAddressController completeEditText:^(NSString *address) {
                cell.detailTextLabel.text = address;
                weakSelf.jobEntity.JobLocation = address;
            }];
            [weakSelf.navigationController pushViewController:jobEditAddressController animated:YES];
        }break;
            
        case 7:// 职位描述
        {
            JobEditWorkDetailController* jobEditWorkDetailController = [[JobEditWorkDetailController alloc]initWithDescripton:weakSelf.jobEntity.JobDescription];
            
            [jobEditWorkDetailController completeEndEditWorkDetailBlock:^(NSString *string) {
                weakSelf.jobEntity.JobDescription = string;
                weakSelf.isJobDescription = string.length > 0 ? YES:NO;
            }];
            [weakSelf.navigationController pushViewController:jobEditWorkDetailController animated:YES];
            
        }break;
            
        case 8:// 简历邮箱
        {
            JobEditEmailController* jobEditEmailController = [[JobEditEmailController alloc]initWithEmail:weakSelf.jobEntity.ContactEmail];
            
            [jobEditEmailController completeEditEmailHandle:^(NSString *string) {
                weakSelf.jobEntity.ContactEmail = string;
                cell.detailTextLabel.text = string;
            }];
            [weakSelf.navigationController pushViewController:jobEditEmailController animated:YES];
            
        }break;
        case 9:// 联系电话
        {
            JobEditPhoneNumberController* jobEditPhoneNumberController = [[JobEditPhoneNumberController alloc]initWithPhoneNum:self.jobEntity.ContactNumber];
            [jobEditPhoneNumberController completeEditPhoneNumHandle:^(NSString *string) {
                weakSelf.jobEntity.ContactNumber = string;
                cell.detailTextLabel.text = string;
            }];
            [weakSelf.navigationController pushViewController:jobEditPhoneNumberController animated:YES];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - tableView datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = ColorWithHex(KColor_Text_BlackColor);
    cell.detailTextLabel.textColor = ColorWithHex(KColor_Text_EumeColor);
    
    NSString* detailStr;
    switch (indexPath.row ) {
        case 0:// 公司信息
        {
            // 获取公司信息
            [MineRequest getCompanyMineWithCompanyId: [UserAuthentication GetBossInformation].CompanyId success:^(CompanySummary *companySummary) {
                
                cell.detailTextLabel.text = companySummary.CompanyName;
                
                self.jobEntity.CompanyId = companySummary.CompanyId;
                
            } fail:^(NSError *error) {
                
                NSLog(@"#getCompanyMineWithCompanyId error===%@",error.localizedDescription);
            }];
            
        }break;
            
        case 1:// 职位名称
        {
            if (self.jobEntity.JobName) {
                detailStr = self.jobEntity.JobName;
            }
            
        }break;
            
        case 2:// 薪资范围
        {
            if (self.jobEntity.SalaryRangeMin && self.jobEntity.SalaryRangeMax) {
                int min = self.jobEntity.SalaryRangeMin.intValue;
                int max = self.jobEntity.SalaryRangeMax.intValue;
                
                if (min/100 == max/100) {
                    detailStr = [NSString stringWithFormat:@"%.2fk",min/1000.0];
                }else{
                    detailStr = [NSString stringWithFormat:@"%.2fk-%.2fk",min/1000.0,max/1000.0];
                }
            }
            
        }break;
            
        case 3:// 经验要求
        {
            if (self.jobEntity.ExperienceRequireText) {
                detailStr = self.jobEntity.ExperienceRequireText;
            }
            
        }break;
            
        case 4:// 学历要求
        {
            if (self.jobEntity.EducationRequireText) {
                detailStr = self.jobEntity.EducationRequireText;
            }
        }break;
            
        case 5:// 工作城市
        {
            if (self.jobEntity.JobCityText) {
                detailStr = self.jobEntity.JobCityText;
            }
            
        }break;
            
        case 6:// 工作地点
        {
            if (self.jobEntity.JobLocation) {
                detailStr = self.jobEntity.JobLocation;
            }
            
        }break;
            
        case 7:// 职位描述
        {
            [self.jobDescriptionImageView removeFromSuperview];
            [cell.contentView addSubview:self.jobDescriptionImageView];
            [self.jobDescriptionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView);
                make.right.equalTo(cell.contentView);
                make.width.height.mas_equalTo(20);
            }];
            self.isJobDescription = self.jobEntity.JobDescription.length>0 ? YES : NO;
            
        }break;
            
        case 8:// 简历邮箱
        {
            if (self.jobEntity.ContactEmail) {
                detailStr = self.jobEntity.ContactEmail;
            }
            
        }break;
            
        case 9:// 联系电话
        {
            if (self.jobEntity.ContactNumber) {
                detailStr = self.jobEntity.ContactNumber;
            }
            
        }break;
            
        default:
            break;
            
    }
    
    cell.detailTextLabel.text = detailStr;
    
    return cell;
}

#pragma mark - lazy load
- (NSArray *)titleArray{
    
    if (!_titleArray) {
        _titleArray = @[@"公司信息",@"职位名称",@"薪资范围",@"经验要求",@"学历要求",@"工作城市",@"工作地点",@"职位描述",@"接受简历邮箱",@"联系电话"];
    }
    return _titleArray;
}
- (JXFooterView*)footerView{
    JXFooterView* footerView = [JXFooterView footerView];
    footerView.nextLabel.text = self.isUpdate ? @"确认修改":@"发布职位";
    footerView.delegate = self;
    return footerView;
}

- (JobEntity *)jobEntity{
    
    if (_jobEntity == nil) {
        _jobEntity = [[JobEntity alloc]init];
    }
    return _jobEntity;
}

- (UIImageView *)jobDescriptionImageView{
    
    if (_jobDescriptionImageView == nil) {
        _jobDescriptionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"灰勾"]];
    }
    return _jobDescriptionImageView;
}

@end


