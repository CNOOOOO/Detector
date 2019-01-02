//
//  SearchMemberTableViewCell.m
//  Detector
//
//  Created by Mac2 on 2018/12/7.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "SearchMemberTableViewCell.h"

@implementation SearchMemberTableViewCell

- (void)setModel:(MemberModel *)model {
    if ([model.isExist isEqualToString:@"1"]) {
        self.removeButton.hidden = NO;
        self.selectImageView.hidden = YES;
    }else {
        self.removeButton.hidden = YES;
        self.selectImageView.hidden = NO;
    }
    if ([model.isSelected isEqualToString:@"1"]) {
        self.selectImageView.image = [UIImage imageNamed:@"selected"];
    }else {
        self.selectImageView.image = [UIImage imageNamed:@"unselected"];
    }
    self.nameLabel.text = [NSString stringWithFormat:@"姓名：%@", model.staff_name];
    self.ageLabel.text = [NSString stringWithFormat:@"年龄：%@", model.staff_age.length ? model.staff_age : @"-"];
    self.genderLabel.text = [NSString stringWithFormat:@"性别：%@", model.staff_sex.length ? model.staff_sex : @"-"];
    self.telephoneLabel.text = [NSString stringWithFormat:@"手机号：%@", model.staff_phone.length ? model.staff_phone : @"-"];
    self.IDCardLabel.text = [NSString stringWithFormat:@"身份证：%@", model.staff_idnumber.length ? model.staff_idnumber : @"-"];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpCell];
    }
    return self;
}

- (void)setUpCell {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.removeButton.hidden = YES;
    [self.removeButton setImage:[UIImage imageNamed:@"remove"] forState:UIControlStateNormal];
    [self.removeButton setImage:[UIImage imageNamed:@"remove"] forState:UIControlStateSelected];
    [self.removeButton addTarget:self action:@selector(removeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.removeButton];
    [self.removeButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.top.mas_equalTo(2);
        make.width.mas_equalTo(45);
    }];
    
    self.selectImageView = [[UIImageView alloc] init];
    self.selectImageView.hidden = YES;
    self.selectImageView.userInteractionEnabled = YES;
    self.selectImageView.image = [UIImage imageNamed:@"unselected"];
    [self.contentView addSubview:self.selectImageView];
    [self.selectImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(25.5);
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(45);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo((SCREEN_WIDTH - 65) / 3);
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
        make.width.mas_equalTo((SCREEN_WIDTH - 65) / 3);
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
        make.left.mas_equalTo(45);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(-10);
    }];
    
    self.IDCardLabel = [[UILabel alloc] init];
    self.IDCardLabel.textColor = [UIColor blackColor];
    self.IDCardLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.IDCardLabel];
    [self.IDCardLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(45);
        make.top.equalTo(self.telephoneLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(-10);
    }];
}

- (void)removeButtonClick:(UIButton *)sender {
    if (self.removeBlock) {
        self.removeBlock(sender);
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
