//
//  NetRequest.m
//  BaseDemo
//
//  Created by 程南 on 2018/4/8.
//  Copyright © 2018年 程南. All rights reserved.
//

#import "NetRequest.h"

@interface NetRequest () {
    AFHTTPSessionManager *_manager;
}

@end

@implementation NetRequest

static NetRequest *_request = nil;

+ (NetRequest *)sharedRequest {
    @synchronized (self) {
        if (!_request) {
            _request = [[self alloc] init];
        }
    }
    return _request;
}

- (UIViewController *)getCurrentVC {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}

- (void)postURLAnotherWay:(NSString * _Nonnull)urlString parameters:(id)parameters success:(void(^_Nonnull)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))successBlock failed:(void(^_Nonnull)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failedBlock {
    if (parameters) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"\n请求地址:%@ \n请求参数:%@",urlString,jsonString);
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //返回内容为json
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //返回HTML
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    //application/json", @"text/json", @"text/javascript", @"text/html", nil
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", @"text/css", @"text/xml", nil];
    //对返回的null进行处理
    #ifdef DEBUG
        //如果是debug环境，不移除，防止写model的时候写不全
        ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = NO;
    #else
        //如果是release环境，及appstore上线时的环境
        ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    #endif
    //请求超时时间
    manager.requestSerializer.timeoutInterval = 15.f;
    [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(task,responseObject);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failedBlock) {
            failedBlock(task,error);
        }
        NSLog(@"请求失败%@",error);
    }];
}

- (void)postURL:(NSString * _Nonnull)urlString parameters:(id)parameters success:(void(^_Nonnull)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))successBlock failed:(void(^_Nonnull)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failedBlock {
    if (parameters) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"\n请求地址:%@ \n请求参数:%@",urlString,jsonString);
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //返回内容为json
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //返回HTML
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    //application/json", @"text/json", @"text/javascript", @"text/html", nil
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", @"text/css", @"text/xml", nil];
    //对返回的null进行处理
//#ifdef DEBUG
//    //如果是debug环境，不移除，防止写model的时候写不全
//    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = NO;
//#else
//    //如果是release环境，及appstore上线时的环境
//    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
//#endif
    //请求超时时间
    manager.requestSerializer.timeoutInterval = 15.f;
    [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(task,responseObject);

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failedBlock) {
            failedBlock(task,error);
        }
        NSLog(@"请求失败%@",error);
    }];
}

- (void)getURL:(NSString * _Nonnull)urlString success:(void(^ _Nonnull)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))successBlock failed:(void(^ _Nonnull)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failedBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/JavaScript", @"text/plain", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"multipart/form-data", nil];    //请求超时时间
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(task,responseObject);
        };
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failedBlock) {
            failedBlock(task,error);
        }
    }];
}

#pragma mark 直接传入二进制上传图片
- (void)uploadImageDataWithURL:(NSString * _Nonnull)urlString parameters:(id  _Nonnull)parameters imageKey:(NSString * _Nonnull)imageKey image:(NSData * _Nonnull)imageData success:(void(^ _Nonnull)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))successBlock failed:(void(^ _Nonnull)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failedBlock {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/JavaScript", @"text/plain", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"multipart/form-data", nil];
    //请求超时时间
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:imageKey fileName:@"image1.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"上传进度%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failedBlock) {
            failedBlock(task,error);
        }
    }];
}

#pragma mark 仅用来上传图片，上传文件用下面的方法
- (void)uploadImageWithURL:(NSString * _Nonnull)urlString parameters:(id)parameters imageKey:(NSString * _Nonnull)imageKey image:(UIImage *_Nonnull)image success:(void(^ _Nonnull)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))successBlock failed:(void(^ _Nonnull)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failedBlock {
    
    if (parameters) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"\n请求地址:%@ \n请求参数:%@",urlString,jsonString);
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/JavaScript", @"text/plain", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"multipart/form-data", nil];
    //请求超时时间
    //manager.requestSerializer.timeoutInterval = 60.f;
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData   *fileData = UIImageJPEGRepresentation(image, 1);  //二进制数据
        NSString *fileName = @"1.jpeg";              //文件名
        NSString *mimeType = @"image/jpeg";              //文件类型
        [formData appendPartWithFileData:fileData name:imageKey fileName:fileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"上传进度%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failedBlock) {
            failedBlock(task,error);
        }
        NSLog(@"请求失败%@",error);
    }];
}

