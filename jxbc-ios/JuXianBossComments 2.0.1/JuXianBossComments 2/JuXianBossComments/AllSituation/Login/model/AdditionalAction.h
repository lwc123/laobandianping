//
//  AdditionalAction.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/1.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@interface AdditionalAction : JSONModel

@property (nonatomic ,copy)NSString *ActionType;
/**来源*/
@property (nonatomic ,copy)NSString *Source;


@end
