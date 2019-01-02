//
//  Macros.h
//  BlueToothTool
//
//  Created by Mac2 on 2018/8/20.
//  Copyright © 2018年 Mac2. All rights reserved.
//

#ifndef Macros_h
#define Macros_h


#endif /* Macros_h */

//#define HOST_NAME @"http://192.168.3.77:8010/mambo"
#define HOST_NAME [NSString stringWithFormat:@"http://%@:8010/mambo/core", [[NSUserDefaults standardUserDefaults] objectForKey:IP_ADDRESS_KEY]]
#define Image_Host [NSString stringWithFormat:@"http://%@:8010/mambo", [[NSUserDefaults standardUserDefaults] objectForKey:IP_ADDRESS_KEY]]
//外部人员
#define Get_Foreigns @"/externalPeople"
//外部人员排序
#define Sort_Foreighs @"/detectionSerialNumber"
//内部人员
#define Get_Internals @"/interiorPeople"
//内部人员排序
#define Sort_Internals @"/companyPeopleSort"
//添加当天外部测试人员
#define Add_Today_Foreigns @"/saveTodayDetection"
//删除当天外部测试人员
#define Delete_Today_Foreign @"/deleteTodayDetection"
//删除内部人员
#define Delete_Internal @"/delPeopleInfo"
//搜索人员
#define Search_Members @"/selectStaff"
//添加人员信息
#define Add_Member_Message @"/saveStaffInfoI"
//修改人员信息
#define Updata_Member_Info @"/updateStaffInfo"
//上传图片
#define Post_Image @"/uploadStaffImg"
//判断身份证号是否重复
#define IDNumberIsExist @"/idNumberIsExist"
//添加血糖值
#define Add_Blood_Value @"/addBloodGlucose"
//添加真实血糖
#define Add_Real_Blood_Value @"/addTrueBloodsugar"
//搜索某人所有血糖值
#define Get_Member_All_Blood_Values @"/selectBloodGlucose"
//所有社会人员
#define Search_All_Foreigns @"/getSocietyPeople"
//人员管理通知
#define Member_Add_Notification @"memberAddNotification"
#define Member_Delete_Notification @"memberDeleteNotification"
#define Member_Remove_Notification @"memberRemoveNotification"
#define Member_Move_Notification @"memberMoveNotification"

#define IP_ADDRESS_KEY @"ipAddress"
#define SHOW_ERROR_DATA @"showErrorData"
#define GET_MULTIPLE_DATA @"getMultipleData"
#define PRINT_LOG @"printLog"
#define AUTO_LINK_SUCCESS @"autoLinkSuccess"
#define NORMAL_POWER @"normalPower"
#define VERY_HIGH_POWER @"veryHighPower"
#define HIGH_POWER @"highPower"
#define LOW_POWER @"lowPower"
#define NORMAL_TIME @"normalTime"
#define VERY_HIGH_TIME @"veryHighTime"
#define HIGH_TIME @"highTime"
#define LOW_TIME @"lowTime"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_MIN MIN(SCREEN_HEIGHT, SCREEN_WIDTH)
#define SCREEN_MAX MAX(SCREEN_HEIGHT, SCREEN_WIDTH)
#define VIEW_WIDTH self.view.bounds.size.width
#define VIEW_HEIGHT self.view.bounds.size.height
#define NAVI_HEIGHT (self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height)
#define STATUS_BAR_HEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height)

#define Switch_Color [UIColor colorWithRed:54 / 255.0 green:217 / 255.0 blue:112 / 255.0 alpha:1.0]
#define RGBA(r, g, b, a)   [UIColor colorWithR:r G:g B:b alpha:a]

//#ifdef DEBUG //开发阶段
//#define NSLog(format,...) printf("%s",[[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])
//#else //发布阶段
//#define NSLog(...)
//#endif

#ifdef DEBUG
#define NSLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif

//加载title：标题  message：详细信息
#define HUD_SHOW(title, message)\
\
HUD_Dismiss;\
MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];\
hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;\
hud.bezelView.backgroundColor = [UIColor blackColor];\
hud.contentColor = [UIColor whiteColor];\
hud.removeFromSuperViewOnHide = YES;\
hud.label.text = NSLocalizedString(title, @"HUD loading title");\
hud.label.numberOfLines = 0;\
hud.detailsLabel.text = NSLocalizedString(message, @"HUD title");

//只有文字
#define HUD_TEXTONLY(string)\
\
HUD_Dismiss;\
MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];\
hud.userInteractionEnabled = NO;\
hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;\
hud.bezelView.backgroundColor = [UIColor blackColor];\
hud.contentColor = [UIColor whiteColor];\
hud.removeFromSuperViewOnHide = YES;\
hud.mode = MBProgressHUDModeText;\
hud.label.text = NSLocalizedString(string, @"HUD message title");\
hud.label.numberOfLines = 0;\
[hud hideAnimated:YES afterDelay:1.0];

//请求成功
#define HUD_RequestSuccess(string)\
\
HUD_Dismiss;\
MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];\
hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;\
hud.bezelView.backgroundColor = [UIColor blackColor];\
hud.contentColor = [UIColor whiteColor];\
hud.removeFromSuperViewOnHide = YES;\
hud.mode = MBProgressHUDModeCustomView;\
UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];\
hud.customView = [[UIImageView alloc] initWithImage:image];\
hud.square = YES;\
hud.label.text = NSLocalizedString(string, @"HUD done title");\
hud.label.numberOfLines = 0;\
[hud hideAnimated:YES afterDelay:1.0];

//请求失败
#define HUD_RequestFaild(string)\
\
HUD_Dismiss;\
MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];\
hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;\
hud.bezelView.backgroundColor = [UIColor blackColor];\
hud.contentColor = [UIColor whiteColor];\
hud.removeFromSuperViewOnHide = YES;\
hud.mode = MBProgressHUDModeCustomView;\
UIImage *image = [[UIImage imageNamed:@"error"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];\
hud.customView = [[UIImageView alloc] initWithImage:image];\
hud.square = YES;\
hud.label.text = NSLocalizedString(string, @"HUD done title");\
hud.label.numberOfLines = 0;\
[hud hideAnimated:YES afterDelay:1.0];

//隐藏吐司
#define HUD_Dismiss \
\
[MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
















