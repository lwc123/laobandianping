//
//  JSONValueTransformer+NSDate.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/27.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface JSONValueTransformer (NSDate)

-(NSDate*)NSDateFromNSString:(NSString*)string;
-(id)JSONObjectFromNSDate:(NSDate*)date;

@end
