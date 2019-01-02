//
//  SettingView.m
//  BlueToothTool
//
//  Created by Mac2 on 2018/11/8.
//  Copyright © 2018年 Mac2. All rights reserved.
//

#import "SettingView.h"

@implementation SettingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
//    [self addGestureRecognizer:tap];
    
//    self.settingView = [[UIView alloc] initWithFrame:self.frame];
//    self.settingView.backgroundColor = [UIColor whiteColor];
//    self.settingView.layer.masksToBounds = YES;
//    self.settingView.layer.cornerRadius = 6;
//    [self addSubview:self.settingView];
//    [self.settingView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(15);
//        make.center.mas_equalTo(0);
//        make.right.mas_equalTo(-15);
//        make.height.mas_equalTo(240);
//    }];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 900)];//632
    bgView.backgroundColor = [UIColor whiteColor];
    
    self.settingView = [[UIScrollView alloc] init];
    self.settingView.backgroundColor = [UIColor whiteColor];
    self.settingView.showsVerticalScrollIndicator = NO;
    self.settingView.contentSize = bgView.frame.size;
    [self addSubview:self.settingView];
    [self.settingView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.settingView addSubview:bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.settingView addGestureRecognizer:tap];
    
    UILabel *normalTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 30)];
    normalTitleLabel.text = @"时间/功率配置(正常)";
    normalTitleLabel.textColor = [UIColor blackColor];
    normalTitleLabel.font = [UIFont systemFontOfSize:18];
    normalTitleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:normalTitleLabel];
    
    self.normalChangeTimeTextField = [[UITextField alloc] init];
    self.normalChangeTimeTextField.placeholder = @"设置积分时间(单位：ms)";
    self.normalChangeTimeTextField.exclusiveTouch = YES;
    self.normalChangeTimeTextField.font = [UIFont systemFontOfSize:14];
    self.normalChangeTimeTextField.clearButtonMode = UITextFieldViewModeNever;
    self.normalChangeTimeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:self.normalChangeTimeTextField];
    [self.normalChangeTimeTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.equalTo(normalTitleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *normalTimeLine = [[UILabel alloc] init];
    normalTimeLine.backgroundColor = [UIColor blackColor];
    [bgView addSubview:normalTimeLine];
    [normalTimeLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.equalTo(self.normalChangeTimeTextField.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    self.normalOutputPowerTextField = [[UITextField alloc] init];
    self.normalOutputPowerTextField.placeholder = @"设置输出功率(1~8档)";
    self.normalOutputPowerTextField.exclusiveTouch = YES;
    self.normalOutputPowerTextField.font = [UIFont systemFontOfSize:14];
    self.normalOutputPowerTextField.clearButtonMode = UITextFieldViewModeNever;
    self.normalOutputPowerTextField.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:self.normalOutputPowerTextField];
    [self.normalOutputPowerTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.equalTo(normalTimeLine.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *normalPowerLine = [[UILabel alloc] init];
    normalPowerLine.backgroundColor = [UIColor blackColor];
    [bgView addSubview:normalPowerLine];
    [normalPowerLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.equalTo(self.normalOutputPowerTextField.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    /***************************超高**************************************/
    UILabel *veryHighTitleLabel = [[UILabel alloc] init];
    veryHighTitleLabel.text = @"时间/功率配置(超高)";
    veryHighTitleLabel.textColor = [UIColor blackColor];
    veryHighTitleLabel.font = [UIFont systemFontOfSize:18];
    veryHighTitleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:veryHighTitleLabel];
    [veryHighTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
        make.top.equalTo(normalPowerLine.mas_bottom).offset(5);
    }];
    
    self.veryHighChangeTimeTextField = [[UITextField alloc] init];
    self.veryHighChangeTimeTextField.placeholder = @"设置积分时间(单位：ms)";
    self.veryHighChangeTimeTextField.exclusiveTouch = YES;
    self.veryHighChangeTimeTextField.font = [UIFont systemFontOfSize:14];
    self.veryHighChangeTimeTextField.clearButtonMode = UITextFieldViewModeNever;
    self.veryHighChangeTimeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:self.veryHighChangeTimeTextField];
    [self.veryHighChangeTimeTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.equalTo(veryHighTitleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *veryHighTimeLine = [[UILabel alloc] init];
    veryHighTimeLine.backgroundColor = [UIColor blackColor];
    [bgView addSubview:veryHighTimeLine];
    [veryHighTimeLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.equalTo(self.veryHighChangeTimeTextField.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    self.veryHighOutputPowerTextField = [[UITextField alloc] init];
    self.veryHighOutputPowerTextField.placeholder = @"设置输出功率(1~8档)";
    self.veryHighOutputPowerTextField.exclusiveTouch = YES;
    self.veryHighOutputPowerTextField.font = [UIFont systemFontOfSize:14];
    self.veryHighOutputPowerTextField.clearButtonMode = UITextFieldViewModeNever;
    self.veryHighOutputPowerTextField.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:self.veryHighOutputPowerTextField];
    [self.veryHighOutputPowerTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.equalTo(veryHighTimeLine.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *veryHighPowerLine = [[UILabel alloc] init];
    veryHighPowerLine.backgroundColor = [UIColor blackColor];
    [bgView addSubview:veryHighPowerLine];
    [veryHighPowerLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.equalTo(self.veryHighOutputPowerTextField.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    /***************************偏高**************************************/
    UILabel *highTitleLabel = [[UILabel alloc] init];
    highTitleLabel.text = @"时间/功率配置(偏高)";
    highTitleLabel.textColor = [UIColor blackColor];
    highTitleLabel.font = [UIFont systemFontOfSize:18];
    highTitleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:highTitleLabel];
    [highTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
        make.top.equalTo(veryHighPowerLine.mas_bottom).offset(5);
    }];
    
    self.highChangeTimeTextField = [[UITextField alloc] init];
    self.highChangeTimeTextField.placeholder = @"设置积分时间(单位：ms)";
    self.highChangeTimeTextField.exclusiveTouch = YES;
    self.highChangeTimeTextField.font = [UIFont systemFontOfSize:14];
    self.highChangeTimeTextField.clearButtonMode = UITextFieldViewModeNever;
    self.highChangeTimeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:self.highChangeTimeTextField];
    [self.highChangeTimeTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.equalTo(highTitleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *highTimeLine = [[UILabel alloc] init];
    highTimeLine.backgroundColor = [UIColor blackColor];
    [bgView addSubview:highTimeLine];
    [highTimeLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.equalTo(self.highChangeTimeTextField.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    self.highOutputPowerTextField = [[UITextField alloc] init];
    self.highOutputPowerTextField.placeholder = @"设置输出功率(1~8档)";
    self.highOutputPowerTextField.exclusiveTouch = YES;
    self.highOutputPowerTextField.font = [UIFont systemFontOfSize:14];
    self.highOutputPowerTextField.clearButtonMode = UITextFieldViewModeNever;
    self.highOutputPowerTextField.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:self.highOutputPowerTextField];
    [self.highOutputPowerTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.equalTo(highTimeLine.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *highPowerLine = [[UILabel alloc] init];
    highPowerLine.backgroundColor = [UIColor blackColor];
    [bgView addSubview:highPowerLine];
    [highPowerLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.equalTo(self.highOutputPowerTextField.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    /***************************低**************************************/
    UILabel *lowTitleLabel = [[UILabel alloc] init];
    lowTitleLabel.text = @"时间/功率配置(低)";
    lowTitleLabel.textColor = [UIColor blackColor];
    lowTitleLabel.font = [UIFont systemFontOfSize:18];
    lowTitleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:lowTitleLabel];
    [lowTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
        make.top.equalTo(highPowerLine.mas_bottom).offset(5);
    }];
    
    self.lowChangeTimeTextField = [[UITextField alloc] init];
    self.lowChangeTimeTextField.placeholder = @"设置积分时间(单位：ms)";
    self.lowChangeTimeTextField.exclusiveTouch = YES;
    self.lowChangeTimeTextField.font = [UIFont systemFontOfSize:14];
    self.lowChangeTimeTextField.clearButtonMode = UITextFieldViewModeNever;
    self.lowChangeTimeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:self.lowChangeTimeTextField];
    [self.lowChangeTimeTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.equalTo(lowTitleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *lowTimeLine = [[UILabel alloc] init];
    lowTimeLine.backgroundColor = [UIColor blackColor];
    [bgView addSubview:lowTimeLine];
    [lowTimeLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.equalTo(self.lowChangeTimeTextField.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    self.lowOutputPowerTextField = [[UITextField alloc] init];
    self.lowOutputPowerTextField.placeholder = @"设置输出功率(1~8档)";
    self.lowOutputPowerTextField.exclusiveTouch = YES;
    self.lowOutputPowerTextField.font = [UIFont systemFontOfSize:14];
    self.lowOutputPowerTextField.clearButtonMode = UITextFieldViewModeNever;
    self.lowOutputPowerTextField.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:self.lowOutputPowerTextField];
    [self.lowOutputPowerTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.equalTo(lowTimeLine.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *lowPowerLine = [[UILabel alloc] init];
    lowPowerLine.backgroundColor = [UIColor blackColor];
    [bgView addSubview:lowPowerLine];
    [lowPowerLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.equalTo(self.lowOutputPowerTextField.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn.exclusiveTouch = YES;
    [self.confirmBtn setTitle:@"设定" forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:self.confirmBtn];
    [self.confirmBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.equalTo(lowPowerLine.mas_bottom).offset(20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
    }];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.exclusiveTouch = YES;
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:self.cancelBtn];
    [self.cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.confirmBtn.mas_left).offset(-10);
        make.top.equalTo(lowPowerLine.mas_bottom).offset(20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
    }];
}

//点击空白处隐藏时间/功率设置视图
- (void)handleTapGesture:(UITapGestureRecognizer *)gesture {
//    //判断手势点击的位置是不是包含在子视图上
//    if (CGRectContainsPoint(self.settingView.frame, [gesture locationInView:self])) {
//
//    }else{
//        [self endEditing:YES];
//        [UIView animateWithDuration:0.3 animations:^{
//            self.alpha = 0.0;
//        } completion:^(BOOL finished) {
//            self.hidden = YES;
//        }];
//    }
    
    [self endEditing:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
