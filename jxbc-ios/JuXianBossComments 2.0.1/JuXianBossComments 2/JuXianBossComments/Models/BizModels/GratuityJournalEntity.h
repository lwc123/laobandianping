




#import <JSONModel/JSONModel.h>

@interface GratuityJournalEntity : JSONModel

@property (nonatomic,assign)long JournalId;
@property (nonatomic,assign)int BizType;
@property (nonatomic,assign)long BizId;
@property (nonatomic,assign)long BuyerId;
@property (nonatomic,assign)long SellerId;
@property (nonatomic,assign)double TotalFee;

@property (nonatomic,strong)NSDate<Optional> *ModifiedTime;

@property (nonatomic,strong)JXUserProfile<Optional> *Profile;

@end