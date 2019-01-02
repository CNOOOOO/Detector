//
//  MemberModel.h
//  Detector
//
//  Created by Mac2 on 2018/12/7.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "JSONModel.h"

@interface MemberModel : JSONModel

@property (nonatomic, copy) NSString <Optional>*ID;
@property (nonatomic, copy) NSString <Optional>*serial_number;
@property (nonatomic, copy) NSString <Optional>*staff_age;
@property (nonatomic, copy) NSString <Optional>*staff_drink;
@property (nonatomic, copy) NSString <Optional>*staff_faceimg;
@property (nonatomic, copy) NSString <Optional>*staff_fingerimg;
@property (nonatomic, copy) NSString <Optional>*staff_hypertension;
@property (nonatomic, copy) NSString <Optional>*staff_idnumber;
@property (nonatomic, copy) NSString <Optional>*staff_name;
@property (nonatomic, copy) NSString <Optional>*staff_phone;
@property (nonatomic, copy) NSString <Optional>*staff_sex;
@property (nonatomic, copy) NSString <Optional>*staff_somking;
@property (nonatomic, copy) NSString <Optional>*staff_type;
@property (nonatomic, copy) NSString <Optional>*staff_weixin;
@property (nonatomic, copy) NSString <Optional>*serialNumber;
@property (nonatomic, copy) NSString <Optional>*isSelected;//是否选中
@property (nonatomic, copy) NSString <Optional>*isExist;//是否存在
@property (nonatomic, copy) NSString <Optional>*number;//序号

@end
