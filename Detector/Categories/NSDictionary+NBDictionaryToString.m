//
//  NSDictionary+NBDictionaryToString.m
//  NorthBlueBand
//
//  Created by Ju Liaoyuan on 2017/6/20.
//  Copyright © 2017年 Fangzhiwei Information Technology Co., Ltd. All rights reserved.
//

#import "NSDictionary+NBDictionaryToString.h"

@implementation NSDictionary (NBDictionaryToString)

- (NSString *)string {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
