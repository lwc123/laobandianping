
#import <JSONModel/JSONModel.h>

/*
 const int JobType_All = -1;
 const int JobType_JuXianLing = 0;
 const int JobType_TalentBank = 1;
 */

@interface OperationJobEntity : JSONModel

@property (nonatomic,assign)long ItemId;
@property (nonatomic,assign)long PassportId;

@property (nonatomic,assign)int JobType;
@property (nonatomic,strong)NSString<Optional> *JobTitle;
@property (nonatomic,strong)NSString<Optional> *Company;
@property (nonatomic,strong)NSString<Optional> *SalaryRange;
@property (nonatomic,strong)NSString<Optional> *Location;
@property (nonatomic,strong)NSString<Optional> *JobDescription;

@property (nonatomic,strong)NSString<Optional> *IndustryText;		//行业字典显示值
@property (nonatomic,strong)NSString<Optional> *JobCategoryText;	//职能字典显示值

@property (nonatomic,strong)NSDate<Optional> *CreatedTime;
@property (nonatomic,strong)NSDate<Optional> *ModifiedTime;

@end