//
//  CBNavigationBarTitleView.m
//  CBImagePicker
//
//  Created by 陈超邦 on 16/6/12.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import "CBNavigationBarTitleView.h"
#import "CBImagePicker.h"

#import "Masonry.h"

@interface CBNavigationBarTitleView()

@property(nonatomic, strong, readwrite) navigationBarTitleViewSelectedBlock inSelectedBlock;

@property(nonatomic, strong, readwrite) navigationBarTitleViewUnSelectedBlock inUnSelectedBlock;

@end

@implementation CBNavigationBarTitleView

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    
    [_navigationBarTitleButton setTitleColor:_titleColor forState:UIControlStateNormal];
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    
    _navigationBarTitleImageView.tintColor = indicatorColor;
}

#pragma - init.
- (instancetype)initWithFrame:(CGRect)frame
                selectedBlock:(navigationBarTitleViewSelectedBlock)selectedBlock
              unSelectedBlock:(navigationBarTitleViewUnSelectedBlock)unselectedBlock{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initNavigationBarTitleButton];
        
        [self initNavigationBarTitleImageView];
        
        _inSelectedBlock = selectedBlock;
        
        _inUnSelectedBlock = unselectedBlock;
    }
    return self;
}

- (void)initNavigationBarTitleButton {
    if (!_navigationBarTitleButton) {
        _navigationBarTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (_titleColor) {
            [_navigationBarTitleButton setTitleColor:_titleColor forState:UIControlStateNormal];
        }else {
            [_navigationBarTitleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        _navigationBarTitleButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        
        [_navigationBarTitleButton addTarget:self action:@selector(navigationBarTitleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_navigationBarTitleButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:_navigationBarTitleButton];
        
        [_navigationBarTitleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.and.top.equalTo(self);
            
            make.centerX.equalTo(self);
        }];
    }
}

- (void)initNavigationBarTitleImageView {
    if (!_navigationBarTitleImageView) {
        _navigationBarTitleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        [_navigationBarTitleImageView setImage:[[UIImage imageNamed:@"pullButton_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        
        if (_indicatorColor) {
            _navigationBarTitleImageView.tintColor  = _indicatorColor;
        }
        
        [_navigationBarTitleImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:_navigationBarTitleImageView];
        
        [_navigationBarTitleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_navigationBarTitleButton.mas_right).offset(5.f);
            
            make.right.equalTo(_navigationBarTitleButton.mas_right).offset(17.f);
            
            make.centerY.equalTo(_navigationBarTitleButton);
            
            make.height.equalTo(_navigationBarTitleButton).multipliedBy(0.28f);
        }];
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

@end

