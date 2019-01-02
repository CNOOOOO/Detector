//
//  MemberTableViewCell.h
//  Detector
//
//  Created by Mac2 on 2018/12/6.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberModel.h"

@interface MemberTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *numberLabel;//序号
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *genderLabel;
@property (nonatomic, strong) UILabel *telephoneLabel;
@property (nonatomic, strong) UILabel *IDCardLabel;
@property (nonatomic, strong) MemberModel *model;

@end
