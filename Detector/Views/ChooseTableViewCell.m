//
//  ChooseTableViewCell.m
//  Detector
//
//  Created by Mac2 on 2018/12/6.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "ChooseTableViewCell.h"

@implementation ChooseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpCell];
    }
    return self;
}

- (void)setUpCell {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    
    self.falseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.falseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.falseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.falseButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.falseButton.layer.masksToBounds = YES;
    self.falseButton.layer.cornerRadius = 3;
    self.falseButton.layer.borderWidth = 0.5;
    self.falseButton.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    [self.falseButton addTarget:self action:@selector(falseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.falseButton];
    [self.falseButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
    }];
    
    self.trueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.trueButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.trueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.trueButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.trueButton.layer.masksToBounds = YES;
    self.trueButton.layer.cornerRadius = 3;
    self.trueButton.layer.borderWidth = 0.5;
    self.trueButton.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    [self.trueButton addTarget:self action:@selector(trueButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.trueButton];
    [self.trueButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.falseButton.mas_left).offset(-5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
    }];
}

- (void)trueButtonClick:(UIButton *)sender {
    if (self.trueBlock) {
        self.trueBlock(sender);
    }
}

- (void)falseButtonClick:(UIButton *)sender {
    if (self.falseBlock) {
        self.falseBlock(sender);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
