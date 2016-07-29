//
//  CBAssetsViewCell.m
//  CBImagePicker
//
//  Created by 陈超邦 on 16/6/12.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import "CBAssetsViewCell.h"

typedef void(^CBAssetsViewCellSelecteBlock)(NSNumber *seletedStaus);

@interface CBAssetsViewCell()

@property (nonatomic, strong, readwrite) UIButton                     *selectButton;

@property (nonatomic, strong, readwrite) CBAssetsViewCellSelecteBlock selectBlock;

@end

@implementation CBAssetsViewCell

#pragma init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initAssetsImageView];
        
        [self initSelectButton];
        
        [self addConstraints];
    }
    return self;
}

- (void)initAssetsImageView {
    if (!_assetsImageView) {
        _assetsImageView = [[UIView alloc] initWithFrame:CGRectZero];
        
        _assetsImageView.clipsToBounds = YES;
        
        _assetsImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [_assetsImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:_assetsImageView];
    }
}

- (void)initSelectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _selectButton.clipsToBounds = YES;
                
        [_selectButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_selectButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:_selectButton];
    }
}

- (void)configureWithModel:(CBAssetsModel *)mdoel {
    self.assetsImageView.layer.contents = (__bridge id _Nullable)mdoel.image.CGImage;
    
    self.seletedStaus = mdoel.selectedStaus;
}

#pragma Action
- (void)setSeletedStaus:(NSNumber *)seletedStaus {
    if ([seletedStaus boolValue]) {
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"Highlight"] forState:UIControlStateSelected];
        
        [_selectButton setSelected:YES];
        
        [UIView animateWithDuration:0.2 animations:^{
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.2 animations:^{
                _selectButton.transform = CGAffineTransformMakeScale(0.9, 0.9);
                
                _assetsImageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
            }];
        }];
    }else {
        [_selectButton setBackgroundImage:nil forState:UIControlStateNormal];
        
        [_selectButton setSelected:NO];
        
        [UIView animateWithDuration:0.2 animations:^{
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.2 animations:^{
                _selectButton.transform = CGAffineTransformMakeScale(1, 1);
                
                _assetsImageView.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }];
    }
}

- (void)selectAction:(id)sender {
    if (_selectButton.selected) {
        self.seletedStaus = @NO;
        
        _selectBlock(@NO);
    }else {
        self.seletedStaus = @YES;
        
        _selectBlock(@YES);
    }
}

- (void)buttonSelectBlock:(void (^)(NSNumber *seletedStaus))selectBlock {
    _selectBlock = selectBlock;
}

#pragma Constraints
- (void)addConstraints {
    NSLayoutConstraint *imageConstraintsBottom = [NSLayoutConstraint constraintWithItem:_assetsImageView
                                                                              attribute:NSLayoutAttributeBottom
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self
                                                                              attribute:NSLayoutAttributeBottom
                                                                             multiplier:1.f
                                                                               constant:0.f];
    
    NSLayoutConstraint *imageContraintsTop = [NSLayoutConstraint constraintWithItem:_assetsImageView
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1.f
                                                                           constant:0.f];
    
    NSLayoutConstraint *imageContraintsRight = [NSLayoutConstraint constraintWithItem:_assetsImageView
                                                                            attribute:NSLayoutAttributeRight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self
                                                                            attribute:NSLayoutAttributeRight
                                                                           multiplier:1.f
                                                                             constant:0.f];
    
    NSLayoutConstraint *imageContraintsLeft = [NSLayoutConstraint constraintWithItem:_assetsImageView
                                                                           attribute:NSLayoutAttributeLeft
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeLeft
                                                                          multiplier:1.f
                                                                            constant:0.f];
    
    NSLayoutConstraint *selectButtonConstraitRight = [NSLayoutConstraint constraintWithItem:_selectButton
                                                                                  attribute:NSLayoutAttributeRight
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:self
                                                                                  attribute:NSLayoutAttributeRight
                                                                                 multiplier:1.f
                                                                                   constant:0.f];
    
    NSLayoutConstraint *selectButtonConstraitTop = [NSLayoutConstraint constraintWithItem:_selectButton
                                                                                attribute:NSLayoutAttributeTop
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self
                                                                                attribute:NSLayoutAttributeTop
                                                                               multiplier:1.f
                                                                                 constant:0.f];
    
    NSLayoutConstraint *selectButtonConstraitWidthAndHeight = [NSLayoutConstraint constraintWithItem:_selectButton
                                                                                           attribute:NSLayoutAttributeWidth
                                                                                           relatedBy:NSLayoutRelationEqual
                                                                                              toItem:_selectButton
                                                                                           attribute:NSLayoutAttributeHeight
                                                                                          multiplier:1.f
                                                                                            constant:0.f];
    
    NSLayoutConstraint *selectButtonConstraitHeightOrWidth = [NSLayoutConstraint constraintWithItem:_selectButton
                                                                                          attribute:NSLayoutAttributeWidth
                                                                                          relatedBy:NSLayoutRelationEqual
                                                                                             toItem:_assetsImageView
                                                                                          attribute:NSLayoutAttributeHeight
                                                                                         multiplier:1.f
                                                                                           constant:0.f];
    
    [self addConstraints:@[imageConstraintsBottom,imageContraintsTop,imageContraintsRight,imageContraintsLeft,selectButtonConstraitRight,selectButtonConstraitTop,selectButtonConstraitWidthAndHeight,selectButtonConstraitHeightOrWidth]];
}

@end

