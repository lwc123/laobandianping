//
//  JXRechargeMoneyVC.m
//  JuXianBossComments
//
//  Created by juxian on 2017/2/24.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JXRechargeMoneyVC.h"
#import "ApplePayCell.h"
#import "MineDataRequest.h"
#import "BuyReportVaultVC.h"

enum{
    IAPPro20=21,
    IAPPro100,
}JHSCbuyCoinsTag;


@interface JXRechargeMoneyVC ()<SKPaymentTransactionObserver,SKProductsRequestDelegate,ApplePayCellDelegate>{

    NSString * _applePayStr;

}
@property (nonatomic, strong) PaymentResult *completResult;
@property (nonatomic, strong) NSArray *savedReceipts;
@property (nonatomic, strong) JXIapProductCodeEntity *productCodeEntity;

@end

@implementation JXRechargeMoneyVC

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
    [self initData];
    [self initProductInformation];
    [self initUI];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

}

- (void)initData{

    _productCodeEntity = [[JXIapProductCodeEntity alloc] init];

}

#pragma mark -- 获取指定业务的苹果内购产品信息
- (void)initProductInformation{

    [self showLoadingIndicator];
    MJWeakSelf
    [MineDataRequest getPaymentIAPProductWithBizSource:PaymentEngine.BizSources_Deposit success:^(JXIapProductCodeEntity *productCodeEntity) {
        [weakSelf dismissLoadingIndicator];
        NSLog(@"result===%@",productCodeEntity);
        _productCodeEntity = productCodeEntity;
        [self.jxTableView reloadData];
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        NSLog(@"error===%@",error);
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];

}

- (void)initUI{

    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    [self.jxTableView registerNib:[UINib nibWithNibName:@"ApplePayCell" bundle:nil] forCellReuseIdentifier:@"applePayCell"];
    self.jxTableView.scrollEnabled = NO;
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    cell.despritonLabel.text = @"企业金库余额不足,请充值购买金币后使用";
    cell.despritonLabel.textColor = [PublicUseMethod setColor:@"F29434"];
    cell.moneyLabel.text = @"使用Apple ID支付";
    cell.moneyLabel.font = [UIFont boldSystemFontOfSize:15.0];
    
    cell.sayLabel.text = [NSString stringWithFormat:@"购买金币%ld(个)",(long)[_productCodeEntity.GoldCoins integerValue]];
    cell.GoldMoneyLabel.hidden = NO;
    cell.GoldMoneyLabel.text =[NSString stringWithFormat:@"¥%1.f元",_productCodeEntity.Price];

    cell.totalMoneyLabel.font = [UIFont boldSystemFontOfSize:15.0];
    NSString  * myStr = [NSString stringWithFormat:@"应支付：%1.f元",_productCodeEntity.Price];
    
    NSRange range = [myStr rangeOfString: @"应支付："];
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:myStr];
    [str addAttribute:NSForegroundColorAttributeName value:[PublicUseMethod setColor:KColor_Text_EumeColor] range:range];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range];
    cell.totalMoneyLabel.attributedText = str;
    return cell;
}


#pragma mark -- 去支付
- (void)ApplePayCellDidClickedPayBtn:(ApplePayCell *)applePayCell{
    
    self.goldMonwyentity= [[PaymentEntity alloc] init];
    
    self.goldMonwyentity.BizSource =PaymentEngine.BizSources_Deposit;
    self.goldMonwyentity.PayWay = PaymentEngine.PayWays_AppleIAP;
    self.goldMonwyentity.TradeMode = PaymentEngine.TradeMode_Payoff;
    self.goldMonwyentity.TradeType  = PaymentEngine.TradeType_OrganizationToOrganization;
    self.goldMonwyentity.CommodityQuantity = _productCodeEntity.GoldCoins;
    self.goldMonwyentity.CommoditySubject = @"充值";
    self.goldMonwyentity.CommodityCode = self.bhentity.CommodityCode;
    self.goldMonwyentity.OwnerId = self.bhentity.OwnerId;
    self.goldMonwyentity.TotalFee  = _productCodeEntity.Price;
    
    __weak typeof(self) weakSelf = self;
    [self showLoadingIndicator];
    
    [PaymentRepository createTrade:self.goldMonwyentity success:^(PaymentResult * result) {
        if (result.Success) {
            
            weakSelf.goldMonwyentity.TradeCode = result.TradeCode;
            [self buy:IAPPro20];

        }else{
            
            [PublicUseMethod showAlertView:result.ErrorMessage];
        }
    } fail:^(NSError * error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];
        [self faile:error];
    }];


}

-(void)buy:(int)type{

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
            product=[[NSArray alloc] initWithObjects:_productCodeEntity.ProductCode,nil];
            break;
            
        default:
            break;
    }
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers: nsset];
    request.delegate=self;
    [request start];
    
}
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
            payment  = [SKPayment paymentWithProductIdentifier:_productCodeEntity.ProductCode];    //支付25
            break;
        default:
            break;
    }
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}



- (void)requestProUpgradeProductData
{
    NSSet *productIdentifiers = [NSSet setWithObject:@"com.productid"];
    SKProductsRequest* productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
}
//弹出错误信息
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    [self dismissLoadingIndicator];
}

-(void) requestDidFinish:(SKRequest *)request
{
    [self dismissLoadingIndicator];
}

-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"-----PurchasedTransaction----");
    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
}

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
    completResult.TradeCode = self.goldMonwyentity.TradeCode;
    completResult.PayWay = self.goldMonwyentity.PayWay;
    
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
        if (result.Success) {
            [PublicUseMethod showAlertView:@"购买成功"];
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
            [weakSelf performSelector:@selector(payDetailView:) withObject:result afterDelay:0.5];
        }else{
            [PublicUseMethod showAlertView:result.ErrorMessage];
        }
    } fail:^(NSError * error) {
        [weakSelf dismissLoadingIndicator];
        
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
        [self faile:error];
    }];
}

- (void)faile:(NSError*)error{
    if (error.code == -1001) { // 请求超时
        [PublicUseMethod showAlertView:@"网络链接超时,请稍后再试"];
        
    }else if (error.code == -1009) {// 没有网络
        
        [PublicUseMethod showAlertView:@"网络好像断开了,请检查网络设置"];
        
    }else{// 其他
        [PublicUseMethod showAlertView:[NSString stringWithFormat:@"%@",error.localizedDescription]];
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

#pragma mark -- 支付成功之后是进行金币支付
- (void)payDetailView:(PaymentResult *)payResult{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.navigationController popViewControllerAnimated:YES];
    });
}

-(void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
