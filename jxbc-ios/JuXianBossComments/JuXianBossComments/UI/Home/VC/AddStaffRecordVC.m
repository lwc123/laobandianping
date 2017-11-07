//
//  AddStaffRecordVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/24.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "AddStaffRecordVC.h"
#import "JXMineModel.h"
#import "STPickerDate.h"
#import "DegreeView.h"
#import "AddJobViewController.h"//添加职务
#import "MineDataRequest.h"
#import "AddRecodeCell.h"
#import "TopAlertView.h"
#import "AddJobCell.h"
//添加档案model
#import "EmployeArchiveEntity.h"
#import "WorkItemEntity.h"
#import "WorkCommentsVC.h"

//在电脑上创建简历
#import "AddArchiveOnPcVC.h"
#import "StaffListVC.h"
#import "CommentsDetail.h"//阶段评价详情修改档案
#import "DepartureDetail.h"
#import "AddDepartureReportVC.h"//添加离任报告
#import "NSString+RegexCategory.h"
#import "JXShortMessage.h"//告知短信

@interface AddStaffRecordVC ()<UITextFieldDelegate,JXFooterViewDelegate,STPickerDateDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,AddRecodeCellDelegate,TopAlertViewDelegate,JXShortMessageDelagate>{
    UIButton * _delegateBtn;
    /**最上面的View*/
    UILabel * _headerLabel;
    TopAlertView * _topView;
    
    NSString * _startDateStr;
    NSString * _overDateStr;
    NSString * _jobStr;
    NSString * _doortStr;
    NSString * _moneyStr;
    NSString * _imageStr;
    NSString * _educationCode;
}

@property (nonatomic,strong)NSArray * dataTextArray;
@property (nonatomic,strong)UITextField *allFieldTex;
@property (nonatomic,strong)UIImage * defalutIamge;
//xjh加号btn
@property (nonatomic,strong)UIView *btnBgView;
@property (nonatomic,strong)UIButton * addButton;
/**入职日期*/
@property (nonatomic,strong)UITextField *putDateTf;
/**离职日期*/
@property (nonatomic,strong)UITextField *outDateTf;
/**学历*/
@property (nonatomic,strong)UITextField *schoolTf;
@property (nonatomic,strong)UITextField *nameTf;
@property (nonatomic,strong)UITextField *idCardTf;
@property (nonatomic,strong)UITextField *phoneTf;
@property (nonatomic,strong)UITextField *xueliTf;

@property (nonatomic, strong) NSMutableArray *jobArray;
@property (nonatomic, strong) NSMutableArray *workArray;
@property (nonatomic,assign)int index;
@property (nonatomic,assign)int onOrInIndex;
@property (nonatomic,strong)UIImageView * iconImageView;
//返回的档案Id
@property (nonatomic,assign)long archiveId;
@property (nonatomic, strong) NSArray *workItems;
//学历字典model
@property (nonatomic,strong)AcademicModel * academicModel;
@property (nonatomic,strong)NSMutableArray * academicMArray;
@property (nonatomic, assign) NSInteger pickerSelectedRow;

//是否发送短信
@property (nonatomic, assign) BOOL isSendMes;

@end

@implementation AddStaffRecordVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self isShowLeftButton:YES];
    [self isShowRightButton:YES with:@"提交"];
    
    [self initData];
    [self initUI];
    [self initEducationRequest];//学历字典
    self.pickerSelectedRow = 0;
}

- (void)initData{
    
    _jobArray = [NSMutableArray array];
    if (_employeEntity.ArchiveId) {
        _jobArray = [_employeEntity.WorkItems mutableCopy];
    }
    //数组排序
    /*
    _jobArray = [NSMutableArray arrayWithObjects:@"20160111",@"20161111",@"20151211",nil];
    NSArray *sorted = [_jobArray sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        NSInteger timeObj1 = [obj1 integerValue];
        NSInteger timeObj2 = [obj2 integerValue];
        if (timeObj1>timeObj2) {
            return (NSComparisonResult)NSOrderedDescending;
        }else{
            return (NSComparisonResult)NSOrderedAscending;
        }
    }];
    _jobArray = [NSMutableArray arrayWithArray:sorted];
     */
    _xueliTf = [[UITextField alloc] init];;
    _academicModel = [[AcademicModel alloc] init];
    _isSendMes = YES;
}


