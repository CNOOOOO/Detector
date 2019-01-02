//
//  ToastView.h
//  BlueToothTool
//
//  Created by Mac2 on 2018/11/7.
//  Copyright © 2018年 Mac2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToastView : UIView

@property (nonatomic, strong) UIView *textBgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) CGRect textBgViewFrame;
- (void)setTitle:(NSString *)title withCenter:(CGPoint)center;

@end
