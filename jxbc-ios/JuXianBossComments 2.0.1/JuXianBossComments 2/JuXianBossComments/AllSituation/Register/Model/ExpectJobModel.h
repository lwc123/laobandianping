//
//  ExpectJobModel.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/28.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ExpectJobModel : JSONModel
@property (nonatomic, strong)NSNumber<Optional> * ItemId;

@property (nonatomic, strong)NSNumber<Optional> * PassportId;
@property (nonatomic, copy)NSString<Optional> * JobTitle;


@property (nonatomic, copy)NSString<Optional> * Industry;//code
@property (nonatomic, copy)NSString<Optional> * JobCategory;//code
@property (nonatomic,copy)NSString <Optional> * IndustryText;
@property (nonatomic,copy)NSString <Optional> * JobCategoryText;



@property (nonatomic, copy)NSString<Optional> * SalaryRange;
@property (nonatomic, copy)NSString<Optional> * Location;
@property (nonatomic, copy)NSString<Optional> * Other;
@property (nonatomic, copy)NSString<Optional> * CreatedTime;
@property (nonatomic, copy)NSString<Optional> * ModifiedTime;
@property (nonatomic, strong)NSNumber<Optional> * Id;




@end
