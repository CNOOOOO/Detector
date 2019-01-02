//
//  EditMemberInfoViewController.m
//  Detector
//
//  Created by Mac2 on 2018/12/11.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "EditMemberInfoViewController.h"
#import "PhotoTableViewCell.h"
#import "InputTableViewCell.h"
#import "ChooseTableViewCell.h"

@interface EditMemberInfoViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImage *faceImage;
@property (nonatomic, strong) UIImage *fingerImage;
@property (nonatomic, copy) NSString *faceUrl;
@property (nonatomic, copy) NSString *fingerUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *isMale;//(1、男 2、女，其他为初始状态)
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *IDCard;
@property (nonatomic, copy) NSString *telephoneNumber;
@property (nonatomic, copy) NSString *wechat;
@property (nonatomic, copy) NSString *isSmoking;//(1、默认 2、选中，其他为初始状态)
@property (nonatomic, copy) NSString *isDrink;//(1、默认 2、选中，其他为初始状态)
@property (nonatomic, copy) NSString *isHypertension;//(1、默认 2、选中，其他为初始状态)
@property (nonatomic, copy) NSString *serialNumber;//工号
@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) BOOL isSelectFaceImage;//是否选择脸部照片
@property (nonatomic, assign) BOOL idNumberIsExist;//身份证号是否存在
@property (nonatomic, assign) BOOL requestComplete;//请求完成

@end

@implementation EditMemberInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)note {
    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
}

- (void)keyboardWillHide:(NSNotification *)note {
    self.tableView.contentInset = UIEdgeInsetsZero;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    HUD_Dismiss;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.requestComplete = YES;
    self.navigationItem.title = @"信息修改";
    self.faceImage = [UIImage imageNamed:@"face"];
    self.fingerImage = [UIImage imageNamed:@"face"];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        if (self.memberModel.staff_faceimg.length) {
            NSData *faceImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Image_Host, self.memberModel.staff_faceimg]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.faceImage = [UIImage imageWithData:faceImageData];
                [self.tableView reloadData];
            });
        }
        if (self.memberModel.staff_fingerimg.length) {
            NSData *fingerImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Image_Host, self.memberModel.staff_fingerimg]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.fingerImage = [UIImage imageWithData:fingerImageData];
                [self.tableView reloadData];
            });
        }
    });
    
    self.faceUrl = self.memberModel.staff_faceimg;
    self.fingerUrl = self.memberModel.staff_fingerimg;
    self.name = self.memberModel.staff_name;
    if ([self.memberModel.staff_sex isEqualToString:@"男"]) {
        self.isMale = @"1";
    }else if ([self.memberModel.staff_sex isEqualToString:@"女"]) {
        self.isMale = @"2";
    }else {
        self.isMale = @"0";
    }
    self.age = self.memberModel.staff_age;
    self.IDCard = self.memberModel.staff_idnumber;
    self.telephoneNumber = self.memberModel.staff_phone;
    self.wechat = self.memberModel.staff_weixin;
    if ([self.memberModel.staff_somking isEqualToString:@"0"]) {
        self.isSmoking = @"1";
    }else if ([self.memberModel.staff_somking isEqualToString:@"1"]) {
        self.isSmoking = @"2";
    }else {
        self.isSmoking = @"0";
    }
    if ([self.memberModel.staff_drink isEqualToString:@"0"]) {
        self.isDrink = @"1";
    }else if ([self.memberModel.staff_drink isEqualToString:@"1"]) {
        self.isDrink = @"2";
    }else {
        self.isDrink = @"0";
    }
    if ([self.memberModel.staff_hypertension isEqualToString:@"0"]) {
        self.isHypertension = @"1";
    }else if ([self.memberModel.staff_hypertension isEqualToString:@"1"]) {
        self.isHypertension = @"2";
    }else {
        self.isHypertension = @"0";
    }
    self.serialNumber = self.memberModel.serialNumber;
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonClick)];
    self.navigationItem.rightBarButtonItem = saveItem;
    
    [self.view addSubview:self.tableView];
}

