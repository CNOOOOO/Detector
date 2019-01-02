//
//  MemberModel.m
//  Detector
//
//  Created by Mac2 on 2018/12/7.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "MemberModel.h"

@implementation MemberModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID":@"id"}];
}

@end
