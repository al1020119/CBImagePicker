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
 *  导航栏标题
 */
@property (nonatomic, strong, readwrite) UIButton    *navigationBarTitleButton;

/**
 *  导航栏ImageView
 */
@property (nonatomic, strong, readwrite) UIImageView *navigationBarTitleImageView;

/**
 *  初始化方法
 *
 *  @param frame           frame
 *  @param selectedBlock   选择回调
 *  @param unselectedBlock 取消选择回调
 *
 *  @return 实例化对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                selectedBlock:(navigationBarTitleViewSelectedBlock)selectedBlock
              unSelectedBlock:(navigationBarTitleViewUnSelectedBlock)unselectedBlock;

/**
 *  按钮点击操作
 *
 *  @param sender 无描述
 */
- (void)navigationBarTitleButtonAction:(id)sender;

@end
