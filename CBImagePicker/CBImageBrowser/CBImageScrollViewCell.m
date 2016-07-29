//
//  CBImageScrollViewCell.m
//  CBImagePicker
//
//  Created by 陈超邦 on 2016/7/24.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import "CBImageScrollViewCell.h"
#import "UIView+CBAddition.h"
#import "UIImage+CBAddition.h"

@interface CBImageScrollViewCell()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong, readwrite) PHImageManager *imageManager;

@end

@implementation CBImageScrollViewCell

#pragma init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.delegate = self;
        
        self.bouncesZoom = YES;
        
        self.maximumZoomScale = 3;
        
        self.multipleTouchEnabled = YES;
        
        self.alwaysBounceVertical = NO;
        
        self.showsVerticalScrollIndicator = YES;
        
        self.showsHorizontalScrollIndicator = NO;
        
        self.frame = [UIScreen mainScreen].bounds;
        
        _imageManager = [[PHCachingImageManager alloc] init];
        
        [self initImageContainerView];
        
        [self initImageView];
        
        [self initProgressLayer];
    }
    return self;
}

- (void)initImageContainerView {
    if (!_imageContainerView) {
        _imageContainerView = [[UIView alloc] init];
        
        _imageContainerView.clipsToBounds = YES;
        
        [self addSubview:_imageContainerView];
    }
}

- (void)initImageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        
        _imageView.clipsToBounds = YES;
        
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        
        [_imageContainerView addSubview:_imageView];
    }
}

- (void)initProgressLayer {
    if (_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        
        _progressLayer.frame = CGRectMake(_progressLayer.frame.origin.x, _progressLayer.frame.origin.y, PROGRESS_SIZE_HEIGHT_WIDTH, PROGRESS_SIZE_HEIGHT_WIDTH);
        
        _progressLayer.cornerRadius = PROGRESS_SIZE_HEIGHT_WIDTH / 2;
        
        _progressLayer.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500].CGColor;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(_progressLayer.bounds, 7, 7) cornerRadius:(PROGRESS_SIZE_HEIGHT_WIDTH / 2 - 7)];
        
        _progressLayer.path = path.CGPath;
        
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        
        _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
        
        _progressLayer.lineWidth = 4;
        
        _progressLayer.lineCap = kCALineCapRound;
        
        _progressLayer.strokeStart = 0;
        
        _progressLayer.strokeEnd = 0;
        
        _progressLayer.hidden = YES;
        
        [self.layer addSublayer:_progressLayer];
    }
}


#pragma View Layeout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    _progressLayer.frame = CGRectMake(self.center.x - _progressLayer.frame.size.width / 2, self.center.y - _progressLayer.frame.size.height / 2, _progressLayer.frame.size.width, _progressLayer.frame.size.height);
}

- (void)reLayoutSubviews {
    _imageContainerView.origin = CGPointZero;
    
    _imageContainerView.sizeWidth = self.sizeWidth;
    
    UIImage *image = self.imageView.image;
    
    if (image.sizeHeight / image.sizeWidth > self.sizeHeight / self.sizeWidth) {
        _imageContainerView.sizeHeight = floor(image.size.height / (image.size.width / self.sizeWidth));
    }else{
        CGFloat height = floor(image.sizeHeight / image.sizeWidth * self.sizeWidth);
        
        _imageContainerView.sizeHeight = height;
        
        _imageContainerView.centerY = self.sizeHeight / 2;
    }
    
    self.contentSize = CGSizeMake(self.sizeWidth, MAX(_imageContainerView.sizeHeight, self.sizeHeight));
    
    [self scrollRectToVisible:self.bounds animated:NO];

    if (_imageContainerView.sizeHeight < self.sizeHeight) {
        self.alwaysBounceVertical = NO;
    }else {
        self.alwaysBounceVertical = YES;
    }
    
    _imageView.frame = _imageContainerView.bounds;
}

#pragma Cell Configurer
- (void)configureCellWithModel:(CBImageModel *)model {
    if (!model) {
        return;
    }
    
    [self setZoomScale:1.0 animated:NO];
    
    self.maximumZoomScale = 3;
    
//    if (model.fullSizeImage) {
//        self.maximumZoomScale = 3;
//        
//        self.imageView.image = model.fullSizeImage;
//    }else if(!model.fullSizeImage && model.imageUrl) {
//        
//    }
    
    self.imageView.image = model.smallImage;
    
    [_imageManager requestImageForAsset:model.imageAsset
                             targetSize:PHImageManagerMaximumSize
                            contentMode:PHImageContentModeDefault
                                options:nil
                          resultHandler:^(UIImage *result, NSDictionary *info) {
                              self.imageView.image = result;
                          }];
    
    [self reLayoutSubviews];
}

+ (CBImageScrollViewCell *)cellForDataArray:(NSArray *)dataArray
                                  pageIndex:(NSInteger)pageIndex {
    for (CBImageScrollViewCell *cell in dataArray) {
        if (cell.currentPageIndex == pageIndex) {
            return cell;
        }
    }
    return nil;
}

#pragma UIScrollView Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = _imageContainerView;
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

@end
