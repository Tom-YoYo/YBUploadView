//
//  YBUploadView.m
//  YBUploadView
//
//  Created by 尚往文化 on 17/5/31.
//  Copyright © 2017年 YBing. All rights reserved.
//

#import "YBUploadView.h"
#import "YBUploadCell.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface YBUploadView ()<UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<id> *data_images;

@end

@implementation YBUploadView

#pragma mark - 属性方法
- (NSMutableArray<id> *)data_images
{
    if (_data_images==nil) {
        _data_images = [NSMutableArray array];
    }
    return _data_images;
}

- (void)setImages:(NSArray<id> *)images
{
    _data_images = [images mutableCopy];
    [self.collectionView reloadData];
}

- (NSArray<id> *)images
{
     NSArray *imgs = [self.data_images copy];
     NSMutableArray *uploadImgs = [NSMutableArray array];
     [imgs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
          if ([obj isKindOfClass:[UIImage class]]) {
               UIImage *img = obj;
               [uploadImgs addObject:UIImageJPEGRepresentation(img, 0.5)];
          } else {
               [uploadImgs addObject:obj];
          }
     }];
    return uploadImgs;
}

- (void)setEditEnabled:(BOOL)editEnabled
{
    _editEnabled = editEnabled;
    [self.collectionView reloadData];
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self yb_config];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self yb_config];
    }
    return self;
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

#pragma mark - UICollectionViewDataSource UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (!self.editEnabled) return self.data_images.count;
    if (self.data_images.count==self.maxCount) return self.maxCount;
    return self.data_images.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YBUploadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBUploadCell" forIndexPath:indexPath];
    cell.deleteBtnHidden = !self.editEnabled;
    if (indexPath.row>=self.data_images.count) {
        cell.img = nil;
        cell.deleteBtnHidden = YES;
    } else {
        cell.img = self.data_images[indexPath.row];
    }
    __weak typeof(self) weakSelf = self;
    [cell setDeleteBlock:^(id img) {
        [[weakSelf mutableArrayValueForKeyPath:@"data_images"] removeObject:img];//这样写可以KVO 监听data_images
//        [weakSelf.data_images removeObject:img];
        [weakSelf.collectionView reloadData];
    }];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.editEnabled) return;
    if (indexPath.row==self.data_images.count) {//点击加号
        
        UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        __weak typeof(self) weakSelf = self;
        [alertCtl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertCtl addAction:[UIAlertAction actionWithTitle:@"相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf yb_selectImg:UIImagePickerControllerSourceTypePhotoLibrary];
        }]];
        [alertCtl addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf yb_selectImg:UIImagePickerControllerSourceTypeCamera];
        }]];
        
        [[self yb_targetVC] presentViewController:alertCtl animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *img = info[UIImagePickerControllerEditedImage];
    [[self mutableArrayValueForKeyPath:@"data_images"] addObject:img];
    [self.collectionView reloadData];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.data_images.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 私有方法
- (void)yb_setupCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(80, 80);
    flowLayout.minimumLineSpacing = 4;
    flowLayout.minimumInteritemSpacing = 4;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"YBUploadCell" bundle:nil] forCellWithReuseIdentifier:@"YBUploadCell"];
    [self addSubview:self.collectionView];
}

- (UIViewController *)yb_targetVC
{
    UIViewController *vc = nil;
    __kindof UIResponder *responder = self;
    while (1) {
        responder = [responder nextResponder];
        if ([responder isKindOfClass:[UIViewController class]]) {
            vc = responder;
            break;
        }
        if (responder == nil) {
            break;
        }
    }
    return vc;
}

- (void)yb_selectImg:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = sourceType;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [[self yb_targetVC] presentViewController:ipc animated:YES completion:nil];
}

- (void)yb_config
{
    [self yb_setupCollectionView];
    self.maxCount = 9;//默认9张
    self.editEnabled = YES;
}

@end
