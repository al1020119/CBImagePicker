//
//  CBAssetsModel.h
//  CBImagePicker
//
//  Created by 陈超邦 on 2016/7/26.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <UIKit/UIKit.h>

@interface CBAssetsModel : NSObject

/**
 *  图片文件
 */
@property (nonatomic, strong, readwrite) UIImage  *image;

/**
 *  选择状态
 */
@property (nonatomic, strong, readwrite) NSNumber *selectedStaus;

/**
 *  cell所在的index
 */
@property (nonatomic, assign, readwrite) NSInteger index;

/**
 *  Asset图片资源
 */
@property (nonatomic, strong, readwrite) PHAsset   *imageAsset;

@end
