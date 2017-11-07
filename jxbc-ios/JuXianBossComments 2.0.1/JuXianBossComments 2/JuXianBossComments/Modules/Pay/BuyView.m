//
//  BuyView.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/19.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "BuyView.h"

@interface BuyView ()

@property (nonatomic,strong)UIButton * selectedBtn;
@property (nonatomic,assign)NSInteger index;

@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@end

@implementation BuyView

+ (instancetype)buyView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"BuyView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib{

//    self.backgroundColor = [UIColor blueColor];
    [super awakeFromNib];
    self.discountLabel.layer.masksToBounds = YES;
    self.discountLabel.layer.cornerRadius = 4;
    
    for (int i = 0; i < 4; i++) {
        UIButton * btn = [self viewWithTag:100 + i];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [PublicUseMethod setColor:KColor_Text_ListColor].CGColor;
        if (btn.tag == 100) {
            btn.backgroundColor = [PublicUseMethod setColor:KColor_MainColor];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.layer.borderColor = [PublicUseMethod setColor:KColor_MainColor].CGColor;
            _selectedBtn = btn;
            _index = 1;
        }
        [btn setTintColor:[UIColor clearColor]];
    }
    [self changLabelTextColor:self.moneyLabel.text];

}

- (void)btnClick:(UIButton *)btn{
    

    if (btn!= self.selectedBtn) {
        
        self.selectedBtn.backgroundColor = [UIColor whiteColor];
        
        [self.selectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.selectedBtn.layer.borderColor = [PublicUseMethod setColor:KColor_Text_ListColor].CGColor;
        self.selectedBtn.selected = NO;
        
        btn.selected = YES;
        btn.backgroundColor = [PublicUseMethod setColor:KColor_MainColor];
        btn.layer.borderColor = [PublicUseMethod setColor:KColor_MainColor].CGColor;
        _index = (btn.tag - 100) +1;
        
//        self.moneyLabel.text = [NSString stringWithFormat:@"%.2f元", self.servicemodel.Price +(self.servicemodel.Price * (btn.tag - 100))];
        
          self.moneyLabel.text = [NSString stringWithFormat:@"%.1f元", 50.0 +(50.0 * (btn.tag - 100))];
//        if ([self.delegate respondsToSelector:@selector(buyViewwDidClickTimeBtn:)]) {
//            [self.delegate buyViewwDidClickTimeBtn:self];
//        }
        
        if ([self.delegate respondsToSelector:@selector(buyViewwDidClickTimeBtnWith:andView:)]) {
            
            [self.delegate buyViewwDidClickTimeBtnWith:_index andView:self];
        }
        
        
        
        [self changLabelTextColor:self.moneyLabel.text];
        
        self.selectedBtn = btn;
        
    }else{
        self.selectedBtn.selected = YES;
        _index = (self.selectedBtn.tag - 100) +1;
        
    }

}

- (void)changLabelTextColor:(NSString *)str{
    
    //改变label上的颜色
    NSRange range = [str rangeOfString: @"元"];
    NSMutableAttributedString*attribute = [[NSMutableAttributedString alloc] initWithString: str];
    [attribute addAttributes: @{NSForegroundColorAttributeName: [UIColor blackColor]}range: range];
    
    [attribute addAttributes: @{NSForegroundColorAttributeName: [UIColor redColor]}range: NSMakeRange(0, range.location)];
    
    //    [attribute addAttributes: @{NSForegroundColorAttributeName: [UIColor blackColor]}range: NSMakeRange(range.location+ range.length, 1)];
    [self.moneyLabel setAttributedText: attribute];
    
}

@end
