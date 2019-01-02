//
//  MainViewController.m
//  Detector
//
//  Created by Mac1 on 2018/12/6.
//  Copyright © 2018 Mac1. All rights reserved.
//

#import "MainViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BlueToothTableViewCell.h"
#import "DataRecordsViewController.h"
#import "IPSettingView.h"

typedef NS_ENUM(NSInteger, ManagerState) {//蓝牙状态
    ManagerStateUnknown = 0,
    ManagerStateResetting,
    ManagerStateUnsupported,
    ManagerStateUnauthorized,
    ManagerStatePoweredOff,
    ManagerStatePoweredOn,
};

@interface MainViewController () <UIScrollViewDelegate, CBCentralManagerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;//网络监听manager
@property (nonatomic, assign) BOOL isNetWorkStatuOK;//是否有网络
@property (nonatomic, strong) CBCentralManager *centralManager;//中心设备管理类
@property (nonatomic, strong) CBPeripheral *peripheral;//外设

@property (nonatomic, strong) UIButton *recordDataBtn;//历史数据

@property (nonatomic, strong) UIButton *ipSettingBtn;//ip设置按钮
@property (nonatomic, strong) IPSettingView *ipSettingBgView;//ip设置页面

@property (nonatomic, copy) NSString *ipString;//ip地址
@property (nonatomic, strong) UIButton *scanButton;//开始/结束扫描按钮
@property (nonatomic, strong) UIImageView *scanLoadingImageView;//扫描动画
@property (nonatomic, strong) UITableView *tableView;//扫描到的蓝牙设备列表
@property (nonatomic, strong) NSMutableArray *peripheralModel;//所有外设model
@property (nonatomic, strong) NSMutableArray *peripheralList;//所有外设
@property (nonatomic, assign) NSInteger index;//操作的是哪一行的蓝牙
@property (nonatomic, assign) BOOL isScanning;//是否正在扫描
@property (nonatomic, assign) BOOL isLinked;//蓝牙是否连接
@property (nonatomic, assign) BOOL isBrokenByUser;//是否是人为断开
@property (nonatomic, assign) BOOL isAutoLink;//是否是自动连接
@property (nonatomic, assign) int autoLinkTimes;//自动连接的次数（暂定3次）

@end

@implementation MainViewController

- (NSMutableArray *)peripheralModel {
    if (!_peripheralModel) {
        _peripheralModel = [NSMutableArray array];
    }
    return _peripheralModel;
}

- (NSMutableArray *)peripheralList {
    if (!_peripheralList) {
        _peripheralList = [NSMutableArray array];
    }
    return _peripheralList;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    self.ipSettingBtn.hidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    HUD_Dismiss;
    self.ipSettingBtn.hidden = YES;
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
        if (keyboardOriginY - 260 > SCREEN_HEIGHT * 0.5 - 130) {
            self.ipSettingBgView.ipSettingView.frame = CGRectMake(15, SCREEN_HEIGHT * 0.5 - 130, SCREEN_WIDTH - 30, 260);
        }else {
            self.ipSettingBgView.ipSettingView.frame = CGRectMake(15, keyboardOriginY - 280, SCREEN_WIDTH - 30, 260);
        }
    } completion:nil];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"血糖测试";
    self.view.backgroundColor = [UIColor whiteColor];
