//
//  PackageVersion.h
//  JuXianTalentBank
//
//  Created by 马欣欣 on 15/8/3.
//  Copyright (c) 2015年 Max. All rights reserved.
//

#import "JSONModel.h"

@interface PackageVersion : JSONModel
{
    
}
//当前版本的属性信息
@property (nonatomic,strong)NSString *VersionName;
@property (nonatomic,strong)NSString *Description;
@property (nonatomic,strong)NSString *DownloadUrl;
@property (nonatomic,assign)BOOL EnforcedUpgrades;


@end
