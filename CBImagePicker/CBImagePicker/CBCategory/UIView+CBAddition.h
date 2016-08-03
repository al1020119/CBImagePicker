//
//  UIView+CBAddition.h
//  CBImagePicker
//
//  Created by 陈超邦 on 2016/7/29.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CBAddition)

/**
 *  The X of origin.
 */
@property (nonatomic, assign, readwrite) CGFloat originLeft;

/**
 *  The Y of origin.
 */
@property (nonatomic, assign, readwrite) CGFloat originUp;

/**
 *  The X of origin + the width of size.
 */
@property (nonatomic, assign, readwrite) CGFloat originRight;

/**
 *  The Y of origin + the height of size.
 */
@property (nonatomic, assign, readwrite) CGFloat originDown;

/**
 *  The width of size.
 */
@property (nonatomic, assign, readwrite) CGFloat sizeWidth;

/**
 *  The height of size.
 */
@property (nonatomic, assign, readwrite) CGFloat sizeHeight;

/**
 *  The origin.
 */
@property (nonatomic, assign, readwrite) CGPoint origin;

/**
 *  The size.
 */
@property (nonatomic, assign, readwrite) CGSize  size;

/**
 *  The X of center point.
 */
@property (nonatomic, assign, readwrite) CGFloat centerX;

/**
 *  The Y of center point.
 */
@property (nonatomic, assign, readwrite) CGFloat centerY;

/**
 *  The ViewControll object which self was added to.
 *
 *  @return ViewControll object.
 */
- (UIViewController *)viewController;

@end