//    if (@available(iOS 11.0, *)) {
//        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:IP_ADDRESS_KEY]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"192.168.3.77" forKey:IP_ADDRESS_KEY];
    }
    
    //网络监听
    self.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [self observeNetworkStatus];
    self.autoLinkTimes = 0;
    
    //查看历史数据按钮
    self.recordDataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recordDataBtn.exclusiveTouch = YES;
    self.recordDataBtn.frame = CGRectMake(0, 0, 70, 40);
    [self.recordDataBtn setTitle:@"历史数据" forState:UIControlStateNormal];
    [self.recordDataBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.recordDataBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.recordDataBtn addTarget:self action:@selector(browseRecords) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.recordDataBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //IP设置页面
    self.ipSettingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.ipSettingBtn.backgroundColor = [UIColor clearColor];
    [self.ipSettingBtn addTarget:self action:@selector(ipSettingBtnClicked:) forControlEvents:UIControlEventTouchDownRepeat];
    [self.navigationController.view addSubview:self.ipSettingBtn];
    [self.ipSettingBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(STATUS_BAR_HEIGHT);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(50);
    }];
    
    self.ipSettingBgView = [[IPSettingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.ipSettingBgView.hidden = YES;
    self.ipSettingBgView.alpha = 0.0;
    [self.navigationController.view addSubview:self.ipSettingBgView];
    [self.ipSettingBgView.ipConfirmBtn addTarget:self action:@selector(ipConfirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.ipSettingBgView.ipCancelBtn addTarget:self action:@selector(ipCancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.ipSettingBgView.ipTextField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:self.ipSettingBgView.ipTextField];
    
    //扫描按钮
    self.scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.scanButton.exclusiveTouch = YES;
    self.scanButton.frame = CGRectMake(SCREEN_WIDTH * 0.5 - 40, 15, 80, 45);
    [self.scanButton setTitle:@"开始扫描" forState:UIControlStateNormal];
    [self.scanButton setTitle:@"停止扫描" forState:UIControlStateSelected];
    [self.scanButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.scanButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    self.scanButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.scanButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    self.scanButton.layer.masksToBounds = YES;
    self.scanButton.layer.cornerRadius = 3;
    [self.scanButton addTarget:self action:@selector(startOrStopScan:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.scanButton];
    
    //扫描动画图片
    self.scanLoadingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scanLoading"]];
    self.scanLoadingImageView.hidden = YES;
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    basicAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    basicAnimation.duration = 0.8;
    basicAnimation.repeatCount = MAXFLOAT;
    basicAnimation.fillMode = kCAFillModeForwards;
    basicAnimation.removedOnCompletion = NO;
    [self.scanLoadingImageView.layer addAnimation:basicAnimation forKey:@"rotateAnimation"];
    [self.view addSubview:self.scanLoadingImageView];
    [self.scanLoadingImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.scanButton);
        make.right.mas_equalTo(-15);
    }];
    
    [self setUpTableView];
    
    //创建中心设备管理类，会回调centralManagerDidUpdateState方法
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
}

//IP设置按钮双击事件
- (void)ipSettingBtnClicked:(UIButton *)sender {
    self.ipSettingBgView.hidden = NO;
    self.ipSettingBgView.ipTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:IP_ADDRESS_KEY];
    [self.ipSettingBgView.ipTextField becomeFirstResponder];
    self.ipString = [[NSUserDefaults standardUserDefaults] objectForKey:IP_ADDRESS_KEY];
    NSString *showErrorDataStatus = [[NSUserDefaults standardUserDefaults] objectForKey:SHOW_ERROR_DATA];
    NSString *getMultipleDataStatus = [[NSUserDefaults standardUserDefaults] objectForKey:GET_MULTIPLE_DATA];
    NSString *ifPrintLogStatus = [[NSUserDefaults standardUserDefaults] objectForKey:PRINT_LOG];
    if ([showErrorDataStatus isEqualToString:@"1"]) {
        self.ipSettingBgView.showErrorDataSwitch.on = YES;
    }else {
        self.ipSettingBgView.showErrorDataSwitch.on = NO;
    }
    if ([getMultipleDataStatus isEqualToString:@"1"]) {
        self.ipSettingBgView.getMultipleDataSwitch.on = YES;
    }else {
        self.ipSettingBgView.getMultipleDataSwitch.on = NO;
    }
    if ([ifPrintLogStatus isEqualToString:@"1"]) {
        self.ipSettingBgView.printLogSwitch.on = YES;
    }else {
        self.ipSettingBgView.printLogSwitch.on = NO;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.ipSettingBgView.alpha = 1.0;
    }];
}

//查看历史数据
- (void)browseRecords {
    DataRecordsViewController *recordController = [[DataRecordsViewController alloc] init];
    recordController.isBrowseRecords = YES;
    [self.navigationController pushViewController:recordController animated:YES];
}

//IP确定设置按钮点击事件
- (void)ipConfirmBtnClicked {
    [self.ipSettingBgView endEditing:YES];
    [[NSUserDefaults standardUserDefaults] setObject:self.ipString forKey:IP_ADDRESS_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",self.ipSettingBgView.showErrorDataSwitch.on] forKey:SHOW_ERROR_DATA];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",self.ipSettingBgView.getMultipleDataSwitch.on] forKey:GET_MULTIPLE_DATA];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",self.ipSettingBgView.printLogSwitch.on] forKey:PRINT_LOG];
    [UIView animateWithDuration:0.3 animations:^{
        self.ipSettingBgView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.ipSettingBgView.hidden = YES;
        HUD_TEXTONLY(@"设置成功!");
    }];
}

