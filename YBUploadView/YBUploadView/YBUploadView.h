//
//  YBUploadView.h
//  YBUploadView
//
//  Created by 尚往文化 on 17/5/31.
//  Copyright © 2017年 YBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBUploadView : UIView

/**
 UIImage NSString  NSData
 */
@property (nonatomic, strong) NSArray<id> *images;

@property (nonatomic, assign) IBInspectable NSUInteger maxCount;//最多选择几张  默认9张
@property (nonatomic, assign) IBInspectable BOOL editEnabled;//是否可以编辑  默认YES

@end


