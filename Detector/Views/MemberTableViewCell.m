//
//  MemberTableViewCell.m
//  Detector
//
//  Created by Mac2 on 2018/12/6.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "MemberTableViewCell.h"

@implementation MemberTableViewCell

- (void)setModel:(MemberModel *)model {
    self.nameLabel.text = [NSString stringWithFormat:@"姓名：%@", model.staff_name];
    if ([model.staff_age isEqualToString:@"-1"]) {
        self.ageLabel.text = @"-";
    }else {
        self.ageLabel.text = [NSString stringWithFormat:@"年龄：%@", model.staff_age.length ? model.staff_age : @"-"];
    }
    self.genderLabel.text = [NSString stringWithFormat:@"性别：%@", model.staff_sex.length ? model.staff_sex : @"-"];
    self.telephoneLabel.text = [NSString stringWithFormat:@"手机号：%@", model.staff_phone.length ? model.staff_phone : @"-"];
    self.IDCardLabel.text = [NSString stringWithFormat:@"身份证：%@", model.staff_idnumber.length ? model.staff_idnumber : @"-"];
    
    if (model.number.length) {
        self.numberLabel.text = model.number;
        [self.numberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(50);
        }];
    }else {
        [self.numberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(10);
        }];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpCell];
    }
    return self;
}

- (void)setUpCell {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.textColor = [UIColor blackColor];
    self.numberLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.numberLabel];
    [self.numberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(50);
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberLabel.mas_right);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo((SCREEN_WIDTH - 50) / 3);
    }];
    
    self.ageLabel = [[UILabel alloc] init];
    self.ageLabel.textAlignment = NSTextAlignmentCenter;
    self.ageLabel.textColor = [UIColor blackColor];
    self.ageLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.ageLabel];
    [self.ageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(-5);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo((SCREEN_WIDTH - 70) / 3);
    }];
    
    self.genderLabel = [[UILabel alloc] init];
    self.genderLabel.textColor = [UIColor blackColor];
    self.genderLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.genderLabel];
    [self.genderLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ageLabel.mas_right).offset(-5);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(-10);
    }];
    
    self.telephoneLabel = [[UILabel alloc] init];
    self.telephoneLabel.textColor = [UIColor blackColor];
    self.telephoneLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.telephoneLabel];
    [self.telephoneLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberLabel.mas_right);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(-10);
    }];
    
    self.IDCardLabel = [[UILabel alloc] init];
    self.IDCardLabel.textColor = [UIColor blackColor];
    self.IDCardLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.IDCardLabel];
    [self.IDCardLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberLabel.mas_right);
        make.top.equalTo(self.telephoneLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(-10);
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
