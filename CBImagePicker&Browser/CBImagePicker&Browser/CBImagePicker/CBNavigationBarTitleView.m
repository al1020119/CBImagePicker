//
//  CBNavigationBarTitleView.m
//  CBImagePicker
//
//  Created by 陈超邦 on 16/6/12.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import "CBNavigationBarTitleView.h"
#import "CBImagePicker.h"

@interface CBNavigationBarTitleView()

@property(nonatomic, strong, readwrite) navigationBarTitleViewSelectedBlock inSelectedBlock;

@property(nonatomic, strong, readwrite) navigationBarTitleViewUnSelectedBlock inUnSelectedBlock;

@end

@implementation CBNavigationBarTitleView

#pragma 初始化
- (instancetype)initWithFrame:(CGRect)frame
                selectedBlock:(navigationBarTitleViewSelectedBlock)selectedBlock
              unSelectedBlock:(navigationBarTitleViewUnSelectedBlock)unselectedBlock{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initNavigationBarTitleButton];
        
        [self initNavigationBarTitleImageView];
        
        [self addConstraints];
        
        _inSelectedBlock = selectedBlock;
        
        _inUnSelectedBlock = unselectedBlock;
    }
    return self;
}

- (void)initNavigationBarTitleButton {
    if (!_navigationBarTitleButton) {
        _navigationBarTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_navigationBarTitleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        _navigationBarTitleButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        
        [_navigationBarTitleButton addTarget:self action:@selector(navigationBarTitleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_navigationBarTitleButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:_navigationBarTitleButton];
    }
}

- (void)initNavigationBarTitleImageView {
    if (!_navigationBarTitleImageView) {
        _navigationBarTitleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        [_navigationBarTitleImageView setImage:[UIImage imageNamed:@"lay2_btm_arr"]];
        
        [_navigationBarTitleImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:_navigationBarTitleImageView];
    }
}

- (void)navigationBarTitleButtonAction:(id)sender {
    if (!_navigationBarTitleButton.selected) {
        [UIView animateWithDuration:0.1f
                              delay:0.f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             _navigationBarTitleImageView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
                             
                             _inSelectedBlock ? _inSelectedBlock() : nil;
                         } completion:nil];
        
        [_navigationBarTitleButton setSelected:YES];
    }else {
        [UIView animateWithDuration:0.1f
                              delay:0.f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             _navigationBarTitleImageView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
                             
                             _inUnSelectedBlock ? _inUnSelectedBlock() : nil;
                         } completion:nil];
        
        [_navigationBarTitleButton setSelected:NO];
    }
}

#pragma 添加约束
- (void)addConstraints {
    NSLayoutConstraint *buttonConstraintsBottom = [NSLayoutConstraint constraintWithItem:_navigationBarTitleButton
                                                                               attribute:NSLayoutAttributeBottom
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self
                                                                               attribute:NSLayoutAttributeBottom
                                                                              multiplier:1.f
                                                                                constant:0.f];
    
    NSLayoutConstraint *buttonContraintsTop = [NSLayoutConstraint constraintWithItem:_navigationBarTitleButton
                                                                           attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeTop
                                                                          multiplier:1.f
                                                                            constant:0.f];
    
    NSLayoutConstraint *buttonContraintsCenterX = [NSLayoutConstraint constraintWithItem:_navigationBarTitleButton
                                                                               attribute:NSLayoutAttributeCenterX
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self
                                                                               attribute:NSLayoutAttributeCenterX
                                                                              multiplier:1.f
                                                                                constant:0.f];
    
    NSLayoutConstraint *imageContraintsLeft = [NSLayoutConstraint constraintWithItem:_navigationBarTitleImageView
                                                                           attribute:NSLayoutAttributeLeft
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:_navigationBarTitleButton
                                                                           attribute:NSLayoutAttributeRight
                                                                          multiplier:1.f
                                                                            constant:0.f];
    
    NSLayoutConstraint *imageContraintsCenterX = [NSLayoutConstraint constraintWithItem:_navigationBarTitleButton
                                                                              attribute:NSLayoutAttributeCenterY
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:_navigationBarTitleImageView
                                                                              attribute:NSLayoutAttributeCenterY
                                                                             multiplier:1.f
                                                                               constant:0.f];
    
    [self addConstraints:@[buttonContraintsTop,buttonConstraintsBottom,buttonContraintsCenterX,imageContraintsLeft,imageContraintsCenterX]];
}

@end

