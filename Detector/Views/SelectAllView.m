//
//  SelectAllView.m
//  BlueToothTool
//
//  Created by Mac2 on 2018/11/6.
//  Copyright © 2018年 Mac2. All rights reserved.
//

#import "SelectAllView.h"

@implementation SelectAllView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView {
    self.backgroundColor = [UIColor whiteColor];
    
    self.selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectAllBtn.exclusiveTouch = YES;
    [self.selectAllBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    [self.selectAllBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [self.selectAllBtn setTitle:@"全选" forState:UIControlStateSelected];
    [self.selectAllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.selectAllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    self.selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.selectAllBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    self.selectAllBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    [self.selectAllBtn addTarget:self action:@selector(selectAll:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.selectAllBtn];
    [self.selectAllBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(93);
    }];
    
    self.deleteAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteAllBtn.enabled = NO;
    self.deleteAllBtn.exclusiveTouch = YES;
    self.deleteAllBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    [self.deleteAllBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteAllBtn setTitleColor:[UIColor colorWithWhite:0 alpha:0.3] forState:UIControlStateNormal];
    self.deleteAllBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.deleteAllBtn addTarget:self action:@selector(deleteAll:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteAllBtn];
    [self.deleteAllBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(110);
    }];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.exclusiveTouch = YES;
    self.cancelBtn.backgroundColor = [UIColor blackColor];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.cancelBtn addTarget:self action:@selector(cancelEdit:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelBtn];
    [self.cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.equalTo(self.deleteAllBtn.mas_left);
        make.width.mas_equalTo(110);
    }];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.3)];
    line.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    [self addSubview:line];
}

- (void)selectAll:(UIButton *)sender {
    if (self.selectAllBlock) {
        self.selectAllBlock(sender);
    }
}

- (void)deleteAll:(UIButton *)sender {
    if (self.deleteAllBlock) {
        self.deleteAllBlock(sender);
    }
}

- (void)cancelEdit:(UIButton *)sender {
    if (self.cancelBlock) {
        self.cancelBlock(sender);
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