- (void)initUI{
    
    _topView = [TopAlertView topAlertView];
    _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    _topView.myLabel.text = @"在电脑上建立员工档案";
    _topView.delegate = self;
    
    _topView.addOnPcBtn.userInteractionEnabled = YES;
    _topView.addOnPcBtn.hidden = NO;
    _topView.delagateBtn.userInteractionEnabled = NO;
    [_topView.delagateBtn setImage:[UIImage imageNamed:@"rightBtn"] forState:UIControlStateNormal];
    [self.view addSubview:_topView];
    
    
    
    self.jxTableView.frame = CGRectMake(0, CGRectGetMaxY(_topView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 30);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.jxTableView.backgroundView addGestureRecognizer:tap];
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    
    JXFooterView * footerView = [JXFooterView footerView];
    footerView.delegate = self;
    footerView.nextLabel.text = @"提交";
    self.jxTableView.tableFooterView = footerView;
    [self.jxTableView registerNib:[UINib nibWithNibName:@"AddRecodeCell" bundle:nil] forCellReuseIdentifier:@"addRecodeCell"];
    [self.jxTableView registerNib:[UINib nibWithNibName:@"AddJobCell" bundle:nil] forCellReuseIdentifier:@"addJobCell"];
}

- (void)topAlertViewDidClickedOffBtn:(TopAlertView *)alertView{
    [_topView removeFromSuperview];
    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    [self.jxTableView reloadData];
}

