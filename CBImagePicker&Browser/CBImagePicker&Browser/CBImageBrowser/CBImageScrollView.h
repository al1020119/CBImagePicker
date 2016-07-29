//
//  CBImageScrollView.h
//  CBImagePicker
//
//  Created by 陈超邦 on 2016/7/25.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CBImageScrollViewIndexBlock)(NSInteger index);

@interface CBImageScrollView : UIScrollView

@property (nonatomic, strong, readwrite) UIPageControl *pageControl;

@property (nonatomic, strong, readwrite) CBImageScrollViewIndexBlock imageScrollViewIndexBlock;

/**
 *  加载数据
 *
 *  @param cellArray cell数组
 *  @param dataArray 数据数组
 *
 *  @return cell数组
 */
- (NSMutableArray *)preLoadDataWithCellArray:(NSMutableArray *)cellArray
                                   dataArray:(NSMutableArray *)dataArray;

/**
 *  隐藏pageControl
 */
- (void)hidePageControl;

@end
