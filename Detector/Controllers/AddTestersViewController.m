//
//  AddTestersViewController.m
//  Detector
//
//  Created by Mac2 on 2018/12/6.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "AddTestersViewController.h"
#import "AddNewMemberViewController.h"
#import "SearchResultsViewController.h"
#import "EditMemberInfoViewController.h"
#import "MemberTableViewCell.h"

@interface AddTestersViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *searchBgView;
@property (nonatomic, strong) UISearchBar *searchBar;//搜索框
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *allMembers;
@property (nonatomic, strong) NSMutableArray *sortArray;

@end

@implementation AddTestersViewController

- (NSMutableArray *)allMembers {
    if (!_allMembers) {
        _allMembers = [NSMutableArray array];
    }
    return _allMembers;
}

- (NSMutableArray *)sortArray {
    if (!_sortArray) {
        _sortArray = [NSMutableArray array];
    }
    return _sortArray;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    HUD_Dismiss;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"操作测试人员信息";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMembers) name:Member_Delete_Notification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMembers) name:Member_Add_Notification object:nil];
    
    UIBarButtonItem *confirmItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(confirmAction)];
    self.navigationItem.leftBarButtonItem = confirmItem;
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStyleDone target:self action:@selector(addMemberAction)];
    self.navigationItem.rightBarButtonItem = addItem;
    
    if ([self.testModel isEqualToString:@"1"]) {
        self.searchBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        self.searchBgView.backgroundColor = [UIColor whiteColor];
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 30)];
        self.searchBar.layer.masksToBounds = YES;
        self.searchBar.layer.cornerRadius = 6;
        self.searchBar.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
        self.searchBar.layer.borderWidth = 0.5;
        self.searchBar.placeholder = @"查找";
        self.searchBar.delegate = self;
        self.searchBar.showsCancelButton = NO;
        self.searchBar.backgroundImage = [UIImage new];
        UITextField *searchTextField = [self.searchBar valueForKey:@"_searchField"];
        //字体大小
        searchTextField.font = [UIFont systemFontOfSize:15];
        [self.searchBgView addSubview:self.searchBar];
        [self.view addSubview:self.searchBgView];
    }
    
    [self getMembers];
    
    [self.view addSubview:self.tableView];
}

//确定
- (void)confirmAction {
    [self.navigationController popViewControllerAnimated:YES];
}

//新增
- (void)addMemberAction {
    AddNewMemberViewController *addNewController = [[AddNewMemberViewController alloc] init];
    addNewController.testModel = self.testModel;
    [self.navigationController pushViewController:addNewController animated:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    SearchResultsViewController *resultsController = [[SearchResultsViewController alloc] init];
    [self.navigationController pushViewController:resultsController animated:YES];
    return NO;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        if ([self.testModel isEqualToString:@"1"]) {
            _tableView.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT - 50);
        }else {
            _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT);
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.tableFooterView = [UIView new];
        __weak typeof(self) weakSelf = self;
        _tableView.moveCompleteBlock = ^(NSIndexPath *fromIndexPath, NSIndexPath *toIndexPath) {
            if (fromIndexPath != toIndexPath) {
                [weakSelf.sortArray removeAllObjects];
                [weakSelf sortMembersWithFormIndexPath:fromIndexPath toIndexPath:toIndexPath];
            }
        };
        [_tableView registerClass:[MemberTableViewCell class] forCellReuseIdentifier:@"member"];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allMembers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"member" forIndexPath:indexPath];
    MemberModel *model = self.allMembers[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MemberModel *model = self.allMembers[indexPath.row];
    EditMemberInfoViewController *editController = [[EditMemberInfoViewController alloc] init];
    editController.memberModel = model;
    editController.testModel = self.testModel;
    [self.navigationController pushViewController:editController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

//允许编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//删除按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)setTableViewData {
    __weak typeof(self) weakSelf = self;
    [self.tableView setDataWithArray:self.allMembers withBlock:^(NSMutableArray *newArray) {
        weakSelf.allMembers = newArray;
    }];
}

//数据、UI处理
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MemberModel *model = self.allMembers[indexPath.row];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定删除此人？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *urlStr;
            NSDictionary *params;
            if ([self.testModel isEqualToString:@"1"]) {
                urlStr = Delete_Today_Foreign;
                params = @{
                          @"staffId": model.ID
                          };
            }else if ([self.testModel isEqualToString:@"2"]) {
                urlStr = Delete_Internal;
                params = @{
                          @"staffId": model.ID
                          };
            }
            //移除
            [[NetRequest sharedRequest] postURL:[urlStr getFullRequestPath] parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSDictionary *dic = [CustomTools jsonToArrayOrDictionary:responseString];
                if ([dic[@"code"] integerValue] == 200) {
                    HUD_TEXTONLY(@"移除成功");
                    [self.allMembers removeObject:model];
                    if ([self.testModel isEqualToString:@"1"]) {
                        for (int i = 0; i < self.allMembers.count; i++) {
                            MemberModel *model = self.allMembers[i];
                            model.number = [NSString stringWithFormat:@"%d", i + 1];
                        }
                        [self setTableViewData];
                    }
                    [self.tableView reloadData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:Member_Remove_Notification object:nil];
                }
                NSLog(@"移除：%@",dic);
            } failed:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                HUD_TEXTONLY(error.localizedDescription);
            }];
        }];
        [alert addAction:actionOne];
        [alert addAction:actionTwo];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


