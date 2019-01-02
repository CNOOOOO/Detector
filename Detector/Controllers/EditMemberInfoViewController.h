//
//  EditMemberInfoViewController.h
//  Detector
//
//  Created by Mac2 on 2018/12/11.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "BaseViewController.h"
#import "MemberModel.h"

@interface EditMemberInfoViewController : BaseViewController

@property (nonatomic, strong) MemberModel *memberModel;
@property (nonatomic, copy) NSString *testModel;//测试模式（1、社会人员 2、公司人员）

@end
