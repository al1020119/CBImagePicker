//
//  CBAssetsViewCell.h
//  CBImagePicker
//
//  Created by 陈超邦 on 16/6/12.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBAssetsModel.h"

@interface CBAssetsViewCell : UICollectionViewCell

/**
 *  The imageView of cell.
 */
@property (nonatomic, strong, readwrite) UIView   *assetsImageView;

/**
 *  The cell's select status.
 */
@property (nonatomic, strong, readwrite) NSNumber *seletedStaus;

/**
 *  The block which work when selected.
 *
 *  @param selectBlock seletct block.
 */
- (void)buttonSelectBlock:(void(^)(NSNumber *seletedStaus))selectBlock;

/**
 *  The data loader of cell.
 *
 *  @param mdoel model object.
 */
- (void)configureWithModel:(CBAssetsModel *)mdoel;

@end
