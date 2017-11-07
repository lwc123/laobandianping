//
//  ApplePayValidate.m
//  JuXianBossComments
//
//  Created by easemob on 2017/1/19.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "ApplePayValidate.h"
#import "PaymentResult.h"

@implementation ApplePayValidate

+ (void)validateApplePay{
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    NSArray *savedReceipts = [storage arrayForKey:@"receipts"];
    if (savedReceipts) {
        for (PaymentResult *completResult in savedReceipts) {
            [self applePayProvingWith:completResult];
        }
    }
}

+ (void)applePayProvingWith:(PaymentResult *)completResult {
    
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    NSArray *savedReceipts = [storage arrayForKey:@"receipts"];
//    __weak typeof(self) weakSelf = self;
    [PaymentRepository paymentCompleted:completResult success:^(PaymentResult * result) {
        if (result.Success) {
            [PublicUseMethod showAlertView:@"购买成功"];
            [[NSUserDefaults standardUserDefaults] setObject:result.TargetBizTradeCode forKey:CompanyChoiceKey];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            if (savedReceipts) {
                NSMutableArray *savedReceiptsM = savedReceipts.mutableCopy;
                [savedReceiptsM removeObject:completResult];
                NSArray *updatedReceipts = savedReceiptsM.copy;
                if (updatedReceipts.count==0) {
                    [storage removeObjectForKey:@"receipts"];
                    [storage synchronize];
                }else{
                    [storage setObject:updatedReceipts forKey:@"receipts"];
                    [storage synchronize];
                }
            }
//            [weakSelf performSelector:@selector(payDetailView:) withObject:result afterDelay:0.5];
        }else{
            [PublicUseMethod showAlertView:result.ErrorMessage];
        }
    } fail:^(NSError * error) {
        
        if (!savedReceipts) {
            //判断取出的数组有没有，如果没有，则新保存@"receipts"字段的数据
            [storage setObject:@[completResult] forKey:@"receipts"];
        } else {
            //本地如果有保存过数据，则在保存的数组中再加一个新保存的数据
            __block BOOL isSaved=NO;
            [savedReceipts enumerateObjectsUsingBlock:^(PaymentResult *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqual:completResult]) {
                    isSaved=YES;
                }
            }];
            if (!isSaved) {
                NSArray *updatedReceipts = [savedReceipts arrayByAddingObject:completResult];
                [storage setObject:updatedReceipts forKey:@"receipts"];
            }
        }
        //保存
        [storage synchronize];
        [UserAuthentication SavePayEntity:completResult];
        [PublicUseMethod showAlertView:error.localizedDescription];
        [self faile];
    }];
}

+ (void)faile{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"后台数据错误，请店家重试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self recetcomplant];
}

+ (void)recetcomplant{
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    NSArray *savedReceipts = [storage arrayForKey:@"receipts"];
    for (PaymentResult *completResult in savedReceipts) {
        [self applePayProvingWith:completResult];
    }
}

@end
