//
//  CBImageBrowser.m
//  CBImagePicker
//
//  Created by 陈超邦 on 2016/7/24.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import "CBImageBrowser.h"

@interface CBImageBrowser()<UIGestureRecognizerDelegate>

@property (nonatomic, strong, readwrite) NSMutableArray    *cellArray;

@property (nonatomic, strong, readwrite) UIImageView       *blurBackground;

@property (nonatomic, strong, readwrite) UIView            *fromView;

@property (nonatomic, strong, readwrite) UIView            *toContainerView;

@property (nonatomic, assign, readwrite) NSInteger         fromItemIndex;

@property (nonatomic, assign, readwrite) BOOL              isPresented;

@property (nonatomic, assign, readwrite) CGPoint           panGestureBeginPoint;

@property (nonatomic, strong, readwrite) CBImageScrollView *scrollView;

@end

@implementation CBImageBrowser

- (void)setAssetArrays:(NSMutableArray *)assetArrays {
    _assetArrays = assetArrays;
}

#pragma - init.
- (instancetype)initWithAssetArrays:(NSArray *)assetArrays {
    self = [super init];
    
    if (self) {
        if (assetArrays.count == 0) return nil;
        
        self.assetArrays = assetArrays.mutableCopy;
        
        self.cellArray = [[NSMutableArray alloc] init];
        
        self.backgroundColor = [UIColor clearColor];
        
        self.frame = [UIScreen mainScreen].bounds;

        self.clipsToBounds = YES;
                
        [self initView];
        
        [self addGesture];
    }
    return self;
}

- (void)initView {
    _blurBackground = [[UIImageView alloc] init];
    
    _blurBackground.frame = self.bounds;
    
    _blurBackground.userInteractionEnabled = YES;
    
    _blurBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = _blurBackground.bounds;
    
    [_blurBackground addSubview:visualEffectView];
    
    [self addSubview:_blurBackground];
    
    _scrollView = [[CBImageScrollView alloc] initWithFrame:CGRectMake(0, 0, self.sizeWidth, self.sizeHeight)];
    
    _scrollView.alwaysBounceHorizontal = _assetArrays.count > 1;
    
    @WEAK_OBJ(self);
    _scrollView.imageScrollViewIndexBlock = ^(NSInteger index){
        @STRONG_OBJ(selfWeak);
        
        if ([selfWeakStrong.imageBrowserDelegate respondsToSelector:@selector(imageBrowser:index:)]) {
            [selfWeakStrong.imageBrowserDelegate imageBrowser:selfWeakStrong index:index];
        }
    };
    
    [self addSubview:_scrollView];
    
    [self addSubview:_scrollView.pageControl];
}

