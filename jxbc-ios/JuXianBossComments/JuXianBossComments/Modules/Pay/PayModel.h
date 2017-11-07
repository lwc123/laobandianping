//
//  payModel.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/5.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayModel : NSObject
@property (nonatomic,strong)id model;//外部传入的参数模型
//真正需要作为请求参数的字符
//@property (nonatomic,strong)NSString * paymentInterfaceCode;//支付渠道
@property (nonatomic,assign)long productId;//服务id
@property (nonatomic,strong)NSNumber *number;//购买个数
@property (nonatomic,strong)NSNumber *productType;//服务类型
@property (nonatomic,strong)NSString *bizType;
@property (nonatomic,assign)double price;
//打赏
@property (nonatomic,assign)long PrimaryId;
@property (nonatomic,strong)NSNumber *RMB;
@end
