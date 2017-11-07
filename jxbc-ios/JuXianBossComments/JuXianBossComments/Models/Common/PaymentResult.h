#import <JSONModel/JSONModel.h>

@interface PaymentResult : JSONModel

@property (nonatomic,copy)NSString<Optional> *TradeCode;
@property (nonatomic,copy)NSString<Optional> *TargetBizTradeCode;
@property (nonatomic,assign)bool Success;
@property (nonatomic,copy)NSString<Optional> *PayWay;
@property (nonatomic,copy)NSString<Optional> *PaidDetail;
@property (nonatomic,copy)NSString<Optional> *ErrorCode;
@property (nonatomic,copy)NSString<Optional> *ErrorMessage;
@property (nonatomic,copy)NSString<Optional> *SignedParams;


@end
