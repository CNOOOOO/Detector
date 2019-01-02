//
//  SettingView.h
//  BlueToothTool
//
//  Created by Mac2 on 2018/11/8.
//  Copyright © 2018年 Mac2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingView : UIView

@property (nonatomic, strong) UIScrollView *settingView;//设置页面
@property (nonatomic, strong) UITextField *normalChangeTimeTextField;//设置时间输入框(正常)
@property (nonatomic, strong) UITextField *normalOutputPowerTextField;//设置输出功率输入框(正常)
@property (nonatomic, strong) UITextField *veryHighChangeTimeTextField;//设置时间输入框(超高)
@property (nonatomic, strong) UITextField *veryHighOutputPowerTextField;//设置输出功率输入框(超高)
@property (nonatomic, strong) UITextField *highChangeTimeTextField;//设置时间输入框(偏高)
@property (nonatomic, strong) UITextField *highOutputPowerTextField;//设置输出功率输入框(偏高)
@property (nonatomic, strong) UITextField *lowChangeTimeTextField;//设置时间输入框(低)
@property (nonatomic, strong) UITextField *lowOutputPowerTextField;//设置输出功率输入框(低)
@property (nonatomic, strong) UIButton *confirmBtn;//确定按钮
@property (nonatomic, strong) UIButton *cancelBtn;//取消按钮

@end
