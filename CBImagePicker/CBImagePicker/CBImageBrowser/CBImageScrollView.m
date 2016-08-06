
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
#import "UIView+CBAddition.h"

@interface CBImageScrollView()<UIScrollViewDelegate>

@property (nonatomic, strong, readwrite) NSMutableArray *cellArr;

@property (nonatomic, strong, readwrite) NSMutableArray *dataArr;

@end

@implementation CBImageScrollView

#pragma - init
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

#pragma - cell loader.
- (NSMutableArray *)preLoadDataWithCellArray:(NSMutableArray *)cellArray
                                   dataArray:(NSMutableArray *)dataArray{
    _cellArr = cellArray;
    
    _dataArr = dataArray;

    [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CBImageScrollViewCell *cell = [[CBImageScrollViewCell alloc] initWithFrame:self.bounds];
        
        cell.imageContainerView.frame = self.bounds;
        
        cell.imageView.frame = self.bounds;
        
        cell.tag = 100 + idx;
        
        cell.originLeft = self.sizeWidth * idx + CELL_PADDING / 2;
        
        [cell configureCellWithModel:dataArray[idx]];
        
        cell.currentPageIndex = idx;
        
        [_cellArr addObject:cell];
        
        [self addSubview:cell];
    }];
    
    return _cellArr;
}

#pragma - ScrollView delegate.
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    _pageControl.alpha = 1;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    NSInteger intPage = targetContentOffset->x / self.sizeWidth;
    
    _imageScrollViewIndexBlock ? _imageScrollViewIndexBlock(intPage) : nil;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger intPage = self.contentOffset.x / self.sizeWidth + 0.5;
    
    intPage = intPage < 0 ? 0 : intPage >= _dataArr.count ? (int)_dataArr.count - 1 : intPage;
    
    _pageControl.currentPage = intPage;
    
    [self hidePageControl];
}

@end
