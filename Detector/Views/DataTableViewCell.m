//
//  DataTableViewCell.m
//  BlueToothTool
//
//  Created by Mac2 on 2018/11/7.
//  Copyright © 2018年 Mac2. All rights reserved.
//

#import "DataTableViewCell.h"

@implementation DataTableViewCell

- (void)setModel:(DataModel *)model {
    self.textLabel.text = [NSString stringWithFormat:@"%@ --> %@", model.date, model.requestValue];
    if ([model.isSelected isEqualToString:@"1"]) {
        self.selectImageView.image = [UIImage imageNamed:@"selected"];
    }else {
        self.selectImageView.image = [UIImage imageNamed:@"unselected"];
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
    
    self.selectImageView = [[UIImageView alloc] init];
    self.selectImageView.userInteractionEnabled = YES;
    self.selectImageView.image = [UIImage imageNamed:@"unselected"];
    [self.contentView addSubview:self.selectImageView];
    [self.selectImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_left).offset(0);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(22);
    }];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    //重写此方法，作用为当进入编辑模式时候运行customMultipleChioce方法
    [super setEditing:editing animated:animated];
    if (editing) {
        [self customMultipleChioce];
    }
}

- (void)customMultipleChioce {
    for (UIControl *control in self.subviews) {
        //循环cell的subview
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]) {
            //找出UITableViewCellEditControl
            for (UIView *view in control.subviews) {
                if ([view isKindOfClass: [UIImageView class]]) {
                    //在UITableViewCellEditControl中找到imageView
                    UIImageView *imageView = (UIImageView *)view;
                    if (self.selected) {
//                        imageView.image = [UIImage imageNamed:@"selected"];
                        imageView.image=[UIImage new];
                    }else {
//                        imageView.image = [UIImage imageNamed:@"unSelected"];
                        imageView.image=[UIImage new];
                    }
                }
            }
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
