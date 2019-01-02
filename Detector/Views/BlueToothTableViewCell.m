//
//  BlueToothTableViewCell.m
//  BlueToothTool
//
//  Created by Mac2 on 2018/8/17.
//  Copyright © 2018年 Mac2. All rights reserved.
//

#import "BlueToothTableViewCell.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation BlueToothTableViewCell

- (void)setModel:(BlueToothModel *)model {
    if ([model.ifConnect isEqualToString:@"1"]) {
        self.connectButton.hidden = YES;
        self.connectStatusLabel.hidden = NO;
        self.brokenButton.hidden = NO;
        self.operationButton.hidden = NO;
        self.blueToothLogo.image = [UIImage imageNamed:@"wifi"];
        self.nameLabel.textColor = [UIColor greenColor];
        self.blueToothId.textColor = [UIColor greenColor];
    }else {
        self.connectButton.hidden = NO;
        self.connectStatusLabel.hidden = YES;
        self.brokenButton.hidden = YES;
        self.operationButton.hidden = YES;
        self.blueToothLogo.image = [UIImage imageNamed:@"unconnected"];
        self.nameLabel.textColor = [UIColor blackColor];
        self.blueToothId.textColor = [UIColor grayColor];
    }
    self.nameLabel.text = model.blueToothName;
    self.blueToothId.text = model.blueToothId;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpCell];
    }
    return self;
}

- (void)setUpCell {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.blueToothLogo = [[UIImageView alloc] init];
    [self.contentView addSubview:self.blueToothLogo];
    [self.blueToothLogo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.centerY.mas_equalTo(0);
    }];
    
    self.connectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.connectButton.exclusiveTouch = YES;
    [self.connectButton setTitle:@"连接" forState:UIControlStateNormal];
    [self.connectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.connectButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.connectButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    self.connectButton.layer.masksToBounds = YES;
    self.connectButton.layer.cornerRadius = 3;
    [self.connectButton addTarget:self action:@selector(connect) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.connectButton];
    [self.connectButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    self.operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.operationButton.exclusiveTouch = YES;
    [self.operationButton setTitle:@"进入\n操作" forState:UIControlStateNormal];
    [self.operationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.operationButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.operationButton.titleLabel.numberOfLines = 2;
    self.operationButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.operationButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    self.operationButton.layer.masksToBounds = YES;
    self.operationButton.layer.cornerRadius = 3;
    [self.operationButton addTarget:self action:@selector(operation) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.operationButton];
    [self.operationButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    self.brokenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.brokenButton.exclusiveTouch = YES;
    [self.brokenButton setTitle:@"断开\n连接" forState:UIControlStateNormal];
    [self.brokenButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.brokenButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.brokenButton.titleLabel.numberOfLines = 2;
    self.brokenButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.brokenButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    self.brokenButton.layer.masksToBounds = YES;
    self.brokenButton.layer.cornerRadius = 3;
    [self.brokenButton addTarget:self action:@selector(broken) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.brokenButton];
    [self.brokenButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.equalTo(self.operationButton.mas_left).offset(-10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    self.connectStatusLabel = [[UILabel alloc] init];
    self.connectStatusLabel.text = @"已连接";
    self.connectStatusLabel.font = [UIFont systemFontOfSize:12];
    self.connectStatusLabel.textColor = [UIColor greenColor];
    [self.contentView addSubview:self.connectStatusLabel];
    [self.connectStatusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.brokenButton.mas_left).offset(-10);
        make.centerY.mas_equalTo(0);
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.top.mas_equalTo(5);
        make.right.equalTo(self.connectButton.mas_left).offset(-15);
    }];
    
    self.blueToothId = [[UILabel alloc] init];
    self.blueToothId.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.blueToothId];
    [self.blueToothId mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.bottom.mas_equalTo(-5);
        make.right.equalTo(self.connectStatusLabel.mas_left).offset(-15);
    }];
}

//连接
- (void)connect {
    if (self.connectBlock) {
        self.connectBlock();
    }
}

//断开
- (void)broken {
    if (self.brokenBlock) {
        self.brokenBlock();
    }
}

//操作
- (void)operation {
    if (self.operationBlock) {
        self.operationBlock();
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
