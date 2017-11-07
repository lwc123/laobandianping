//
//  ChoiceCompanyCell.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/2.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyMembeEntity.h"
#import "CompanyModel.h"

//添加离任评价也用 
@interface ChoiceCompanyCell : UITableViewCell

//有Model

@property (weak, nonatomic) IBOutlet UIButton *watiBtn;

@property (weak, nonatomic) IBOutlet UILabel *companyLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (nonatomic,strong)CompanyMembeEntity * membeEntity;
@property (nonatomic,strong) CompanyModel * companyModel;

@end
