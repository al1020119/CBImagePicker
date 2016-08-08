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
 *  Small size of image.
 */
@property (nonatomic, strong, readwrite) UIImage   *smallImage;

/**
 *  Big size of image.
 */
@property (nonatomic, strong, readwrite) UIImage   *fullSizeImage;

/**
 *  From imageView.
 */
@property (nonatomic, strong, readwrite) UIView    *thumbView;

/**
 *  The url of image.
 */
@property (nonatomic, strong, readwrite) NSString  *imageUrl;

/**
 *  The sourse of asset.
 */
@property (nonatomic, strong, readwrite) PHAsset   *imageAsset;

@end
