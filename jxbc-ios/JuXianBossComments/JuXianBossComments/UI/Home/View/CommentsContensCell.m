//
//  CommentsContensCell.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/1.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "CommentsContensCell.h"

//一排最多imageView的数量
#define MAXCOL 4
//每一张图片的间隔
#define MARGIN 10

@implementation CommentsContensCell

//+ (void)initialize{
//    
//    CommentsContensCell *cell = [self appearance];
//    
//    cell.allView.layer.cornerRadius = 4;
//    //    self.allView.backgroundColor = [UIColor redColor];
//    cell.allView.layer.borderWidth = .3;
//    cell.allView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    cell.commentsLabel.backgroundColor = [UIColor yellowColor];
//    cell.dateLabel.text = @"2000999";
//    cell.bossLabel.text = @"老板点评";
//    cell.nameLabel.text = @"被评价者的姓名";
//    cell.commentsLabel.text = @"评语：在职期间工作能力各项都符合；但在工作期间有兼职行为，对本职的工作的完成度不够";
//    cell.voiceImagView.userInteractionEnabled = YES;
//    
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.allView.layer.cornerRadius = 4;
//    self.allView.backgroundColor = [UIColor redColor];
    self.allView.layer.borderWidth = .3;
    self.allView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.commentsLabel.backgroundColor = [UIColor yellowColor];
    self.dateLabel.text = @"2000999";
    self.bossLabel.text = @"老板点评";
    self.nameLabel.text = @"被评价者的姓名";
    self.commentsLabel.text = @"评语：在职期间工作能力各项都符合；但在工作期间有兼职行为，对本职的工作的完成度不够";
    self.voiceImagView.userInteractionEnabled = YES;

    
}

+ (CGFloat)cellHeightWithModel:(BossCommentsEntity *)bossModel{
    
    //算文字的尺寸
    //计算cell的高度 一先技术评语的动态高度
    
    CommentsContensCell *cell = [self appearance];
    CGSize contenLabelSize = CGSizeMake(SCREEN_WIDTH,26);
    CGSize textSize = [cell sizeWithText:cell.commentsLabel.text font:JHTextFont maxSize:contenLabelSize];
    
    
    //缺图片和语音点评
    CGFloat pingYuH = CGRectGetMaxY(cell.bgView.frame) + 10 + textSize.height;
    //    if (_bossModel.Voice == nil) {//没有语音
    //
    //        _cellHeight =pingYuH;
    //        self.voiceImagView.hidden = YES;
    //    }else{
    //
    //        self.voiceImagView.hidden = NO;
    //    }
    
    //语音的图片距离是
    cell.yuYinH = (34 + 72) * .5;
    
    //    if (bossModel.Images.count == 0) {//有语音，没有图片
    //
    //        _cellHeight = pingYuH + _yuYinH + 10;
    //    }
    //
    //声音
    cell.voiceImagView.image = [UIImage imageNamed:@"qipao"];
    cell.voiceImagView.backgroundColor = [UIColor yellowColor];
    
    for (int i = 0; i < bossModel.Images.count; i++) {
        
        UIImageView * commentImage = [[UIImageView alloc] initWithFrame:CGRectMake(32 + i * 76, CGRectGetMaxY(cell.voiceImagView.frame) + 10, 76, 76)];
        commentImage.backgroundColor = [UIColor yellowColor];
        [cell.allView addSubview:commentImage];
        [commentImage sd_setImageWithURL:[NSURL URLWithString:bossModel.Images[i]] placeholderImage:nil];
    }
    
    
    
    CGFloat photoH = (34 + 152) * .5 + 50;
    cell.cellHeight = pingYuH + cell.yuYinH + photoH;
    
    
    //    if (_bossModel.Images.count > 0 && _bossModel.Images.count <= 4) {//有一排图片
    //        _cellHeight = pingYuH + _yuYinH + photoH;
    //
    //    }
    //    if (bossModel.Images.count >4  && bossModel.Images.count <= 8) {//两排
    //
    //        _cellHeight = pingYuH + _yuYinH + (photoH + 152*0.5);
    //    }
    //
    //    if (bossModel.Images.count == 9) {//三排
    //        
    //         _cellHeight = pingYuH + _yuYinH +(photoH + 152);
    //    }
    //    

    
    
    return cell.cellHeight;
}


- (void)layoutSubviews{
    
  
}

