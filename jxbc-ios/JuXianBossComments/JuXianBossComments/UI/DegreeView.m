//
//  DegreeView.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/5/15.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "DegreeView.h"
//#import "DegreeCell.h"

//static NSString *degreeCell = @"degreeCell";
@interface DegreeView()<UIPickerViewDelegate,UIPickerViewDataSource>

@end
@implementation DegreeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:.45];
        
           }
    return self;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [UIView animateWithDuration:.35 animations:^{
//        self.hidden = YES;
        [self removeFromSuperview];
    }];
}

- (void)loadDegreeView{

    if (_cellData.count != 0) {

        // picker
        _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-5*44-64, SCREEN_WIDTH, 5*44)];
        _picker.delegate = self;
        _picker.dataSource = self;
        _picker.backgroundColor = [UIColor whiteColor];
        _picker.showsSelectionIndicator = YES;
        [self addSubview:_picker];
        
        // 条视图
        UIView* barView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-5*44-64-44, ScreenWidth, 44)];
        barView.backgroundColor = [PublicUseMethod setColor:KColor_Alert_View];
        [self addSubview:barView];
        
        // 标题
        UILabel * titleLabel = [UILabel labelWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) title:self.title titleColor:[UIColor whiteColor] fontSize:15 numberOfLines:1];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.backgroundColor = [UIColor clearColor];
        [barView addSubview:titleLabel];
        
        // 确定按钮
        UIButton* doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-50, 0, 50, 44)];
        [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
        doneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [doneBtn setTitleColor:ColorWithHex(KColor_GoldColor) forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [barView addSubview:doneBtn];
        
        // 确定按钮
        UIButton* cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [cancelBtn setTitleColor:ColorWithHex(KColor_GoldColor) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
        [barView addSubview:cancelBtn];
    }

}

#pragma mark - 点击确定
- (void)doneButtonClick
{
    NSInteger selectedRow = [self.picker selectedRowInComponent:0];
        if (_block) {
            _block(_cellData[selectedRow],selectedRow);
        }
    
        [UIView animateWithDuration:.35 animations:^{
            self.hidden = YES;
        }];
}
#pragma mark -- 取消
- (void)cancelBtn{

    [UIView animateWithDuration:.35 animations:^{
        self.hidden = YES;
    }];
}


#pragma mark - pickerView delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{

    return 44;
}
#pragma mark - pickerVIew dataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.cellData.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.cellData[row];
}



@end