//IP取消按钮点击事件
- (void)ipCancelBtnClicked {
    [self.ipSettingBgView endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.ipSettingBgView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.ipSettingBgView.hidden = YES;
    }];
}

#pragma textfield delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self validateNumberByRegExp:string] == YES || [string isEqualToString:@"."]) {
        return YES;
    }
    return NO;
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

- (void)textfieldTextDidChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    if (textField == self.ipSettingBgView.ipTextField) {//设置网络请求IP地址
        if (textField.text.length) {
            self.ipString = textField.text;
            NSLog(@"%@",self.ipString);
        }
    }
}

//开始/停止扫描按钮点击事件
- (void)startOrStopScan:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [self.peripheralList removeAllObjects];
        [self.peripheralModel removeAllObjects];
        [self.tableView reloadData];
        self.isScanning = YES;
        self.scanLoadingImageView.hidden = NO;
        //扫描设备
        [self scanForPeripheralsWithCentral:self.centralManager];
        [self performSelector:@selector(stopScanBlueTooth) withObject:@"cancel" afterDelay:10];
    }else {
        self.isScanning = NO;
        self.scanLoadingImageView.hidden = YES;
        //停止扫描
        [self.centralManager stopScan];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopScanBlueTooth) object:@"cancel"];
    }
}

//停止扫描
- (void)stopScanBlueTooth {
    self.isScanning = NO;
    self.scanLoadingImageView.hidden = YES;
    [self.centralManager stopScan];
    if (self.peripheralList.count == 0) {
        HUD_TEXTONLY(@"未找到符合的设备")
    }
    self.scanButton.selected = NO;
}

