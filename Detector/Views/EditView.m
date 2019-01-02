//
//  EditView.m
//  BlueToothTool
//
//  Created by Mac2 on 2018/11/8.
//  Copyright © 2018年 Mac2. All rights reserved.
//

#import "EditView.h"

@implementation EditView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView {
    self.backgroundColor = [UIColor whiteColor];
    
    self.normalCheckButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.normalCheckButton.exclusiveTouch = YES;
    [self.normalCheckButton setTitle:@"正常功率检测" forState:UIControlStateNormal];
    [self.normalCheckButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.normalCheckButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    self.normalCheckButton.layer.masksToBounds = YES;
    self.normalCheckButton.layer.cornerRadius = 3;
    self.normalCheckButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.normalCheckButton];
    [self.normalCheckButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    
    self.veryHighCheckButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.veryHighCheckButton.exclusiveTouch = YES;
    [self.veryHighCheckButton setTitle:@"超高功率检测" forState:UIControlStateNormal];
    [self.veryHighCheckButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.veryHighCheckButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    self.veryHighCheckButton.layer.masksToBounds = YES;
    self.veryHighCheckButton.layer.cornerRadius = 3;
    self.veryHighCheckButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.veryHighCheckButton];
    [self.veryHighCheckButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.equalTo(self.normalCheckButton.mas_bottom).offset(15);
        make.width.mas_equalTo((SCREEN_WIDTH - 30) / 3.0);
        make.height.mas_equalTo(45);
    }];
    
    self.highCheckButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.highCheckButton.exclusiveTouch = YES;
    [self.highCheckButton setTitle:@"偏高功率检测" forState:UIControlStateNormal];
    [self.highCheckButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.highCheckButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    self.highCheckButton.layer.masksToBounds = YES;
    self.highCheckButton.layer.cornerRadius = 3;
    self.highCheckButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.highCheckButton];
    [self.highCheckButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.veryHighCheckButton.mas_right).offset(10);
        make.top.equalTo(self.normalCheckButton.mas_bottom).offset(15);
        make.width.mas_equalTo((SCREEN_WIDTH - 30) / 3.0);
        make.height.mas_equalTo(45);
    }];
    
    self.lowCheckButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lowCheckButton.exclusiveTouch = YES;
    [self.lowCheckButton setTitle:@"低功率检测" forState:UIControlStateNormal];
    [self.lowCheckButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.lowCheckButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    self.lowCheckButton.layer.masksToBounds = YES;
    self.lowCheckButton.layer.cornerRadius = 3;
    self.lowCheckButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.lowCheckButton];
    [self.lowCheckButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.top.equalTo(self.normalCheckButton.mas_bottom).offset(15);
        make.width.mas_equalTo((SCREEN_WIDTH - 30) / 3.0);
        make.height.mas_equalTo(45);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
