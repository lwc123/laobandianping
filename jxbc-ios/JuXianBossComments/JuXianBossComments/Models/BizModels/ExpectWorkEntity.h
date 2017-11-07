
#import <JSONModel/JSONModel.h>

@interface ExpectWorkEntity : JSONModel

@property (nonatomic,assign)long ItemId;
@property (nonatomic,assign)long PassportId;

@property (nonatomic,strong)NSString<Optional> *JobTitle;
@property (nonatomic,strong)NSString<Optional> *Industry;
@property (nonatomic,strong)NSString<Optional> *JobCategory;
@property (nonatomic,strong)NSString<Optional> *SalaryRange;
@property (nonatomic,strong)NSString<Optional> *Location;
@property (nonatomic,strong)NSString<Optional> *Other;

@property (nonatomic,strong)NSString<Optional> *IndustryText;		//行业字典显示值
@property (nonatomic,strong)NSString<Optional> *JobCategoryText;	//职能字典显示值

@property (nonatomic,strong)NSDate<Optional> *CreatedTime;
@property (nonatomic,strong)NSDate<Optional> *ModifiedTime;

@end