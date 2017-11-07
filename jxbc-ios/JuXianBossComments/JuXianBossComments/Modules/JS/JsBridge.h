//
//  JsBridge.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/2.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

//#import <>
@protocol JsBridgeProtocol <JSExport>
//js端调用此方法；
JSExportAs(gotoNativePage,
           - (void)gotoNativePageWith:(NSString *)pageName with:(NSString *)pageParams
           );
- (NSString*)getAppInfo;
@end


@interface JsBridge : NSObject<JsBridgeProtocol>

@property (nonatomic,strong)UIViewController *viewcontroller;

+ (void)initForWebView:(UIWebView*)webView with:(UIViewController*)vc;
- (id)initWithVC:(UIViewController*)VC;


@end