#pragma mark -- 学历字典
- (void)initEducationRequest{

    [WebAPIClient getJSONWithUrl:API_Dictionary_Academic parameters:nil success:^(id result) {        
        JSONModelArray *modelArray = [[JSONModelArray alloc]initWithArray:result[@"academic"] modelClass:[AcademicModel class]];
        self.academicMArray = modelArray.mutableCopy;
    } fail:^(NSError *error) {
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
}

- (void)setEmployeEntity:(EmployeArchiveEntity *)employeEntity{
    _employeEntity = employeEntity;
    self.workArray = employeEntity.WorkItems.mutableCopy;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if (section == 0){
    return self.dataTextArray.count + 2;
    }else{
        return _jobArray.count;
    }
}


//self.jobstatus == 1

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//头像
            
            static NSString *identifier = @"myCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 65 ) * 0.5, 14, 65, 65)];
                imageView.backgroundColor = [UIColor blackColor];
                imageView.layer.cornerRadius = 65 * 0.5;
                imageView.layer.masksToBounds = YES;
                imageView.layer.borderWidth = 2;
                imageView.layer.borderColor = [PublicUseMethod setColor:KColor_GoldColor].CGColor;
                imageView.image = StaffPahoto;
                [cell.contentView addSubview:imageView];
                imageView.userInteractionEnabled = YES;
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
                [imageView addGestureRecognizer:tap];
                self.iconImageView = imageView;
                
                UILabel * textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 8, SCREEN_WIDTH, 12)];
                textLabel.text = @"点击上传";
                textLabel.textAlignment = NSTextAlignmentCenter;
                textLabel.font = [UIFont systemFontOfSize:12.0];
                textLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
                [cell.contentView addSubview:textLabel];
            }
            
            if (self.employeEntity) {
                [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_employeEntity.Picture] placeholderImage:StaffPahoto];
            }
            return cell;
        }else if (indexPath.row == 1){//目前在职状态
            AddRecodeCell * addCell = [tableView dequeueReusableCellWithIdentifier:@"addRecodeCell" forIndexPath:indexPath];
            addCell.delegate = self;
            
            if (self.employeEntity) {
                
                _onOrInIndex = self.employeEntity.IsDimission + 1;
                if (self.employeEntity.IsDimission == 0) {
                    [addCell.inJobBtn setImage:[UIImage imageNamed:@"myok"] forState:UIControlStateNormal];
                    [addCell.onJobBtn setImage:[UIImage imageNamed:@"seril"] forState:UIControlStateNormal];
                }else{
                    [addCell.inJobBtn setImage:[UIImage imageNamed:@"seril"] forState:UIControlStateNormal];
                    [addCell.onJobBtn setImage:[UIImage imageNamed:@"myok"] forState:UIControlStateNormal];
                }
            }
            if (self.jobstatus == 1) {//在职
                _onOrInIndex = 1;
                [addCell.inJobBtn setImage:[UIImage imageNamed:@"myok"] forState:UIControlStateNormal];
                [addCell.onJobBtn setImage:[UIImage imageNamed:@"seril"] forState:UIControlStateNormal];
            }else if (self.jobstatus == 2){
                _onOrInIndex = 2;
                [addCell.onJobBtn setImage:[UIImage imageNamed:@"myok"] forState:UIControlStateNormal];
                [addCell.inJobBtn setImage:[UIImage imageNamed:@"seril"] forState:UIControlStateNormal];
            }else{}
            return addCell;
        }else{
        
            static NSString *identifier = @"cell000";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                CGFloat allFieldTexW = 245;
                _allFieldTex = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-allFieldTexW-10, 0, allFieldTexW, 44)];
                _allFieldTex.textAlignment = NSTextAlignmentRight;
                _allFieldTex.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
                _allFieldTex.font = [UIFont systemFontOfSize:14];
                _allFieldTex.delegate = self;
                [cell.contentView addSubview:_allFieldTex];
            }
            cell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            _allFieldTex.tag = 300 + indexPath.row;
            _allFieldTex.placeholder = [NSString stringWithFormat:@"请输入%@",self.dataTextArray[indexPath.row - 2]];
            cell.textLabel.text = self.dataTextArray[indexPath.row -2];
            _allFieldTex.enabled = YES;
            _nameTf = [self.view viewWithTag:302];
            _idCardTf = [self.view viewWithTag:303];
            _phoneTf = [self.view viewWithTag:304];
            _putDateTf = [self.view viewWithTag:305];
            _outDateTf = [self.view viewWithTag:306];
            _schoolTf = [self.view viewWithTag:307];
            _xueliTf = [self.view viewWithTag:308];//SC.XJH.1.5
            if (indexPath.row == 2) {//姓名
                _allFieldTex.placeholder= @"该员工的姓名";
                if (_employeEntity.RealName.length != 0) {
                    _allFieldTex.text = _employeEntity.RealName;
                }
            }else if (indexPath.row == 3){//身份证号
                _allFieldTex.placeholder = @"自动提取年龄、性别";
                if (_employeEntity.IDCard.length != 0) {
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    _allFieldTex.text = _employeEntity.IDCard;
                    _allFieldTex.enabled = NO;
                }else{
                    _allFieldTex.enabled = YES;
                }
            
            }else if (indexPath.row == 4){//手机号
                _allFieldTex.placeholder = @"常用的手机号";
                if (_employeEntity.MobilePhone.length != 0) {
                    _allFieldTex.text = _employeEntity.MobilePhone;
                }
            }else if (indexPath.row == 5){//入职日期
                _allFieldTex.placeholder = @"入职的日期";
                _allFieldTex.enabled = NO;
                if (_employeEntity.EntryTime) {
                    _allFieldTex.text = [JXJhDate JHFormatDateWith:_employeEntity.EntryTime];
                }
            
            }else if (indexPath.row == 6){//离任日期
                _allFieldTex.enabled = NO;
                _allFieldTex.placeholder = @"请输入离任日期";
//                if (_onOrInIndex == 1) {
//                    _allFieldTex.placeholder = @"在职，可不填";
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                }else if (_onOrInIndex == 2){//离职
//                    _allFieldTex.placeholder = @"必填";
//                }
                if (_employeEntity) {
                    if (self.employeEntity.IsDimission == 0) {//在职 没有离任
                        
                    }else{
                        _allFieldTex.text = [JXJhDate JHFormatDateWith:_employeEntity.DimissionTime];
                    }
                }
                if (_onOrInIndex == 1 || _onOrInIndex == 0) {
                
                    cell.hidden = YES;
                }else{
                    cell.hidden = NO;
                }
            }else if (indexPath.row == 7){//毕业学校
                _allFieldTex.placeholder = @"毕业学校";
                    _allFieldTex.enabled = YES;
                if (_employeEntity.GraduateSchool.length != 0) {
                    _allFieldTex.text = _employeEntity.GraduateSchool;
                }
            }else{//学历
                    _allFieldTex.enabled = NO;
                _allFieldTex.placeholder = @"该员工的最高学历";
                if (_employeEntity.EducationText.length != 0) {
                    _allFieldTex.text = _employeEntity.EducationText;
                    _xueliTf.text = _employeEntity.EducationText;//SC.XJH.1.5
                    _educationCode = _employeEntity.Education;
                }
            }
            _phoneTf.keyboardType = UIKeyboardTypeNumberPad;
            return cell;
        }
    }else{
        AddJobCell * jobCell = [tableView dequeueReusableCellWithIdentifier:@"addJobCell" forIndexPath:indexPath];
        jobCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (self.jobArray.count>0) {
            WorkItemEntity * allItemEntity;
            if ([_jobArray[indexPath.row] isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dic = _jobArray[indexPath.row];
                allItemEntity = [[WorkItemEntity alloc] initWithDictionary:dic error:nil];
            }else{
                allItemEntity = _jobArray[indexPath.row];
            }
            NSString * dateStr = [JXJhDate stringFromDate:allItemEntity.PostStartTime];
            NSString * endStr = [JXJhDate stringFromDate:allItemEntity.PostEndTime];
            
            if ([endStr isEqualToString:@"3000年01月"] || [endStr isEqualToString:@"3000年01月01日"]) {
                endStr = @"至今";
            }
            jobCell.dateLabel.text = [NSString stringWithFormat:@"%@-%@",dateStr,endStr];
            jobCell.jobLabel.text = allItemEntity.PostTitle;
            jobCell.doorLabel.text = allItemEntity.Department;
            
            if (allItemEntity.Salary.length != 0) {
                jobCell.moneyLabel.text = [NSString stringWithFormat:@"年薪%@万元",allItemEntity.Salary];
            }
            
        }else{
            WorkItemEntity * workItem = _jobArray[indexPath.row];
            
            if ([[JXJhDate stringFromYearAndMonthDate:workItem.PostEndTime] isEqualToString:@"3000年01月"]) {
                jobCell.dateLabel.text = [NSString stringWithFormat:@"%@-至今",[JXJhDate stringFromYearAndMonthDate:workItem.PostStartTime]];

            }else{
            jobCell.dateLabel.text = [NSString stringWithFormat:@"%@-%@",[JXJhDate stringFromDate:workItem.PostStartTime],[JXJhDate stringFromDate:workItem.PostEndTime]];
            }
            
            jobCell.jobLabel.text = workItem.PostTitle;
            jobCell.doorLabel.text = workItem.Department;
            if (workItem.Salary.length != 0) {
                jobCell.moneyLabel.text = [NSString stringWithFormat:@"年薪%@万元",workItem.Salary];
            }
        }
        return jobCell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    if (section == 1) {
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        bgView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
        JXShortMessage * messageView = [JXShortMessage shortMessage];
        messageView.delegate = self;
        if (!self.employeEntity.ArchiveId) {
            [bgView addSubview:messageView];
        }
        _addButton = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 35, 200, 45)];
        [_addButton addTarget:self action:@selector(addServiceContent:) forControlEvents:UIControlEventTouchUpInside];
        [_addButton setTitle:@"+ 添加职务" forState:UIControlStateNormal];
        [_addButton setTitleColor:[PublicUseMethod setColor:KColor_Text_BlackColor] forState:UIControlStateNormal];
        _addButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _addButton.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:_addButton];
        return bgView;
    }
    return nil;
}

