//
//  CBImageModel.h
//  CBImagePicker
//
//  Created by 陈超邦 on 2016/7/24.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface CBImageModel : NSObject

/**
 *  小尺寸图片（不能为空）
 */
@property (nonatomic, strong, readwrite) UIImage  *smallImage;

/**
 *  大尺寸图片（可以为空）
 */
@property (nonatomic, strong, readwrite) UIImage  *fullSizeImage;

/**
 *  对应的源imageView
 */
@property (nonatomic, strong, readwrite) UIView   *thumbView;

/**
 *  图片链接
 */
@property (nonatomic, strong, readwrite) NSString *imageUrl;

/**
 *  Asset图片资源
 */
@property (nonatomic, strong, readwrite) PHAsset   *imageAsset;

@end
