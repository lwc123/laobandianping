//
//  UIWebView+Extension.m
//  JuXianBossComments
//
//  Created by juxian on 17/1/12.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "UIWebView+Extension.h"

@implementation UIWebView (Extension)

- (NSMutableURLRequest *)urlRequestWith:(NSString *)urlStr{

    NSString *AccessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"AccessToken"];
    NSString *DeviceKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceKey"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlStr]];
    [request setValue:DeviceKey forHTTPHeaderField:@"DeviceKey"];
    [request setValue:AccessToken forHTTPHeaderField:@"JX-TOKEN"];
    return request;
}


@end
