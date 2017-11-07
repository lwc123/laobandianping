//
//  PayRecodeEntity.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/19.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "TradeJournalEntity.h"
@protocol TradeJournalEntity;

@interface PayRecodeEntity : JSONModel

@property (nonatomic,strong)NSArray<TradeJournalEntity> *tradeJournalEntity;

@end
