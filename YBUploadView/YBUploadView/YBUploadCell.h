//
//  YBUploadCell.h
//  YBUploadView
//
//  Created by 尚往文化 on 17/5/31.
//  Copyright © 2017年 YBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBUploadCell : UICollectionViewCell

@property (nonatomic, assign) BOOL deleteBtnHidden;

@property (nonatomic, strong) id img;

@property (nonatomic, copy) void(^deleteBlock)(id img);

@end
