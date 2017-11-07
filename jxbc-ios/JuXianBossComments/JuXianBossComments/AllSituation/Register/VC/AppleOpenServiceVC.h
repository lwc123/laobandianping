//
//  AppleOpenServiceVC.h
//  JuXianBossComments
//
//  Created by juxian on 17/1/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

//#import "JXBasedViewController.h"
#import "JXTableViewController.h"
#import <StoreKit/StoreKit.h>
@interface AppleOpenServiceVC : JXTableViewController<SKPaymentTransactionObserver,SKProductsRequestDelegate>{
    int buyType;
}
@property (nonatomic,strong)PaymentEntity *entity;
@property (nonatomic, strong) UIViewController *secondP;

- (void) requestProUpgradeProductData;

-(void)RequestProductData;

-(void)buy:(int)type;

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;

-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction;

- (void) completeTransaction: (SKPaymentTransaction *)transaction;

- (void) failedTransaction: (SKPaymentTransaction *)transaction;

-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction;

-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error;

- (void) restoreTransaction: (SKPaymentTransaction *)transaction;

-(void)provideContent:(NSString *)product;

-(void)recordTransaction:(NSString *)product;

@end
