//
//  DataRecordsViewController.m
//  BlueToothTool
//
//  Created by Mac2 on 2018/10/12.
//  Copyright © 2018年 Mac2. All rights reserved.
//

#import "DataRecordsViewController.h"
#import "ChartLineViewController.h"
#import "AddTestersViewController.h"
#import "SelectAllView.h"
#import "EditView.h"
#import "SettingView.h"
#import "DataTableViewCell.h"
#import "ToastView.h"
#import "MemberModel.h"

typedef NS_ENUM(NSInteger, LinkFunction) {//功能
    LinkFunctionOpen = 0,     //开启光谱检测
    LinkFunctionChangeTime,   //设置积分时间
    LinkFunctionOutputPower,  //设置激光输出功率
};

typedef NS_ENUM(NSInteger, CheckStatus) {//检测状态（正常、超高、偏高、低）
    CheckStatusNormal = 0,     //正常
    CheckStatusVeryHigh,       //超高
    CheckStatusHigh,           //偏高
    CheckStatusLow             //低
};

typedef NS_ENUM(NSInteger, TestModel) {
    TestModelForeign = 1,     //外部人员测试
    TestModelInternal,        //内部人员测试
    TestModelDefalut          //自由测试
};

@interface DataRecordsViewController ()<CBPeripheralDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>

@property (nonatomic, strong) CBCharacteristic *readCharacteristic;//读取数据特征
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;//写入数据特征
@property (nonatomic, strong) CBCharacteristic *noitCharacteristic;//通知特征

@property (nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;//网络监听manager
@property (nonatomic, assign) BOOL isNetWorkStatuOK;//是否有网络
@property (nonatomic, copy) NSString *nowDateString;//当前日期
@property (nonatomic, strong) UITableView *tableView;//tableView
@property (nonatomic, copy) NSString *openString;//开启命令
@property (nonatomic, assign) LinkFunction linkFuction;//功能
@property (nonatomic, strong) NSMutableString *dataStringOne;//蓝牙返回的数据1
@property (nonatomic, strong) NSMutableString *dataStringTwo;//蓝牙返回的数据2
@property (nonatomic, copy) NSString *requestValue;//网络请求获取到的值
@property (nonatomic, strong) EditView *editView;//底部编辑视图
@property (nonatomic, assign) CheckStatus checkStatus;//检测的不同状态
@property (nonatomic, strong) NSMutableArray *dataArray;//所有数据
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UISwitch *RequestServerSwitch;//是否访问服务器开关

@property (nonatomic, strong) IFMMenu *menu;//更多菜单

@property (nonatomic, strong) SettingView *settingView;//设置页面
@property (nonatomic, copy) NSString *setNormalTimeString;//时间命令(正常)
@property (nonatomic, copy) NSString *setNormalPowerString;//输出功率命令(正常)
@property (nonatomic, copy) NSString *setVeryHighTimeString;//时间命令(超高)
@property (nonatomic, copy) NSString *setVeryHighPowerString;//输出功率命令(超高)
@property (nonatomic, copy) NSString *setHighTimeString;//时间命令(偏高)
@property (nonatomic, copy) NSString *setHighPowerString;//输出功率命令(偏高)
@property (nonatomic, copy) NSString *setLowTimeString;//时间命令(低)
@property (nonatomic, copy) NSString *setLowPowerString;//输出功率命令(低)
@property (nonatomic, copy) NSString *setTimeString;//时间命令
@property (nonatomic, copy) NSString *setPowerString;//输出功率命令
//@property (nonatomic, assign) int settingTimes;//设置次数

@property (nonatomic, assign) int dataNum;//是第几笔数据
@property (nonatomic, assign) BOOL haveUnusualData;//是否有不正常的数据
@property (nonatomic, assign) BOOL needPostDataTwice;//需要发送两次数据
@property (nonatomic, assign) BOOL ifShowErrorData;//是否显示异常数据

@property (nonatomic, strong) SelectAllView *selectAllView;//全选删除视图
@property (nonatomic, strong) NSMutableArray *deleteArray;//删除的数据
@property (nonatomic, strong) ToastView *toastView;//删除成功提示
@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) CustomAlertView *alertView;//输入正常血糖值的弹窗
@property (nonatomic, strong) ToastView *valueErrorView;//数值填写格式错误提示
@property (nonatomic, assign) NSIndexPath *indexPath;

@property (nonatomic, strong) NSMutableArray *allMembers;
@property (nonatomic, assign) TestModel testModel;//测试模式
@property (nonatomic, strong) MemberModel *currentModel;
@property (nonatomic, assign) BOOL requestComplete;//请求完成
@property (nonatomic, strong) DOPDropDownMenu *dropMenu;
@property (nonatomic, strong) NSArray *modelArray;
@property (nonatomic, strong) NSMutableArray *memberArray;
@property (nonatomic, strong) NSMutableDictionary *menuDic;

@end

@implementation DataRecordsViewController

- (NSMutableString *)dataStringOne {
    if (!_dataStringOne) {
        _dataStringOne = [NSMutableString string];
    }
    return _dataStringOne;
}

- (NSMutableString *)dataStringTwo {
    if (!_dataStringTwo) {
        _dataStringTwo = [NSMutableString string];
    }
    return _dataStringTwo;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)deleteArray {
    if (!_deleteArray) {
        _deleteArray = [NSMutableArray array];
    }
    return _deleteArray;
}

- (NSMutableArray *)allMembers {
    if (!_allMembers) {
        _allMembers = [NSMutableArray array];
    }
    return _allMembers;
}

- (NSMutableDictionary *)menuDic {
    if (!_menuDic) {
        _menuDic = [NSMutableDictionary dictionary];
    }
    return _menuDic;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _dateFormatter;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)note {
    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //首先通过这两行代码获取第一相应
//    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
//    UIView * firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    //然后再通过判断响应类做出相应的响应
//    if ([firstResponder isKindOfClass:[UITextField class]]) {
//        if (firstResponder.frame.origin.y > SCREEN_HEIGHT - keyBoardRect.size.height - 40) {
//            self.offsetY = self.settingView.settingView.contentOffset.y;
//            self.settingView.settingView.contentOffset = CGPointMake(0,self.settingView.settingView.contentOffset.y + firstResponder.frame.origin.y + firstResponder.frame.size.height - (SCREEN_HEIGHT - keyBoardRect.size.height) + 80 - self.offsetY);;
//        }
//    }
    
    if (self.textField.frame.origin.y > SCREEN_HEIGHT - keyBoardRect.size.height - 40) {
        self.offsetY = self.settingView.settingView.contentOffset.y;
        self.settingView.settingView.contentOffset = CGPointMake(0,self.settingView.settingView.contentOffset.y + self.textField.frame.origin.y + self.textField.frame.size.height - (SCREEN_HEIGHT - keyBoardRect.size.height) + 80 - self.offsetY);;
    }
}

- (void)keyboardWillHide:(NSNotification *)note {
    [UIView animateWithDuration:0.3 animations:^{
        self.settingView.settingView.contentOffset = CGPointMake(0, self.offsetY);
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    HUD_Dismiss;
}

- (void)keyboardWillChangeFrame:(NSNotification *)notify{
    NSDictionary *info = notify.userInfo;
    //动画时间
    CGFloat animationDuration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //键盘目标位置
    CGRect  keyboardAnimationFrame = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self keyboardAnimationWithDuration:animationDuration keyboardOriginY:keyboardAnimationFrame.origin.y];
}

- (void)keyboardAnimationWithDuration:(CGFloat)duration keyboardOriginY:(CGFloat)keyboardOriginY{
    //作为视图的键盘，弹出动画也是UIViewAnimationOptionCurveEaseIn的方式
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if (keyboardOriginY - 240 > SCREEN_HEIGHT * 0.5 - 120) {
            self.settingView.settingView.frame = CGRectMake(15, SCREEN_HEIGHT * 0.5 - 120, SCREEN_WIDTH - 30, 240);
        }else {
            self.settingView.settingView.frame = CGRectMake(15, keyboardOriginY - 240, SCREEN_WIDTH - 30, 240);
        }
    } completion:nil];
}

