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
 *  图片包含视图
 */
@property (nonatomic, strong, readwrite) UIView       *imageContainerView;

/**
 *  ImageView
 */
@property (nonatomic, strong, readwrite) UIImageView  *imageView;

/**
 *  当前页数
 */
@property (nonatomic, assign, readwrite) NSInteger    currentPageIndex;

/**
 *  进度
 */
@property (nonatomic, assign, readwrite) CGFloat      progress;

/**
 *  进度layer
 */
@property (nonatomic, strong, readwrite) CAShapeLayer *progressLayer;


/**
 *  取出PageIndex对应的cell
 *
 *  @param dataArray 数据数组
 *  @param pageIndex index
 *
 *  @return cell 对象
 */
+ (CBImageScrollViewCell *)cellForDataArray:(NSArray *)dataArray
                                  pageIndex:(NSInteger)pageIndex;

/**
 *  根据model填充cell
 *
 *  @param model model对象
 */
- (void)configureCellWithModel:(CBImageModel *)model;

/**
 *  重新放置子视图
 */
- (void)reLayoutSubviews;

@end
