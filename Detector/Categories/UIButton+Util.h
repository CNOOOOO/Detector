//
//  UIButton+Util.h
//  BlueToothTool
//
//  Created by Mac2 on 2018/8/28.
//  Copyright © 2018年 Mac2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Util)

/** 扩大button响应范围，不同方向根据给定的大小扩大 */
- (void)enlargeEdgeWithTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;

@end