//接收通知
- (void)receiveNotification:(NSNotification *)infoNotification {
    NSDictionary *dic = [infoNotification userInfo];
    self.peripheral = (CBPeripheral *)[dic objectForKey:@"peripheral"];
    NSNumber *isLinked = [dic objectForKey:@"isLinked"];
    self.isLinked = [isLinked boolValue];
    self.peripheral.delegate = self;
    //发现服务
    [self.peripheral discoverServices:nil];
}

//网络监听
- (void)observeNetworkStatus {
    __weak typeof(self) weakSelf = self;
    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                weakSelf.isNetWorkStatuOK = NO;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                weakSelf.isNetWorkStatuOK = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G/4G");
                weakSelf.isNetWorkStatuOK = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi");
                weakSelf.isNetWorkStatuOK = YES;
                break;
            default:
                break;
        }
    }];
    [self.reachabilityManager startMonitoring];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[DataTableViewCell class] forCellReuseIdentifier:@"dataCell"];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"检测数据";
    self.requestComplete = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMembers) name:Member_Add_Notification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMembers) name:Member_Delete_Notification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMembers) name:Member_Remove_Notification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMembers) name:Member_Move_Notification object:nil];
    
    //是否显示异常数据
    NSString *showErrorDataStatus = [[NSUserDefaults standardUserDefaults] objectForKey:SHOW_ERROR_DATA];
    if ([showErrorDataStatus isEqualToString:@"1"]) {
        self.ifShowErrorData = YES;
    }else {
        self.ifShowErrorData = NO;
    }
    //网络监听
    self.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [self observeNetworkStatus];
    
    //是否访问服务器开关
    self.RequestServerSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, 60, 30)];
    self.RequestServerSwitch.on = YES;
    [self.RequestServerSwitch addTarget:self action:@selector(requestServer:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.RequestServerSwitch];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.RequestServerSwitch];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    //删除成功提示
    self.toastView = [[ToastView alloc] initWithFrame:self.navigationController.view.frame];
    [self.toastView setTitle:@"删除成功!" withCenter:self.toastView.center];
    self.toastView.hidden = YES;
    self.toastView.alpha = 0.0;
    [self.navigationController.view addSubview:self.toastView];
    
    //格式异常提示
    self.valueErrorView = [[ToastView alloc] initWithFrame:self.navigationController.view.frame];
    [self.valueErrorView setTitle:@"数值格式错误" withCenter:CGPointMake(self.valueErrorView.center.x, SCREEN_HEIGHT - 120)];
    self.valueErrorView.hidden = YES;
    self.valueErrorView.alpha = 0.0;
    [self.navigationController.view addSubview:self.valueErrorView];
    
    //更多按钮
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gengduo"] style:UIBarButtonItemStylePlain target:self action:@selector(showMoreFunctions)];
    self.navigationItem.rightBarButtonItem = moreItem;
    
    //选择模式和人员
    self.modelArray = @[@"社会人员", @"公司人员", @"自由测试"];
    self.memberArray = [NSMutableArray array];
    [self.memberArray addObject:@"添加人员"];
    [self.menuDic setObject:self.modelArray forKey:@"0"];
    [self.menuDic setObject:self.memberArray forKey:@"1"];
    self.dropMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:45.0];
    self.dropMenu.delegate = self;
    self.dropMenu.dataSource = self;
    [self.view addSubview:self.dropMenu];
    self.testModel = TestModelForeign;
    [self getMembers];
    
    //底部全选删除按钮视图
    self.selectAllView = [[SelectAllView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 45 - NAVI_HEIGHT, SCREEN_WIDTH, 45)];
    self.selectAllView.hidden = YES;
    [self.view addSubview:self.selectAllView];
    
    __weak typeof(self) weakSelf = self;
    CGFloat naviHeight = NAVI_HEIGHT;
    if (!self.isBrowseRecords) {//不是查看历史
        //更多菜单
        NSMutableArray *menuItems = [[NSMutableArray alloc] initWithObjects:
                                     [IFMMenuItem itemWithImage:[UIImage imageNamed:@"shezhi"]
                                                          title:@"设置"
                                                         action:^(IFMMenuItem *item) {
                                                             [weakSelf showSettingView];
                                                         }],
                                     [IFMMenuItem itemWithImage:[UIImage imageNamed:@"shanchu"]
                                                          title:@"批量删除"
                                                         action:^(IFMMenuItem *item) {
                                                             weakSelf.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - naviHeight - 45);
                                                             weakSelf.dropMenu.hidden = YES;
                                                             weakSelf.selectAllView.hidden = NO;
                                                             weakSelf.editView.hidden = YES;
                                                             [weakSelf.tableView setEditing:NO animated:NO];
                                                             [weakSelf.tableView setEditing:YES animated:YES];
                                                         }], nil];
        self.menu = [[IFMMenu alloc] initWithItems:menuItems];
        self.menu.titleFont = [UIFont systemFontOfSize:15];

        //设置视图
        self.settingView = [[SettingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.settingView.hidden = YES;
        self.settingView.alpha = 0.0;
        [self.navigationController.view addSubview:self.settingView];
        [self.settingView.confirmBtn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.settingView.cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        self.settingView.normalOutputPowerTextField.delegate = self;
        self.settingView.normalChangeTimeTextField.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:self.settingView.normalOutputPowerTextField];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:self.settingView.normalChangeTimeTextField];
        
        self.settingView.veryHighOutputPowerTextField.delegate = self;
        self.settingView.veryHighChangeTimeTextField.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:self.settingView.veryHighOutputPowerTextField];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:self.settingView.veryHighChangeTimeTextField];
        
        self.settingView.highOutputPowerTextField.delegate = self;
        self.settingView.highChangeTimeTextField.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:self.settingView.highOutputPowerTextField];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:self.settingView.highChangeTimeTextField];
        
        self.settingView.lowOutputPowerTextField.delegate = self;
        self.settingView.lowChangeTimeTextField.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:self.settingView.lowOutputPowerTextField];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:self.settingView.lowChangeTimeTextField];
        
        //蓝牙断开重连的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:AUTO_LINK_SUCCESS object:nil];

        self.tableView.frame = CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT - 110 - 45);
        [self.view addSubview:self.tableView];
        
        //打开光谱仪按钮
        self.editView = [[EditView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - NAVI_HEIGHT - 110, SCREEN_WIDTH, 110)];
        [self.view addSubview:self.editView];
        [self.editView.normalCheckButton addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
        [self.editView.veryHighCheckButton addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
        [self.editView.highCheckButton addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
        [self.editView.lowCheckButton addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
        
        //设置代理
        self.peripheral.delegate = self;
        //发现服务
        [self.peripheral discoverServices:nil];
    }else {
        //更多菜单
        NSMutableArray *menuItems = [[NSMutableArray alloc] initWithObjects:
                                     [IFMMenuItem itemWithImage:[UIImage imageNamed:@"shanchu"]
                                                          title:@"批量删除"
                                                         action:^(IFMMenuItem *item) {
                                                             weakSelf.selectAllView.hidden = NO;
                                                             weakSelf.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - naviHeight - 45);
                                                             weakSelf.dropMenu.hidden = YES;
                                                             [weakSelf.tableView setEditing:NO animated:NO];
                                                             [weakSelf.tableView setEditing:YES animated:YES];
                                                         }], nil];
        self.menu = [[IFMMenu alloc] initWithItems:menuItems];
        self.menu.titleFont = [UIFont systemFontOfSize:15];
        
        self.tableView.frame = CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT - 45);
        [self.view addSubview:self.tableView];
    }
    
    //全选
    self.selectAllView.selectAllBlock = ^(UIButton *button) {
        if (weakSelf.dataArray.count) {
            button.selected = !button.selected;
            [weakSelf.deleteArray removeAllObjects];
            if (button.selected) {
                for (DataModel *model in weakSelf.dataArray) {
                    [weakSelf.deleteArray addObject:model];
                    model.isSelected = @"1";
                    weakSelf.selectAllView.deleteAllBtn.enabled = YES;
                    weakSelf.selectAllView.deleteAllBtn.backgroundColor = [UIColor redColor];
                    [weakSelf.selectAllView.deleteAllBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
            }else {
                for (DataModel *model in weakSelf.dataArray) {
                    model.isSelected = @"0";
                    weakSelf.selectAllView.deleteAllBtn.enabled = NO;
                    weakSelf.selectAllView.deleteAllBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
                    [weakSelf.selectAllView.deleteAllBtn setTitleColor:[UIColor colorWithWhite:0 alpha:0.3] forState:UIControlStateNormal];
                }
            }
            [weakSelf.tableView reloadData];
        }
    };
    
    //删除
    self.selectAllView.deleteAllBlock = ^(UIButton *button) {
        //加弹窗(删除成功将tableview编辑模式关闭)
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要删除选中数据？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            for (DataModel *model in weakSelf.deleteArray) {
                NSString *dateStr = model.date;
                //读取文件夹下的所有文件
                NSFileManager *fileManager = [NSFileManager defaultManager];
                //在这里获取应用程序Documents文件夹里的文件及文件夹列表
                NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *dataFilePath = [documentDir stringByAppendingPathComponent:@"AllDatas"];
                NSString *path = [NSString stringWithFormat:@"%@/%@.txt",dataFilePath, dateStr];
                [fileManager removeItemAtPath:path error:nil];
                [weakSelf.dataArray removeObject:model];
            }
            [weakSelf.tableView reloadData];
            [weakSelf.deleteArray removeAllObjects];
            weakSelf.selectAllView.selectAllBtn.selected = NO;
            weakSelf.selectAllView.deleteAllBtn.enabled = NO;
            weakSelf.selectAllView.deleteAllBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
            [weakSelf.selectAllView.deleteAllBtn setTitleColor:[UIColor colorWithWhite:0 alpha:0.3] forState:UIControlStateNormal];
            
            weakSelf.toastView.hidden = NO;
            weakSelf.toastView.alpha = 1.0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.toastView.hidden = YES;
                weakSelf.toastView.alpha = 0.0;
            });
        }];
        [alert addAction:actionOne];
        [alert addAction:actionTwo];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    };
    
    //取消
    self.selectAllView.cancelBlock = ^(UIButton *button) {
        [weakSelf.deleteArray removeAllObjects];
        weakSelf.selectAllView.hidden = YES;
        weakSelf.dropMenu.hidden = NO;
        if (!weakSelf.isBrowseRecords) {
            weakSelf.editView.hidden = NO;
        }
        if (weakSelf.isBrowseRecords) {
            weakSelf.tableView.frame = CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - naviHeight - 45);
        }else {
            weakSelf.tableView.frame = CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - naviHeight - 110 - 45);
        }
        [weakSelf.tableView setEditing:NO animated:YES];
        weakSelf.selectAllView.selectAllBtn.selected = NO;
        weakSelf.selectAllView.deleteAllBtn.enabled = NO;
        weakSelf.selectAllView.deleteAllBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        [weakSelf.selectAllView.deleteAllBtn setTitleColor:[UIColor colorWithWhite:0 alpha:0.3] forState:UIControlStateNormal];
        for (DataModel *model in weakSelf.dataArray) {
            model.isSelected = @"0";
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    };
    
    //读取历史数据
    [self readDataFromLocal];
}

