//
//  JobEditPhoneNumberController.h
//  JuXianBossComments
//
//  Created by Jam on 17/1/16.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JXBasedViewController.h"

typedef void(^EndEditPhoneNumBlock)(NSString* string);

@interface JobEditPhoneNumberController : JXBasedViewController

-(void)completeEditPhoneNumHandle:(EndEditPhoneNumBlock)endEditPhoneNumBlock;

- (instancetype)initWithPhoneNum:(NSString*)string;


@end
