//
//  DataModel.h
//  BlueToothTool
//
//  Created by Mac2 on 2018/11/7.
//  Copyright © 2018年 Mac2. All rights reserved.
//

#import "JSONModel.h"

@interface DataModel : JSONModel

@property (nonatomic, copy) NSString <Optional>*dataString;
@property (nonatomic, copy) NSString <Optional>*requestValue;
@property (nonatomic, copy) NSString <Optional>*date;
@property (nonatomic, copy) NSString <Optional>*code;
@property (nonatomic, copy) NSString <Optional>*isSelected;//是否选中
@property (nonatomic, copy) NSString <Optional>*valueID;

@end