#pragma mark --- DOPDropDownMenuDelegate
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return self.menuDic.count;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    NSArray *array = [self.menuDic objectForKey:[NSString stringWithFormat:@"%ld", (long)column]];
    return array.count;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    switch (indexPath.column) {
        case 0:
            return self.modelArray[indexPath.row];
            break;
        case 1:
            return self.memberArray[indexPath.row];
        default:
            return nil;
            break;
    }
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
    NSLog(@"column:%li row:%li", (long)indexPath.column, (long)indexPath.row);
    NSLog(@"%@",[menu titleForRowAtIndexPath:indexPath]);
    
    if (indexPath.column == 0) {
        if (indexPath.row == 0) {
            self.testModel = TestModelForeign;
            [self getMembers];
        }else if (indexPath.row == 1) {
            self.testModel = TestModelInternal;
            [self getMembers];
        }else if (indexPath.row == 2) {
            self.currentModel = nil;
            self.testModel = TestModelDefalut;
            [self.memberArray removeAllObjects];
            [self.memberArray addObject:@"无"];
        }
    }else {
        if (indexPath.row == 0 && (self.testModel == 1 || self.testModel == 2)) {//添加人员
            AddTestersViewController *testViewController = [[AddTestersViewController alloc] init];
            testViewController.testModel = [NSString stringWithFormat:@"%ld", (long)self.testModel];
            [self.navigationController pushViewController:testViewController animated:YES];
        }else if(self.testModel == 1 || self.testModel == 2) {
            self.currentModel = self.allMembers[indexPath.row - 1];
            //获取此人的所有血糖测试记录
//            [self getMemberAllBloodValues];
        }
    }
}

//显示更多(设置，删除)
- (void)showMoreFunctions {
    [self.menu showFromNavigationController:self.navigationController WithX:SCREEN_WIDTH - 30];
}

- (void)showSettingView {
    self.settingView.hidden = NO;
    self.settingView.normalChangeTimeTextField.text = nil;
    self.settingView.normalOutputPowerTextField.text = nil;
    self.settingView.veryHighChangeTimeTextField.text = nil;
    self.settingView.veryHighOutputPowerTextField.text = nil;
    self.settingView.highChangeTimeTextField.text = nil;
    self.settingView.highOutputPowerTextField.text = nil;
    self.settingView.lowChangeTimeTextField.text = nil;
    self.settingView.lowOutputPowerTextField.text = nil;
    [self.settingView.normalChangeTimeTextField becomeFirstResponder];
    [self setDefalutData];
    [UIView animateWithDuration:0.3 animations:^{
        self.settingView.alpha = 1.0;
    }];
}

- (void)setDefalutData {
    //设置激光输出功率
    self.setNormalPowerString = nil;
    self.setVeryHighPowerString = nil;
    self.setHighPowerString = nil;
    self.setLowPowerString = nil;
    //设置积分时间
    self.setNormalTimeString = nil;
    self.setVeryHighTimeString = nil;
    self.setHighTimeString = nil;
    self.setLowTimeString= nil;
}

