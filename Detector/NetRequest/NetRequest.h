//
//  NetRequest.h
//  BaseDemo
//
//  Created by 程南 on 2018/4/8.
//  Copyright © 2018年 程南. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetRequest : NSObject

/**
 *  生成自己封装的网络请求的单例
 *
 *  @return 单例对象
 */
+ (NetRequest * _Nonnull)sharedRequest;


/**
 *  发送post请求
 *
 *  @param urlString    请求的网址字符串
 *  @param parameters   请求的参数字典
 *  @param successBlock 请求成功的回调
 *  @param failedBlock  请求失败的回调
 */
//- (void)postURL:(NSString * _Nonnull)urlString parameters:(id _Nonnull)parameters success:(void(^_Nonnull)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))successBlock failed:(void(^_Nonnull)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failedBlock;
- (void)postURL:(NSString * _Nonnull)urlString parameters:(id)parameters success:(void(^_Nonnull)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))successBlock failed:(void(^_Nonnull)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failedBlock;

- (void)postURLAnotherWay:(NSString * _Nonnull)urlString parameters:(id)parameters success:(void(^_Nonnull)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))successBlock failed:(void(^_Nonnull)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failedBlock;

/**
 *  发送get请求
 *
 *  @param urlString    请求的网址字符串
 *  @param successBlock 请求成功的回调
 *  @param failedBlock  请求失败的回调
 */
- (void)getURL:(NSString * _Nonnull)urlString success:(void(^ _Nonnull)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))successBlock failed:(void(^ _Nonnull)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failedBlock;


/**
 上传文件
 
 @param urlString 请求地址
 @param parameters 参数
 @param filePath 文件路径
 @param keyName 文件对应的key的名字（myfiles）
 @param successBlock 成功的回调
 @param failedBlock 失败的回调
 */
- (void)uploadFilesWithURL:(NSString * _Nonnull)urlString parameters:(id _Nonnull)parameters filePath:(NSString * _Nonnull)filePath keyName:(NSString *_Nullable)keyName success:(void(^ _Nonnull)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))successBlock failed:(void(^ _Nonnull)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failedBlock;


/**
 *  以base64字符串的方式上传，将文件转为base64字符串，存放在参数中
 *
 *  @param requestUrl 请求地址
 *  @param parameters 参数
 *  @param successBlock 成功的回调
 *  @param failedBlock  失败的回调
 */
- (void)uploadFileUseBase64StringStyleWithRequestUrl:(NSString * _Nonnull)requestUrl parameters:(id _Nonnull)parameters success:(void(^ _Nonnull)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))successBlock failed:(void(^ _Nonnull)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failedBlock;




/**
 仅用来上传图片
 
 @param urlString 请求地址
 @param parameters 参数
 @param imageKey 在服务器上对应的是一个表单，这个相当于表单的一个Key
 @param image 图片对象
 @param successBlock 成功的回调
 @param failedBlock 失败的回调
 */
- (void)uploadImageWithURL:(NSString * _Nonnull)urlString parameters:(id)parameters imageKey:(NSString * _Nonnull)imageKey image:(UIImage *_Nonnull)image success:(void(^ _Nonnull)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))successBlock failed:(void(^ _Nonnull)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failedBlock;

//上传多张图片
- (void)postImagesWithURL:(NSString * _Nonnull)urlString parameters:(id  _Nonnull)parameters imageArray:(NSArray * _Nonnull)imageArray imageKey:(NSString * _Nonnull)imageKey success:(void(^ _Nonnull)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))successBlock failed:(void(^ _Nonnull)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failedBlock;

/**
 使用二进制的方式上传图片
 
 @param urlString 请求地址
 @param parameters 参数
 @param imageKey 在服务器上对应的是一个表单，这个相当于表单的一个Key
 @param imageData 图片的二进制
 @param successBlock 成功的回调
 @param failedBlock 失败的回调
 */
- (void)uploadImageDataWithURL:(NSString * _Nonnull)urlString parameters:(id  _Nonnull)parameters imageKey:(NSString * _Nonnull)imageKey image:(NSData * _Nonnull)imageData success:(void(^ _Nonnull)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))successBlock failed:(void(^ _Nonnull)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failedBlock;

- (void)downloadFileWithRequestUrl:(NSString *_Nonnull)requestUrl parameters:(id _Nonnull)parameters downloadPath:(NSString *_Nonnull)filePath progress:(void(^_Nullable)(float progress))progressBlock complentionBlock:(void(^)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error))complentionBlock;

@end
