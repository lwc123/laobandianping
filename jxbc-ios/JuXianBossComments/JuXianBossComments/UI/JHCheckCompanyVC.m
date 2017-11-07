//
//  JHCheckCompanyVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/20.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JHCheckCompanyVC.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "JXFooterView.h"

#define ONE_URL @"http://qyxy.baic.gov.cn/simple/dealSimpleAction!transport_ww.dhtml?fourth=fourth&amp;sysid=0150008788304366b7d3903b5067bb8c&amp;module=wzsy&amp;styleFlag=sy#"

#define TWO_YRL @"http://qyxy.baic.gov.cn/lucene/luceneAction!NetCreditLucene.dhtml?currentTimeMillis=%@&credit_ticket=%@"

//http://qyxy.baic.gov.cn/lucene/luceneAction!NetCreditLucene.dhtml?currentTimeMillis=每次访问的时间串&credit_ticket=校验的字符串吧&check_code=1&queryStr=公司名字

@interface JHCheckCompanyVC ()<UITextFieldDelegate,NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (nonatomic,copy)NSString * queryStr;
@property (nonatomic,copy)NSString * module;
@property (nonatomic,copy)NSString * idflag;

@property (nonatomic,copy)NSString * timeStr;
@property (nonatomic,copy)NSString * ticketStr;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@property (nonatomic,strong) NSXMLParser *par;
@property (nonatomic,strong)NSMutableArray * nameArray;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)JXFooterView * footerView;


@end

@implementation JHCheckCompanyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"企业查询";
    [self initData];
    [self initRequest];
    
//    [self text2];
//    [self getCompanyWithTime:@"1" ticket:@"1"];
    self.companyTextField.delegate = self;
    //监听文本框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeText) name:UITextFieldTextDidChangeNotification object:self.companyTextField];

}

- (void)initData{

    _nameArray = [NSMutableArray array];
//    _companyTextField.text = @"领翔";
}


- (void)initUI{
    

    CGFloat tableY = CGRectGetMaxY(self.companyTextField.frame) + 30;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, tableY, SCREEN_WIDTH - 40, SCREEN_HEIGHT - tableY) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _footerView = [JXFooterView footerView];
    _footerView.nextLabel.text = @"无更多能容";
    _footerView.nextLabel.textColor = [UIColor grayColor];
    _footerView.nextLabel.backgroundColor = [UIColor clearColor];
    _footerView.nextBtn.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = _footerView;
    [self.view addSubview:_tableView];
}

- (void)initRequest{

//    NSString * path = @"http://qyxy.baic.gov.cn/simple/dealSimpleAction!transport_ww.dhtml?fourth=fourth&amp;sysid=0150008788304366b7d3903b5067bb8c&amp;module=wzsy&amp;styleFlag=sy#";
    
    NSData * cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: cookiesData forKey:@"Cookie"];
    [defaults synchronize];

    NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"Cookie"]];
    NSHTTPCookieStorage * cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie * cookie in cookies){
        [cookieStorage setCookie: cookie];
    }
    //网络请求管理的类
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    //如果不写这个方法 会自动解析,有解析的功能
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:ONE_URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        [self analysisData:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error===%@",error.localizedDescription);
        
    }];
    
    
}

- (void)analysisData:(NSData *)data{

    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"str===%@",str);
    //验证码
    NSRange range1 = [str rangeOfString:@"credit_ticket = "];
//    NSRange range1 = [str rangeOfString:@"id=\"credit_ticket\" value="];
    NSLog(@"rang:%@",NSStringFromRange(range1));
    range1.location = range1.location+17;
//    range1.location = range1.location+26;
    range1.length = 32;
    _ticketStr = [NSString stringWithString:str];
    _ticketStr = [_ticketStr substringWithRange:range1];//截取范围类的字符串
    NSLog(@"ticketStr截取的值为：%@",_ticketStr);
    //08E6E382EE40CB9D57781464B4285B95
    //时间
    NSRange range2 = [str rangeOfString:@"id=\"currentTimeMillis\""];
    NSLog(@"rang:%@",NSStringFromRange(range2));
    range2.location = range2.location+30;
    range2.length = 13;
    _timeStr = [NSString stringWithString:str];
    _timeStr = [_timeStr substringWithRange:range2];//截取范围类的字符串
    NSLog(@"timeStr截取的值为：%@",_timeStr);
}

#pragma mark -- textField  结束编辑
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
//    if (!_ticketStr && !_timeStr) {
//        
//        [self getCompanyWithTime:_timeStr ticket:_ticketStr];
//
//    }else{
//    
//        [PublicUseMethod showAlertView:@"网络繁忙，请稍后重试"];
//    }
    [self getCompanyWithTime:_timeStr ticket:_ticketStr];


}

- (IBAction)checkBtnClick:(id)sender {
    
    //网络请求管理的类
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    //如果不写这个方法 会自动解析,有解析的功能
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * url = @"http://qyxy.baic.gov.cn/beijing";
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject===%@",responseObject);
        NSString * str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"str===%@",str);
        
        [self analysisData:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error===%@",error.localizedDescription);
        
    }];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    textField = self.companyTextField;

    NSLog(@"%@",textField.text);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    return YES;

}

//全国
//- (void)getCompanyWithTime:(NSString *)timeStr ticket:(NSString *)ticketStr{
//    
//    NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"Cookie"]];
//    NSHTTPCookieStorage * cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (NSHTTPCookie * cookie in cookies){
//        [cookieStorage setCookie: cookie];
//    }
//    
//    NSString *urlStr = [NSString stringWithFormat:@"http://qyxy.baic.gov.cn/lucene/luceneAction!NetCreditLucene.dhtml?currentTimeMillis=%@&credit_ticket=%@",timeStr,ticketStr];
    
