//
//  AppleOpenServiceVC.m
//  JuXianBossComments
//
//  Created by juxian on 17/1/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "AppleOpenServiceVC.h"
#import "ApplePayCell.h"
#import "paySucessVC.h"
#import "JXIapProductCodeEntity.h"
#import "UserOpenVipVC.h"
#import "AccountRepository.h"
#import "SetingVC.h"
#import "JXOpenServiceWebVC.h"

#define ProductID @"com.juxian.bosscomments.1"
#define UserProductID @"OpenPersonalService.default"

enum{
    IAPPro20=20,
    IAPPro100,
}JHbuyCoinsTag;

@interface AppleOpenServiceVC ()<ApplePayCellDelegate,UIAlertViewDelegate>{

    NSString * _applePayStr;
}

@property (nonatomic, strong) NSArray *savedReceipts;
@property (nonatomic, strong) PaymentResult *completResult;
@property (nonatomic,strong)JXIapProductCodeEntity * productEntity;

@end

@implementation AppleOpenServiceVC


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    _savedReceipts = [storage arrayForKey:@"receipts"];
    if (_savedReceipts) {
        [self recetcomplant];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    [self isShowLeftButton:YES];
    _productEntity = [[JXIapProductCodeEntity alloc] init];
    [self initUI];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

}

- (void)initUI{

    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.jxTableView.scrollEnabled = NO;
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.jxTableView registerNib:[UINib nibWithNibName:@"ApplePayCell" bundle:nil] forCellReuseIdentifier:@"applePayCell"];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 224;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ApplePayCell * cell = [tableView dequeueReusableCellWithIdentifier:@"applePayCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.moneyLabel.text = [NSString stringWithFormat:@"支付金额：%1.f元",self.entity.TotalFee];
    cell.sayLabel.text = [NSString stringWithFormat:@"支付说明：%@",self.entity.CommoditySubject];
    cell.totalMoneyLabel.textColor = [PublicUseMethod setColor:KColor_RedColor];
    NSString  * myStr = [NSString stringWithFormat:@"应支付：%1.f元",self.entity.TotalFee];
    
    NSRange range = [myStr rangeOfString: @"应支付："];
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:myStr];
    [str addAttribute:NSForegroundColorAttributeName value:[PublicUseMethod setColor:KColor_Text_EumeColor] range:range];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range];
    cell.totalMoneyLabel.attributedText = str;
    return cell;
}

- (void)ApplePayCellDidClickedPayBtn:(ApplePayCell *)applePayCell{

    applePayCell.payBtn.enabled = NO;
    self.entity.PayWay = PaymentEngine.PayWays_AppleIAP;
    __weak typeof(self) weakSelf = self;
    [self showLoadingIndicator];
    [PaymentRepository createTrade:self.entity success:^(PaymentResult * result) {
        
        applePayCell.payBtn.enabled = YES;
        [weakSelf dismissLoadingIndicator];
        
        if (result.Success) {
            
            _productEntity = [[JXIapProductCodeEntity alloc] initWithString:result.SignedParams error:nil];
            weakSelf.entity.TradeCode = result.TradeCode;
            
             [self buy:IAPPro20];
        }else{
            [PublicUseMethod showAlertView:result.ErrorMessage];
        }        
    } fail:^(NSError * error) {
        
        applePayCell.payBtn.enabled = YES;
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];
        
    }];

}


-(void)buy:(int)type
{
    buyType = type;
    if ([SKPaymentQueue canMakePayments]) {
        
        [self RequestProductData];
        NSLog(@"允许程序内付费购买");
    }
    else
    {
        NSLog(@"不允许程序内付费购买");
        [PublicUseMethod showAlertView:@"您的手机没有打开程序内付费购买"];
    }
}

-(void)RequestProductData
{
    [self showLoadingIndicator];
    NSLog(@"---------请求对应的产品信息------------");
    NSArray *product = nil;
    switch (buyType) {
            
        case IAPPro20:
            product=[[NSArray alloc] initWithObjects:_productEntity.ProductCode,nil];
            break;
            
        default:
            break;
    }
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers: nsset];
    request.delegate=self;
    [request start];
    
}

//<SKProductsRequestDelegate> 请求协议
//收到的产品信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSLog(@"-----------收到产品反馈信息--------------");
    NSArray *myProduct = response.products;
    
    NSLog(@"产品Product ID:%@",response.invalidProductIdentifiers);
    
    
    NSLog(@"产品付费数量: %d", (int)[myProduct count]);
    // populate UI
    for(SKProduct *product in myProduct){
        NSLog(@"product info");
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题 %@" , product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        
        _applePayStr = [NSString stringWithFormat:@"%@",product.price];
        NSLog(@"Product id: %@" , product.productIdentifier);
    }
    SKPayment *payment = nil;
    switch (buyType) {
        case IAPPro20:
            payment  = [SKPayment paymentWithProductIdentifier:_productEntity.ProductCode];    //支付25
            
            break;
        default:
            break;
    }
    NSLog(@"---------发送购买请求------------");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}
