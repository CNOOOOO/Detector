//
//  DataRecordsViewController.h
//  BlueToothTool
//
//  Created by Mac2 on 2018/10/12.
//  Copyright © 2018年 Mac2. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface DataRecordsViewController : BaseViewController

@property (nonatomic, assign) BOOL isBrowseRecords;//是否是进来浏览记录
@property (nonatomic, strong) CBPeripheral *peripheral;//外设
@property (nonatomic, assign) BOOL isLinked;//蓝牙是否连接

@end
