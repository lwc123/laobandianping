
#import <JSONModel/JSONModel.h>

@interface MiniResumeEntity : JSONModel

@property (nonatomic,assign)long ResumeId;
@property (nonatomic,assign)long PassportId;

@property (nonatomic,strong)NSArray<Optional> *PersonalTags;
@property (nonatomic,strong)NSArray<Optional> *EmploymentHistory;
@property (nonatomic,strong)NSArray<Optional> *EucationalHistory;

@property (nonatomic,strong)NSDate<Optional> *CreatedTime;
@property (nonatomic,strong)NSDate<Optional> *ModifiedTime;

@end

/// 工作信息项
@interface MiniEmploymentEntity : JSONModel

@property (nonatomic,assign)long ItemId;
@property (nonatomic,assign)long ResumeId;
@property (nonatomic,assign)long PassportId;

@property (nonatomic,strong)NSString<Optional> *CompanyName;
@property (nonatomic,strong)NSString<Optional> *JobTitle;
@property (nonatomic,strong)NSString<Optional> *Department;
@property (nonatomic,strong)NSDate<Optional> *StartDate;
@property (nonatomic,strong)NSDate<Optional> *EndDate;
@property (nonatomic,strong)NSString<Optional> *AttestationImage;
@property (nonatomic,assign)bool IsAttestation;

@property (nonatomic,strong)NSDate<Optional> *CreatedTime;
@property (nonatomic,strong)NSDate<Optional> *ModifiedTime;

@end

/// 教育信息项
@interface MiniEucationalEntity : JSONModel

@property (nonatomic,assign)long ItemId;
@property (nonatomic,assign)long ResumeId;
@property (nonatomic,assign)long PassportId;

@property (nonatomic,strong)NSString<Optional> *SchoolName;
@property (nonatomic,strong)NSString<Optional> *Education;
@property (nonatomic,strong)NSString<Optional> *SpecialtyName;
@property (nonatomic,strong)NSDate<Optional> *StartDate;
@property (nonatomic,strong)NSDate<Optional> *EndDate;

@property (nonatomic,strong)NSDate<Optional> *CreatedTime;
@property (nonatomic,strong)NSDate<Optional> *ModifiedTime;

@end