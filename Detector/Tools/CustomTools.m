//
//  CustomTools.m
//  BlueToothTool
//
//  Created by Mac2 on 2018/8/20.
//  Copyright © 2018年 Mac2. All rights reserved.
//

#import "CustomTools.h"

static NSString *NL_HTON(NSString *original) {
    NSMutableString *result = [NSMutableString new];
    for (int loc = 0; loc < original.length; loc += 4) {
        NSString *subStr = [original substringWithRange:NSMakeRange(loc, MIN(original.length - loc, 4))];
        if (subStr.length < 4) {
            for (int index = 0; index < subStr.length % 4; index ++) {
                subStr = [NSString stringWithFormat:@"0%@",subStr];
            }
        }
        [result appendString:[NSString stringWithFormat:@"%@%@",[subStr substringWithRange:NSMakeRange(2, 2)],[subStr substringWithRange:NSMakeRange(0, 2)]]];
    }
    return result;
}

@implementation CustomTools

//16进制字符串转NSData(16进制数)
+ (NSData *)dataFromHexString:(NSString *)hexString {
    if (!hexString || [hexString length] == 0) {
        return nil;
    }
    NSMutableData *hexData = [[NSMutableData alloc] init];
    NSRange range;
    if ([hexString length] % 2 == 0) {
        range = NSMakeRange(0, 4);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [hexString length]; i += 4) {
        unsigned int anInt;
        NSString *hexCharStr = [hexString substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        range.location += range.length;
        range.length = 4;
    }
    return hexData;
}

//NSData转字符串
+ (NSString *)stringFromData:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}

//大小端转换
+ (NSString *)CN_HTON:(NSString *)originalString {
    NSMutableString *result = [NSMutableString new];
    for (int loc = 0; loc < originalString.length; loc += 4) {
        NSString *subStr = [originalString substringWithRange:NSMakeRange(loc, MIN(originalString.length - loc, 4))];
        if (subStr.length < 4) {
            for (int index = 0; index < subStr.length % 4; index++) {
                subStr = [NSString stringWithFormat:@"0%@",subStr];
            }
        }
        [result appendString:[NSString stringWithFormat:@"%@%@",[subStr substringWithRange:NSMakeRange(2, 2)],[subStr substringWithRange:NSMakeRange(0, 2)]]];
    }
    return result;
}

//两位16进制数转10进制字符串(方式一)
+ (NSString *)decimalStringFromHexString:(NSString *)hexString {
    NSMutableString *mutableString = [NSMutableString string];
    for(int i = 0; i < hexString.length; i++) {
        int int_ch;  // 两位16进制数转化后的10进制数
        unichar hex_char1 = [hexString characterAtIndex:i]; // 两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <= '9')
            int_ch1 = (hex_char1 - 48) * 16;   // 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <= 'F')
            int_ch1 = (hex_char1 - 55) * 16; // A 的Ascll - 65
        else
            int_ch1 = (hex_char1 - 87) * 16; // a 的Ascll - 97
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; // 两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <= '9')
            int_ch2 = (hex_char2 - 48); // 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <= 'F')
            int_ch2 = hex_char2 - 55; // A 的Ascll - 65
        else
            int_ch2 = hex_char2 - 87; // a 的Ascll - 97
        
        int_ch = int_ch1 + int_ch2;
        [mutableString appendString:[NSString stringWithFormat:@"%d",int_ch]];
    }
    return [mutableString copy];
}

//两位16进制数转10进制字符串(方式二)
+ (NSString *)decimalStringWithHexString:(NSString *)hexString {
    NSString *string = NL_HTON(hexString);
    NSMutableString *mutableString = [NSMutableString string];
    for (int i = 0; i < string.length; i += 4) {
        NSString *number = [string substringWithRange:NSMakeRange(i,4)];
        number = [NSString stringWithFormat:@"%ld,",strtoul([number UTF8String],0,16)];//,号是为了将每个数隔开
        [mutableString appendString:number];
    }
    return [mutableString copy];
}

//十进制转16进制
+ (NSString *)getHexByDecimal:(NSInteger)decimal {
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i < 9; i++) {
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
            case 10:
                letter = @"A"; break;
            case 11:
                letter = @"B"; break;
            case 12:
                letter = @"C"; break;
            case 13:
                letter = @"D"; break;
            case 14:
                letter = @"E"; break;
            case 15:
                letter = @"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", (long)number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            break;
        }
    }
    //转换成0000四位形式
//    if (hex.length == 1) {
//        hex = [NSString stringWithFormat:@"000%@",hex];
//    }else if (hex.length == 2) {
//        hex = [NSString stringWithFormat:@"00%@",hex];
//    }else if (hex.length == 3) {
//        hex = [NSString stringWithFormat:@"0%@",hex];
//    }
    
    //转换成0x000x00形式
    if (hex.length == 1) {
        hex = [NSString stringWithFormat:@"0x000x0%@",hex];
    }else if (hex.length == 2) {
        hex = [NSString stringWithFormat:@"0x000x%@",hex];
    }else if (hex.length == 3) {
        hex = [NSString stringWithFormat:@"0x0%@0x%@",[hex substringToIndex:1],[hex substringWithRange:NSMakeRange(1, 2)]];
    }else {
        hex = [NSString stringWithFormat:@"0x%@0x%@",[hex substringWithRange:NSMakeRange(0, 2)],[hex substringWithRange:NSMakeRange(2, 2)]];
    }
    //大小端转换(小端在前，大端在后)
    hex = [NSString stringWithFormat:@"%@%@",[hex substringWithRange:NSMakeRange(4, 4)], [hex substringWithRange:NSMakeRange(0, 4)]];
    return hex;
}

//- (void)handleClearView {
//    //删除两部分 //1.删除 sd 图片缓存
//    //先清除内存中的图片缓存
//    [[SDImageCache sharedImageCache] clearMemory];
//    //清除磁盘的缓存
//    [[SDImageCache sharedImageCache] clearDisk];
//    //2.删除自己缓存
//    NSString *myCachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"]; [[NSFileManager defaultManager] removeItemAtPath:myCachePath error:nil];
//}

+ (id)jsonToArrayOrDictionary:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingMutableContainers
                                                      error:&err];
    if (jsonObject != nil && err == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}

+ (NSString *)convertToJsonString:(NSDictionary *)dic {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

@end
