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

/**
 *  Page controll.
 */
@property (nonatomic, strong, readwrite) UIPageControl *pageControl;

/**
 *  A block which can be used to get the index of the imageSCrollView.
 */
@property (nonatomic, strong, readwrite) CBImageScrollViewIndexBlock imageScrollViewIndexBlock;

/**
 *  PreLoad the data of the cell.
 *
 *  @param cellArray cell array.
 *  @param dataArray data array.
 *
 *  @return  Modified cell array.
 */
- (NSMutableArray *)preLoadDataWithCellArray:(NSMutableArray *)cellArray
                                   dataArray:(NSMutableArray *)dataArray;

/**
 *  Hide the page controll.
 */
- (void)hidePageControl;

@end