#pragma mark -- 选择是否发送短信
- (void)shortMessageDidClickedWith:(UIButton *)button shortMessage:(JXShortMessage *)shortMessage{
    if (shortMessage.clinkBtn.selected == YES) {
        _isSendMes = NO;
    }else{
        _isSendMes = YES;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            return 113;
        }else if (indexPath.row == 6){
            
//            return 44;self.jobstatus == 1 || self.jobstatus == 0 ||
            if ( _onOrInIndex == 1 || _onOrInIndex == 0) {
                return 0;
            }else{
                return 44;
            }
        }else{
            return 44;
        }
    }else{
        return 82;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==1) {
        return 80;
    }
    return 0;
}

- (void)tapAction{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    [PublicUseMethod pickerImageChannelWithImageController:imagePicker andViewController:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//头像保存
//            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
//            imagePicker.delegate = self;
//            [PublicUseMethod pickerImageChannelWithImageController:imagePicker andViewController:self];
        }
        if (indexPath.row == 5) {// 入职
            _index = 5;
            STPickerDate *pickerDate = [[STPickerDate alloc]init];
            [pickerDate setDelegate:self];
            [pickerDate show];
            [pickerDate selectedDateWithString:self.putDateTf.text];
            
        }else if (indexPath.row == 6){//离职
            
            if (_onOrInIndex == 1) {
                [PublicUseMethod showAlertView:@"目前状态在职"];

            }else{//离职
                _index = 6;
                STPickerDate *pickerDate = [[STPickerDate alloc]init];
                [pickerDate setDelegate:self];
                [pickerDate show];
                [pickerDate selectedDateWithString:self.outDateTf.text];
            }
        }else if (indexPath.row == 8){
            __weak typeof(self) weakSelf = self;
            DegreeView *degreeView = [[DegreeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
            degreeView.title = @"学历";
            NSMutableArray *academicArray = [NSMutableArray array];
            NSMutableArray * academicCodeArr = [NSMutableArray array];            
            for (AcademicModel *academicModel in self.academicMArray) {
                [academicArray addObject:academicModel.Name];
                [academicCodeArr addObject:academicModel.Code];
            }
            degreeView.cellData = [academicArray copy];
            degreeView.block = ^(NSString *string,NSInteger index){
                UITextField *label = (UITextField *)[weakSelf.view viewWithTag:308];
                label.text = string;
                label.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
                _xueliTf.text = string;
                _employeEntity.EducationText = string;//SC.XJH.1.4
                _educationCode = academicCodeArr[index];
                weakSelf.pickerSelectedRow = index;
            };
            [degreeView loadDegreeView];
            // 预选中
            if (self.employeEntity) {
                NSInteger row = [degreeView.cellData indexOfObject:self.employeEntity.EducationText];
                [degreeView.picker selectRow:row inComponent:0 animated:NO];
            }else{
                [degreeView.picker selectRow:self.pickerSelectedRow inComponent:0 animated:NO];
            }
            [self.view addSubview:degreeView];
        }
    }else{//修改职务
    
        AddJobViewController * addJobVC = [[AddJobViewController alloc] init];
        addJobVC.joinCompanyDate = self.putDateTf.text;
        addJobVC.leaveCompanyDate = self.outDateTf.text;
        
        if (_jobArray.count) {
            WorkItemEntity * workItem;
            if ([_jobArray[indexPath.row] isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dic = _jobArray[indexPath.row];
                workItem = [[WorkItemEntity alloc] initWithDictionary:dic error:nil];
            }else{
                workItem = _jobArray[indexPath.row];
            }
            addJobVC.workItemEntity = workItem;
        }
        
        MJWeakSelf
        addJobVC.workItemBlock = ^(WorkItemEntity *workItemEntity,NSString * startDateStr,NSString * endDateStr){
            
            _startDateStr = startDateStr;
            _overDateStr = endDateStr;
            [_jobArray replaceObjectAtIndex:indexPath.row withObject:workItemEntity];
            NSDictionary * dic = [workItemEntity toDictionary] ;
            [weakSelf.workArray replaceObjectAtIndex:indexPath.row withObject:dic];
            [weakSelf.jxTableView reloadData];
        };
        [self.navigationController pushViewController:addJobVC animated:YES];
    }
    
}


#pragma mark -- 保存
- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{

    if (jxFooterView.nextBtn.selected) {
        jxFooterView.nextBtn.selected = NO;
    }else{

        if (_onOrInIndex == 1) {//在职离任可选
            
        }
        if (_onOrInIndex == 2) {//离任
            if (_outDateTf.text.length == 0) {
                [PublicUseMethod showAlertView:@"离任日期不能为空"];
                return;
            }
        }
        if(_onOrInIndex != 1 && _onOrInIndex != 2){
            [PublicUseMethod showAlertView:@"请选择目前状态"];
            return;
        }
        
        if (_nameTf.text.length == 0) {
            [PublicUseMethod showAlertView:@"请输入姓名"];
            return;
        }
        if (_nameTf.text.length > 5) {
            [PublicUseMethod showAlertView:@"姓名最多5个汉字"];
            return;
        }
        
        if (_idCardTf.text.length == 0) {
            [PublicUseMethod showAlertView:@"请输入身份证号码"];
            return;
        }
        if ([_nameTf.text isContainsEmoji]) {
            [PublicUseMethod showAlertView:@"姓名不可以包含表情"];
            return;
        }
        if ([_schoolTf.text isContainsEmoji]) {
            [PublicUseMethod showAlertView:@"毕业学校不可以包含表情"];
            return;
        }
        [self upRecord];
    }
}
//添加档案
- (void)upRecord{

    if (_employeEntity.ArchiveId && !_imageStr) {
        NSData *data = UIImageJPEGRepresentation(_iconImageView.image, 1);
        NSString *imageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        _imageStr =imageStr;
    }
    
    if (_phoneTf.text.length == 0) {
        [PublicUseMethod showAlertView:@"请输入手机号码"];
        return;
    }
    if ([PublicUseMethod textField:_phoneTf length:11]==NO)
    {
        [SVProgressHUD showInfoWithStatus:@"手机号为11位数字"];
        return;
    }
    if ([PublicUseMethod isMobileNumber:_phoneTf.text]==NO)
    {
        return;
    }
    
    if (_putDateTf.text.length == 0) {
        [PublicUseMethod showAlertView:@"入职日期不能为空"];
        return;
    }
    
    if (_schoolTf.text.length == 0) {
        [PublicUseMethod showAlertView:@"请输入毕业学校"];
        return;
    }
    
    if (_schoolTf.text.length > 30) {
        [PublicUseMethod showAlertView:@"毕业学校最多30个汉字"];
        return;
    }
    
    if (_educationCode.length == 0) {
        [PublicUseMethod showAlertView:@"请选择学历"];
        return;
    }
    if (_jobArray.count == 0) {
        [PublicUseMethod showAlertView:@"请输入职务信息"];
        return;
    }
    
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    NSDate *starDate = [JXJhDate getNowDateFromatAnDate:[outputFormatter dateFromString:_putDateTf.text]];
    NSDate *endDate;
    if (_outDateTf.text.length == 0) {

    }else{
        endDate = [JXJhDate getNowDateFromatAnDate:[outputFormatter dateFromString:_outDateTf.text]];
    }
    
    if ([endDate timeIntervalSinceDate:starDate]<0.0) {
        [PublicUseMethod showAlertView:@"离任时间小于入职时间"];
        return;
    } ;
    if ([endDate isEqual:starDate]) {
        [PublicUseMethod showAlertView:@"离任时间不能等于入职时间"];
        return;
    }    
    
    EmployeArchiveEntity * employeArchive = [[EmployeArchiveEntity alloc] init];
    
    if (_employeEntity.ArchiveId) {
        employeArchive.ArchiveId = _employeEntity.ArchiveId;
        employeArchive.CompanyId = _employeEntity.CompanyId;
    }else{    
        employeArchive.CompanyId = self.companyId;
    }
    employeArchive.Picture = _imageStr;
    employeArchive.IsDimission = _onOrInIndex -1;
    employeArchive.RealName = _nameTf.text;
    employeArchive.IDCard = _idCardTf.text;
    employeArchive.MobilePhone = _phoneTf.text;
    employeArchive.EntryTime = starDate;
    if (_outDateTf.text.length == 0) {
    }else{
        employeArchive.DimissionTime = endDate;
    }
    employeArchive.GraduateSchool = _schoolTf.text;
    employeArchive.Education = _educationCode;
    employeArchive.WorkItems = self.workArray.copy;
    //是否发短信
    employeArchive.IsSendSms = _isSendMes;
    NSString *fixSU = @"操作成功";
    NSString *fixSure = @"添加阶段评价";
    if (_onOrInIndex -1 == 1) {
        fixSure = @"添加离任报告";
    }
    NSString *cancelButtonTitle = @"返回";
    if (_employeEntity.ArchiveId) {
        [self showLoadingIndicator];
        MJWeakSelf
        [WorkbenchRequest postUpDateEmployeArchiveWith:employeArchive success:^(ResultEntity *resultEntity) {
            [weakSelf dismissLoadingIndicator];
            
            EmployeArchiveEntity * employeArchive = [[EmployeArchiveEntity alloc] initWithString:resultEntity.JsonModel error:nil];

            if (resultEntity.Success) {
                [self alertWithTitle:nil message:fixSU cancelTitle:cancelButtonTitle okTitle:fixSure and:employeArchive];
            }else{
                [PublicUseMethod showAlertView:resultEntity.ErrorMessage];
            }
        } fail:^(NSError *error) {
            [weakSelf dismissLoadingIndicator];
            [PublicUseMethod showAlertView:error.localizedDescription];
        }];
    }else{
        
        // 先验证身份证号
        [WorkbenchRequest getExistsIDCardWithCompanyId:self.companyId WithidCard:_idCardTf.text success:^(id result) {
            if ([result[@"Success"] integerValue] > 0) {
                [self initPostRequest:employeArchive];
            }else{
                [PublicUseMethod showAlertView:result[@"ErrorMessage"]];
            }
        } fail:^(NSError *error) {
            [PublicUseMethod showAlertView:error.localizedDescription];
        }];
    }
}

#pragma mark -- 右上角的提交
- (void)rightButtonAction:(UIButton *)button{
    [self jxFooterViewDidClickedNextBtn:nil];
}


#pragma mark -- 是否在职
- (void)addRecodeCellClickTimeBtnWith:(int)index andView:(AddRecodeCell *)resonCell{
    _onOrInIndex = index - 2;
    
    self.employeEntity.IsDimission = index - 3;//SC.XJH.1.5

    if (_onOrInIndex == 1) {
        
        self.outDateTf.text = nil;
    }
    
    [self.jxTableView reloadData];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *originalImage = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    UIImage *UserSelectImage = [PublicUseMethod fixOrientationForImage:originalImage];
    //等比压缩
    UIImage *comImage = [PublicUseMethod thumbnailWithImageWithoutScale:UserSelectImage size:self.iconImageView.size];
    NSData *data = UIImageJPEGRepresentation(comImage, 1);
    NSString *imageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    _imageStr = imageStr;
    self.iconImageView.image = comImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 添加职务内容
- (void)addServiceContent:(UIButton*)button
{
    AddJobViewController * addJobVC = [[AddJobViewController alloc] init];
    addJobVC.joinCompanyDate = self.putDateTf.text;
    addJobVC.leaveCompanyDate = self.outDateTf.text;
    MJWeakSelf
    addJobVC.workItemBlock = ^(WorkItemEntity *workItemEntity,NSString * startDateStr,NSString * endDateStr){
        _startDateStr = startDateStr;
        _overDateStr = endDateStr;
        
        [_jobArray addObject:workItemEntity];
        NSDictionary * dic = [workItemEntity toDictionary] ;
        [weakSelf.workArray addObject:dic];
        /*
        NSArray *sorted = [_jobArray sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            NSInteger timeObj1 = [obj1 integerValue];
            NSInteger timeObj2 = [obj2 integerValue];
            if (timeObj1>timeObj2) {
                return (NSComparisonResult)NSOrderedDescending;
            }else{
                return (NSComparisonResult)NSOrderedAscending;
            }
        }];
        _jobArray = [NSMutableArray arrayWithArray:sorted];
         */
        [self.jxTableView reloadData];
    };
    [self.navigationController pushViewController:addJobVC animated:YES];
}

- (void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSString * dateStr = [NSString stringWithFormat:@"%zd年%02zd月%02zd日", year, month, day];
    if (_index == 5) {
        self.putDateTf.text = dateStr;
    }
    if (_index == 6) {
        self.outDateTf.text = dateStr;
    }
    
}

/*
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if (textField == self.putDateTf) {
        _index = 5;
        STPickerDate *pickerDate = [[STPickerDate alloc]init];
        [pickerDate setDelegate:self];
        pickerDate.title = @"入职日期";
        [pickerDate show];
        [pickerDate selectedDateWithString:self.putDateTf.text];

        return NO;
    }
    if (textField == self.outDateTf) {
        
        if (_onOrInIndex == 1) {
            [PublicUseMethod showAlertView:@"目前状态在职"];
            return NO;
            
        }else{
            _index = 6;
            STPickerDate *pickerDate = [[STPickerDate alloc]init];
            [pickerDate setDelegate:self];
            pickerDate.title = @"离任日期";
            [pickerDate show];
            [pickerDate selectedDateWithString:self.outDateTf.text];

            return NO;
        }
    }
    if (textField.tag == 308) {
                
        __weak typeof(self) weakSelf = self;
        DegreeView *degreeView = [[DegreeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        degreeView.title = @"学历";
        NSMutableArray *academicArray = [NSMutableArray array];
        NSMutableArray * academicCodeArr = [NSMutableArray array];

        for (AcademicModel *academicModel in _academicMArray) {
            NSLog(@"periodModel.Code===%@",academicModel.Code);
            [academicCodeArr addObject:academicModel.Code];
            [academicArray addObject:academicModel.Name];
        }
        degreeView.cellData = [academicArray copy];
        degreeView.block = ^(NSString *string,NSInteger index){
            UITextField *label = (UITextField *)[weakSelf.view viewWithTag:308];
            label.text = string;
            label.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
            _xueliTf.text = string;
            _employeEntity.EducationText = string;//SC.XJH.1.4
            _educationCode = academicCodeArr[index];
            weakSelf.pickerSelectedRow = index;
        };
        [degreeView loadDegreeView];
        // 预选中
        if (self.employeEntity) {
            NSInteger row = [degreeView.cellData indexOfObject:self.employeEntity.EducationText];
            [degreeView.picker selectRow:row inComponent:0 animated:NO];
        }else{
            [degreeView.picker selectRow:self.pickerSelectedRow inComponent:0 animated:NO];
        }
        [self.view addSubview:degreeView];
        
        return NO;
    }
    return YES;
}
*/
#pragma mark -- 封装elert
- (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle okTitle:(NSString *)okTitle with:(EmployeArchiveEntity *)employeArchive{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    //取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    
    //确定
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([okTitle isEqualToString:@"是"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self initPostRequest:employeArchive];
        
        }
    }];
    
    [cancelAction setValue:[PublicUseMethod setColor:KColor_Text_BlackColor] forKey:@"titleTextColor"];
    [otherAction setValue:[PublicUseMethod setColor:KColor_Text_BlackColor] forKey:@"titleTextColor"];

    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)initPostRequest:(EmployeArchiveEntity *)employeArchive{

    NSString *message = @"操作成功";
    NSString *cancelButtonTitle = @"返回";
    
    NSString *otherButtonTitle = @"添加阶段评价";
    if (_onOrInIndex -1 == 1) {
        otherButtonTitle = @"添加离任报告";
    }
    [self showLoadingIndicator];
    [WorkbenchRequest postAddEmployeArchiveWith:employeArchive success:^(ResultEntity *resultEntity) {
        [self dismissLoadingIndicator];
        
        if (resultEntity.Success) {
            EmployeArchiveEntity * employe = [[EmployeArchiveEntity alloc] initWithString:resultEntity.JsonModel error:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if ([self.secondVC isKindOfClass:[WorkCommentsVC class]]) {
                    WorkCommentsVC * commentVC = [[WorkCommentsVC alloc] init];
                    commentVC.detailComment.EmployeArchive = employeArchive;
                    [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
                }else{
                    
                    [self alertWithTitle:nil message:message cancelTitle:cancelButtonTitle okTitle:otherButtonTitle and:employe];
                }
            });
        }else{
            [PublicUseMethod showAlertView:resultEntity.ErrorMessage];
        }
    } fail:^(NSError *error) {
        [self dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
    
}

#pragma mark - 修改 档案
- (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle okTitle:(NSString *)okTitle and:(EmployeArchiveEntity *)employeArchive{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //可能要传档案id
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([self.navigationController.viewControllers[1] isKindOfClass:[StaffListVC class]]) {
                StaffListVC * listVC = self.navigationController.viewControllers[1];
                [listVC.jxTableView beginRefresh];
            }            
            [self.navigationController popViewControllerAnimated:YES];
        });
        [self dismissLoadingIndicator];
    }];
    
    //添加阶段工作评价
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        if (_onOrInIndex -1 == 1) {//添加离任
            
            AddDepartureReportVC * addVC = [[AddDepartureReportVC alloc] init];
            addVC.nameStr = employeArchive.RealName;
            addVC.imageStr = employeArchive.Picture;
            addVC.archiveId = employeArchive.ArchiveId;
            addVC.departmenStr = employeArchive.WorkItem.Department;
            addVC.postTitleStr = employeArchive.WorkItem.PostTitle;
            addVC.recodeEntity = employeArchive;
            addVC.secondVC = self;
            [self.navigationController pushViewController:addVC animated:YES];
        }else{
            WorkCommentsVC * work = [[WorkCommentsVC alloc] init];
            work.employeArchive = employeArchive;
            work.nameStr = employeArchive.RealName;
            work.imageStr = employeArchive.Picture;
            work.archiveId = employeArchive.ArchiveId;
            work.title = @"添加阶段评价";
            work.secondVC = self;
            [self.navigationController pushViewController:work animated:YES];
        }
        [self dismissLoadingIndicator];
        
    }];
    
    [cancelAction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
    [cancelAction setValue:[NSNumber numberWithInteger:NSTextAlignmentCenter] forKey:@"titleTextAlignment"];
    [otherAction setValue:[PublicUseMethod setColor:KColor_Text_BlackColor] forKey:@"titleTextColor"];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark -- 在电脑上创建简历
- (void)topAlertViewAddRecodeOnPc:(TopAlertView *)alertView{
    AddArchiveOnPcVC * addVC = [[AddArchiveOnPcVC alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark --键盘消失
- (void)tap:(UITapGestureRecognizer *)tapGes{
        [self.jxTableView endEditing:YES];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    [self.jxTableView endEditing:YES];
    return [self hitTest:point withEvent:event];
}

// textField代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // string.length为0，表明没有输入字符，应该是正在删除，应该返回YES。
    if (string.length == 0) {
        return YES;
    }
    NSUInteger length = textField.text.length + string.length;
    if (textField == _idCardTf) {
        // str为当前输入框中的字符
        NSString *str = [NSString stringWithFormat:@"%@%@", textField.text, string];
        if (length == 17 && [self theLastIsX:str]) {
            // 如果是17位，并通过前17位计算出18位为X，自动补全，并返回NO，禁止编辑。
            textField.text = [NSString stringWithFormat:@"%@%@X", textField.text, string];
            return NO;
        }
        return length <= 18;
    }
    return YES;
}
// 判断最后一个是不是X
- (BOOL)theLastIsX:(NSString *)IDNumber {
    NSMutableArray *IDArray = [NSMutableArray array];
    for (int i = 0; i < 17; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [IDNumber substringWithRange:range];
        [IDArray addObject:subString];
    }
    NSArray *coefficientArray = [NSArray arrayWithObjects:@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2", nil];
    int sum = 0;
    for (int i = 0; i < 17; i++) {
        int coefficient = [coefficientArray[i] intValue];
        int ID = [IDArray[i] intValue];
        sum += coefficient * ID;
    }
    if (sum % 11 == 2) return YES;
    else return NO;
}

- (NSMutableArray *)workArray{

    if(!_workArray){
        _workArray = @[].mutableCopy;
    }
    return _workArray;
}

- (NSMutableArray *)academicMArray{

    if (!_academicMArray) {
        _academicMArray = @[].mutableCopy;
    }
    return _academicMArray;
}


- (NSArray *)dataTextArray{
    
    if (_dataTextArray == nil) {
        _dataTextArray = @[@"姓名",@"身份证号",@"手机号",@"入职日期",@"离任日期",@"毕业学校",@"学历"];
    }
    return _dataTextArray;
}


- (void)leftButtonAction:(UIButton *)button{
    
    if (!_employeEntity.ArchiveId ) {
        if (_nameTf.text.length != 0 || _idCardTf.text.length != 0 || _phoneTf.text.length != 0 || _putDateTf.text.length != 0 || _schoolTf.text.length != 0 || _educationCode.length != 0 || _jobArray.count != 0) {//在职离任可选
            [self alertWithTitle:@"温馨提示" message:@"信息尚未保存，是否离开？" cancelTitle:@"否" okTitle:@"是" with:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