//        NSString *urlStr = [NSString stringWithFormat:@"http://qyxy.baic.gov.cn/gjjbj/gjjQueryCreditAction!getBjQyList.dhtml?currentTimeMillis=%@&credit_ticket=%@",timeStr,ticketStr];

//    NSString *urlStr = @"http://qyxy.baic.gov.cn/gjjbj/gjjQueryCreditAction!getBjQyList.dhtml?currentTimeMillis=%@&credit_ticket=%@";
//    NSString *url = [urlStr stringByRemovingPercentEncoding];
//    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    
////    params[@"currentTimeMillis"] = _timeStr;
////    params[@"credit_ticket"] = _ticketStr;
//    params[@"queryStr"] = @"举贤";
//
//    
//    
//    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        NSString * str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"str===%@",str);
//        
//        //        NSRange range1 = [str rangeOfString:@"法定代表人："];
//        //        NSLog(@"rang:%@",NSStringFromRange(range1));
//        //        range1.location = range1.location+18;
//        //        range1.length = 3;
//        //        NSString *ticketStr = [NSString stringWithString:str];
//        //        ticketStr = [ticketStr substringWithRange:range1];//截取范围类的字符串
//        //        NSLog(@"ticketStr截取的值为：%@",ticketStr);
//        
//        NSArray * tempArray = [self rangesOfString:@"法定代表人：" inString:str];
//        NSLog(@"tempArray.count===%lu",(unsigned long)tempArray.count);
//        
//        NSString * nameStr = [NSString string];
//        for (int i = 0; i < tempArray.count; i++) {
//            
//            nameStr = [NSString stringWithFormat:@"%@",tempArray[i]];
//            if ([nameStr containsString:@"，"]) {
//                nameStr = [nameStr substringToIndex:2];
//                NSLog(@"nameStr===%@",nameStr);
//            }
//            [_nameArray addObject:nameStr];
//        }
//        
//        [self initUI];
//        
//        NSLog(@"nameArray===%@",_nameArray);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        NSLog(@"%@",error.localizedDescription);
//        [PublicUseMethod showAlertView:@"网络繁忙..."];
//    }];
//}


//以前的北京网
- (void)getCompanyWithTime:(NSString *)timeStr ticket:(NSString *)ticketStr{
    
    NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"Cookie"]];
    NSHTTPCookieStorage * cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie * cookie in cookies){
        [cookieStorage setCookie: cookie];
    }

    NSString *urlStr = [NSString stringWithFormat:@"http://qyxy.baic.gov.cn/lucene/luceneAction!NetCreditLucene.dhtml?currentTimeMillis=%@&credit_ticket=%@",timeStr,ticketStr];

    NSString *url = [urlStr stringByRemovingPercentEncoding];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"queryStr"] = @"举贤";
    
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"str===%@",str);
        
//        NSRange range1 = [str rangeOfString:@"法定代表人："];
//        NSLog(@"rang:%@",NSStringFromRange(range1));
//        range1.location = range1.location+18;
//        range1.length = 3;
//        NSString *ticketStr = [NSString stringWithString:str];
//        ticketStr = [ticketStr substringWithRange:range1];//截取范围类的字符串
//        NSLog(@"ticketStr截取的值为：%@",ticketStr);
        
        NSArray * tempArray = [self rangesOfString:@"法定代表人：" inString:str];
        NSLog(@"tempArray.count===%lu",(unsigned long)tempArray.count);
 
        NSString * nameStr = [NSString string];
        for (int i = 0; i < tempArray.count; i++) {
            
            nameStr = [NSString stringWithFormat:@"%@",tempArray[i]];
            if ([nameStr containsString:@"，"]) {
                nameStr = [nameStr substringToIndex:2];
                NSLog(@"nameStr===%@",nameStr);
            }
            [_nameArray addObject:nameStr];
        }
        
        [self initUI];

        NSLog(@"nameArray===%@",_nameArray);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"2222222%@",error.localizedDescription);
        [PublicUseMethod showAlertView:@"网络繁忙..."];
    }];
}

- (NSArray *)rangesOfString:(NSString *)searchString inString:(NSString *)str {

        NSMutableArray *results = [NSMutableArray array];
        NSRange searchRange = NSMakeRange(0, [str length]);
        NSRange range;
    
        while ((range = [str rangeOfString:searchString options:0 range:searchRange]).location != NSNotFound) {
            
            range.location = range.location+18;
            range.length = 3;
            NSString *ticketStr = [NSString stringWithString:str];
            ticketStr = [ticketStr substringWithRange:range];
            NSLog(@"ticketStr截取的值为：%@",ticketStr);
            [results addObject:ticketStr];
           searchRange = NSMakeRange(NSMaxRange(range), [str length] - NSMaxRange(range));
            }
       return results;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    if (!_nameArray) {
//        return _nameArray.count;
//    }
//    if (!_nameArray) ;
    
    return _nameArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"法人代表是:%@",_nameArray[indexPath.row]];
    return cell;
}


//开始解析
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"parserDidStartDocument...");
}
//准备节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    
    NSLog(@"elementName===%@,namespaceURI===%@,qName===%@,attributeDict===%@",elementName,namespaceURI,qName,attributeDict);
    
}
//获取节点内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    NSLog(@"----string===%@",string);
}

//解析完一个节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{
    
    NSLog(@"elementName===%@,namespaceURI===%@,qName===%@",elementName,namespaceURI,qName);
}

//解析结束
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"parserDidEndDocument...");
}




- (void)changeText{



}


- (void)dealloc{

        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.companyTextField];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];



}



@end
