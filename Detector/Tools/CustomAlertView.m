//
//  CustomAlertView.m
//  BlueToothTool
//
//  Created by Mac2 on 2018/12/4.
//  Copyright © 2018年 Mac2. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    if (buttonIndex == 1 && !self.dismissEnabled) {
        return;
    }
    [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
