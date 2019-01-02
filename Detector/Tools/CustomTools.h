//
//  CustomTools.h
//  BlueToothTool
//
//  Created by Mac2 on 2018/8/20.
//  Copyright © 2018年 Mac2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomTools : NSObject

//16进制字符串转NSData(16进制数)
+ (NSData *)dataFromHexString:(NSString *)hexString;

//NSData转字符串
+ (NSString *)stringFromData:(NSData *)data;

//大小端转换
+ (NSString *)CN_HTON:(NSString *)originalString;

//两位16进制数转10进制字符串(方式一)
+ (NSString *)decimalStringFromHexString:(NSString *)hexString;

//两位16进制数转10进制字符串(方式二)
+ (NSString *)decimalStringWithHexString:(NSString *)hexString;

//十进制转16进制
+ (NSString *)getHexByDecimal:(NSInteger)decimal;

//将json字符串转成字典或数组形式
+ (id)jsonToArrayOrDictionary:(NSString *)jsonString;

//字典转json字符串
+ (NSString *)convertToJsonString:(NSDictionary *)dic;

@end
