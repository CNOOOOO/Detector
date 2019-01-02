//
//  NSString+Util.h
//  BaseDemo
//
//  Created by 程南 on 2018/4/8.
//  Copyright © 2018年 程南. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Util)

//计算字符串的宽度
- (CGFloat)getWidthWithMaxSize:(CGSize)maxSize font:(CGFloat)font;

//计算字符串的高度
- (CGFloat)getHeightWithMaxSize:(CGSize)maxSize font:(CGFloat)font;

//根据最大宽高计算字符串的宽高
- (CGSize)getSizeWithMaxSize:(CGSize)maxSize font:(CGFloat)font;

//得到完整的路径名字
- (NSString *)getFullRequestPath;

//uuid
+ (NSString *)uuid;

//判断字符串是否全为空格
- (BOOL)ifEmpty;

- (BOOL)isNullString:(NSString *)string;

- (BOOL)isRequestSuccess;

//将data转换为不带<>的字符串
+ (NSString *)convertToNSStringWithNSData:(NSData *)data;

@end
