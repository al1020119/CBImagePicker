//
//  CBImageScrollViewCell.h
//  CBImagePicker
//
//  Created by 陈超邦 on 2016/7/24.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBImageModel.h"

#define PROGRESS_SIZE_HEIGHT_WIDTH 40.f

@interface CBImageScrollViewCell : UIScrollView

/**
 *  The contain View of the image.
 */
@property (nonatomic, strong, readwrite) UIView       *imageContainerView;

/**
 *  The main imageView which can be used to show the image.
 */
@property (nonatomic, strong, readwrite) UIImageView  *imageView;

/**
 *  The current index of image.
 */
@property (nonatomic, assign, readwrite) NSInteger    currentPageIndex;

/**
 *  The progress.
 */
@property (nonatomic, assign, readwrite) CGFloat      progress;

/**
 *  The layer of peogress.
 */
@property (nonatomic, strong, readwrite) CAShapeLayer *progressLayer;


/**
 *  Get the page index method.
 *
 *  @param dataArray dataArray.
 *  @param pageIndex index.
 *
 *  @return cell instance.
 */
+ (CBImageScrollViewCell *)cellForDataArray:(NSArray *)dataArray
                                  pageIndex:(NSInteger)pageIndex;

/**
 *  Load the cell with model.
 *
 *  @param model model instance.
 */
- (void)configureCellWithModel:(CBImageModel *)model;

/**
 *  Relayout the subview.
 */
- (void)reLayoutSubviews;

@end
