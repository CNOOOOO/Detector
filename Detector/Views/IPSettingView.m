//
//  IPSettingView.m
//  BlueToothTool
//
//  Created by Mac2 on 2018/11/8.
//  Copyright © 2018年 Mac2. All rights reserved.
//

#import "IPSettingView.h"

@implementation IPSettingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideIpSettingView:)];
    [self addGestureRecognizer:tap];
    
    self.ipSettingView = [[UIView alloc] init];
    self.ipSettingView.backgroundColor = [UIColor whiteColor];
    self.ipSettingView.layer.masksToBounds = YES;
    self.ipSettingView.layer.cornerRadius = 6;
    [self addSubview:self.ipSettingView];
    [self.ipSettingView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.center.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(260);
    }];
    
    UILabel *ipTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH - 30, 30)];
    ipTitleLabel.text = @"配置";
    ipTitleLabel.textColor = [UIColor blackColor];
    ipTitleLabel.font = [UIFont systemFontOfSize:18];
    ipTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.ipSettingView addSubview:ipTitleLabel];
    
    self.ipConfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.ipConfirmBtn.exclusiveTouch = YES;
    [self.ipConfirmBtn setTitle:@"设定" forState:UIControlStateNormal];
    [self.ipConfirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.ipConfirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.ipSettingView addSubview:self.ipConfirmBtn];
    [self.ipConfirmBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-5);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
    }];
    
    self.ipCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.ipCancelBtn.exclusiveTouch = YES;
    [self.ipCancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.ipCancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.ipCancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.ipSettingView addSubview:self.ipCancelBtn];
    [self.ipCancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.ipConfirmBtn.mas_left).offset(-10);
        make.bottom.mas_equalTo(-5);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *printLogSwitchTitle = [[UILabel alloc] init];
    printLogSwitchTitle.text = @"是否打印log:";
    printLogSwitchTitle.font = [UIFont systemFontOfSize:15];
    printLogSwitchTitle.textColor = [UIColor blackColor];
    [self.ipSettingView addSubview:printLogSwitchTitle];
    [printLogSwitchTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.bottom.equalTo(self.ipCancelBtn.mas_top).offset(-10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    self.printLogSwitch = [[UISwitch alloc] init];
    NSString *ifPrintLogStatus = [[NSUserDefaults standardUserDefaults] objectForKey:PRINT_LOG];
    if ([ifPrintLogStatus isEqualToString:@"1"]) {
        self.printLogSwitch.on = YES;
    }else {
        self.printLogSwitch.on = NO;
    }
    [self.ipSettingView addSubview:self.printLogSwitch];
    [self.printLogSwitch mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(printLogSwitchTitle.mas_right).offset(5);
        make.centerY.equalTo(printLogSwitchTitle);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *multipleSwitchTitle = [[UILabel alloc] init];
    multipleSwitchTitle.text = @"是否多次采集数据:";
    multipleSwitchTitle.font = [UIFont systemFontOfSize:15];
    multipleSwitchTitle.textColor = [UIColor blackColor];
    [self.ipSettingView addSubview:multipleSwitchTitle];
    [multipleSwitchTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.bottom.equalTo(self.ipCancelBtn.mas_top).offset(-50);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(30);
    }];
    
    self.getMultipleDataSwitch = [[UISwitch alloc] init];
    NSString *getMultipleDataStatus = [[NSUserDefaults standardUserDefaults] objectForKey:GET_MULTIPLE_DATA];
    if ([getMultipleDataStatus isEqualToString:@"1"]) {
        self.getMultipleDataSwitch.on = YES;
    }else {
        self.getMultipleDataSwitch.on = NO;
    }
    [self.ipSettingView addSubview:self.getMultipleDataSwitch];
    [self.getMultipleDataSwitch mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(multipleSwitchTitle.mas_right).offset(5);
        make.centerY.equalTo(multipleSwitchTitle);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *switchTitle = [[UILabel alloc] init];
    switchTitle.text = @"显示异常数据:";
    switchTitle.font = [UIFont systemFontOfSize:15];
    switchTitle.textColor = [UIColor blackColor];
    [self.ipSettingView addSubview:switchTitle];
    [switchTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.bottom.equalTo(self.ipCancelBtn.mas_top).offset(-90);
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(30);
    }];
    
    self.showErrorDataSwitch = [[UISwitch alloc] init];
    NSString *showErrorDataStatus = [[NSUserDefaults standardUserDefaults] objectForKey:SHOW_ERROR_DATA];
    if ([showErrorDataStatus isEqualToString:@"1"]) {
        self.showErrorDataSwitch.on = YES;
    }else {
        self.showErrorDataSwitch.on = NO;
    }
    [self.ipSettingView addSubview:self.showErrorDataSwitch];
    [self.showErrorDataSwitch mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(switchTitle.mas_right).offset(5);
        make.centerY.equalTo(switchTitle);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *ipLine = [[UILabel alloc] init];
    ipLine.backgroundColor = [UIColor blackColor];
    [self.ipSettingView addSubview:ipLine];
    [ipLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.bottom.equalTo(switchTitle.mas_top).offset(-10);
        make.height.mas_equalTo(0.5);
    }];
    
    self.ipTextField = [[UITextField alloc] init];
    self.ipTextField.text = @"192.168.17.46";
    self.ipTextField.exclusiveTouch = YES;
    self.ipTextField.font = [UIFont systemFontOfSize:14];
    self.ipTextField.clearButtonMode = UITextFieldViewModeNever;
    self.ipTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.ipSettingView addSubview:self.ipTextField];
    [self.ipTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.bottom.equalTo(ipLine.mas_top);
        make.height.mas_equalTo(40);
    }];
}

//点击空白处隐藏IP设置视图
- (void)hideIpSettingView:(UITapGestureRecognizer *)gesture {
    //判断手势点击的位置是不是包含在子视图上
    if (CGRectContainsPoint(self.ipSettingView.frame, [gesture locationInView:self])) {
        
    }else{
        [self endEditing:YES];
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
