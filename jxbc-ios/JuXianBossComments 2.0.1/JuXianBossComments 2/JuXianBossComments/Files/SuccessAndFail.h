//
//  SuccessAndFail.h
//  JuXianTalentBank
//
//  Created by 马欣欣 on 15/8/3.
//  Copyright (c) 2015年 Max. All rights reserved.
//

#ifndef JuXianTalentBank_SuccessAndFail_h

#define JuXianTalentBank_SuccessAndFail_h

#define CreateNew_Success @"CreateNew_Success"
#define CreateNew_Fail @"CreateNew_Fail"

#define SignIn_Success @"SignIn_Success"//登录
#define SignIn_Fail @"SignIn_Fail"

#define IsExistsMobilePhone_Success @"IsExists_Success"
#define IsExistsMobilePhone_Fail @"IsExists_Fail"

#define SignUp_Success @"SignUp_Success"//注册
#define SignUp_Fail @"SignUp_Fail"


#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)]? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size):NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


#define UMAppKey @"55cb166ae0f55a4a5a001c9e"
#define boardColor [UIColor lightGrayColor].CGColor
#define widthBili [UIScreen mainScreen].bounds.size.width/320.0

//-------------------获取设备大小-------------------------
///NavBar高度
#define NavigationBar_HEIGHT 44
///获取屏幕 宽度、高度
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
//打印当前方法的名称
#define ITTDPRINTMETHODNAME() ITTDPRINT(@"%s", __PRETTY_FUNCTION__)
//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]
//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
//判断设备的操做系统是不是ios7

#define IsIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0 ? YES : NO)

//R,G,B  色值
#define setColorWithRGB(R,G,B)  [UIColor colorWithRed:R/255.0  green:G/255.0 blue:B/255.0 alpha:1.0];




/**
 *  判断是否为ios7
 *
 *	@return	判断结果（YES:是 NO:不是）
 */
#define system_7 ([[[UIDevice currentDevice] systemVersion] floatValue])>= 7.0
#define system_8 ([[[UIDevice currentDevice] systemVersion] floatValue])>= 8.0


#define IS_IPHONE_4  [UIScreen mainScreen].bounds.size.height == 480
#define IS_IPHONE_5  [UIScreen mainScreen].bounds.size.height == 568
#define IS_IPHONE_6  [UIScreen mainScreen].bounds.size.height == 667
#define IS_IPHONE_6Plus  [UIScreen mainScreen].bounds.size.height == 736

//主色调
#define mainColor [UIColor colorWithRed:255/255.f green:46/255.f blue:77/255.f alpha:1]


//iPhone Simulator

//检查系统版本
#define System_Version_Equal_To(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define System_Version_Greater_Than(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define System_Version_Greater_Than_OR_Equal_To(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define System_Version_Less_Than(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define System_Version_Less_Than_OR_Equal_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//----------------------内存----------------------------
//读取本地图片
#define LocalImage(file,ext) [UIImage imageWithContentsOfFile:［NSBundle mainBundle]pathForResource:file ofType:ext］

//定义UIImage对象
#define Image(A) [UIImage imageWithContentsOfFile:［NSBundle mainBundle] pathForResource:A ofType:nil］

//定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer］
//-----------------------颜色类------------------------------
//最常用的是16进制转化成RGB==>PublicUseMain方法里
//背景色
#define BackgroundColor [UIColor colorWithRed:242.0/255.0 green:236.0/255.0 blue:231.0/255.0 alpha:1.0]
//颜色
#define JXColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//设置一个全局tableview的背景颜色
#define JXGlobleTableViewBackgroundColor JXColor(239,239,239)
//清除背景色
#define ClearColor [UIColor clearColor]



// RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//------------------------其他-------------------------------
//方正黑体简体字体定义
#define SetFont(F) [UIFont fontWithName:@"FZLanTingHei-L-GBK" size:F]

//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

//NSUserDefaults 实例化
#define CreateUserDefault [NSUserDefaults standardUserDefaults]



#define TencentQQ_KEY       @"tencent1104812536"

#endif


