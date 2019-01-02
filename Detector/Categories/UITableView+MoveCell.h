//
//  UITableView+MoveCell.h
//  drawTableViewCell
//
//  Created by yuandiLiao on 2017/5/31.
//  Copyright © 2017年 yuandiLiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void(^MoveCellBlock)(NSMutableArray *newArray);
typedef void(^MoveCompleteBlock)(NSIndexPath *fromIndexPath, NSIndexPath *toIndexPath);

typedef enum{
    SnapshotMeetsEdgeTop = 1,
    SnapshotMeetsEdgeBottom,
}SnapshotMeetsEdge;

@interface UITableView (MoveCell)

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSIndexPath *fromIndexPath;//起始位置
@property (nonatomic, strong) NSIndexPath *toIndexPath;//目标位置
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIView *snapView;
@property (nonatomic, strong) UITableViewCell *moveCell;
/**自动滚动的方向*/
@property (nonatomic, assign) SnapshotMeetsEdge autoScrollDirection;
/**cell被拖动到边缘后开启，tableview自动向上或向下滚动*/
@property (nonatomic, strong) CADisplayLink *autoScrollTimer;

@property (nonatomic, weak) MoveCellBlock block;
@property (nonatomic, copy) MoveCompleteBlock moveCompleteBlock;

- (void)setDataWithArray:(NSMutableArray *)array withBlock:(MoveCellBlock)block;
//- (void)moveCompleteWithBlock:(MoveCompleteBlock)block;

@end
