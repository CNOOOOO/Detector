//
//  SearchResultsViewController.m
//  Detector
//
//  Created by Mac2 on 2018/12/11.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "MemberTableViewCell.h"

@interface SearchResultsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *allKeys;
@property (nonatomic, strong) NSMutableDictionary *allDatas;

@end

@implementation SearchResultsViewController

- (NSMutableDictionary *)allDatas {
    if (!_allDatas) {
        _allDatas = [NSMutableDictionary dictionary];
    }
    return _allDatas;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    HUD_Dismiss;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"查找添加";
    
    [self getAllMembers];
    
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionIndexColor = Switch_Color;
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[MemberTableViewCell class] forCellReuseIdentifier:@"member"];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allKeys.count / 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = [[self.allDatas objectForKey:self.allKeys[2 * section + 1]] copy];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"member" forIndexPath:indexPath];
    NSArray *array = [[self.allDatas objectForKey:self.allKeys[indexPath.section * 2 + 1]] copy];
    MemberModel *model = array[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = [[self.allDatas objectForKey:self.allKeys[indexPath.section * 2 + 1]] copy];
    MemberModel *model = array[indexPath.row];
    NSArray *idArray = @[model.ID];
    [self addMemberWithIds:idArray];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0000001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = RGBA(245, 245, 245, 1.0);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 30)];
    label.text = self.allKeys[section * 2 + 1];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    label.textColor = [UIColor blackColor];
    [header addSubview:label];
    return header;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.allKeys;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if ([title isEqualToString:@" "]) {
        return index / 2;
    }
    return (index - 1) / 2;
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

//数据、UI处理
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *array = [[self.allDatas objectForKey:self.allKeys[indexPath.section * 2 + 1]] mutableCopy];
        MemberModel *model = array[indexPath.row];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定删除此人？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *params = @{
                       @"staffId": model.ID
                       };
            //移除
            [[NetRequest sharedRequest] postURL:[Delete_Internal getFullRequestPath] parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSDictionary *dic = [CustomTools jsonToArrayOrDictionary:responseString];
                if ([dic[@"code"] integerValue] == 200) {
                    HUD_TEXTONLY(@"移除成功");
                    [array removeObject:model];
                    [self.allDatas removeObjectForKey:self.allKeys[indexPath.section * 2 + 1]];
                    if (array.count != 0) {
                        [self.allDatas setObject:array forKey:self.allKeys[indexPath.section * 2 + 1]];
                    }else {
                        [self.allKeys removeObjectAtIndex:indexPath.section * 2 + 1];
                        [self.allKeys removeObjectAtIndex:indexPath.section * 2];
                    }
                    [self.tableView reloadData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:Member_Delete_Notification object:nil];
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

- (void)getAllMembers {
    HUD_SHOW(@"", @"");
    [[NetRequest sharedRequest] postURL:[Search_All_Foreigns getFullRequestPath] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HUD_Dismiss;
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [CustomTools jsonToArrayOrDictionary:responseString];
        if ([dic[@"code"] integerValue] == 200) {
            [self.allDatas removeAllObjects];
            [self.allKeys removeAllObjects];
            NSMutableArray *members = [NSMutableArray array];
            for (NSDictionary *memDic in dic[@"result"]) {
                MemberModel *model = [[MemberModel alloc] initWithDictionary:memDic error:nil];
                [members addObject:model];
            }
            for (MemberModel *model in members) {
                NSMutableArray *mutArray = [NSMutableArray array];
                if ([self.allDatas objectForKey:[model.staff_name getFirstLetter]]) {
                    mutArray = [self.allDatas objectForKey:[model.staff_name getFirstLetter]];
                    [mutArray addObject:model];
                    [self.allDatas setObject:mutArray forKey:[model.staff_name getFirstLetter]];
                }else {
                    [mutArray addObject:model];
                    [self.allDatas setObject:mutArray forKey:[model.staff_name getFirstLetter]];
                }
            }
            self.allKeys = [NSMutableArray arrayWithArray:[[self.allDatas allKeys] sortedArrayUsingSelector:@selector(compare:)]];
            NSString *firstKey = [self.allKeys firstObject];
            if ([firstKey isEqualToString:@"#"]) {
                [self.allKeys removeObjectAtIndex:0];
                [self.allKeys addObject:firstKey];
            }
            NSInteger count = self.allKeys.count;
            for (int i = 0; i < count; i++) {//添加空格增加索引间距
                [self.allKeys insertObject:@" " atIndex:i * 2];
            }
            [self.tableView reloadData];
        }
        NSLog(@"所有社会人员：%@",dic);
    } failed:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HUD_TEXTONLY(error.localizedDescription);
    }];
}

//添加
- (void)addMemberWithIds:(NSArray *)ids {
    HUD_SHOW(@"", @"");
    [[NetRequest sharedRequest] postURLAnotherWay:[Add_Today_Foreigns getFullRequestPath] parameters:ids success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            HUD_TEXTONLY(@"添加成功");
            [[NSNotificationCenter defaultCenter] postNotificationName:Member_Add_Notification object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            HUD_Dismiss;
        }
        NSLog(@"添加：%@", responseObject);
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
