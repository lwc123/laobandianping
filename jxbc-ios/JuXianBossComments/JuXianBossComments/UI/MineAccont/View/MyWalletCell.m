//
//  MyWalletCell.m
//  JuXianTalentBank
//
//  Created by juxian on 16/5/11.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MyWalletCell.h"

@interface MyWalletCell()

@end

@implementation MyWalletCell


+ (id)infoCellWithTableView:(UITableView *)tableView{

    NSString * className = NSStringFromClass([self class]);
    [tableView registerClass:[self class] forCellReuseIdentifier:className];

    return [tableView dequeueReusableCellWithIdentifier:className];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat labelX = 16.5;
        CGFloat labelY = 10;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, SCREEN_WIDTH - labelX * 2, 15)];
        self.titleLabel.font = [UIFont systemFontOfSize:15.0];
        self.titleLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
//        self.titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
        
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, CGRectGetMaxY(_titleLabel.frame) + 10, 150, 13)];
        self.dateLabel.font = [UIFont systemFontOfSize:13.0];
        self.dateLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
        [self.contentView addSubview:_dateLabel];
        
        CGFloat companyY = CGRectGetMaxY(self.dateLabel.frame) + 10;
        CGFloat companyW = SCREEN_WIDTH - 33;;
        CGFloat companyH = 11;
        
        self.companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, companyY, companyW, companyH)];
        self.companyLabel.font = [UIFont systemFontOfSize:11.0];
        self.companyLabel.textColor = [PublicUseMethod setColor:KColor_Text_ListColor];
//        [self.contentView addSubview:_companyLabel];
        
        CGFloat moneyY = (60 - 15) / 2;
        CGFloat moneyW = 180;
        CGFloat moneyX = SCREEN_WIDTH - moneyW - 15;
        self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(moneyX, moneyY, moneyW, 15)];
        self.moneyLabel.font = [UIFont systemFontOfSize:15];
        self.moneyLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
        self.moneyLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_moneyLabel];
        
    }

    return self;

}

- (void)setModel:(TradeJournalEntity *)model{

    _model = model;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.CommoditySubject];
    
    if ([model.BizSource isEqualToString:PaymentEngine.BizSources_OpenEnterpriseService] || [model.BizSource isEqualToString:PaymentEngine.BizSources_OpenPersonalService] || [model.BizSource isEqualToString:PaymentEngine.BizSources_RenewalEnterpriseService]) {
        self.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",model.TotalFee];
    }else{
        self.moneyLabel.text = [NSString stringWithFormat:@"%.2f金币",model.TotalFee];
    }
    
    self.dateLabel.text = [JXJhDate stringFromDate:model.ModifiedTime];
    if ([self.moneyLabel.text containsString:@"-"]) {
        if ([model.PayWay isEqualToString:PaymentEngine.PayWays_Alipay]) {
            self.companyLabel.text = @"支付宝支付";
        }else if ([model.PayWay isEqualToString:PaymentEngine.PayWays_Wallet]) {
            self.companyLabel.text = @"金库支付";
        }else if ([model.PayWay isEqualToString:PaymentEngine.PayWays_AppleIAP]){
            self.companyLabel.text = @"Apple ID支付";
        }else{
            self.companyLabel.text = @"微信支付";
        }
    }else{//收益
        
        if ([model.PayWay isEqualToString:PaymentEngine.PayWays_AppleIAP]) {
            self.companyLabel.text = @"Apple ID支付";
        }else{
            self.companyLabel.text = model.CommoditySummary;
        }
    }
        
}

-(void)setMessageModel:(JXMessageEntity *)messageModel
{
    _messageModel = messageModel;
//    [self.dateImage sd_setImageWithURL:[NSURL URLWithString:messageModel.Picture] placeholderImage:LOADing_Image];
    self.titleLabel.text = messageModel.Content;
    
    if (messageModel.IsRead == 0) {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    }else if (messageModel.IsRead == 1){//已读
        self.titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    self.dateLabel.text = [JXJhDate jhDateChangeWith:messageModel.CreatedTime];
    self.moneyLabel.hidden = YES;
    
}

+ (CGFloat)sizeWithMessageModel:(JXMessageEntity *)messageModel{
    
    if (messageModel.Content.length > 40) {
        return 92;
    }else{
        return [self sizeWithText:messageModel.Content font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(ScreenWidth - 20, CGFLOAT_MAX)].height + 53.5;
    }
}

//计算高度
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
