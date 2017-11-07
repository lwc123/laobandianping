//
//  PublicUseMethod.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/10.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "PublicUseMethod.h"
#import "JXBasedNavigationController.h"

#define APPDELEGATE     ((AppDelegate*)[[UIApplication sharedApplication] delegate])


@implementation PublicUseMethod


+ (BOOL)textField:(UITextField *)textField length:(int)length{

    textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([textField.text length] > length) {
        textField.text = [textField.text substringToIndex:length];
        return NO;
    }
    return YES;
}

//判断手机是否合法
//手机号验证方法
+ (BOOL)isMobileNumber:(NSString *)mobileNum{
    NSString *MOBILE= @"^1\\d{10}$";
    NSString *CM=@"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString *CU =  @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString *CT =@"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate*regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT];
    if(([regextestmobile evaluateWithObject:mobileNum]==YES)||([regextestcm evaluateWithObject:mobileNum]==YES)||([regextestct evaluateWithObject:mobileNum]==YES)||([regextestcu evaluateWithObject:mobileNum]==YES))
    {
        return YES;
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }

}

+ (NSString *)valiMobile:(NSString *)mobile{
    if (mobile.length < 11)
    {
        return @"手机号长度只能是11位";
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return nil;
        }else{
            return @"请输入正确的电话号码";
        }
    }
    return nil;
}


+ (void)showAlertView:(NSString *)messageString{
    NSString *title = @"温馨提示";
    if (!messageString || [messageString isEqualToString:@""]) {
        return;
    }
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    alert.view.tintColor = [UIColor orangeColor];//按钮的颜色
    
    [PublicUseMethod getAlertPromptLabelWith:alert.view];
    
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:title];
    
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:16]
                  range:[title rangeOfString:title]];
    [alert setValue:hogan forKey:@"attributedTitle"];
    
    if (messageString.length!=0) {
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:messageString];
        [message addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:13]
                        range:[messageString rangeOfString:messageString]];
        [alert setValue:message forKey:@"attributedMessage"];
    }
    
    [APPDELEGATE.window.rootViewController presentViewController:alert animated:YES completion:nil];
//
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
    


}

+ (void)getAlertPromptLabelWith:(UIView*)supView
{
    if ([supView isKindOfClass:[UILabel class]])
    {
        supView.backgroundColor = [[UIColor clearColor]colorWithAlphaComponent:0];
    }
    if ([supView isKindOfClass:[UIView class]])
    {
        supView.frame = CGRectMake(0, 0, 200, 100);
    }
    if ([supView isKindOfClass:NSClassFromString(@"_UIAlertControllerShadowedScrollView")]) {
        //        supView.backgroundColor = [UIColor greenColor];
        //        supView.tintColor = [UIColor greenColor];
    }
    for (UIView *view in supView.subviews) {
        [self getAlertPromptLabelWith:view];
    }
}


//改变跟视图
+(void)goViewController:(Class)cls{
    UIViewController *vc = [[cls alloc] init];
    UIWindow *window =[[[UIApplication sharedApplication] delegate] window];
    window.rootViewController =vc;
    
}

