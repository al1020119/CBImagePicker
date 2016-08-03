//
//  CBNavigationBarTitleView.h
//  CBImagePicker
//
//  Created by 陈超邦 on 16/6/12.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^navigationBarTitleViewSelectedBlock)(void);

typedef void(^navigationBarTitleViewUnSelectedBlock)(void);

@interface CBNavigationBarTitleView : UIView

/**
 *  The title of navigationView.
 */
@property (nonatomic, strong, readwrite) UIButton    *navigationBarTitleButton;

/**
 *  The imageView of navigationView.
 */
@property (nonatomic, strong, readwrite) UIImageView *navigationBarTitleImageView;

/**
 *  The initstancetype method.
 *
 *  @param frame           frame.
 *  @param selectedBlock   block.
 *  @param unselectedBlock unselect block.
 *
 *  @return instance.
 */
- (instancetype)initWithFrame:(CGRect)frame
                selectedBlock:(navigationBarTitleViewSelectedBlock)selectedBlock
              unSelectedBlock:(navigationBarTitleViewUnSelectedBlock)unselectedBlock;

/**
 *  The navigation select action.
 *
 *  @param sender button object.
 */
- (void)navigationBarTitleButtonAction:(id)sender;

@end