//时间/功率确定设置按钮点击事件
- (void)confirmBtnClicked {
    BOOL ifSaveSuccess = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (!self.setNormalTimeString && !self.setNormalPowerString && !self.setVeryHighTimeString && !self.setVeryHighPowerString && !self.setHighTimeString && !self.setHighPowerString && !self.setLowTimeString && !self.setLowPowerString) {
        HUD_TEXTONLY(@"参数为空");
        ifSaveSuccess = NO;
    }
    if ((self.setNormalTimeString && !self.setNormalPowerString) || (!self.setNormalTimeString && self.setNormalPowerString) || (self.setVeryHighTimeString && !self.setVeryHighPowerString) || (!self.setVeryHighTimeString && self.setVeryHighPowerString) || (self.setHighTimeString && !self.setHighPowerString) || (!self.setHighTimeString && self.setHighPowerString) || (self.setLowTimeString && !self.setLowPowerString) || (!self.setLowTimeString && self.setLowPowerString)) {
        HUD_TEXTONLY(@"功率和积分时间需同时设置");
        ifSaveSuccess = NO;
    }
    if (ifSaveSuccess) {
        if (self.setNormalTimeString && self.setNormalPowerString) {
            [defaults setObject:self.setNormalTimeString forKey:NORMAL_TIME];
            [defaults setObject:self.setNormalPowerString forKey:NORMAL_POWER];
        }
        if (self.setVeryHighTimeString && self.setVeryHighPowerString) {
            [defaults setObject:self.setVeryHighTimeString forKey:VERY_HIGH_TIME];
            [defaults setObject:self.setVeryHighPowerString forKey:VERY_HIGH_POWER];
        }
        if (self.setHighTimeString && self.setHighPowerString) {
            [defaults setObject:self.setHighTimeString forKey:HIGH_TIME];
            [defaults setObject:self.setHighPowerString forKey:HIGH_POWER];
        }
        if (self.setLowTimeString && self.setLowPowerString) {
            [defaults setObject:self.setLowTimeString forKey:LOW_TIME];
            [defaults setObject:self.setLowPowerString forKey:LOW_POWER];
        }
        [self saveToLocalSuccess];
    }else {
        return;
    }
}

- (void)saveToLocalSuccess {
    HUD_TEXTONLY(@"设置成功");
    [self.settingView endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.settingView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.settingView.hidden = YES;
        self.settingView.settingView.contentOffset = CGPointZero;
    }];
}

//时间/功率取消按钮点击事件
- (void)cancelBtnClicked {
    [self.settingView endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.settingView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.settingView.hidden = YES;
        self.settingView.settingView.contentOffset = CGPointZero;
    }];
}

#pragma textfield delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (!textField.text.length) {
        if ([string isEqualToString:@"0"]) {
            return NO;
        }
    }
    return [self validateNumberByRegExp:string];
}

- (BOOL)validateNumberByRegExp:(NSString *)string {
    BOOL isValid = YES;
    NSInteger length = string.length;
    if (length > 0) {
        NSString *numberRegexp = @"^[0-9]*$";
        NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegexp];
        isValid = [numberPredicate evaluateWithObject:string];
    }
    return isValid;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.textField = textField;
}

- (void)textfieldTextDidChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    if (textField == self.settingView.normalChangeTimeTextField) {//设置积分时间(正常)
        if ([textField.text intValue] > 10000) {
            textField.text = @"10000";
            HUD_TEXTONLY(@"超出最大范围10000");
        }
        if (textField.text.length) {
            NSString *timeString = [CustomTools getHexByDecimal:[textField.text integerValue]];
            self.setNormalTimeString = timeString;
//            self.setNormalTimeString = @"0xFF0xFF0x010x830x040x000x110x220x330x440x550x660x010x000x880x130x000x000x1f0xFF0xFF";
//            self.setNormalTimeString = [self.setNormalTimeString stringByReplacingCharactersInRange:NSMakeRange(56, 8) withString:timeString];
            NSLog(@"%@",self.setNormalTimeString);
        }else {
            self.setNormalTimeString = nil;
        }
    }else if (textField == self.settingView.normalOutputPowerTextField) {//设置激光输出功率(正常)
        if ([textField.text intValue] > 8) {
            textField.text = @"8";
            HUD_TEXTONLY(@"超出最大范围8");
        }
        if (textField.text.length) {
            self.setNormalPowerString = textField.text;
//            self.setNormalPowerString = @"0xFF0xFF0x020x830x040x000x110x220x330x440x550x660x020x000x080x000x000x000x1f0xFF0xFF";
//            self.setNormalPowerString = [self.setNormalPowerString stringByReplacingCharactersInRange:NSMakeRange(59, 1) withString:textField.text];
            NSLog(@"%@",self.setNormalPowerString);
        }else {
            self.setNormalPowerString = nil;
        }
    }else if (textField == self.settingView.veryHighChangeTimeTextField) {
        if ([textField.text intValue] > 10000) {
            textField.text = @"10000";
            HUD_TEXTONLY(@"超出最大范围10000");
        }
        if (textField.text.length) {
            NSString *timeString = [CustomTools getHexByDecimal:[textField.text integerValue]];
            self.setVeryHighTimeString = timeString;
//            self.setVeryHighTimeString = @"0xFF0xFF0x010x830x040x000x110x220x330x440x550x660x010x000x880x130x000x000x1f0xFF0xFF";
//            self.setVeryHighTimeString = [self.setVeryHighTimeString stringByReplacingCharactersInRange:NSMakeRange(56, 8) withString:timeString];
            NSLog(@"%@",self.setVeryHighTimeString);
        }else {
            self.setVeryHighTimeString = nil;
        }
    }else if (textField == self.settingView.veryHighOutputPowerTextField) {
        if ([textField.text intValue] > 8) {
            textField.text = @"8";
            HUD_TEXTONLY(@"超出最大范围8");
        }
        if (textField.text.length) {
            self.setVeryHighPowerString = textField.text;
//            self.setVeryHighPowerString = @"0xFF0xFF0x020x830x040x000x110x220x330x440x550x660x020x000x080x000x000x000x1f0xFF0xFF";
//            self.setVeryHighPowerString = [self.setVeryHighPowerString stringByReplacingCharactersInRange:NSMakeRange(59, 1) withString:textField.text];
            NSLog(@"%@",self.setVeryHighPowerString);
        }else {
            self.setVeryHighPowerString = nil;
        }
    }else if (textField == self.settingView.highChangeTimeTextField) {
        if ([textField.text intValue] > 10000) {
            textField.text = @"10000";
            HUD_TEXTONLY(@"超出最大范围10000");
        }
        if (textField.text.length) {
            NSString *timeString = [CustomTools getHexByDecimal:[textField.text integerValue]];
            self.setHighTimeString = timeString;
//            self.setHighTimeString = @"0xFF0xFF0x010x830x040x000x110x220x330x440x550x660x010x000x880x130x000x000x1f0xFF0xFF";
//            self.setHighTimeString = [self.setHighTimeString stringByReplacingCharactersInRange:NSMakeRange(56, 8) withString:timeString];
            NSLog(@"%@",self.setHighTimeString);
        }else {
            self.setHighTimeString = nil;
        }
    }else if (textField == self.settingView.highOutputPowerTextField) {
        if ([textField.text intValue] > 8) {
            textField.text = @"8";
            HUD_TEXTONLY(@"超出最大范围8");
        }
        if (textField.text.length) {
            self.setHighPowerString = textField.text;
//            self.setHighPowerString = @"0xFF0xFF0x020x830x040x000x110x220x330x440x550x660x020x000x080x000x000x000x1f0xFF0xFF";
//            self.setHighPowerString = [self.setHighPowerString stringByReplacingCharactersInRange:NSMakeRange(59, 1) withString:textField.text];
            NSLog(@"%@",self.setHighPowerString);
        }else {
            self.setHighPowerString = nil;
        }
    }else if (textField == self.settingView.lowChangeTimeTextField) {
        if ([textField.text intValue] > 10000) {
            textField.text = @"10000";
            HUD_TEXTONLY(@"超出最大范围10000");
        }
        if (textField.text.length) {
            NSString *timeString = [CustomTools getHexByDecimal:[textField.text integerValue]];
            self.setLowTimeString = timeString;
//            self.setLowTimeString = @"0xFF0xFF0x010x830x040x000x110x220x330x440x550x660x010x000x880x130x000x000x1f0xFF0xFF";
//            self.setLowTimeString = [self.setLowTimeString stringByReplacingCharactersInRange:NSMakeRange(56, 8) withString:timeString];
            NSLog(@"%@",self.setLowTimeString);
        }else {
            self.setLowTimeString = nil;
        }
    }else if (textField == self.settingView.lowOutputPowerTextField) {
        if ([textField.text intValue] > 8) {
            textField.text = @"8";
            HUD_TEXTONLY(@"超出最大范围8");
        }
        if (textField.text.length) {
            self.setLowPowerString = textField.text;
//            self.setLowPowerString = @"0xFF0xFF0x020x830x040x000x110x220x330x440x550x660x020x000x080x000x000x000x1f0xFF0xFF";
//            self.setLowPowerString = [self.setLowPowerString stringByReplacingCharactersInRange:NSMakeRange(59, 1) withString:textField.text];
            NSLog(@"%@",self.setLowPowerString);
        }else {
            self.setLowPowerString = nil;
        }
    }
}

