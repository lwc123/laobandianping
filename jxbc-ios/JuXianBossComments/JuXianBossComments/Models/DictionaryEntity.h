
#import <JSONModel/JSONModel.h>

@interface DictionaryEntity : JSONModel
@property (nonatomic, strong)NSString<Optional> *Code;
@property (nonatomic, strong)NSDate<Optional> *Expires;
@property (nonatomic, strong)NSArray<Optional> *Keys;
@property (nonatomic, strong)NSDictionary<Optional> *Data;

- (NSString*) getValueStr:(NSString*)code;
- (NSMutableArray*) getChildrenKeys;
- (NSMutableArray*) getChildrenKeys:(NSString*)code;

@end
