//
//  IWEmotionTextView.m
//  WeiBo
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 icsast. All rights reserved.
//

#import "IWEmotionTextView.h"
//#import "NSString+Emoji.h"
//#import "IWTextAttachment.h"
//#import "IWEmotion.h"

@implementation IWEmotionTextView

/*
- (void)insertEmotion:(IWEmotion *)emotion{
    //判断是否是Emoji表情
    if (emotion.isEmoji) {
        //处理Emoji表情的逻辑
        [self insertText:[emotion.code emoji]];
    }else{
        //通过表情的fullPath能加载出当前图片表情对应的图片
        UIImage *emotionImage = [UIImage imageNamed:emotion.fullPath];
        
        //拿到之前的内容
        NSMutableAttributedString *oldAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        
        
        //==============初始化一个带有图片的AttributedString===============
        
        //初始化一个文字附件，文字附件可以授受一个图片
        IWTextAttachment *attachment = [[IWTextAttachment alloc] init];
        //设置图片
        attachment.image = emotionImage;
        attachment.emotion = emotion;
        CGFloat imageWH = self.font.lineHeight;
        //设置图片附件的大小和偏移量
        attachment.bounds = CGRectMake(0, -4, imageWH, imageWH);
        //通过文字附件初始化一个带有属性的文字
        NSAttributedString *attribute = [NSAttributedString attributedStringWithAttachment:attachment];
        
        //==============初始化一个带有图片的AttributedString===============
        //把带有图片的attributedString拼到当前已的属性文字后面
        //    [oldAttributedString appendAttributedString:attribute];
        //把带有图片的文字插入textView当前选中的selectedRange.location
        
        NSRange range = self.selectedRange;
        
        //会把表情图片添加到最后，如果用户用户可能把光标停留在中间，就不能添加到指定位置
        //    [oldAttributedString appendAttributedString:attribute];
        //insertAttributedString用户insert的方法原因：用户可能把光标停留在中间，我们要把表情添加到光标停留的位置
        //    [oldAttributedString insertAttributedString:attribute atIndex:range.location];
        //用户的光标可能选中了一部分内容，按常理来说，会以表情图片把选中的内容替换
        [oldAttributedString replaceCharactersInRange:range withAttributedString:attribute];
        
        //设置字体
        [oldAttributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, oldAttributedString.length)];
        
        self.attributedText = oldAttributedString;
        
        //我们设置完attributedText之后，光标会跳到最后，得手动设置
        //设置光标的位置
        range.location++;
        //设置用户光标选中范围为0
        range.length = 0;
        self.selectedRange = range;
    }
    
    //自定义TextView，往里面添加表情，也算是文字内容改变，就要做下面两步操作
    //发送文字改变通知
    [IWNotificationCenter postNotificationName:UITextViewTextDidChangeNotification object:self];
    
    //调用代理
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
    
}
*/

/*
- (NSString *)fullText{
    
    //[马到成功]A[马到成功]
    
    NSMutableString *statusContent = [NSMutableString string];
    
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
//        NSLog(@"%@",attrs);
        //遍历 的时候，已经能拿NSAttachment 但不是知道这个文字附件对应的表情字符串是什么-->拿对其对应的IWEmotion模型
        
        IWTextAttachment *attachment = attrs[@"NSAttachment"];
        if (attachment) {
            //当前遍历到表情附件
            IWEmotion *emotion = attachment.emotion;
            //拼接表情的对应文字
            [statusContent appendString:emotion.chs];
        }else{
            //当前遍历文字
            [statusContent appendString:[self.attributedText.string substringWithRange:range]];
        }
    }];
    
    return statusContent;
}
*/
@end