- (void)requestServer:(UISwitch *)sender {
    if (sender.on == YES) {//访问服务器
        HUD_TEXTONLY(@"开启服务器访问");
    }else {//不访问服务器
        HUD_TEXTONLY(@"关闭服务器访问");
    }
}

//打开光谱检测
- (void)open:(UIButton *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *ifPrintLog;
    if ([[defaults objectForKey:PRINT_LOG] isEqualToString:@"1"]) {
        ifPrintLog = @"01";
    }else {
        ifPrintLog = @"00";
    }
    if ([sender.titleLabel.text isEqualToString:@"正常功率检测"]) {
        self.checkStatus = CheckStatusNormal;
        self.setTimeString = [defaults objectForKey:NORMAL_TIME];
        self.setPowerString = [defaults objectForKey:NORMAL_POWER];
        if ([[defaults objectForKey:GET_MULTIPLE_DATA] isEqualToString:@"1"]) {//获取多次数据
            self.openString = [NSString stringWithFormat:@"0xFF0xFF0x010x820x000x000x110x220x330x440x550x660x030x000x010x000x%@0x00%@0x000x000x0%@0x000x000x000x1f0xFF0xFF", ifPrintLog, [defaults objectForKey:NORMAL_TIME], [defaults objectForKey:NORMAL_POWER]];
        }else {
            self.openString = [NSString stringWithFormat:@"0xFF0xFF0x010x820x000x000x110x220x330x440x550x660x030x000x000x000x%@0x00%@0x000x000x0%@0x000x000x000x1f0xFF0xFF", ifPrintLog, [defaults objectForKey:NORMAL_TIME], [defaults objectForKey:NORMAL_POWER]];
        }
    }else if ([sender.titleLabel.text isEqualToString:@"超高功率检测"]) {
        self.checkStatus = CheckStatusVeryHigh;
        self.setTimeString = [defaults objectForKey:VERY_HIGH_TIME];
        self.setPowerString = [defaults objectForKey:VERY_HIGH_POWER];
        if ([[defaults objectForKey:GET_MULTIPLE_DATA] isEqualToString:@"1"]) {//获取多次数据
            self.openString = [NSString stringWithFormat:@"0xFF0xFF0x010x820x000x000x110x220x330x440x550x660x030x000x010x000x%@0x00%@0x000x000x0%@0x000x000x000x1f0xFF0xFF", ifPrintLog, [defaults objectForKey:VERY_HIGH_TIME], [defaults objectForKey:VERY_HIGH_POWER]];
        }else {
            self.openString = [NSString stringWithFormat:@"0xFF0xFF0x010x820x000x000x110x220x330x440x550x660x030x000x000x000x%@0x00%@0x000x000x0%@0x000x000x000x1f0xFF0xFF", ifPrintLog, [defaults objectForKey:VERY_HIGH_TIME], [defaults objectForKey:VERY_HIGH_POWER]];
        }
    }else if ([sender.titleLabel.text isEqualToString:@"偏高功率检测"]) {
        self.checkStatus = CheckStatusHigh;
        self.setTimeString = [defaults objectForKey:HIGH_TIME];
        self.setPowerString = [defaults objectForKey:HIGH_POWER];
        if ([[defaults objectForKey:GET_MULTIPLE_DATA] isEqualToString:@"1"]) {//获取多次数据
            self.openString = [NSString stringWithFormat:@"0xFF0xFF0x010x820x000x000x110x220x330x440x550x660x030x000x010x000x%@0x00%@0x000x000x0%@0x000x000x000x1f0xFF0xFF", ifPrintLog, [defaults objectForKey:HIGH_TIME], [defaults objectForKey:HIGH_POWER]];
        }else {
            self.openString = [NSString stringWithFormat:@"0xFF0xFF0x010x820x000x000x110x220x330x440x550x660x030x000x000x000x%@0x00%@0x000x000x0%@0x000x000x000x1f0xFF0xFF", ifPrintLog, [defaults objectForKey:HIGH_TIME], [defaults objectForKey:HIGH_POWER]];
        }
    }else if ([sender.titleLabel.text isEqualToString:@"低功率检测"]) {
        self.checkStatus = CheckStatusLow;
        self.setTimeString = [defaults objectForKey:LOW_TIME];
        self.setPowerString = [defaults objectForKey:LOW_POWER];
        if ([[defaults objectForKey:GET_MULTIPLE_DATA] isEqualToString:@"1"]) {//获取多次数据
            self.openString = [NSString stringWithFormat:@"0xFF0xFF0x010x820x000x000x110x220x330x440x550x660x030x000x010x000x%@0x00%@0x000x000x0%@0x000x000x000x1f0xFF0xFF", ifPrintLog, [defaults objectForKey:LOW_TIME], [defaults objectForKey:LOW_POWER]];
        }else {
            self.openString = [NSString stringWithFormat:@"0xFF0xFF0x010x820x000x000x110x220x330x440x550x660x030x000x000x000x%@0x00%@0x000x000x0%@0x000x000x000x1f0xFF0xFF", ifPrintLog, [defaults objectForKey:LOW_TIME], [defaults objectForKey:LOW_POWER]];
        }
    }
    //开启检测
    if (!self.isLinked) {
        HUD_TEXTONLY(@"蓝牙未连接");
    }else {
        if (!self.setTimeString && !self.setPowerString) {
            HUD_TEXTONLY(@"请先设置参数");
            [self showSettingView];
        }else {
            if (self.peripheral && self.writeCharacteristic) {
                HUD_SHOW(@"正在测试，请不要移动手指...", @"");
                self.dataNum = 0;
                self.haveUnusualData = NO;
                NSData *data = [CustomTools dataFromHexString:self.openString];
                [self.peripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
                NSDate *date = [NSDate date];
                NSLog(@"开始：%@",[self.dateFormatter stringFromDate:date]);
            }else {
                HUD_TEXTONLY(@"操作未成功");
            }
        }
    }
}

- (void)resetAndOpen {
    if (self.checkStatus == CheckStatusNormal) {
        [self open:self.editView.normalCheckButton];
    }else if (self.checkStatus == CheckStatusVeryHigh) {
        [self open:self.editView.veryHighCheckButton];
    }else if (self.checkStatus == CheckStatusHigh) {
        [self open:self.editView.highCheckButton];
    }else if (self.checkStatus == CheckStatusLow) {
        [self open:self.editView.lowCheckButton];
    }
}

//写入
- (void)saveDataToLocalWithDataString:(NSString *)dataStr date:(NSString *)nowDate requestValue:(NSString *)requestValue code:(NSString *)code valueID:(NSString *)valueID {
    //创建文件夹存储每一份文件
    NSString * documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dataFilePath = [documentDir stringByAppendingPathComponent:@"AllDatas"]; // 在Document目录下创建 "AllDatas" 文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否存在，isDirectory判断是否是一个文件夹
    BOOL existed = [fileManager fileExistsAtPath:dataFilePath isDirectory:&isDir];
    if (!(isDir && existed)) {
        // 在Document目录下创建一个AllDatas目录
        [fileManager createDirectoryAtPath:dataFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    // 在AllDatas下写入文件
    NSString *path = [dataFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",self.nowDateString]];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:dataStr, @"dataString", requestValue, @"requestValue", nowDate, @"date", code, @"code", @"0", @"isSelected" ,valueID, @"valueID", nil];
    [dictionary writeToFile:path atomically:YES];
    
    [self readDataFromLocal];
}

//读取
- (void)readDataFromLocal {
    //读取文件夹下的所有文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dataFilePath = [documentDir stringByAppendingPathComponent:@"AllDatas"];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:dataFilePath error:&error];
    //获得的fileList中列出文件名
    [self.dataArray removeAllObjects];
    for (int i=(int)fileList.count-1; i>=0; i--) {
        NSString *file = fileList[i];
        NSString *path = [dataFilePath stringByAppendingPathComponent:file];
        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        DataModel *model = [[DataModel alloc] initWithDictionary:[dataDic copy] error:nil];
        if (!self.ifShowErrorData) {
            if ([[dataDic objectForKey:@"code"] isEqualToString:@"200"]) {
                [self.dataArray addObject:model];
            }
        }else {
            [self.dataArray addObject:model];
        }
    }
    //测试数据
//    for (int i=0; i<20; i++) {
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"10,26,13,66,45,35,96,27,78,9", @"dataString", @"10.1", @"requestValue", @"2018.11.7", @"date", @"200", @"code", @"0", @"isSelected", nil];
//        DataModel *model = [[DataModel alloc] initWithDictionary:dic error:nil];
//        [self.dataArray addObject:model];
//    }
    
    [self.tableView reloadData];
}

//发现服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    //遍历外设中所有的服务
    for (CBService *service in peripheral.services) {
        NSLog(@"service===%@",service);
    }
    //这里由于只有一个服务，所以直接取，实际开发中可能不止一个，可通过上面的遍历获取
    CBService *service = peripheral.services.lastObject;
    //根据UUID寻找服务中的特征
    if (service) {
        //        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:CHARACTERISTIC_UUID]] forService:service];
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

//发现特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    //遍历服务中的所有特征,拿到不同特征的UUID，不同的特征处理不同的事情
    if (error) {
        NSLog(@"characteristic error：%@",error);
    }else {
        for (int i=0; i<service.characteristics.count; i++) {
            CBCharacteristic *characteristic = service.characteristics[i];
            NSLog(@"characteristic===%@",characteristic);
            if ([characteristic.UUID.UUIDString hasPrefix:@"6E400002"]) {
                self.writeCharacteristic = characteristic;
                self.readCharacteristic = characteristic;
            }else if ([characteristic.UUID.UUIDString hasPrefix:@"6E400003"]) {
                self.noitCharacteristic = characteristic;
                //订阅通知
                [peripheral setNotifyValue:YES forCharacteristic:self.noitCharacteristic];
            }
        }
    }
}

//接收到外设数据回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    //蓝牙返回的数据
    NSString *receivedString = [CustomTools stringFromData:characteristic.value];
    NSLog(@"%@",characteristic.value);
    if (error) {
        NSLog(@"数据回调error：%@",error);
//        [self resetAndOpen];
    }else {
        if ([receivedString hasPrefix:@"ffff0100"] && [[receivedString substringWithRange:NSMakeRange(receivedString.length - 7, 1)] isEqualToString:@"0"]) {
            //30s没有获取到蓝牙返回的光谱数据，超时处理
            [self performSelector:@selector(timeOut) withObject:@"timeOut" afterDelay:30];
            self.needPostDataTwice = NO;
            if ([[receivedString substringWithRange:NSMakeRange(36, 2)] isEqualToString:@"04"]) {
                self.needPostDataTwice = YES;
            }
        }else if ([receivedString hasPrefix:@"ffff0100"] && [[receivedString substringWithRange:NSMakeRange(receivedString.length - 7, 1)] isEqualToString:@"1"]) {
            HUD_TEXTONLY(@"操作未成功");
        }else if ([receivedString hasPrefix:@"ffff0100"] && [[receivedString substringWithRange:NSMakeRange(receivedString.length - 7, 1)] isEqualToString:@"3"]) {
            HUD_TEXTONLY(@"操作未成功");
        }else {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeOut) object:@"timeOut"];
            //数据异常
            if (![[receivedString substringToIndex:4] isEqualToString:@"ffff"]) {
                self.haveUnusualData = YES;
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissHud) object:@"dismiss"];
            }
            //总包数
            int totalWraps = [[CustomTools decimalStringWithHexString:[receivedString substringWithRange:NSMakeRange(28, 4)]] intValue];
            //包序号
            int wrapNumber = [[CustomTools decimalStringWithHexString:[receivedString substringWithRange:NSMakeRange(32, 4)]] intValue];
            if (wrapNumber == 1) {
                if (self.dataNum == 0) {
                    NSDate *date = [NSDate date];
                    NSLog(@"第一次接收到蓝牙返回数据：%@",[self.dateFormatter stringFromDate:date]);
                    HUD_SHOW(@"测试完成，正在分析数据...", @"");
                }
                self.dataNum++;
            }
            NSLog(@"%d:%d",totalWraps,wrapNumber);
            if (self.needPostDataTwice && self.dataNum == 2) {
                [self.dataStringTwo appendString:[CustomTools decimalStringWithHexString:[receivedString substringWithRange:NSMakeRange(36, receivedString.length - 42)]]];
            }else {
                [self.dataStringOne appendString:[CustomTools decimalStringWithHexString:[receivedString substringWithRange:NSMakeRange(36, receivedString.length - 42)]]];
            }
            
            if (wrapNumber == totalWraps) {//所有数据都返回时
                if (self.needPostDataTwice && self.dataNum == 2) {//需要发送两次数据的情况
                    NSDate *date = [NSDate date];
                    NSLog(@"接收到所有数据：%@",[self.dateFormatter stringFromDate:date]);
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissHud) object:@"dismiss"];
//                    NSArray *totalCount1 = [[self.dataStringOne substringToIndex:self.dataStringOne.length - 1] componentsSeparatedByString:@","];
//                    NSArray *totalCount2 = [[self.dataStringTwo substringToIndex:self.dataStringOne.length - 1] componentsSeparatedByString:@","];
//                    if (totalCount1.count != 905 && totalCount2.count != 905) {
//                        self.haveUnusualData = YES;
//                    }
//                    //数据异常时不往下执行
//                    if (self.haveUnusualData) {
//                        HUD_TEXTONLY(@"光谱数据异常");
//                        return;
//                    }
                    if (self.RequestServerSwitch.on == YES) {
                        //发送数据给服务器
                        if (self.isNetWorkStatuOK) {
                            [self postDataToServerWithDataStringOne:self.dataStringOne dataStringTwo:self.dataStringTwo];
                        }else {
                            HUD_TEXTONLY(@"网络异常，请检查网络");
                        }
                    }else {
                        NSDate *date = [NSDate date];
                        self.nowDateString = [self.dateFormatter stringFromDate:date];
                        self.requestValue = @"无服务器返回值";
                        //                    [self saveDataToLocalWithDataString:[self.dataStringOne substringToIndex:self.dataStringOne.length - 1] date:self.nowDateString requestValue:self.requestValue code:@"00"];
                        [self saveDataToLocalWithDataString:[self.dataStringTwo substringToIndex:self.dataStringTwo.length - 1] date:self.nowDateString requestValue:self.requestValue code:@"00" valueID:@"00"];
                    }
                    NSLog(@"%@%@",self.dataStringOne, self.dataStringTwo);
                }else {
                    NSDate *date = [NSDate date];
                    NSLog(@"接收到所有数据：%@",[self.dateFormatter stringFromDate:date]);
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissHud) object:@"dismiss"];
                    NSArray *totalCount = [[self.dataStringOne substringToIndex:self.dataStringOne.length - 1] componentsSeparatedByString:@","];
                    NSLog(@"总值数：%ld", (long)totalCount.count);
                    if (totalCount.count != 905) {
                        self.haveUnusualData = YES;
                    }
                    //判断峰值、峰谷
                    
                    //数据异常时不往下执行
                    if (self.haveUnusualData) {
                        HUD_TEXTONLY(@"光谱数据异常");
                        return;
                    }
                    if (self.RequestServerSwitch.on == YES) {
                        //发送数据给服务器
                        if (self.isNetWorkStatuOK) {
                            [self postDataToServerWithDataStringOne:self.dataStringOne dataStringTwo:nil];
                        }else {
                            HUD_TEXTONLY(@"网络异常，请检查网络");
                        }
                    }else {
                        NSDate *date = [NSDate date];
                        self.nowDateString = [self.dateFormatter stringFromDate:date];
                        self.requestValue = @"无服务器返回值";
                        [self saveDataToLocalWithDataString:[self.dataStringOne substringToIndex:self.dataStringOne.length - 1] date:self.nowDateString requestValue:self.requestValue code:@"00" valueID:@"00"];
                    }
                    NSLog(@"%@",self.dataStringOne);
                }
            }
        }
    }
}

