//
//  BlueToothTableViewCell.h
//  BlueToothTool
//
//  Created by Mac2 on 2018/8/17.
//  Copyright © 2018年 Mac2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlueToothModel.h"

typedef void(^ConnectBlock)(void);
typedef void(^BrokenBlock)(void);
typedef void(^OperationBlock)(void);

@interface BlueToothTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *blueToothLogo;//蓝牙logo
@property (nonatomic, strong) UILabel *nameLabel;//蓝牙名称
@property (nonatomic, strong) UILabel *blueToothId;//id
@property (nonatomic, strong) UIButton *connectButton;//连接按钮
@property (nonatomic, strong) UIButton *brokenButton;//断开连接按钮
@property (nonatomic, strong) UIButton *operationButton;//操作按钮
@property (nonatomic, strong) UILabel *connectStatusLabel;//连接状态label
@property (nonatomic, copy) ConnectBlock connectBlock;
@property (nonatomic, copy) BrokenBlock brokenBlock;
@property (nonatomic, copy) OperationBlock operationBlock;

@property (nonatomic, strong) BlueToothModel *model;

@end