+(void)goViewControllerWithNav:(Class)cls{
    UIViewController *vc = [[cls alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    UIWindow *window =[[[UIApplication sharedApplication]delegate]window];
    window.rootViewController =nav;
}

//+(void)changeRootViewController:(UIViewController *)vc{
//    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
//    window.rootViewController =vc;
//}

+(void)changeRootNavController:(UIViewController *)vc
{
    JXBasedNavigationController *nav = [[JXBasedNavigationController alloc] initWithRootViewController:vc];
    UIWindow *window =[[[UIApplication sharedApplication]delegate]window];
    window.rootViewController =nav;
}

+(void)changeRootViewController:(UIViewController *)vc{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    window.rootViewController =vc;
}

+ (UIColor *)setColor:(NSString *)hexColor{

    if (hexColor) {
        unsigned int red, green, blue;
        NSRange range;
        range.length = 2 ;
        range.location = 0 ;
        [[NSScanner scannerWithString:[hexColor substringWithRange :range]] scanHexInt :&red];
        
        range.location = 2 ;
        [[ NSScanner scannerWithString :[hexColor substringWithRange :range]] scanHexInt :&green];
        
        range.location = 4 ;
        [[ NSScanner scannerWithString:[hexColor substringWithRange :range]] scanHexInt :&blue];
        //NSLog(@"red  %d   green  %d  blue   %d",red,green,blue);
        return [UIColor colorWithRed :(float)(red/255.0f) green :(float)(green/ 255.0f ) blue:(float)(blue/255.0f ) alpha : 1.0f ];
    }
    return nil;
}


//等比压缩图片
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)sourceImage size:(CGSize)size{    
    UIImage *newImage = nil;
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width * screenScale;
    CGFloat targetHeight = size.height * screenScale;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    
    if (CGSizeEqualToSize(imageSize, size) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor;
        }
        else
        {
            scaleFactor = heightFactor;
        }
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

//像素压缩
+ (UIImage *)transformWidth:(CGFloat)width height:(CGFloat)height with:(UIImage *)sourceImage{

    CGFloat destW = width;
    CGFloat destH = height;
    CGFloat sourceW = width;
    CGFloat sourceH = height;
    
    CGImageRef imageRef = sourceImage.CGImage;
    CGContextRef bitmap = CGBitmapContextCreate(NULL,destW,
                                                destH,CGImageGetBitsPerComponent(imageRef),4*destW,CGImageGetColorSpace(imageRef),(kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    CGContextDrawImage(bitmap, CGRectMake(0, 0, sourceW, sourceH), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:ref];
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    return result;
}
//照片选择
+ (void)pickerImageChannelWithImageController:(UIImagePickerController *)imagePickerCtr andViewController:(UIViewController *)vc{
    imagePickerCtr.allowsEditing = YES;//SC.XJH.12.13注释
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"上传照片" message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"本地相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            //UIImagePickerControllerSourceTypePhotoLibrary
            imagePickerCtr.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [vc presentViewController:imagePickerCtr animated:YES completion:nil];
        }else{
            Log(@"不支持图库");
        }
        
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"去拍美照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePickerCtr.sourceType = UIImagePickerControllerSourceTypeCamera;
            [vc presentViewController:imagePickerCtr animated:YES completion:nil];
        }else{
            Log(@"不支持相机");
        }
        
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [alertVC addAction:action3];
    [vc presentViewController:alertVC animated:YES completion:nil];
}



+(UIImage *)fixOrientationForImage:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//?????
+(NSString *)moneyFormatWith:(NSString *)moneyStr{
    if ([[moneyStr substringWithRange:NSMakeRange(moneyStr.length-1, 1)] intValue]==0)
    {
        
        moneyStr = [moneyStr substringToIndex:moneyStr.length-1];
        //SC.XJH.6.8
        //        moneyStr = [moneyStr substringToIndex:moneyStr.length];
        return moneyStr;
    }else{
        
        return moneyStr;
    }
}


+ (void)colorWear:(UIView *)view{
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame =CGRectMake(0,0,view.frame.size.width,view.frame.size.height);
    
    gradient.colors = [NSArray arrayWithObjects:
                       
                       (id)[PublicUseMethod setColor:@"DCC37F"].CGColor,
                       
                       (id)[PublicUseMethod setColor:@"F7E6B9"].CGColor,
                       
                       (id)[PublicUseMethod setColor:@"AF8F4D"].CGColor,
                       
                       nil];
    
    [view.layer insertSublayer:gradient atIndex:0];
    
}



+ (BOOL)validateEmail:(NSString *)email{

    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


+ (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle okTitle:(NSString *)okTitle{
    
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:message];
    [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0,message.length)];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController setValue:hogan forKey:@"attributedTitle"];
    
    //取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    //确定
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        
    }];
    
    //设置cancelAction的title颜色
    [cancelAction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
    //设置cancelAction的title的对齐方式
    [cancelAction setValue:[NSNumber numberWithInteger:NSTextAlignmentCenter] forKey:@"titleTextAlignment"];
    //设置okAction的title颜色
    [otherAction setValue:[PublicUseMethod setColor:KColor_MainColor] forKey:@"titleTextColor"];
    
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [APPDELEGATE.window.rootViewController presentViewController:alertController animated:YES completion:nil];

}

+ (BOOL)verifyIDCardNumber:(NSString *)value
 {
     value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     if ([value length] != 18) {
         return NO;
     }
     NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
     NSString *leapMmdd = @"0229";
     NSString *year = @"(19|20)[0-9]{2}";
     NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
     NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
     NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
     NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
     NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
     NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];

     NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
     if (![regexTest evaluateWithObject:value]) {
         return NO;
     }
     int summary = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7
             + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9
             + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10
             + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5
             + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8
             + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4
             + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2
             + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6
             + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
     NSInteger remainder = summary % 11;
     NSString *checkBit = @"";
     NSString *checkString = @"10X98765432";
     checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
     return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]];
 }


+ (BOOL)isCorrect:(NSString *)IDNumber
{
    NSMutableArray *IDArray = [NSMutableArray array];
    // 遍历身份证字符串,存入数组中
    for (int i = 0; i < 18; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [IDNumber substringWithRange:range];
        [IDArray addObject:subString];
    }
    // 系数数组
    NSArray *coefficientArray = [NSArray arrayWithObjects:@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2", nil];
    // 余数数组
    NSArray *remainderArray = [NSArray arrayWithObjects:@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2", nil];
    // 每一位身份证号码和对应系数相乘之后相加所得的和
    int sum = 0;
    for (int i = 0; i < 17; i++) {
        int coefficient = [coefficientArray[i] intValue];
        int ID = [IDArray[i] intValue];
        sum += coefficient * ID;
    }
    // 这个和除以11的余数对应的数
    NSString *str = remainderArray[(sum % 11)];
    // 身份证号码最后一位
    NSString *string = [IDNumber substringFromIndex:17];
    // 如果这个数字和身份证最后一位相同,则符合国家标准,返回YES
    if ([str isEqualToString:string]) {
        return YES;
    } else {
        return NO;
    }
}


@end
