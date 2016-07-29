
//
//  CBImageScrollView.m
//  CBImagePicker
//
//  Created by 陈超邦 on 2016/7/25.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import "CBImageScrollView.h"
#import "CBImageScrollViewCell.h"
#import "CBImageModel.h"
#import "UIView+Addition.h"

@interface CBImageScrollView()<UIScrollViewDelegate>

@property (nonatomic, strong, readwrite) NSMutableArray *cellArr;

@property (nonatomic, strong, readwrite) NSMutableArray *dataArr;

@end

@implementation CBImageScrollView

#pragma init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.cellArr = [[NSMutableArray alloc] init];
        
        self.delegate = self;
        
        self.scrollsToTop = NO;
        
        self.pagingEnabled = YES;
                
        self.showsHorizontalScrollIndicator = NO;
        
        self.showsVerticalScrollIndicator = NO;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.delaysContentTouches = NO;
        
        self.canCancelContentTouches = YES;
        
        [self initPageControl];
    }
    return self;
}

- (void)initPageControl {
    _pageControl = [[UIPageControl alloc] init];
    
    _pageControl.hidesForSinglePage = YES;
    
    _pageControl.userInteractionEnabled = NO;
    
    _pageControl.sizeHeight = 10;
    
    _pageControl.center = CGPointMake(self.sizeWidth / 2, self.sizeHeight - 18);
    
    _pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

- (void)hidePageControl {
    [UIView animateWithDuration:0.3 delay:0.8 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
        _pageControl.alpha = 0;
    }completion:nil];
}

#pragma cell加载
- (NSMutableArray *)preLoadDataWithCellArray:(NSMutableArray *)cellArray
                                   dataArray:(NSMutableArray *)dataArray{
    _cellArr = cellArray;
    
    _dataArr = dataArray;

    [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CBImageScrollViewCell *cell = [[CBImageScrollViewCell alloc] initWithFrame:self.bounds];
        
        cell.imageContainerView.frame = self.bounds;
        
        cell.imageView.frame = self.bounds;
        
        cell.originLeft = self.sizeWidth * idx;
        
        [cell configureCellWithModel:dataArray[idx]];
        
        cell.currentPageIndex = idx;
        
        [_cellArr addObject:cell];
        
        [self addSubview:cell];
    }];
    
    return _cellArr;
}

#pragma ScrollView代理
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self hidePageControl];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (_imageScrollViewIndexBlock) {
        _imageScrollViewIndexBlock(targetContentOffset->x / self.sizeWidth);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger intPage = self.contentOffset.x / self.sizeWidth + 0.5;
    
    intPage = intPage < 0 ? 0 : intPage >= _dataArr.count ? (int)_dataArr.count - 1 : intPage;
    
    _pageControl.currentPage = intPage;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        _pageControl.alpha = 1;
    }completion:nil];
}

@end
