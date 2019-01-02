//
//  SearchMemberTableViewCell.h
//  Detector
//
//  Created by Mac2 on 2018/12/7.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberModel.h"

typedef void(^RemoveBlcok)(UIButton *button);

@interface SearchMemberTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *removeButton;
@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *genderLabel;
@property (nonatomic, strong) UILabel *telephoneLabel;
@property (nonatomic, strong) UILabel *IDCardLabel;
@property (nonatomic, copy) RemoveBlcok removeBlock;
@property (nonatomic, strong) MemberModel *model;

@end
