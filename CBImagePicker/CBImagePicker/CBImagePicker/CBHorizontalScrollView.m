//
//  CBHorizontalScrollView.m
//  CBImagePicker

//
//  Created by 陈超邦 on 2016/7/27.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import "CBHorizontalScrollView.h"
#import "UIView+CBAddition.h"
#import "UIImage+CBAddition.h"
#import "CBImageModel.h"
#import "CBImageBrowser.h"

@interface CBHorizontalScrollView()<UIScrollViewDelegate,CBImageBrowserDelegate>

@property (nonatomic, strong, readwrite) NSMutableArray *cellArray;

@property (nonatomic, strong, readwrite) NSMutableArray *assetsArray;

@property (nonatomic, strong, readwrite) PHImageManager *imageManager;

@property (nonatomic, strong, readwrite) CBImageBrowser *imageBrowser;

@end

@implementation CBHorizontalScrollView

#pragma - init.
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.cellArray = [[NSMutableArray alloc] init];
        
        self.assetsArray = [[NSMutableArray alloc] init];
        
        self.delegate = self;
        
        self.alwaysBounceHorizontal = YES;
        
        self.showsHorizontalScrollIndicator = NO;
        
        self.showsVerticalScrollIndicator = NO;
                 
        _imageManager = [[PHCachingImageManager alloc] init];
    }
    return self;
}

#pragma - Setter
- (UIImageView *)setupImageViewWithImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, HORZONTAL_IMAGE_CELL_PADDING, HORZONTAL_IMAGE_CELL_SIZE.width, HORZONTAL_IMAGE_CELL_SIZE.height)];
    
    imageView.clipsToBounds = YES;
    
    imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageSelector:)];
    
    [imageView addGestureRecognizer:singleTap];
    
    imageView.image = image;
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    imageView.backgroundColor = [UIColor blackColor];
    
    return imageView;
}

- (void)setImageModel:(CBAssetsModel *)imageModel {
    _imageModel = imageModel;
    
    if (_imageModel) {
        [_assetsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([(CBAssetsModel *)obj index] == _imageModel.index) {
                [_assetsArray removeObject:obj];
                
                [_cellArray removeAllObjects];
                
                *stop = YES;
                
                _imageModel = nil;
            }
        }];
    }
    
    if (_imageModel) {
        [_assetsArray addObject:imageModel];
        
        UIImageView *imageView = [self setupImageViewWithImage:_imageModel.image];
        
        imageView.tag = _assetsArray.count;
        
        [_imageManager requestImageForAsset:imageModel.imageAsset
                                 targetSize:CGSizeMake(HORZONTAL_IMAGE_CELL_SIZE.width * 2, HORZONTAL_IMAGE_CELL_SIZE.height * 2)
                                contentMode:PHImageContentModeDefault
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  imageModel.image = result;

                                  imageView.image = result;
                              }];
        
        imageView.originLeft = HORZONTAL_IMAGE_CELL_PADDING * _assetsArray.count + imageView.sizeWidth * (_assetsArray.count - 1);
        
        [_cellArray addObject:imageView];
        
        self.contentSize = CGSizeMake(HORZONTAL_IMAGE_CELL_SIZE.width * _assetsArray.count + HORZONTAL_IMAGE_CELL_PADDING * (_assetsArray.count + 1), self.sizeHeight);
        
        if (_assetsArray.count == 1) {
            [self setContentInset:UIEdgeInsetsMake(0, (self.sizeWidth - imageView.sizeWidth) / 2 - imageView.originLeft, 0, 0)];

            [self setContentOffset:CGPointMake(imageView.originLeft - (self.sizeWidth - imageView.sizeWidth) / 2,0) animated:NO];
        }else {
            [self setContentInset:UIEdgeInsetsZero];

            [self setContentOffset:CGPointMake(imageView.originLeft - (self.sizeWidth - imageView.sizeWidth - HORZONTAL_IMAGE_CELL_PADDING),0) animated:YES];
        }
        
        [self addSubview:imageView];
    }else {
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        
        self.contentSize = CGSizeMake(HORZONTAL_IMAGE_CELL_SIZE.width * _assetsArray.count + HORZONTAL_IMAGE_CELL_PADDING * (_assetsArray.count + 1), self.sizeHeight);

        [_assetsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIImageView *imageView = [self setupImageViewWithImage:[(CBAssetsModel *)obj image]];
            
            imageView.tag = idx + 1;
            
            imageView.originLeft = HORZONTAL_IMAGE_CELL_PADDING * (idx + 1) + imageView.sizeWidth * idx;
            
            [_cellArray addObject:imageView];
            
            [self addSubview:imageView];
        }];
        
        if (_assetsArray.count == 1) {
            [self setContentInset:UIEdgeInsetsMake(0, (self.sizeWidth - HORZONTAL_IMAGE_CELL_SIZE.width) / 2 - HORZONTAL_IMAGE_CELL_PADDING, 0, 0)];

            [self setContentOffset:CGPointMake(10.f - (self.sizeWidth - HORZONTAL_IMAGE_CELL_SIZE.width) / 2,0) animated:NO];
        }else {
            if (self.contentOffset.x != 0) {
                [self setContentOffset:CGPointZero animated:YES];
            }
            [self setContentInset:UIEdgeInsetsZero];
        }
    }
}

#pragma - method.
- (void)removeAllCells {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    [_assetsArray removeAllObjects];
    
    [_cellArray removeAllObjects];
    
    self.contentSize = CGSizeZero;
}

- (void)imageSelector:(UITapGestureRecognizer *)sender {
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    
    [_assetsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CBImageModel *model = [[CBImageModel alloc] init];
        
        model.thumbView = _cellArray[idx];
        
        model.smallImage = [(CBAssetsModel *)obj image];
        
        model.imageAsset = [(CBAssetsModel *)obj imageAsset];
        
        [modelArray addObject:model];
    }];
    
    if (!_imageBrowser) {
        _imageBrowser = [[CBImageBrowser alloc] initWithAssetArrays:modelArray];
        
        _imageBrowser.imageBrowserDelegate = self;
    }else {
        _imageBrowser.assetArrays = modelArray;
    }
    
    [_imageBrowser presentFromImageView:sender.view
                            toContainer:self.viewController.navigationController.view
                               animated:YES
                             completion:nil];
}

#pragma - CBImageBrowser delegate
- (void)imageBrowser:(CBImageBrowser *)browser index:(NSInteger)index {
    [self setContentOffset:CGPointMake(HORZONTAL_IMAGE_CELL_PADDING * (index + 1) + HORZONTAL_IMAGE_CELL_SIZE.width * index - (self.sizeWidth - HORZONTAL_IMAGE_CELL_SIZE.width) / 2,0) animated:NO];
}

@end
