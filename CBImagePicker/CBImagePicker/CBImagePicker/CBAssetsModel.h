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
 *  The image.
 */
@property (nonatomic, strong, readwrite) UIImage   *image;

/**
 *  The select status.
 */
@property (nonatomic, strong, readwrite) NSNumber  *selectedStaus;

/**
 *  The page index.
 */
@property (nonatomic, assign, readwrite) NSInteger index;

/**
 *  The sourse of asset.
 */
@property (nonatomic, strong, readwrite) PHAsset   *imageAsset;

@end
