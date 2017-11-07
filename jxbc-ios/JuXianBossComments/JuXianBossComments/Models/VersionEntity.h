//
//  VersionEntity.h
//  JuXianBossComments
//
//  Created by Jam on 17/3/11.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

typedef NS_ENUM(NSUInteger, KUpgradeType) {
    CurrentNewest = 1,
    RecommendedUpdate = 2,
    ForcedUpdate = 3,
};

@interface VersionEntity : JSONModel

@property (nonatomic, assign) int ID;

//AppType (string, optional): 系统，android或ios ,
@property (nonatomic, copy) NSString <Optional> *AppType;

//UpgradeType (integer, optional): 更新策略枚举，参考枚举UpgradeType ,
@property (nonatomic, assign) KUpgradeType UpgradeType;

//VersionCode (string, optional): 当前版本号 ,
@property (nonatomic, copy) NSString <Optional> *VersionCode;

//VersionName (string, optional): 版本名称 ,
@property (nonatomic, copy) NSString <Optional> *VersionName;

//LowestSupportVersion (string, optional): 最低支持版本号 ,
@property (nonatomic, copy) NSString <Optional> *LowestSupportVersion;

//Description (string, optional): 升级说明 ,
@property (nonatomic, copy) NSString <Optional> *Description;

//DownloadUrl (string, optional): 下载地址 ,
@property (nonatomic, copy) NSString <Optional> *DownloadUrl;

//CreatedTime (string, optional): 发布时间 ,
@property (nonatomic, strong) NSDate <Optional> *CreatedTime;

//ModifiedTime (string, optional): 修改时间
@property (nonatomic, strong) NSDate <Optional> *ModifiedTime;

/*
 Version {
 VersionId (integer): ID ,
 AppType (string, optional): 系统，android或ios ,
 UpgradeType (integer, optional): 更新策略枚举，参考枚举UpgradeType ,
 VersionCode (string, optional): 当前版本号 ,
 VersionName (string, optional): 版本名称 ,
 LowestSupportVersion (string, optional): 最低支持版本号 ,
 Description (string, optional): 升级说明 ,
 DownloadUrl (string, optional): 下载地址 ,
 CreatedTime (string, optional): 发布时间 ,
 ModifiedTime (string, optional): 修改时间
 }
 */

@end