- (void)requestProUpgradeProductData
{
    NSLog(@"------请求升级数据---------");
    NSSet *productIdentifiers = [NSSet setWithObject:@"com.productid"];
    SKProductsRequest* productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
}
//弹出错误信息
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"-------弹出错误信息----------%@",error);
    [self dismissLoadingIndicator];
}

-(void) requestDidFinish:(SKRequest *)request
{
    NSLog(@"----------反馈信息结束--------------");
    [self dismissLoadingIndicator];
}

-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"-----PurchasedTransaction----");
    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
}

//  <SKPaymentTransactionObserver> 千万不要忘记绑定，代码如下：
//----监听购买结果
//[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
#pragma mark -- 发送购
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    
    for(SKPaymentTransaction *tran in transaction){
        
        switch (tran.transactionState) {
                
            case SKPaymentTransactionStatePurchased:
                NSLog(@"交易成功");
                [self completeTransaction:tran];

                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                [self restoreTransaction:tran];//恢复购买
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:tran];
                break;
            default:
                break;
        }
    }
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    // 恢复已经购买的产品
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

#pragma mark -- 购买完成
- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    PaymentResult *completResult = [[PaymentResult alloc] init];
    _completResult = completResult;
    completResult.Success = true;
    NSString *transactionReceiptString= nil;
    //系统IOS7.0以上获取支付验证凭证的方式应该改变，切验证返回的数据结构也不一样了。
    if([[UIDevice currentDevice].systemVersion floatValue]>=7.0)
    {
        NSURLRequest*appstoreRequest = [NSURLRequest requestWithURL:[[NSBundle mainBundle] appStoreReceiptURL]];
        
        NSError *error = nil;
        NSData * receiptData = [NSURLConnection sendSynchronousRequest:appstoreRequest returningResponse:nil error:&error];
        
        transactionReceiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    } else{
        
        NSData * receiptData = transaction.transactionReceipt;
        transactionReceiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    completResult.PaidDetail = transactionReceiptString;
    NSLog(@"completResult.PaidDetail===%@",completResult.PaidDetail);
    completResult.TradeCode = self.entity.TradeCode;
    completResult.PayWay = self.entity.PayWay;
    
    NSString *product = transaction.payment.productIdentifier;
    if ([product length] > 0) {
        
        NSArray *tt = [product componentsSeparatedByString:@"."];
        NSString *bookid = [tt lastObject];
        if ([bookid length] > 0) {
            //向服务器验证购买凭证
            [self applePayProvingWith:completResult];
            [self recordTransaction:bookid];
            [self provideContent:bookid];
        }
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

#pragma mark -- 向服务器验证购买凭证
- (void)applePayProvingWith:(PaymentResult *)completResult {
    
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    NSData *newReceipt = [[NSData alloc]initWithBase64EncodedString:completResult.PaidDetail options:NSDataBase64DecodingIgnoreUnknownCharacters];
    _savedReceipts = [storage arrayForKey:@"receipts"];  //这一步是从本地取以@"receipts"字段保存的数组
    
    
    __weak typeof(self) weakSelf = self;
    [self showLoadingIndicator];
    [PaymentRepository paymentCompleted:completResult success:^(PaymentResult * result) {
        [weakSelf dismissLoadingIndicator];        
        NSLog(@"result===%@",result);
        
        if (result.Success) {
            [PublicUseMethod showAlertView:@"购买成功"];
            
            if ([self.secondP isKindOfClass:[UserOpenVipVC class]] || [self.secondP isKindOfClass:[JXOpenServiceWebVC class]]) {//个人支付

            }else{
            
                [[NSUserDefaults standardUserDefaults] setObject:result.TargetBizTradeCode forKey:CompanyChoiceKey];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            [weakSelf performSelector:@selector(payDetailView:) withObject:result afterDelay:0.5];
        }else{
            
            if (_savedReceipts) {
                NSMutableArray *savedReceiptsM = _savedReceipts.mutableCopy;
                
                NSData *receipt = [[NSData alloc]initWithBase64EncodedString:result.PaidDetail options:NSDataBase64DecodingIgnoreUnknownCharacters];
                
                [savedReceiptsM removeObject:receipt];
                NSArray *updatedReceipts = savedReceiptsM.copy;
                if (updatedReceipts.count==0) {
                    [storage removeObjectForKey:@"receipts"];
                    [storage synchronize];
                }else{
                    [storage setObject:updatedReceipts forKey:@"receipts"];
                    [storage synchronize];
                }
            }
            [PublicUseMethod showAlertView:result.ErrorMessage];
        }
    } fail:^(NSError * error) {
        [weakSelf dismissLoadingIndicator];
        [weakSelf faile:error];
        if (!_savedReceipts) {
            //判断取出的数组有没有，如果没有，则新保存@"receipts"字段的数据
            [storage setObject:@[newReceipt] forKey:@"receipts"];
        } else {
            //本地如果有保存过数据，则在保存的数组中再加一个新保存的数据
            __block BOOL isSaved=NO;
            [_savedReceipts enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToData:newReceipt]) {
                    isSaved=YES;
                }
            }];
            if (!isSaved) {
                NSArray *updatedReceipts = [_savedReceipts arrayByAddingObject:newReceipt];
                [storage setObject:updatedReceipts forKey:@"receipts"];
            }
        }
        //保存
        [storage synchronize];
        [UserAuthentication SavePayEntity:completResult];
        [PublicUseMethod showAlertView:error.localizedDescription];
        
    }];
}

