//
//  BlueToothModel.h
//  BlueToothTool
//
//  Created by Mac2 on 2018/8/17.
//  Copyright © 2018年 Mac2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlueToothModel : NSObject

@property (nonatomic, copy) NSString *blueToothName;
@property (nonatomic, copy) NSString *blueToothId;
@property (nonatomic, copy) NSString *ifConnect;//是否连接

@end
