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
#import <SDWebImage/UIImageView+WebCache.h>

@interface CBImageScrollViewCell()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong, readwrite) PHImageManager *imageManager;

@end

@implementation CBImageScrollViewCell

#pragma - init.
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
    if (!_progressLayer) {
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


#pragma - view layout.
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

#pragma - cell loader.
- (void)configureCellWithModel:(CBImageModel *)model {
    if (!model) {
        return;
    }
    
    [self setZoomScale:1.0 animated:NO];
    
    self.maximumZoomScale = 3;
    
    if (!_imageView.image) {
        self.maximumZoomScale = 1;
        
        self.imageView.image = model.smallImage;
                
        if (model.fullSizeImage) {
            self.imageView.image = model.fullSizeImage;
            
            [self reLayoutSubviews];
        }else if(model.imageAsset){
            _imageManager = [[PHCachingImageManager alloc] init];
            
            [_imageManager requestImageForAsset:model.imageAsset
                                     targetSize:PHImageManagerMaximumSize
                                    contentMode:PHImageContentModeAspectFill
                                        options:nil
                                  resultHandler:^(UIImage *result, NSDictionary *info) {
                                      if (result) {
                                          self.imageView.image = result;
                                          
                                          [self reLayoutSubviews];
                                      }
                                  }];
        }else if(model.imageUrl) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:model.smallImage options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                CGFloat progress = receivedSize / (float)expectedSize;
                
                progress = progress < 0.01 ? 0.01 : progress > 1 ? 1 : progress;
                
                if (isnan(progress)) progress = 0;
                
                _progressLayer.hidden = NO;
                
                _progressLayer.strokeEnd = progress;
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                _progressLayer.hidden = YES;
                
                [self reLayoutSubviews];
            }];
        }
    }
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

#pragma - ScrollView deleagte.
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
