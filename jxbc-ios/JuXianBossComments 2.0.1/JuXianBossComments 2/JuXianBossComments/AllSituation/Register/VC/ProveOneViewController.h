//
//  ProveOneViewController.h
//  JuXianBossComments
//
//  Created by juxian on 16/11/18.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXBasedViewController.h"
#import "ExpectJobModel.h"

/*认证第一步*/
@interface ProveOneViewController : JXBasedViewController

/**城市*/
@property (weak, nonatomic) IBOutlet UITextField *cityTF;
@property (nonatomic,copy)NSString *cityCodeStr;//城市
@property (nonatomic,copy)NSString *sizeCodeStr;//规模

@property (nonatomic,strong)ExpectJobModel *model;
@property (nonatomic,copy)NSString *copanyName;
@property (nonatomic,assign)long companyId;
@property (nonatomic,assign)NSInteger auditStatus;
@property (nonatomic,strong)CompanyModel *companyModel;
@property (nonatomic, assign) BOOL canPop;

@end
