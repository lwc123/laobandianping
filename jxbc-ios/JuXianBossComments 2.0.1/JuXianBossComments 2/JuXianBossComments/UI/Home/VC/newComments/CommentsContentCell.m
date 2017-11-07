//
//  CommentsContentCell.m
//  JuXianBossComments
//
//  Created by easemob on 2016/12/3.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "CommentsContentCell.h"
#import "IWComposePhotosView.h"

@implementation CommentsContentCell

//SC.XJH.12.4初始化自定义cell，设置了固定控件的frame
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,  0, SCREEN_WIDTH, 44)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.text = @"  工作评语";
        titleLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel = titleLabel;
        [self.contentView addSubview:titleLabel];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), SCREEN_WIDTH, 1)];
        lineView.backgroundColor = KColor_CellColor;
        [self.contentView addSubview:lineView];
        
        self.myTextView = [[IWTextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame), SCREEN_WIDTH - 20, 140)];
        self.myTextView.placeholder = @"输入老板点评，或拍摄手写点评，或录制语音点评";
        self.myTextView.placeholderColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
        self.myTextView.delegate = self;
        NSLog(@"%lu",(unsigned long)self.myTextView.text.length);
        [self.contentView addSubview:self.myTextView];
        
        
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.myTextView.frame) + 10, SCREEN_WIDTH, 32)];
        bgView.backgroundColor = [PublicUseMethod setColor:@"F8F8F8"];
        [self.contentView addSubview:bgView];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40,  10, 40, 12)];
        label1.textAlignment = NSTextAlignmentLeft;
        label1.text = @"/500";
        label1.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
        label1.font = [UIFont systemFontOfSize:12];
        [bgView addSubview:label1];
        
        UILabel *lenthLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, 10, 40, 12)];
        self.lenthLabel = lenthLabel;
        lenthLabel.textAlignment = NSTextAlignmentRight;
        lenthLabel.font = [UIFont systemFontOfSize:12];
        lenthLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
        lenthLabel.text = @"0";
        [bgView addSubview:lenthLabel];
        
        UIButton * camerBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 6, 20, 20)];
        camerBtn.tag = 10;
        [camerBtn setImage:[UIImage imageNamed:@"xiangji"] forState:UIControlStateNormal];
        [camerBtn addTarget:self action:@selector(camarBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.camerBtn = camerBtn;
        [bgView addSubview:camerBtn];
        
        UIButton * voiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(camerBtn.frame) + 20, 6, 20, 20)];
        [voiceBtn addTarget:self action:@selector(recodeVoceClick) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:voiceBtn];
        self.voiceBtn = voiceBtn;
        
        //初始相册
        IWComposePhotosView *photosView = [[IWComposePhotosView alloc] init];
        self.photosView = photosView;
        //设置位置
        photosView.y = CGRectGetMaxY(bgView.frame)+10;
        photosView.x = 0;
        photosView.backgroundColor = [UIColor whiteColor];
        photosView.size = CGSizeMake(SCREEN_WIDTH, 0);
        [self.contentView addSubview:photosView];
        
        
        UIButton * voiceImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(photosView.frame) + 10, 146, 0)];
        voiceImageBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [voiceImageBtn setImage:[UIImage imageNamed:@"Group 16"] forState:UIControlStateNormal];//SC.XJH.1.6
        
        voiceImageBtn.adjustsImageWhenHighlighted = NO;
        
        voiceImageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 10, 0);
        voiceImageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 10, 0);
        [self.contentView addSubview:voiceImageBtn];
        self.voiceImageBtn = voiceImageBtn;
        [voiceImageBtn setTitle:@"点击收听评价" forState:UIControlStateNormal];
        
        [voiceImageBtn addTarget:self action:@selector(playVoice:) forControlEvents:UIControlEventTouchUpInside];
        
        [voiceImageBtn setBackgroundImage:[UIImage imageNamed:@"气泡"] forState:UIControlStateNormal];//SC.XJH.1.6
        
        //SC.XJH.1.6
        voiceImageBtn.selected = NO;
        voiceImageBtn.imageView.animationDuration = 1;
        
        voiceImageBtn.imageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"laba－1（被拖移）"],[UIImage imageNamed:@"laba－2（被拖移）"],[UIImage imageNamed:@"laba－3（被拖移）"], nil];
        
        
        UIButton * deleteVoiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(voiceImageBtn.frame), CGRectGetMaxY(photosView.frame) + 10, 14, 0)];
        
        [self.contentView addSubview:deleteVoiceBtn];
        
        self.deleteVoiceBtn = deleteVoiceBtn;
        [deleteVoiceBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [deleteVoiceBtn addTarget:self action:@selector(deleteVoiceClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

//SC.XJH.12.17,设置新model通过刷新UI，更新控件的frame
- (void)setDetaiComment:(ArchiveCommentEntity *)detaiComment{
    _detaiComment = detaiComment;
    
    if (detaiComment.WorkCommentVoice != nil) {//yuyin
        [self.voiceBtn setImage:[UIImage imageNamed:@"wuyuyin"] forState:UIControlStateNormal];
        self.voiceBtn.enabled = NO;
        self.voiceImageBtn.height = 36;
        [self.voiceImageBtn setTitleColor:[PublicUseMethod setColor:KColor_GoldColor] forState:UIControlStateNormal];
        self.deleteVoiceBtn.height = 14;
    }else{
        [self.voiceBtn setImage:[UIImage imageNamed:@"huatong"] forState:UIControlStateNormal];
        self.voiceBtn.enabled = YES;
        self.voiceImageBtn.height = 0;
        [self.voiceImageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        self.deleteVoiceBtn.height = 0;
    }
    
    if (_photosView.photos.count==0) {
        _photosView.height = 0;
    }else if (0<_photosView.photos.count&_photosView.photos.count<=4) {
        //        _photosView.height = 60;
        _photosView.height = 72 + 10;
        
    }else if (4<_photosView.photos.count&_photosView.photos.count<=8){
        _photosView.height = 82 * 2;
    }else{
        _photosView.height = 82 * 3;
    }
    
    self.voiceImageBtn.y = CGRectGetMaxY(_photosView.frame) + 10;
    self.deleteVoiceBtn.y = self.voiceImageBtn.y;
}

+ (CGFloat)cellHeightWithArchiveCommentModel:(ArchiveCommentEntity *)detaiComment{
    CGFloat height = 190 + 30 - 10 + 15 +10;
    if (detaiComment.WorkCommentVoice!= nil) {
        height = height + 36 + 20;
    }
        if (detaiComment.WorkCommentImages.count==0) {
    
        }else if (0<detaiComment.WorkCommentImages.count&detaiComment.WorkCommentImages.count<=4) {
            height = height + 72 + 10;
        }else if (4<detaiComment.WorkCommentImages.count&detaiComment.WorkCommentImages.count<=8){
            height = height + 164;
        }else{
            height = height + 246;
        }
    
    return height;
}

//SC.XJH.12.4通过刷新UI，更新控件的frame
- (void)setModel:(CommentsContentModel *)model{
    _model = model;
    
    if (model.mp3Str != nil) {//yuyin
        [self.voiceBtn setImage:[UIImage imageNamed:@"wuyuyin"] forState:UIControlStateNormal];
        self.voiceBtn.enabled = NO;
        self.voiceImageBtn.height = 36;
        self.deleteVoiceBtn.height = 14;
        
    }else{
        [self.voiceBtn setImage:[UIImage imageNamed:@"huatong"] forState:UIControlStateNormal];
        self.voiceBtn.enabled = YES;
        self.voiceImageBtn.height = 0;
        self.deleteVoiceBtn.height = 0;
        
    }
    
    if (_photosView.photos.count==0) {
        _photosView.height = 0;
    }else if (0<_photosView.photos.count&_photosView.photos.count<=4) {
        //        _photosView.height = 60;
        _photosView.height = 72 + 10;
        
    }else if (4<_photosView.photos.count&_photosView.photos.count<=8){
        _photosView.height = 82 * 2;
    }else{
        _photosView.height = 82 * 3;
    }
    
    self.voiceImageBtn.y = CGRectGetMaxY(_photosView.frame) + 10;
    self.deleteVoiceBtn.y = self.voiceImageBtn.y;
}

//SC.XJH.12.4更加model动态设置cell的高度
+ (CGFloat)cellHeightWithModel:(CommentsContentModel *)model{
    CGFloat height = 190 + 30 - 10 + 10;
    if (model.mp3Str!= nil) {
        height = height + 36 + 20;
    }
    if (model.photos.count==0) {
        
    }else if (0<model.photos.count&model.photos.count<=4) {
        height = height + 72 + 10;
    }else if (4<model.photos.count&model.photos.count<=8){
        height = height + 164;
    }else{
        height = height + 216;
    }
    
    return height;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (![self.myTextView isExclusiveTouch]) {
        [self.myTextView resignFirstResponder];
    }
}

- (void)camarBtnClick{
    if ([_delegate respondsToSelector:@selector(composePicAdd)]) {
        [_delegate composePicAdd];
    }
}

- (void)recodeVoceClick{
    if ([_delegate respondsToSelector:@selector(goToRecordVoice)]) {
        [_delegate goToRecordVoice];
    }
}


//SC.XJH.1.6
- (void)playVoice:(UIButton *)button{
    if ([_delegate respondsToSelector:@selector(playVoice:withVoiceImageBtn:)]) {
        [_delegate playVoice:self withVoiceImageBtn:button];
        [_voiceImageBtn setImage:[UIImage imageNamed:@"Group 16"] forState:UIControlStateNormal];//SC.XJH.1.6

    }
}

- (void)deleteVoiceClick:(UIButton *)button{
    if ([_delegate respondsToSelector:@selector(deleteVoice)]) {
        [_delegate deleteVoice];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 500) {
        _lenthLabel.textColor = [UIColor redColor];
    }else{
        
        _lenthLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
        
    }
    _lenthLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)textView.text.length];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
