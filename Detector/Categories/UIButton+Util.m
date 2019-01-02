//
//  UIButton+Util.m
//  BlueToothTool
//
//  Created by Mac2 on 2018/8/28.
//  Copyright © 2018年 Mac2. All rights reserved.
//

#import "UIButton+Util.h"
#import <objc/runtime.h>

@implementation UIButton (Util)

static char topKey;
static char leftKey;
static char bottomKey;
static char rightKey;

/** 扩大button响应范围，不同方向根据给定的大小扩大 */
- (void)enlargeEdgeWithTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right {
    objc_setAssociatedObject(self, &topKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect {
    NSNumber *topEdge = objc_getAssociatedObject(self, &topKey);
    NSNumber *leftEdge = objc_getAssociatedObject(self, &leftKey);
    NSNumber *bottomEdge = objc_getAssociatedObject(self, &bottomKey);
    NSNumber *rightEdge = objc_getAssociatedObject(self, &rightKey);
    if (topEdge || leftEdge || bottomEdge || rightEdge) {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }else {
        return self.bounds;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}

@end
