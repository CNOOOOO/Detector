//
//  IPSettingView.h
//  BlueToothTool
//
//  Created by Mac2 on 2018/11/8.
//  Copyright © 2018年 Mac2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPSettingView : UIView

@property (nonatomic, strong) UIView *ipSettingView;//ip设置页面
@property (nonatomic, strong) UISwitch *showErrorDataSwitch;//是否显示异常数据开关
@property (nonatomic, strong) UISwitch *getMultipleDataSwitch;//是否多次采集数据开关
@property (nonatomic, strong) UISwitch *printLogSwitch;//是否打印log开关
@property (nonatomic, strong) UITextField *ipTextField;//设置ip地址输入框
@property (nonatomic, strong) UIButton *ipConfirmBtn;//ip设置确定按钮
@property (nonatomic, strong) UIButton *ipCancelBtn;//ip设置取消按钮

@end