#pragma - Gesture.
- (void)addGesture {
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    
    doubleTap.delegate = self;
    
    doubleTap.numberOfTapsRequired = 2;
    
    [doubleTap requireGestureRecognizerToFail:doubleTap];
    
    [self addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    
    singleTap.delegate = self;
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    [self addGestureRecognizer:singleTap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    
    longPress.delegate = self;
    
    [self addGestureRecognizer:longPress];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    
    [self addGestureRecognizer:panGesture];
}

#pragma -  Gesture Action.
- (void)doubleTap:(UITapGestureRecognizer *)sender {
    if (!_isPresented) return;
    
    CBImageScrollViewCell *imageCell = [CBImageScrollViewCell cellForDataArray:_cellArray
                                                                     pageIndex:self.currentPage];
    
    if (imageCell.zoomScale > 1) {
        [imageCell setZoomScale:1 animated:YES];
    } else {
        CGPoint touchPoint = [sender locationInView:imageCell.imageView];
        
        CGFloat newZoomScale = imageCell.maximumZoomScale;
        
        CGFloat xsize = imageCell.sizeWidth / newZoomScale;
        
        CGFloat ysize = imageCell.sizeHeight / newZoomScale;
        
        [imageCell zoomToRect:CGRectMake(touchPoint.x - xsize / 2, touchPoint.y - ysize / 2, xsize, ysize) animated:YES];
    }
}

- (void)dismiss:(UITapGestureRecognizer *)sender {
    if (!_isPresented) return;

    [self dismissAnimated:YES completion:nil];
}

- (void)panGesture:(UIPanGestureRecognizer *)sender {
    if (!_isPresented) return;

    if (sender.state == UIGestureRecognizerStateBegan) {
        _panGestureBeginPoint = [sender locationInView:self];
    }else if(sender.state == UIGestureRecognizerStateChanged) {
        CGFloat changeDistanceY = [sender locationInView:self].y - _panGestureBeginPoint.y;
        
        _scrollView.originUp = changeDistanceY;
        
        CGFloat alpha = (3 / 2 - fabs(changeDistanceY) / PAN_RELEASE_DISTANCE);
        
        alpha > 1 ? alpha = 1 : alpha < 0 ? alpha = 0 : alpha;
        
        [UIView animateWithDuration:0.1
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
            _blurBackground.alpha = alpha;
        } completion:nil];
    }else if(sender.state == UIGestureRecognizerStateEnded) {
        CGPoint moveSpeed = [sender velocityInView:self];
        
        CGPoint changeToPoint = [sender locationInView:self];
        
        CGFloat changeDistanceY = changeToPoint.y - _panGestureBeginPoint.y;
        
        if (fabs(moveSpeed.y) > 1000 || fabs(changeDistanceY) > PAN_RELEASE_DISTANCE) {
            _isPresented = NO;
            
            BOOL moveToTop = (moveSpeed.y < - 50 || (moveSpeed.y < 50 && changeDistanceY < 0));

            CGFloat duration = (moveToTop ? _scrollView.originDown : self.sizeHeight - _scrollView.originUp) / (fabs(moveSpeed.y) > 1 ? fabs(moveSpeed.y) : 1);
            
            duration > 0.1 ? duration = 0.1 : duration < 0.05 ? duration = 0.05 : duration;
            
            [UIView animateWithDuration:duration
                                  delay:0
                                options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{
                _blurBackground.alpha = 0;
                if (moveToTop) {
                    _scrollView.originDown = 0;
                } else {
                    _scrollView.originUp = self.sizeHeight;
                }
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }else {
            [UIView animateWithDuration:0.4f
                                  delay:0.f
                 usingSpringWithDamping:0.9f
                  initialSpringVelocity:moveSpeed.y / 1000.f
                                options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
                _scrollView.originUp = 0;
                
                _blurBackground.alpha = 1;
            } completion:nil];
        }
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)sender {
    CBImageScrollViewCell *imageCell = [CBImageScrollViewCell cellForDataArray:_cellArray
                                                                     pageIndex:self.currentPage];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[imageCell.imageView.image] applicationActivities:nil];
    
    if ([activityViewController respondsToSelector:@selector(popoverPresentationController)]) {
        activityViewController.popoverPresentationController.sourceView = self;
    }
    
    [self.viewController presentViewController:activityViewController animated:YES completion:nil];
}

#pragma - Show or hide with animation.
- (void)presentFromImageView:(UIView *)fromView
                 toContainer:(UIView *)toContainer
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion {
    if (!toContainer) return;
    
    _fromView = fromView;
    
    _toContainerView = toContainer;
    
    _fromItemIndex = 0;
    
    @WEAK_OBJ(self);
    [_assetArrays enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @STRONG_OBJ(selfWeak);
        
        if (fromView == [(CBImageModel *)obj thumbView]) {
            selfWeakStrong.fromItemIndex = idx;
            *stop = YES;
        }
    }];
    
    self.size = toContainer.size;
    
    _scrollView.pageControl.alpha = 0;
    
    _scrollView.center = self.center;
    
    [toContainer addSubview:self];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.sizeWidth * _assetArrays.count, _scrollView.sizeHeight);
    
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.sizeWidth * _fromItemIndex, 0, _scrollView.sizeWidth, _scrollView.sizeHeight) animated:NO];
    
    _scrollView.pageControl.numberOfPages = _assetArrays.count;

    _scrollView.pageControl.currentPage = _fromItemIndex;
    
    if (_cellArray) {
        [_cellArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [_cellArray removeAllObjects];
    }
    
    _cellArray = [_scrollView preLoadDataWithCellArray:_cellArray
                                             dataArray:_assetArrays];
    
    [UIView setAnimationsEnabled:YES];
    
    CBImageScrollViewCell *imageCell = [CBImageScrollViewCell cellForDataArray:_cellArray
                                                                     pageIndex:_fromItemIndex];
    
    [imageCell reLayoutSubviews];
    
    [self showWithAnimated:animated
                      cell:imageCell
                completion:completion];
}

- (void)showWithAnimated:(BOOL)animated
                    cell:(CBImageScrollViewCell *)cell
              completion:(void (^)(void))completion {
    CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:cell.imageContainerView];
    
    cell.imageContainerView.clipsToBounds = NO;
    
    cell.imageView.frame = fromFrame;
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    float oneTime = animated ? 0.18 : 0;
    
    [UIView animateWithDuration:oneTime * 2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        _blurBackground.alpha = 1;
    }completion:nil];
    
    _scrollView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
        cell.imageView.frame = cell.imageContainerView.bounds;
        
        [cell.imageView.layer setValue:@(1.01) forKey:@"transform.scale"];
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            [cell.imageView.layer setValue:@(1.0) forKey:@"transform.scale"];
            
            _scrollView.pageControl.alpha = 1;
        }completion:^(BOOL finished) {
            _isPresented = YES;
            
            cell.imageContainerView.clipsToBounds = YES;
            
            _scrollView.userInteractionEnabled = YES;
            
            [_scrollView hidePageControl];
            
            if (completion) completion();
        }];
    }];
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion {
    UIView *fromView = nil;
    
    CBImageScrollViewCell *imageCell = [CBImageScrollViewCell cellForDataArray:_cellArray
                                                                     pageIndex:[self currentPage]];
    
    CBImageModel *imageModel = _assetArrays[[self currentPage]];
    
    if (_fromItemIndex == [self currentPage]) {
        fromView = _fromView;
    } else {
        fromView = imageModel.thumbView;
    }
    
    _isPresented = NO;
    
    [UIView animateWithDuration:animated ? 0.2 : 0
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
        _scrollView.pageControl.alpha = 0.0;
        
        _blurBackground.alpha = 0.0;
        
        CGRect fromFrame = [fromView convertRect:fromView.bounds toView:imageCell.imageContainerView];
        
        imageCell.imageContainerView.clipsToBounds = NO;
        
        imageCell.imageView.contentMode = fromView.contentMode;
        
        imageCell.imageView.frame = fromFrame;
        
        imageCell.imageView.image = imageModel.smallImage;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        if (completion) completion();
    }];
}

#pragma Other
- (NSInteger)currentPage {
    NSInteger page = _scrollView.contentOffset.x / _scrollView.sizeWidth + 0.5;
    
    if (page >= _assetArrays.count) page = (NSInteger)_assetArrays.count - 1;
    
    if (page < 0) page = 0;
    
    return page;
}

@end
