//
//  ChooseTableViewCell.h
//  Detector
//
//  Created by Mac2 on 2018/12/6.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TrueBlock)(UIButton *button);
typedef void(^FalseBlock)(UIButton *button);

@interface ChooseTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *trueButton;
@property (nonatomic, strong) UIButton *falseButton;
@property (nonatomic, copy) TrueBlock trueBlock;
@property (nonatomic, copy) FalseBlock falseBlock;

@end