#pragma mark ---CBCentralManagerDelegate
/** 判断蓝牙状态
 CBManagerStateUnknown = 0,  未知
 CBManagerStateResetting,    重置中
 CBManagerStateUnsupported,  不支持
 CBManagerStateUnauthorized, 未授权
 CBManagerStatePoweredOff,   未启动
 CBManagerStatePoweredOn,    可用
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    //扫描设备
    //    [self scanForPeripheralsWithCentral:central];
}

- (void)scanForPeripheralsWithCentral:(CBCentralManager *)central {
    if (@available(iOS 10.0, *)) {
        if (central.state == CBManagerStatePoweredOn) {
            //蓝牙可用
            //根据SERVICE_UUID来扫描外设，如果不设置SERVICE_UUID，则扫描所有设备
            //            [central scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:SERVICE_UUID]] options:nil];
            [central scanForPeripheralsWithServices:nil options:nil];
        }
        if (central.state == CBManagerStatePoweredOff) {
            NSLog(@"蓝牙关闭");
        }
        if (central.state == CBManagerStateUnsupported) {
            NSLog(@"该设备不支持蓝牙");
        }
    } else {
        if (central.state == ManagerStatePoweredOn) {
            //蓝牙可用
            //根据SERVICE_UUID来扫描外设，如果不设置SERVICE_UUID，则扫描所有设备
            //            [central scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:SERVICE_UUID]] options:nil];
            [central scanForPeripheralsWithServices:nil options:nil];
        }
        if (central.state == ManagerStatePoweredOff) {
            NSLog(@"蓝牙关闭");
        }
        if (central.state == ManagerStateUnsupported) {
            NSLog(@"该设备不支持蓝牙");
        }
    }
}

//发现符合要求的外设，回调
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    //    NSLog(@"%@",peripheral);
    if (![self.peripheralList containsObject:peripheral]) {
        if ([peripheral.name hasPrefix:@"FZW"] || [peripheral.name hasPrefix:@"fzw"]) {
            [self.peripheralList addObject:peripheral];
            BlueToothModel *model = [[BlueToothModel alloc] init];
            model.blueToothName = peripheral.name;
            model.blueToothId = [NSString stringWithFormat:@"%@",peripheral.identifier];
            model.ifConnect = @"0";
            [self.peripheralModel addObject:model];
            [self.tableView reloadData];
        }
    }
}

//连接成功的回调
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeOut) object:@"timeOut"];
    //连接成功，停止扫描
    self.isLinked = YES;
    self.isBrokenByUser = NO;
    self.autoLinkTimes = 0;
    NSLog(@"连接蓝牙成功");
    HUD_TEXTONLY(@"连接蓝牙成功")
    BlueToothModel *model = self.peripheralModel[self.index];
    model.ifConnect = @"1";
    [self.tableView reloadData];
    //设置代理
    //    peripheral.delegate = self;
    //根据UUID来寻找服务
    //    [peripheral discoverServices:@[[CBUUID UUIDWithString:SERVICE_UUID]]];
    //    [peripheral discoverServices:nil];
    
    if (self.isAutoLink) {
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:self.peripheral, @"peripheral", @(self.isLinked), @"isLinked", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:AUTO_LINK_SUCCESS object:nil userInfo:info];
    }
}

//连接失败的回调
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    if (error) {
        NSLog(@"link error：%@",error);
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeOut) object:@"timeOut"];
    self.isLinked = NO;
    self.isBrokenByUser = NO;
    if (self.isAutoLink && self.autoLinkTimes < 3) {
        self.autoLinkTimes++;
        [central connectPeripheral:peripheral options:nil];
        HUD_SHOW(@"正在连接...", @"")
        [self performSelector:@selector(timeOut) withObject:@"timeOut" afterDelay:10];
    }
    NSLog(@"连接蓝牙失败");
    HUD_TEXTONLY(@"连接蓝牙失败")
}

//断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    if (error) {
        NSLog(@"broken error：%@",error);
    }
    self.isLinked = NO;
    NSLog(@"蓝牙连接断开");
    if (self.isAutoLink) {
        HUD_TEXTONLY(@"蓝牙连接失败");
    }else {
        HUD_TEXTONLY(@"蓝牙连接断开");
    }
    
    //    [self.peripheralList removeAllObjects];
    //    [self.peripheralModel removeAllObjects];
    //    [self.tableView reloadData];
    
    BlueToothModel *model = self.peripheralModel[self.index];
    model.ifConnect = @"0";
    [self.tableView reloadData];
    //不是人为断开,自动重连
    if (!self.isBrokenByUser && self.autoLinkTimes < 3) {
        self.isAutoLink = YES;
        self.autoLinkTimes++;
        [central connectPeripheral:peripheral options:nil];
        HUD_SHOW(@"正在连接...", @"")
        [self performSelector:@selector(timeOut) withObject:@"timeOut" afterDelay:10];
    }
}

#pragma ---tableview
- (void)setUpTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 75, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT - 75) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[BlueToothTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.peripheralModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BlueToothTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    
    //连接
    cell.connectBlock = ^{
        weakSelf.index = indexPath.row;
        CBPeripheral *peripheral = weakSelf.peripheralList[indexPath.row];
        self.peripheral = peripheral;
        [weakSelf.centralManager connectPeripheral:peripheral options:nil];
        self.isBrokenByUser = NO;
        self.isAutoLink = NO;
        if (weakSelf.isScanning) {
            [weakSelf startOrStopScan:weakSelf.scanButton];
        }
        HUD_SHOW(@"正在连接...", @"")
        [weakSelf performSelector:@selector(timeOut) withObject:@"timeOut" afterDelay:10];
    };
    
    //断开
    cell.brokenBlock = ^{
        weakSelf.index = indexPath.row;
        CBPeripheral *peripheral = weakSelf.peripheralList[indexPath.row];
        if (weakSelf.centralManager && peripheral) {
            [weakSelf.centralManager cancelPeripheralConnection:peripheral];
            self.isBrokenByUser = YES;
            self.isAutoLink = NO;
        }
    };
    
    //进入操作
    cell.operationBlock = ^{
        DataRecordsViewController *recordController = [[DataRecordsViewController alloc] init];
        recordController.isBrowseRecords = NO;
        recordController.peripheral = weakSelf.peripheral;
        recordController.isLinked = weakSelf.isLinked;
        [weakSelf.navigationController pushViewController:recordController animated:YES];
    };
    BlueToothModel *model = self.peripheralModel[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)timeOut {
    HUD_TEXTONLY(@"连接失败");
    self.isBrokenByUser = NO;
    self.isLinked = NO;
    [self.centralManager cancelPeripheralConnection:self.peripheral];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