- (void)timeOut {
    HUD_TEXTONLY(@"无光谱数据")
}

- (void)dismissHud {
    HUD_Dismiss;
}

//订阅状态的改变
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"订阅失败:%@",error);
    }
    if (characteristic.isNotifying) {
        NSLog(@"订阅成功!");
    }else {
        NSLog(@"取消订阅");
    }
}

//写入数据回调
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    self.needPostDataTwice = NO;
    if (error) {
        NSLog(@"写入错误：%@",error);
        HUD_Dismiss;
//        [self resetAndOpen];
    }else {
        self.dataStringOne = nil;
        self.dataStringTwo = nil;
        //接收不到返回数据或数据不全数据时，60秒隐藏吐司
        [self performSelector:@selector(dismissHud) withObject:@"dismiss" afterDelay:60];
        NSLog(@"写入成功");
        NSDate *date = [NSDate date];
        NSLog(@"写入成功：%@",[self.dateFormatter stringFromDate:date]);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dataCell" forIndexPath:indexPath];
    DataModel *model = self.dataArray[indexPath.row];
    if (!self.isBrowseRecords) {
        if (indexPath.row == 0) {
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        }else {
            cell.textLabel.font = [UIFont systemFontOfSize:15];
        }
    }else {
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    cell.model = model;
    //添加长按手势
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPress:)];
    longPressGesture.minimumPressDuration = 1.0;
    [cell addGestureRecognizer:longPressGesture];
    return cell;
}

