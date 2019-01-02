//
//  PhotoTableViewCell.h
//  Detector
//
//  Created by Mac2 on 2018/12/6.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FaceImageBlock)(UIImageView *imageView);
typedef void(^FingerImageBlock)(UIImageView *imageView);

@interface PhotoTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *faceImageView;
@property (nonatomic, strong) UIImageView *fingerImageView;
@property (nonatomic, copy) FaceImageBlock faceImageBlock;
@property (nonatomic, copy) FingerImageBlock fingerImageBlock;

@end
