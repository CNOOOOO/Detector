//
//  ToastView.m
//  BlueToothTool
//
//  Created by Mac2 on 2018/11/7.
//  Copyright © 2018年 Mac2. All rights reserved.
//

#import "ToastView.h"

@implementation ToastView

- (void)setTitle:(NSString *)title withCenter:(CGPoint)center {
    self.titleLabel.text = title;
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 100)];
    CGRect rect = self.textBgView.frame;
    rect.size = CGSizeMake(size.width + 30, size.height + 30);
    self.textBgView.frame = rect;
    self.textBgView.center = center;
    self.titleLabel.frame = CGRectMake(15, 15, size.width, size.height);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView {
    self.backgroundColor = [UIColor clearColor];
    
    self.textBgView = [[UIView alloc] init];
    self.textBgView.backgroundColor = [UIColor blackColor];
    self.textBgView.layer.masksToBounds = YES;
    self.textBgView.layer.cornerRadius = 6;
    [self addSubview:self.textBgView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    [self.textBgView addSubview:self.titleLabel];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