- (void)getMembers {
    HUD_SHOW(@"", @"");
    NSString *urlStr;
    if ([self.testModel isEqualToString:@"1"]) {
        urlStr = Get_Foreigns;
    }else if ([self.testModel isEqualToString:@"2"]) {
        urlStr = Get_Internals;
    }
    [[NetRequest sharedRequest] postURL:[urlStr getFullRequestPath] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HUD_Dismiss;
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [CustomTools jsonToArrayOrDictionary:responseString];
        if ([dic[@"code"] integerValue] == 200) {
            [self.allMembers removeAllObjects];
            NSArray *array = dic[@"result"];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *memDic = array[i];
                MemberModel *model = [[MemberModel alloc] initWithDictionary:memDic error:nil];
//                if ([self.testModel isEqualToString:@"2"]) {
//                    model.number = [NSString stringWithFormat:@"%d", [model.serial_number intValue] + 1];
//                }else if ([self.testModel isEqualToString:@"1"]) {
//                    model.number = [NSString stringWithFormat:@"%d", i + 1];
//                }
                model.number = [NSString stringWithFormat:@"%d", [model.serial_number intValue] + 1];
                [self.allMembers addObject:model];
            }
            if ([self.testModel isEqualToString:@"1"]) {
                [self setTableViewData];
            }
            [self.tableView reloadData];
        }
        NSLog(@"人员：%@",dic);
    } failed:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HUD_TEXTONLY(error.localizedDescription);
    }];
}

//人员排序
- (void)sortMembersWithFormIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSString *urlStr;
    if ([self.testModel isEqualToString:@"1"]) {
        urlStr = Sort_Foreighs;
    }else if ([self.testModel isEqualToString:@"2"]) {
        urlStr = Sort_Internals;
    }
    
    for (int i=0; i < self.allMembers.count; i++) {
        MemberModel *model = self.allMembers[i];
        model.serial_number = [NSString stringWithFormat:@"%d", i];
        NSDictionary *dic = @{
                              @"id": model.ID,
                              @"serialNumber": model.serial_number
                              };
        [self.sortArray addObject:dic];
    }

    [[NetRequest sharedRequest] postURLAnotherWay:[urlStr getFullRequestPath] parameters:self.sortArray success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            if ([self.testModel isEqualToString:@"1"]) {
                for (int i = 0; i < self.allMembers.count; i++) {
                    MemberModel *model = self.allMembers[i];
                    model.number = [NSString stringWithFormat:@"%d", i + 1];
                }
                [self.tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:Member_Move_Notification object:nil];
            }
        }
        NSLog(@"排序：%@",responseObject);
    } failed:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HUD_TEXTONLY(error.localizedDescription);
    }];
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
