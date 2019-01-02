//
//  BaseViewController.m
//  BlueToothTool
//
//  Created by Mac2 on 2018/8/20.
//  Copyright © 2018年 Mac2. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-fanhui"] style:UIBarButtonItemStyleDone target:self action:@selector(BackAction)];
    self.navigationItem.leftBarButtonItem = backItem;
    
//    //1.创建会话对象
//    NSURLSession *session = [NSURLSession sharedSession];
//    //2.根据会话对象创建task
//    NSURL *url = [NSURL URLWithString:[Add_Today_Foreigns getFullRequestPath]];
//    //3.创建可变的请求对象
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    request.timeoutInterval = 20.0;
//    //4.修改请求方法为POST
//    request.HTTPMethod = @"POST";
//    //5.设置请求体
//    NSString *str = [NSString stringWithFormat:@"json=%@", [NSString stringWithFormat:@"[%@]", [self.addMembers componentsJoinedByString:@","]]];
//    request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"接口：%@\n参数：%@",[Add_Today_Foreigns getFullRequestPath],  str);
//    //    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
//    //    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    //    NSLog(@"\n请求地址:%@ \n请求参数:%@",url,jsonString);
//    //6.根据会话对象创建一个Task(发送请求）
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        //8.解析数据
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (error) {
//                NSLog(@"请求error :%@",error.localizedDescription);
//            }else {
//                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                NSLog(@"返回值：%@",responseString);
//            }
//        });
//    }];
//    //7.执行任务
//    [dataTask resume];
}

- (void)BackAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
