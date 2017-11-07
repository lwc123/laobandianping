//
//  JobEditAddressController.h
//  JuXianBossComments
//
//  Created by Jam on 17/1/16.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JXBasedViewController.h"

typedef void(^EndEditAddressblock)(NSString* address);

@interface JobEditAddressController : JXBasedViewController

- (void)completeEditText:(EndEditAddressblock)endEditAddressblock;

- (instancetype)initWithAddress:(NSString*)string;
@end
