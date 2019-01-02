//
//  EditView.h
//  BlueToothTool
//
//  Created by Mac2 on 2018/11/8.
//  Copyright © 2018年 Mac2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditView : UIView

@property (nonatomic, strong) UIButton *normalCheckButton;//正常检测按钮
@property (nonatomic, strong) UIButton *veryHighCheckButton;//超高功率检测按钮
@property (nonatomic, strong) UIButton *highCheckButton;//偏高功率检测按钮
@property (nonatomic, strong) UIButton *lowCheckButton;//低功率检测按钮

@end
