//
//  SelectAllView.h
//  BlueToothTool
//
//  Created by Mac2 on 2018/11/6.
//  Copyright © 2018年 Mac2. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectAllBlock)(UIButton *button);
typedef void(^CancelBlock)(UIButton *button);
typedef void(^DeleteAllBlock)(UIButton *button);

@interface SelectAllView : UIView

@property (nonatomic, strong) UIButton *selectAllBtn;//全选按钮
@property (nonatomic, strong) UIButton *cancelBtn;//取消按钮
@property (nonatomic, strong) UIButton *deleteAllBtn;//删除按钮
@property (nonatomic, copy) SelectAllBlock selectAllBlock;
@property (nonatomic, copy) CancelBlock cancelBlock;
@property (nonatomic, copy) DeleteAllBlock deleteAllBlock;

@end
