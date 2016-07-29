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
 *  ImageView
 */
@property (nonatomic, strong, readwrite) UIView   *assetsImageView;

/**
 *  点击状态
 */
@property (nonatomic, strong, readwrite) NSNumber *seletedStaus;

/**
 *  按钮点击回调
 *
 *  @param selectBlock 选择Block
 */
- (void)buttonSelectBlock:(void(^)(NSNumber *seletedStaus))selectBlock;

/**
 *  填充cell内容
 *
 *  @param mdoel 数据模型
 */
- (void)configureWithModel:(CBAssetsModel *)mdoel;

@end