- (void)saveButtonClick {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([self.testModel isEqualToString:@"1"]) {//外部人员
        if (!self.name.length) {
            HUD_TEXTONLY(@"请填写姓名");
            return;
        }else if (!self.IDCard.length) {
            HUD_TEXTONLY(@"请填写身份证号");
            return;
        }else if (self.IDCard.length != 18) {
            HUD_TEXTONLY(@"身份证格式不正确");
            return;
        }else if (self.telephoneNumber.length && self.telephoneNumber.length != 11) {
            HUD_TEXTONLY(@"手机号格式不正确");
            return;
        }else {
            HUD_SHOW(@"", @"");
            params = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.memberModel.ID, @"id", self.name, @"staffName", self.IDCard, @"idNumber", @"1", @"staffType", nil];
        }
    }else if ([self.testModel isEqualToString:@"2"]) {//公司员工
        if (!self.name.length) {
            HUD_TEXTONLY(@"请填写姓名");
            return;
        }else if (self.IDCard.length && self.IDCard.length != 18) {
            HUD_TEXTONLY(@"身份证格式不正确");
            return;
        }else if (self.telephoneNumber.length && self.telephoneNumber.length != 11) {
            HUD_TEXTONLY(@"手机号格式不正确");
            return;
        }else if (!self.serialNumber.length) {
            HUD_TEXTONLY(@"请填写工号");
            return;
        }else {
            HUD_SHOW(@"", @"");
            params = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.memberModel.ID, @"id", self.name, @"staffName", @"0", @"staffType", self.serialNumber, @"serialNumber", nil];
        }
    }
    if (self.faceUrl.length) {//脸部图片
        [params setValue:self.faceUrl forKey:@"faceImg"];
    }
    if (self.fingerUrl.length) {//手指图片
        [params setValue:self.fingerUrl forKey:@"fingerImg"];
    }
    if (![self.isMale isEqualToString:@"0"]) {//性别
        [params setValue:[self.isMale isEqualToString:@"1"] ? @"男" : @"女" forKey:@"staffSex"];
    }
    if (self.age.length) {//年龄
        [params setValue:self.age forKey:@"staffAge"];
    }
    if (self.telephoneNumber.length) {//电话
        [params setValue:self.telephoneNumber forKey:@"staffPhone"];
    }
    if (self.wechat.length) {//微信
        [params setValue:self.wechat forKey:@"weixin"];
    }
    if (![self.isSmoking isEqualToString:@"0"]) {
        [params setValue:[NSString stringWithFormat:@"%d", [self.isSmoking intValue] - 1] forKey:@"somking"];
    }
    if (![self.isDrink isEqualToString:@"0"]) {
        [params setValue:[NSString stringWithFormat:@"%d", [self.isDrink intValue] - 1] forKey:@"drink"];
    }
    if (![self.isHypertension isEqualToString:@"0"]) {
        [params setValue:[NSString stringWithFormat:@"%d", [self.isHypertension intValue] - 1] forKey:@"hypertension"];
    }
    [[NetRequest sharedRequest] postURLAnotherWay:[Updata_Member_Info getFullRequestPath] parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            HUD_TEXTONLY(@"修改成功");
            [[NSNotificationCenter defaultCenter] postNotificationName:Member_Add_Notification object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            HUD_Dismiss;
        }
        NSLog(@"修改：%@", responseObject);
    } failed:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HUD_TEXTONLY(error.localizedDescription);
    }];
    
    
    