- (void)cellLongPress:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    if (longPressGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [longPressGestureRecognizer locationInView:self.tableView];
        self.indexPath = [self.tableView indexPathForRowAtPoint:location];
        self.alertView = [[CustomAlertView alloc]initWithTitle:@"" message:@"请输入血糖值" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        self.alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [self.alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //取消index=0，确定index=1
    if (buttonIndex == 1) {
        UITextField *valueTextField = [alertView textFieldAtIndex:0];
        if ([[valueTextField.text substringToIndex:1] isEqualToString:@"."]) {
            [self showValueErrorView];
            self.alertView.dismissEnabled = NO;
        }else if([self isOnlyhasNumberAndpointWithString:valueTextField.text]) {
            //正常
            self.alertView.dismissEnabled = YES;
            DataModel *model = self.dataArray[self.indexPath.row];
            if (model.valueID.length) {
                [self postNormalValueWithValue:valueTextField.text valueID:model.valueID];
            }else {
                HUD_TEXTONLY(@"ID值不存在");
            }
        }else {
            [self showValueErrorView];
            self.alertView.dismissEnabled = NO;
        }
    }
}

- (void)showValueErrorView {
    self.valueErrorView.hidden = NO;
    self.valueErrorView.alpha = 1.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.valueErrorView.hidden = YES;
        self.valueErrorView.alpha = 0.0;
    });
}

