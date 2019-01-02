//
//  InputTableViewCell.m
//  Detector
//
//  Created by Mac2 on 2018/12/6.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "InputTableViewCell.h"

@implementation InputTableViewCell

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
    
    self.textField = [[UITextField alloc] init];
    self.textField.textAlignment = NSTextAlignmentRight;
    self.textField.exclusiveTouch = YES;
    self.textField.font = [UIFont systemFontOfSize:14];
    self.textField.clearButtonMode = UITextFieldViewModeNever;
    [self.contentView addSubview:self.textField];
    [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.equalTo(self.titleLabel.mas_right).offset(15);
        make.top.bottom.mas_equalTo(0);
    }];
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