- (void)postImagesWithURL:(NSString *)urlString parameters:(id)parameters imageArray:(NSArray *)imageArray imageKey:(NSString *)imageKey success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))successBlock failed:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failedBlock {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"\n请求地址:%@ \n请求参数:%@",urlString,jsonString);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/JavaScript", @"text/plain", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"multipart/form-data", nil];
    //请求超时时间
    //manager.requestSerializer.timeoutInterval = 60.f;
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0 ; i < imageArray.count; i++) {
            UIImage *image = imageArray[i];
            NSData   *fileData = UIImageJPEGRepresentation(image, 0.5);  //二进制数据
            NSString *fileName = @"1.jpeg";              //文件名
            NSString *mimeType = @"image/jpeg";               //文件类型
            [formData appendPartWithFileData:fileData name:[NSString stringWithFormat:@"%@[]",imageKey] fileName:fileName mimeType:mimeType];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"上传进度%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传图片%@",responseObject);
        if (successBlock) {
            successBlock(task,responseObject);
            if ([responseObject isRequestSuccess]) {
                
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failedBlock) {
            failedBlock(task,error);
        }
        NSLog(@"请求失败%@",error);
    }];
}

#pragma mark 用来上传文件
- (void)uploadFilesWithURL:(NSString * _Nonnull)urlString parameters:(id  _Nonnull)parameters filePath:(NSString *_Nonnull)filePath keyName:(NSString *)keyName success:(void(^ _Nonnull)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))successBlock failed:(void(^ _Nonnull)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failedBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/JavaScript", @"text/plain", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"multipart/form-data",@"video/mp4", nil];    //请求超时时间
    //manager.requestSerializer.timeoutInterval = 60.f;
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];  //二进制数据
        NSString *fileName = [filePath lastPathComponent];              //文件名
        NSString *mimeType = [self getMIMEType:filePath];               //文件类型
        if (!mimeType) {
            mimeType = @"application/octet-stream";                   //不知道文件类型
        }
        [formData appendPartWithFileData:fileData name:keyName fileName:fileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"上传文件进度%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failedBlock) {
            failedBlock(task,error);
        }
    }];
}

- (void)uploadFileUseBase64StringStyleWithRequestUrl:(NSString *)requestUrl parameters:(id)parameters success:(void(^ _Nonnull)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))successBlock failed:(void(^ _Nonnull)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failedBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:requestUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"上传进度%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failedBlock) {
            failedBlock(task,error);
        }
    }];
}

//获取文件类型
- (NSString *)getMIMEType:(NSString *)path {
    NSError *error;
    NSURLResponse*response;
    NSURLRequest*request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response
                                      error:&error];
    return [response MIMEType];
}

- (void)downloadFileWithRequestUrl:(NSString *_Nonnull)requestUrl parameters:(id _Nonnull)parameters downloadPath:(NSString *_Nonnull)filePath progress:(void(^_Nullable)(float progress))progressBlock complentionBlock:(void(^)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error))complentionBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    /**
     第一个参数:请求对象
     第二个参数:progress 进度回调
     第三个参数:destination 回调(目标位置)
     有返回值
     targetPath:临时文件路径
     response:响应头信息
     第四个参数:completionHandler 下载完成后的回调
     filePath:最终的文件路径
     */
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        if (progressBlock) {
            progressBlock(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //保存的文件路径
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (complentionBlock) {
            complentionBlock(response,filePath,error);
        }
    }];
    //执行Task
    [downloadTask resume];
}


@end
