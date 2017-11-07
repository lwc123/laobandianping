//
//  JobModel.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/6.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobModel : NSObject


//NSString *startDataStr,NSString *overDataStr,NSString *jobStr,NSString *moneyStr,NSString *doorStr

@property(nonatomic,copy)NSString<Optional> *startDataStr;
@property(nonatomic,copy)NSString<Optional> *overDataStr;
@property(nonatomic,copy)NSString<Optional> *jobStr;
@property(nonatomic,copy)NSString<Optional> *moneyStr;
@property(nonatomic,copy)NSString<Optional> *doorStr;


@end
