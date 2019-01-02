//
//  PhotoTableViewCell.m
//  Detector
//
//  Created by Mac2 on 2018/12/6.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "PhotoTableViewCell.h"

@implementation PhotoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpCell];
    }
    return self;
}

- (void)setUpCell {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.faceImageView = [[UIImageView alloc] init];
    self.faceImageView.userInteractionEnabled = YES;
    self.faceImageView.contentMode = UIViewContentModeScaleAspectFill;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFaceImage)];
    [self.faceImageView addGestureRecognizer:tap];
    self.faceImageView.layer.masksToBounds = YES;
    self.faceImageView.layer.cornerRadius = 6;
    [self.contentView addSubview:self.faceImageView];
    [self.faceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-SCREEN_WIDTH / 2.0 - 40);
        make.width.height.mas_equalTo(80);
    }];
    
    UILabel *faceLabel = [[UILabel alloc] init];
    faceLabel.text = @"人脸照片";
    faceLabel.font = [UIFont systemFontOfSize:10];
    faceLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:faceLabel];
    [faceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.faceImageView);
        make.top.equalTo(self.faceImageView.mas_bottom).offset(5);
    }];
    
    self.fingerImageView = [[UIImageView alloc] init];
    self.fingerImageView.userInteractionEnabled = YES;
    self.fingerImageView.contentMode = UIViewContentModeScaleAspectFill;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFingerImage)];
    [self.fingerImageView addGestureRecognizer:tap1];
    self.fingerImageView.layer.masksToBounds = YES;
    self.fingerImageView.layer.cornerRadius = 6;
    [self.contentView addSubview:self.fingerImageView];
    [self.fingerImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(SCREEN_WIDTH / 2.0 + 40);
        make.width.height.mas_equalTo(80);
    }];
    
    UILabel *fingerLabel = [[UILabel alloc] init];
    fingerLabel.text = @"手指照片";
    fingerLabel.font = [UIFont systemFontOfSize:10];
    fingerLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:fingerLabel];
    [fingerLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.fingerImageView);
        make.top.equalTo(self.fingerImageView.mas_bottom).offset(5);
    }];
}

- (void)tapFaceImage {
    if (self.faceImageBlock) {
        self.faceImageBlock(self.faceImageView);
    }
}

- (void)tapFingerImage {
    if (self.fingerImageBlock) {
        self.fingerImageBlock(self.fingerImageView);
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
