//
//  NSString+Util.m
//  BaseDemo
//
//  Created by 程南 on 2018/4/8.
//  Copyright © 2018年 程南. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString (Util)

#pragma mark 判断字符串是否全为空格
- (BOOL)ifEmpty {
    if (!self) {
        return true;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [self stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

- (BOOL)isNullString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    //空格
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    if ([string isKindOfClass:[NSString class]]) {
        if (string.length == 0) {
            return YES;
        }
    }
    //tap键
    if ([string stringByReplacingOccurrencesOfString:@"\r" withString:@""].length == 0) {
        return YES;
    }
    //换行符
    if ([string stringByReplacingOccurrencesOfString:@"\n" withString:@""].length == 0) {
        return YES;
    }
    if ([self delSpaceAndNewline:string].length == 0) {
        return YES;
    }
    return NO;
}

//去除所有空格和换行
- (NSString *)delSpaceAndNewline:(NSString *)string {
    NSMutableString *mutStr = [NSMutableString stringWithString:string];
    NSRange range = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

#pragma mark 计算文字的最大宽度
- (CGFloat)getWidthWithMaxSize:(CGSize)maxSize font:(CGFloat)font {
    return [self getSizeWithMaxSize:maxSize font:font].width;
}

#pragma mark 计算文字的最大高度
- (CGFloat)getHeightWithMaxSize:(CGSize)maxSize font:(CGFloat)font {
    return [self getSizeWithMaxSize:maxSize font:font].height;
}

#pragma mark 计算文字的最大宽高
- (CGSize)getSizeWithMaxSize:(CGSize)maxSize font:(CGFloat)font {
    /*
     //有行间距
     NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
     [paragraphStyle setLineSpacing:10];//调整行间距
     return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font],NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
     */
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
}

#pragma mark 获得完整的网络请求的路径
- (NSString *)getFullRequestPath {
    return [NSString stringWithFormat:@"%@%@",HOST_NAME,self];
}

#pragma mark 判断网络请求是否成功
- (BOOL)isRequestSuccess {
    if ([self isEqualToString:@"ok"]) {
        return YES;
    }
    return NO;
}

+ (NSString *)uuid{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef strUuid = CFUUIDCreateString(kCFAllocatorDefault,uuid);
    NSString * str = [NSString stringWithString:(__bridge NSString *)strUuid];
    CFRelease(strUuid);
    CFRelease(uuid);
    return  str;
}

+ (NSString *)convertToNSStringWithNSData:(NSData *)data {
    NSMutableString *strTemp = [NSMutableString stringWithCapacity:[data length]*2];
    const unsigned char *szBuffer = [data bytes];
    for (NSInteger i=0; i < [data length]; ++i) {
        [strTemp appendFormat:@"%02lx",(unsigned long)szBuffer[i]];
    }
    return strTemp;
}

@end
