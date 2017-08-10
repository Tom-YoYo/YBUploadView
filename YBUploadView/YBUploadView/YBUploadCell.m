//
//  YBUploadCell.m
//  YBUploadView
//
//  Created by 尚往文化 on 17/5/31.
//  Copyright © 2017年 YBing. All rights reserved.
//

#import "YBUploadCell.h"
//#import <UIImageView+WebCache.h>

@interface YBUploadCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation YBUploadCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setDeleteBtnHidden:(BOOL)deleteBtnHidden
{
    _deleteBtnHidden = deleteBtnHidden;
    self.deleteBtn.hidden = deleteBtnHidden;
}

- (void)setImg:(id)img
{
    _img = img;
    
    if (img==nil) {
        self.imgView.image = [UIImage imageNamed:@"YBUploadView_jiahao2"];
    } else {
        if ([img isKindOfClass:[NSString class]]) {
//            [self.imgView sd_setImageWithURL:[NSURL URLWithString:[img stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:nil];
        } else if ([img isKindOfClass:[UIImage class]]) {
            self.imgView.image = img;
        } else if ([img isKindOfClass:[NSData class]]) {
            self.imgView.image = [UIImage imageWithData:img];
        }
    }
    
}

- (IBAction)deleteClick:(UIButton *)sender {
    if (self.img==nil) return;
    if (self.deleteBlock) {
        self.deleteBlock(self.img);
    }
}

@end
