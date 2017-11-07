//
//  JHMenuTabbleView.h
//  JuXianBossComments
//
//  Created by juxian on 2017/4/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol JHMenuTabbleViewDelaegate;
@interface JHMenuTabbleView : UIView

@property(nonatomic,assign)id<JHMenuTabbleViewDelaegate>delegate;

-(void)refreshWithData:(NSArray *)data;
- (instancetype)initWithViewX:(CGFloat)viewx
                        width:(CGFloat)width
                       height:(CGFloat)height
                      delegat:(id<JHMenuTabbleViewDelaegate >)aDelegat;
@end

@protocol JHMenuTabbleViewDelaegate <NSObject>
@optional
- (void)menuView:(JHMenuTabbleView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void)menuViewRecognizer:(JHMenuTabbleView *)tableView;
@end