- (void)faile:(NSError*)error{
    // 请求超时 提示失败 重新加载
    if (error.code == -1001) { // 请求超时
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络链接超时,请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"重试", nil];
        [alert show];
        
    }else if (error.code == -1009) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络好像断开了,请检查网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"重试", nil];
        [alert show];
        
    }else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@",error.localizedDescription] delegate:self cancelButtonTitle:nil otherButtonTitles:@"重试", nil];
        [alert show];
    }
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    [self recetcomplant];
}

- (void)recetcomplant{
    [self applePayProvingWith:_completResult];
}

-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction{}

//记录交易
-(void)recordTransaction:(NSString *)product{
    NSLog(@"-----记录交易--------");
}

//处理下载内容
-(void)provideContent:(NSString *)product{
    NSLog(@"-----下载--------");
}
- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    
    [PublicUseMethod showAlertView:transaction.error.localizedDescription];
    
    NSLog(@"失败");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"dddd");
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"-------paymentQueue----");
}

#pragma mark connection delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%@",  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    switch([(NSHTTPURLResponse *)response statusCode]) {
        case 200:
        case 206:
            break;
        case 304:
            break;
        case 400:
            break;
        case 404:
            break;
        case 416:
            break;
        case 403:
            break;
        case 401:
        case 500:
            break;
        default:
            break;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"test");
}

#pragma mark -- 详情页
- (void)payDetailView:(PaymentResult *)payResult{
    
    NSDictionary *dic;
    //    服务购买成功
    if ([self.entity.PayWay isEqualToString:PaymentEngine.PayWays_AppleIAP]) {
        dic = @{@"payWay":@"苹果内购",@"money":_applePayStr};
        UMApplePaySuccessEvent(dic);
    }
    paySucessVC * oneVC = [[paySucessVC alloc]init];
    
    if ([self.secondP isKindOfClass:[UserOpenVipVC class]]) {
        dic = @{@"payWay":@"个人开户",@"money":_applePayStr};
        UMApplePaySuccessEvent(dic);
        
        oneVC.secondVC = self.secondP;//个人购买
    }else{
        oneVC.secondVC = self;//企业购买
    }

    if ([self.secondP isKindOfClass:[SetingVC class]]){//个人切换企业的时候
        JXOrganizationProfile * pp = [[JXOrganizationProfile alloc] init];
        pp.CurrentOrganizationId = [payResult.TargetBizTradeCode longLongValue];
        [self changeCurrentToOrganizationProfileWith:pp and:oneVC];
        
    }else{
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([self.secondP isKindOfClass:[UserOpenVipVC class]] || [self.secondP isKindOfClass:[JXOpenServiceWebVC class]]) {
                oneVC.secondVC = self.secondP;//个人购买
                [self.navigationController pushViewController:oneVC animated:YES];
            }else{
                
                [PublicUseMethod changeRootNavController:oneVC];
            }
        });
    
    }
}

- (void)changeCurrentToOrganizationProfileWith:(JXOrganizationProfile *)profile and:(UIViewController *)oneVC{

    [AccountRepository changeCurrentToOrganizationProfileWithprofile:profile success:^(AccountEntity *result) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [PublicUseMethod changeRootNavController:oneVC];
        });

    } fail:^(NSError *error) {
        [PublicUseMethod showAlertView:error.localizedDescription];

    }];
}



-(void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    //移除购买监听
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
