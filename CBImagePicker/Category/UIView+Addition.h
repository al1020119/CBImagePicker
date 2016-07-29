//
//  UIView+Addition.h
//  CBImagePicker
//
//  Created by 陈超邦 on 2016/7/24.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Addition)

/**
 *  左坐标
 */
@property (nonatomic, assign, readwrite) CGFloat      originLeft;

/**
 *  上坐标
 */
@property (nonatomic, assign, readwrite) CGFloat      originUp;

/**
 *  右坐标
 */
@property (nonatomic, assign, readwrite) CGFloat      originRight;

/**
 *  下坐标
 */
@property (nonatomic, assign, readwrite) CGFloat      originDown;

/**
 *  尺寸宽度
 */
@property (nonatomic, assign, readwrite) CGFloat      sizeWidth;

/**
 *  尺寸高度
 */
@property (nonatomic, assign, readwrite) CGFloat      sizeHeight;

/**
 *  位置origin
 */
@property (nonatomic, assign, readwrite) CGPoint      origin;

/**
 *  尺寸Size
 */
@property (nonatomic, assign, readwrite) CGSize       size;

/**
 *  中心坐标X
 */
@property (nonatomic, assign, readwrite) CGFloat       centerX;

/**
 *  中心坐标Y
 */
@property (nonatomic, assign, readwrite) CGFloat       centerY;

/**
 *  当前view的viewController
 *
 *  @return 返回viewcontroller对象
 */
- (UIViewController *)viewController;

@end
