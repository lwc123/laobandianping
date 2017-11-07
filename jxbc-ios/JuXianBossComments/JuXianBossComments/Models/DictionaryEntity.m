
#import "DictionaryEntity.h"

@implementation DictionaryEntity

- (NSString*) getValueStr:(NSString*)code
{
    return [self.Data objectForKey:code];
}

- (NSMutableArray *)getChildrenKeys
{
    NSMutableArray* keys = [NSMutableArray alloc];
    for (NSString* key in self.Data.allKeys) {
        if(key.length == 3) {
            [keys addObject:key];
        }
    }
    return keys;
}

- (NSMutableArray *)getChildrenKeys:(NSString*)parentCode
{
    NSMutableArray* keys = [NSMutableArray alloc];
    for (NSString* key in self.Data.allKeys) {
        if(key.length > parentCode.length && [key hasPrefix:parentCode]){
            [keys addObject:key];
        }
    }
    return keys;
}

@end