//    if (!self.name.length) {
//        HUD_TEXTONLY(@"请填写姓名");
//    }else if ([self.isMale isEqualToString:@"0"]) {
//        HUD_TEXTONLY(@"请选择性别");
//    }else if (!self.age.length) {
//        HUD_TEXTONLY(@"请填写年龄");
//    }else if (!self.IDCard.length) {
//        HUD_TEXTONLY(@"请填写身份证号");
//    }else if (!self.telephoneNumber.length) {
//        HUD_TEXTONLY(@"请填写手机号");
//    }else if ([self.isSmoking isEqualToString:@"0"]) {
//        HUD_TEXTONLY(@"请选择是否抽烟");
//    }else if ([self.isDrink isEqualToString:@"0"]) {
//        HUD_TEXTONLY(@"请选择是否饮酒");
//    }else if ([self.isHypertension isEqualToString:@"0"]) {
//        HUD_TEXTONLY(@"请选择是否高血压");
//    }else if ([self.isInternal isEqualToString:@"0"]) {
//        HUD_TEXTONLY(@"请选择是否是公司职员");
//    }else if (self.IDCard.length != 18) {
//        HUD_TEXTONLY(@"身份证格式不正确");
//    }else if (self.telephoneNumber.length != 11) {
//        HUD_TEXTONLY(@"手机号格式不正确");
//    }else {
//        HUD_SHOW(@"", @"");
//        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.memberModel.ID, @"id", [NSString stringWithFormat:@"%d", [self.isInternal intValue] - 1], @"staffType", self.name, @"staffName", [self.isMale isEqualToString:@"1"] ? @"男" : @"女", @"staffSex", self.age, @"staffAge", self.IDCard, @"idNumber", self.telephoneNumber, @"staffPhone", [NSString stringWithFormat:@"%d", [self.isSmoking intValue] - 1], @"somking", [NSString stringWithFormat:@"%d", [self.isDrink intValue] - 1], @"drink", [NSString stringWithFormat:@"%d", [self.isHypertension intValue] - 1], @"hypertension", nil];
//        if (self.wechat.length) {
//            [params setValue:self.wechat forKey:@"weixin"];
//        }
//        if (self.faceUrl.length) {
//            [params setValue:self.faceUrl forKey:@"faceImg"];
//        }
//        if (self.fingerUrl.length) {
//            [params setValue:self.fingerUrl forKey:@"fingerImg"];
//        }
//        [[NetRequest sharedRequest] postURLAnotherWay:[Updata_Member_Info getFullRequestPath] parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            if ([responseObject[@"code"] integerValue] == 200) {
//                HUD_TEXTONLY(@"修改成功");
//                [[NSNotificationCenter defaultCenter] postNotificationName:Member_Opration_Notification object:nil];
//                [self.navigationController popViewControllerAnimated:YES];
//            }else {
//                HUD_Dismiss;
//            }
//            NSLog(@"新增：%@", responseObject);
//        } failed:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            HUD_TEXTONLY(error.localizedDescription);
//        }];
//    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[PhotoTableViewCell class] forCellReuseIdentifier:@"photo"];
        [_tableView registerClass:[InputTableViewCell class] forCellReuseIdentifier:@"input"];
        [_tableView registerClass:[ChooseTableViewCell class] forCellReuseIdentifier:@"choose"];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.testModel isEqualToString:@"1"]) {
        return 10;
    }else {
        return 11;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        PhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photo" forIndexPath:indexPath];
        cell.faceImageView.image = self.faceImage;
        cell.fingerImageView.image = self.fingerImage;
        __weak typeof(self) weakSelf = self;
        cell.faceImageBlock = ^(UIImageView *imageView) {
            NSLog(@"选头像");
            weakSelf.isSelectFaceImage = YES;
            [weakSelf selectPhoto];
        };
        cell.fingerImageBlock = ^(UIImageView *imageView) {
            NSLog(@"选手指");
            weakSelf.isSelectFaceImage = NO;
            [weakSelf selectPhoto];
        };
        return cell;
    }else if (indexPath.row == 1 || (indexPath.row > 2 && indexPath.row < 7) || indexPath.row == 10) {
        InputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"input" forIndexPath:indexPath];
        if (indexPath.row == 1) {
            cell.titleLabel.text = @"姓名（必填）";
            cell.textField.placeholder = @"请输入姓名";
            cell.textField.text = self.name;
            cell.textField.keyboardType = UIKeyboardTypeDefault;
        }else if (indexPath.row == 3) {
            cell.titleLabel.text = @"年龄";
            cell.textField.placeholder = @"请输入年龄";
            cell.textField.text = self.age;
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        }else if (indexPath.row == 4) {
            if ([self.testModel isEqualToString:@"1"]) {
                cell.titleLabel.text = @"身份证（必填）";
            }else {
                cell.titleLabel.text = @"身份证";
            }
            cell.textField.placeholder = @"请输入身份证号码";
            cell.textField.text = self.IDCard;
            cell.textField.keyboardType = UIKeyboardTypeDefault;
        }else if (indexPath.row == 5) {
            cell.titleLabel.text = @"手机号";
            cell.textField.placeholder = @"请输入手机号";
            cell.textField.text = self.telephoneNumber;
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        }else if (indexPath.row == 6) {
            cell.titleLabel.text = @"微信";
            cell.textField.placeholder = @"请输入微信号";
            cell.textField.text = self.wechat;
            cell.textField.keyboardType = UIKeyboardTypeDefault;
        }else if (indexPath.row == 10) {
            cell.titleLabel.text = @"工号（必填）";
            cell.textField.placeholder = @"请输入工号";
            cell.textField.text = self.serialNumber;
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        cell.textField.delegate = self;
        cell.textField.tag = 1000 + indexPath.row;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:cell.textField];
        return cell;
    }else {
        ChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"choose" forIndexPath:indexPath];
        if (indexPath.row == 2) {
            [cell.trueButton setTitle:@"男" forState:UIControlStateNormal];
            [cell.trueButton setTitle:@"男" forState:UIControlStateSelected];
            [cell.falseButton setTitle:@"女" forState:UIControlStateNormal];
            [cell.falseButton setTitle:@"女" forState:UIControlStateSelected];
        }else {
            [cell.trueButton setTitle:@"是" forState:UIControlStateNormal];
            [cell.trueButton setTitle:@"是" forState:UIControlStateSelected];
            [cell.falseButton setTitle:@"否" forState:UIControlStateNormal];
            [cell.falseButton setTitle:@"否" forState:UIControlStateSelected];
        }
        if (indexPath.row == 2) {
            cell.titleLabel.text = @"性别";
            if ([self.isMale isEqualToString:@"1"]) {
                cell.trueButton.selected = YES;
                cell.falseButton.selected = NO;
                cell.trueButton.backgroundColor = Switch_Color;
                cell.falseButton.backgroundColor = [UIColor whiteColor];
            }else if([self.isMale isEqualToString:@"2"]) {
                cell.trueButton.selected = NO;
                cell.falseButton.selected = YES;
                cell.trueButton.backgroundColor = [UIColor whiteColor];
                cell.falseButton.backgroundColor = Switch_Color;
            }else {
                cell.trueButton.selected = NO;
                cell.falseButton.selected = NO;
                cell.trueButton.backgroundColor = [UIColor whiteColor];
                cell.falseButton.backgroundColor = [UIColor whiteColor];
            }
        }else if (indexPath.row == 7) {
            cell.titleLabel.text = @"是否抽烟";
            if ([self.isSmoking isEqualToString:@"1"]) {
                cell.trueButton.selected = YES;
                cell.falseButton.selected = NO;
                cell.trueButton.backgroundColor = Switch_Color;
                cell.falseButton.backgroundColor = [UIColor whiteColor];
            }else if([self.isSmoking isEqualToString:@"2"]) {
                cell.trueButton.selected = NO;
                cell.falseButton.selected = YES;
                cell.trueButton.backgroundColor = [UIColor whiteColor];
                cell.falseButton.backgroundColor = Switch_Color;
            }else {
                cell.trueButton.selected = NO;
                cell.falseButton.selected = NO;
                cell.trueButton.backgroundColor = [UIColor whiteColor];
                cell.falseButton.backgroundColor = [UIColor whiteColor];
            }
        }else if (indexPath.row == 8) {
            cell.titleLabel.text = @"是否饮酒";
            if ([self.isDrink isEqualToString:@"1"]) {
                cell.trueButton.selected = YES;
                cell.falseButton.selected = NO;
                cell.trueButton.backgroundColor = Switch_Color;
                cell.falseButton.backgroundColor = [UIColor whiteColor];
            }else if([self.isDrink isEqualToString:@"2"]) {
                cell.trueButton.selected = NO;
                cell.falseButton.selected = YES;
                cell.trueButton.backgroundColor = [UIColor whiteColor];
                cell.falseButton.backgroundColor = Switch_Color;
            }else {
                cell.trueButton.selected = NO;
                cell.falseButton.selected = NO;
                cell.trueButton.backgroundColor = [UIColor whiteColor];
                cell.falseButton.backgroundColor = [UIColor whiteColor];
            }
        }else if (indexPath.row == 9) {
            cell.titleLabel.text = @"是否有高血压";
            if ([self.isHypertension isEqualToString:@"1"]) {
                cell.trueButton.selected = YES;
                cell.falseButton.selected = NO;
                cell.trueButton.backgroundColor = Switch_Color;
                cell.falseButton.backgroundColor = [UIColor whiteColor];
            }else if([self.isHypertension isEqualToString:@"2"]) {
                cell.trueButton.selected = NO;
                cell.falseButton.selected = YES;
                cell.trueButton.backgroundColor = [UIColor whiteColor];
                cell.falseButton.backgroundColor = Switch_Color;
            }else {
                cell.trueButton.selected = NO;
                cell.falseButton.selected = NO;
                cell.trueButton.backgroundColor = [UIColor whiteColor];
                cell.falseButton.backgroundColor = [UIColor whiteColor];
            }
        }
        __weak typeof(self) weakSelf = self;
        __weak typeof(cell) weakCell = cell;
        cell.trueBlock = ^(UIButton *button) {
            button.selected = YES;
            weakCell.falseButton.selected = NO;
            button.backgroundColor = Switch_Color;
            weakCell.falseButton.backgroundColor = [UIColor whiteColor];
            if (indexPath.row == 2) {
                weakSelf.isMale = @"1";
            }else if (indexPath.row == 7) {
                weakSelf.isSmoking = @"1";
            }else if (indexPath.row == 8) {
                weakSelf.isDrink = @"1";
            }else if (indexPath.row == 9) {
                weakSelf.isHypertension = @"1";
            }
        };
        cell.falseBlock = ^(UIButton *button) {
            button.selected = YES;
            weakCell.trueButton.selected = NO;
            button.backgroundColor = Switch_Color;
            weakCell.trueButton.backgroundColor = [UIColor whiteColor];
            if (indexPath.row == 2) {
                weakSelf.isMale = @"2";
            }else if (indexPath.row == 7) {
                weakSelf.isSmoking = @"2";
            }else if (indexPath.row == 8) {
                weakSelf.isDrink = @"2";
            }else if (indexPath.row == 9) {
                weakSelf.isHypertension = @"2";
            }
        };
        return cell;
    }
}

