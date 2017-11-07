//
//  UserSummaryModel.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/4/22.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface UserSummaryModel : JSONModel
//@property (nonatomic, strong)JXUserProfile<Optional> *Profile;
@property (nonatomic, assign)double WalletBalance;
@property (nonatomic, assign)int ResumeIntegrality;
@property (nonatomic ,strong)JXUserProfile<Optional> *UserProfile;
//@property (nonatomic ,strong)JXConsultantProfile<Optional> *ConsultantProfile;

//Boss  只有一个model (里面实现改了)
- (JXUserProfile*)getProfile;

@end