- (void)setBossModel:(BossCommentsEntity *)bossModel{

    _bossModel = bossModel;
    
    self.dateLabel.text = [JXJhDate JHFormatDateWith:bossModel.CreatedTime];
    self.bossLabel.text = bossModel.CommentatorName;
    self.companyLabel.text = bossModel.EntName;
    //被评价者的职位
    self.nameLabel.text = bossModel.TargetJobTitle;
//    评语
    self.commentsLabel.text = [NSString stringWithFormat:@"评语：%@",bossModel.Text];

    
    _starArray = @[@"工作能力",@"工作态度",@"工作业绩"];
    NSLog(@"%lu",(unsigned long)_starArray.count);
    
    for (int i = 0; i < _starArray.count; i++) {
        
        UILabel * lanel = [[UILabel alloc] init];
        lanel.frame = CGRectMake(10, i *39+5, 70, 39);
        //        lanel.backgroundColor = [UIColor yellowColor];
        lanel.tag = 200 + i;
        lanel.text = [NSString stringWithFormat:@"%@",_starArray[i]];
        lanel.font = [UIFont systemFontOfSize:15.0];
        [self.bgView addSubview:lanel];
        
        self.tggStarEvaView = [[TggStarEvaluationView alloc] init];
        self.tggStarEvaView.frame = (CGRect){CGRectGetMaxX(lanel.frame) + 10,i *39+5,20 * 10,39};
        
        if (i == 0) {
            self.tggStarEvaView.starCount = bossModel.WorkAbility;

        }
        if (i == 1) {
            
            self.tggStarEvaView.starCount = bossModel.WorkManner;

        }if (i == 2) {
            self.tggStarEvaView.starCount = bossModel.WorkAchievement;

        }
        
        
        [self.bgView addSubview:self.tggStarEvaView];
        // 星星之间的间距，默认0.5ns
        NSLog(@"%lu",self.bgView.subviews.count);
        self.tggStarEvaView.spacing = 0.4;
        self.tggStarEvaView.tapEnabled = NO;
    }
    
    

    //算文字的尺寸
    //计算cell的高度 一先技术评语的动态高度
    CGSize contenLabelSize = CGSizeMake(SCREEN_WIDTH,MAXFLOAT);
    CGSize textSize = [self sizeWithText:self.commentsLabel.text font:JHTextFont maxSize:contenLabelSize];

    
    //缺图片和语音点评
    CGFloat pingYuH = CGRectGetMaxY(self.bgView.frame) + 10 + textSize.height;
    CGFloat commentImageY = 0;
    
    if (_bossModel.Voice == nil) {//没有语音
        self.voiceImagView.hidden = YES;
        _yuYinH = 0;
        commentImageY = pingYuH+ 20 + 5;
    }else{
        
        self.voiceImagView.hidden = NO;
        //语音的图片距离是
        _yuYinH = (34 + 72) * .5;
        commentImageY = CGRectGetMaxY(self.voiceImagView.frame)+10;
    }

    //声音
    self.voiceImagView.image = [UIImage imageNamed:@"qipao"];
    self.voiceImagView.backgroundColor = [UIColor yellowColor];
    
    CGFloat childViewWH = (SCREEN_WIDTH-32*2-10*3)/4;
    
    for (int i = 0; i < bossModel.Images.count; i++) {
        
        UIImageView * commentImage = [[UIImageView alloc] initWithFrame:CGRectMake(32 + i * 76, commentImageY, childViewWH, childViewWH)];
        
//        commentImage.size = CGSizeMake(childViewWH, childViewWH);
        
        //计算当前是第几列
        NSInteger col = i % MAXCOL;
        NSInteger row = i / MAXCOL;
        
        CGFloat childViewX = col * (childViewWH + MARGIN);
        CGFloat childViewY = row * (childViewWH + MARGIN);

        commentImage.x = childViewX+32;
        commentImage.y = childViewY+commentImageY;
        
        commentImage.backgroundColor = [UIColor yellowColor];
        commentImage.image = [UIImage imageNamed:@"toux@2x"];
        [self.allView addSubview:commentImage];
//        [commentImage sd_setImageWithURL:[NSURL URLWithString:bossModel.Images[i]] placeholderImage:nil];
    }
    
    CGFloat photoH;
    if (bossModel.Images.count==0) {
        photoH = 0;
    }else if (0<bossModel.Images.count&bossModel.Images.count<=4){
        photoH = childViewWH + 20;
    }else if (4<bossModel.Images.count&bossModel.Images.count<=8){
        photoH = childViewWH * 2+ 30;
    }else if (bossModel.Images.count>8){
        photoH = childViewWH * 3+ 10*4;
    }
    
//    photoH = (34 + 152) * .5 + 50;
    _cellHeight = pingYuH + _yuYinH + photoH + 10 + 10 + 20 +10;

    NSLog(@"--");
    
//    if (_bossModel.Images.count > 0 && _bossModel.Images.count <= 4) {//有一排图片
//        _cellHeight = pingYuH + _yuYinH + photoH;
//        
//    }
//    if (bossModel.Images.count >4  && bossModel.Images.count <= 8) {//两排
//        
//        _cellHeight = pingYuH + _yuYinH + (photoH + 152*0.5);
//    }
//    
//    if (bossModel.Images.count == 9) {//三排
//        
//         _cellHeight = pingYuH + _yuYinH +(photoH + 152);
//    }
//    
}

//计算高度
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