- (void)selectPhoto {
    UIAlertController *alertview = [UIAlertController alertControllerWithTitle:nil message:@"选择照片来源" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        //判断是否支持摄像头，支持就用，不支持就算了（避免程序崩溃）
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *pickerController =[[UIImagePickerController alloc]init];
            pickerController.delegate = self;
            pickerController.allowsEditing = YES;
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:pickerController animated:YES completion:nil];
        }
    }];
    [firstAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
        pickerController.delegate = self;
        // 允许编辑
        pickerController.allowsEditing = YES;
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerController.navigationBar.translucent = NO;
        [self presentViewController:pickerController animated:YES completion:nil];
    }];
    [secondAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    
    UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //do something
    }];
    [thirdAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
    [alertview addAction:firstAction];
    [alertview addAction:secondAction];
    [alertview addAction:thirdAction];
    [self presentViewController:alertview animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    //图片压缩一下
    UIImage *newImage = [self thumbnaiWithImage:image size:CGSizeMake(170, 170)];
    NSData *data = UIImageJPEGRepresentation(newImage, 0.1);
    if (self.isSelectFaceImage) {
        self.faceImage = [UIImage imageWithData:data];
        [self postImageWithImage:self.faceImage];
    }else {
        self.fingerImage = [UIImage imageWithData:data];
        [self postImageWithImage:self.fingerImage];
    }
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)postImageWithImage:(UIImage *)image {
    [[NetRequest sharedRequest] uploadImageWithURL:[Post_Image getFullRequestPath] parameters:nil imageKey:@"file" image:image success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [CustomTools jsonToArrayOrDictionary:responseString];
        if (image == self.faceImage) {
            self.faceUrl = dic[@"result"];
        }else if(image == self.fingerImage){
            self.fingerUrl = dic[@"result"];
        }
        NSLog(@"上传图片：%@",dic);
    } failed:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HUD_TEXTONLY(error.localizedDescription);
    }];
}