//是否为数字和点
- (BOOL)isOnlyhasNumberAndpointWithString:(NSString *)string {
    NSCharacterSet *cs=[[NSCharacterSet characterSetWithCharactersInString:@".0123456789"] invertedSet];
    NSString *filter=[[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filter];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DataModel *model = self.dataArray[indexPath.row];
    if (tableView.isEditing) {//多选删除模式下
        if ([model.isSelected isEqualToString:@"0"]) {
            model.isSelected = @"1";
            [self.deleteArray addObject:model];
        }else {
            model.isSelected = @"0";
            [self.deleteArray removeObject:model];
        }
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        BOOL isSelectedAll = YES;
        BOOL noSelect = YES;
        for (DataModel *mod in self.dataArray) {
            if ([mod.isSelected isEqualToString:@"0"]) {
                isSelectedAll = NO;
            }else {
                noSelect = NO;
            }
        }
        //判断是否全选
        if (isSelectedAll) {
            self.selectAllView.selectAllBtn.selected = YES;
        }else {
            self.selectAllView.selectAllBtn.selected = NO;
        }
        //判断是否一个都没选
        if (noSelect) {
            self.selectAllView.deleteAllBtn.enabled = NO;
            self.selectAllView.deleteAllBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
            [self.selectAllView.deleteAllBtn setTitleColor:[UIColor colorWithWhite:0 alpha:0.3] forState:UIControlStateNormal];
        }else {
            self.selectAllView.deleteAllBtn.enabled = YES;
            self.selectAllView.deleteAllBtn.backgroundColor = [UIColor redColor];
            [self.selectAllView.deleteAllBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }else {
        ChartLineViewController *chartLineController = [[ChartLineViewController alloc] init];
        chartLineController.dataString = model.dataString;
        chartLineController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:chartLineController animated:YES completion:nil];
    }
}

//允许编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

/**
 设置编辑模式：
 UITableViewCellEditingStyleNone 没有编辑样式
 UITableViewCellEditingStyleDelete 删除样式 （左边是红色减号）
 UITableViewCellEditingStyleInsert 插入样式  (左边是绿色加号)
 UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert 多选模式，左边是蓝色对号
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing) {
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }else {
        return UITableViewCellEditingStyleDelete;
    }
}

//删除按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//数据、UI处理
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要删除该条数据？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            DataModel *model = self.dataArray[indexPath.row];
            NSString *dateStr = model.date;
            //读取文件夹下的所有文件
            NSFileManager *fileManager = [NSFileManager defaultManager];
            //在这里获取应用程序Documents文件夹里的文件及文件夹列表
            NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *dataFilePath = [documentDir stringByAppendingPathComponent:@"AllDatas"];
            NSString *path = [NSString stringWithFormat:@"%@/%@.txt",dataFilePath, dateStr];
            [fileManager removeItemAtPath:path error:nil];
            [self.dataArray removeObject:model];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        }];
        [alert addAction:actionOne];
        [alert addAction:actionTwo];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//发送血糖测试数据
- (void)postDataToServerWithDataStringOne:(NSMutableString *)dataStrOne dataStringTwo:(NSMutableString *_Nullable)dataStrTwo {
    NSDate *date = [NSDate date];
    NSLog(@"服务器请求：%@",[self.dateFormatter stringFromDate:date]);
    NSString *level;
    if (self.checkStatus == CheckStatusNormal) {
        level = @"0";
    }else if (self.checkStatus == CheckStatusLow) {
        level = @"1";
    }else if (self.checkStatus == CheckStatusHigh) {
        level = @"2";
    }else if (self.checkStatus == CheckStatusVeryHigh) {
        level = @"3";
    }
    NSDictionary *params;
    if (self.currentModel) {
        params = @{
                   @"staffId": self.currentModel.ID,
                   @"simulateBloodsugar":[NSString stringWithFormat:@"%@", [dataStrOne substringToIndex:dataStrOne.length - 1]],
                   @"level":level
                   };
    }else {
        params = @{
                   @"simulateBloodsugar":[NSString stringWithFormat:@"%@", [dataStrOne substringToIndex:dataStrOne.length - 1]],
                   @"level":level
                   };
    }
    [[NetRequest sharedRequest] postURL:[Add_Blood_Value getFullRequestPath] parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject=%@", responseObject);
        NSDate *date = [NSDate date];
        NSLog(@"服务器请求成功：%@",[self.dateFormatter stringFromDate:date]);
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [CustomTools jsonToArrayOrDictionary:responseString];
        if ([dic[@"code"] integerValue] == 200) {
            HUD_TEXTONLY(@"数据分析成功");
            NSDate *date = [NSDate date];
            self.nowDateString = [self.dateFormatter stringFromDate:date];
            self.requestValue = [NSString stringWithFormat:@"%@", dic[@"result"][@"testResult"]];
            if (dataStrOne.length && dataStrTwo.length) {
                [self saveDataToLocalWithDataString:[dataStrTwo substringToIndex:dataStrTwo.length - 1] date:self.nowDateString requestValue:self.requestValue code:@"200" valueID:dic[@"result"][@"bloodsugarId"]];
            }else {
                [self saveDataToLocalWithDataString:[dataStrOne substringToIndex:dataStrOne.length - 1] date:self.nowDateString requestValue:self.requestValue code:@"200" valueID:dic[@"result"][@"bloodsugarId"]];
            }
        }else if ([dic[@"code"] integerValue] == 5001) {
            HUD_TEXTONLY(@"手指轻一些！");
            NSDate *date = [NSDate date];
            self.nowDateString = [self.dateFormatter stringFromDate:date];
            self.requestValue = [NSString stringWithFormat:@"%@", dic[@"result"][@"testResult"]];
            if (dataStrOne.length && dataStrTwo.length) {
                [self saveDataToLocalWithDataString:[dataStrTwo substringToIndex:dataStrTwo.length - 1] date:self.nowDateString requestValue:self.requestValue code:@"5001" valueID:dic[@"result"][@"bloodsugarId"]];
            }else {
                [self saveDataToLocalWithDataString:[dataStrOne substringToIndex:dataStrOne.length - 1] date:self.nowDateString requestValue:self.requestValue code:@"5001" valueID:dic[@"result"][@"bloodsugarId"]];
            }
        }else {
            NSString *toast = [NSString stringWithFormat:@"%@", dic[@"result"][@"testResult"]];
            HUD_TEXTONLY(toast);
            NSDate *date = [NSDate date];
            self.nowDateString = [self.dateFormatter stringFromDate:date];
            self.requestValue = toast;
            if (dataStrOne.length && dataStrTwo.length) {
                [self saveDataToLocalWithDataString:[dataStrTwo substringToIndex:dataStrTwo.length - 1] date:self.nowDateString requestValue:self.requestValue code:dic[@"code"] valueID:dic[@"result"][@"bloodsugarId"]];
            }else {
                [self saveDataToLocalWithDataString:[dataStrOne substringToIndex:dataStrOne.length - 1] date:self.nowDateString requestValue:self.requestValue code:dic[@"code"] valueID:dic[@"result"][@"bloodsugarId"]];
            }
        }
        NSLog(@"上传血糖测试数据:%@", dic);
    } failed:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HUD_TEXTONLY(error.localizedDescription);
    }];
}

//获取人员
- (void)getMembers {
    if (self.requestComplete) {
        NSString *urlStr;
        if (self.testModel == TestModelForeign) {
            self.requestComplete = NO;
            urlStr = Get_Foreigns;
        }else if (self.testModel == TestModelInternal) {
            self.requestComplete = NO;
            urlStr = Get_Internals;
        }
        [[NetRequest sharedRequest] postURL:[urlStr getFullRequestPath] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSDictionary *dic = [CustomTools jsonToArrayOrDictionary:responseString];
            if ([dic[@"code"] integerValue] == 200) {
                [self.allMembers removeAllObjects];
                for (NSDictionary *memDic in dic[@"result"]) {
                    MemberModel *model = [[MemberModel alloc] initWithDictionary:memDic error:nil];
                    [self.allMembers addObject:model];
                }
                [self.memberArray removeAllObjects];
                [self.memberArray addObject:@"添加人员"];
                for (MemberModel *model in self.allMembers) {
                    [self.memberArray addObject:[NSString stringWithFormat:@"%d号：%@", [model.serial_number intValue] + 1, model.staff_name]];
                }
            }
            self.requestComplete = YES;
            NSLog(@"人员：%@",dic);
        } failed:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            self.requestComplete = YES;
            [self.memberArray removeAllObjects];
            [self.memberArray addObject:@"添加人员"];
        }];
    }
}

//将填写的正常血糖值发送给服务器
- (void)postNormalValueWithValue:(NSString *)value valueID:(NSString *)valueID {
    NSDictionary *params = @{
                             @"bloodsugarId": valueID,
                             @"trueBloodsugar": value
                             };
    [[NetRequest sharedRequest] postURL:[Add_Real_Blood_Value getFullRequestPath] parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [CustomTools jsonToArrayOrDictionary:responseString];
        if ([dic[@"code"] integerValue] == 200) {
            HUD_TEXTONLY(@"添加成功");
        }
        NSLog(@"添加真实血糖：%@", dic);
    } failed:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HUD_TEXTONLY(error.localizedDescription);
    }];
}

//查询某人的所有血糖值
- (void)getMemberAllBloodValues {
    NSDictionary *params = @{
                             @"staffId": self.currentModel.ID
                             };
    [[NetRequest sharedRequest] postURL:[Get_Member_All_Blood_Values getFullRequestPath] parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [CustomTools jsonToArrayOrDictionary:responseString];
        if ([dic[@"code"] integerValue] == 200) {
            
        }
        NSLog(@"所有血糖数据：%@", dic);
    } failed:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HUD_TEXTONLY(error.localizedDescription);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ dealloc",self);
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