//压缩图片
- (UIImage*)thumbnaiWithImage:(UIImage*)image size:(CGSize)size {
    UIImage *newImage = nil;
    if (image != nil) {
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newImage;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.textField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSInteger textFieldTag = textField.tag;
    if (textFieldTag == 1004) {//身份证
        if (textField.text.length && textField.text.length != 18) {
            HUD_TEXTONLY(@"身份证格式不正确");
        }
    }else if (textFieldTag == 1005) {//手机号
        if (textField.text.length && textField.text.length != 11) {
            HUD_TEXTONLY(@"手机号格式不正确");
        }
    }
}

- (void)textfieldTextDidChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    NSInteger textFieldTag = textField.tag;
    if (textFieldTag == 1001) {//姓名
        self.name = textField.text;
    }else if (textFieldTag == 1003) {//年龄
        self.age = textField.text;
    }else if (textFieldTag == 1004) {//身份证
        self.IDCard = textField.text;
        if (textField.text.length == 18) {
            [self judgingWhetherIDNumberExists:textField.text];
        }
    }else if (textFieldTag == 1005) {//手机号
        self.telephoneNumber = textField.text;
    }else if (textFieldTag == 1006) {//微信
        self.wechat = textField.text;
    }else if (textFieldTag == 1010) {//工号
        self.serialNumber = textField.text;
    }
}

//判断身份证号是否存在
- (void)judgingWhetherIDNumberExists:(NSString *)idNumber {
    if (self.requestComplete) {
        self.requestComplete = NO;
        NSDictionary *params = @{
                                 @"idNumber": idNumber
                                 };
        [[NetRequest sharedRequest] postURL:[IDNumberIsExist getFullRequestPath] parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSDictionary *dic = [CustomTools jsonToArrayOrDictionary:responseString];
            if ([dic[@"code"] integerValue] == 200) {
                if ([dic[@"result"] integerValue] == 0) {//不存在
                    self.idNumberIsExist = NO;
                }else if ([dic[@"result"] integerValue] == 1) {//已存在
                    self.idNumberIsExist = YES;
                    HUD_TEXTONLY(@"身份证号已存在");
                }
            }
            self.requestComplete = YES;
            NSLog(@"判断身份证：%@", dic);
        } failed:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            self.requestComplete = YES;
            //        HUD_TEXTONLY(error.localizedDescription);
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",(long)indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 120;
    }
    return 45;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"dealloc:%@",self);
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
