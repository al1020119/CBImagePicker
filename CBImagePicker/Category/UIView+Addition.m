//
//  UIView+Addition.m
//  CBImagePicker
//
//  Created by 陈超邦 on 2016/7/24.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import "UIView+Addition.h"

@implementation UIView (Addition)

#pragma Getter
- (CGFloat)originLeft {
    return self.frame.origin.x;
}

- (CGFloat)originUp {
    return self.frame.origin.y;
}

- (CGFloat)originRight {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)originDown {
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)sizeWidth {
    return self.frame.size.width;
}

- (CGFloat)sizeHeight {
    return self.frame.size.height;
}

- (CGSize)size {
    return self.frame.size;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (CGFloat)centerY {
    return self.center.y;
}

#pragma Setter
- (void)setOriginLeft:(CGFloat)originLeft {
    if (!isnan(originLeft)) {
        self.frame = CGRectMake(originLeft, self.originUp, self.sizeWidth, self.sizeHeight);
    }
}

- (void)setOriginUp:(CGFloat)originUp {
    if (!isnan(originUp)) {
        self.frame = CGRectMake(self.originLeft, originUp, self.sizeWidth, self.sizeHeight);
    }
}

- (void)setOriginRight:(CGFloat)originRight {
    if (!isnan(originRight)) {
        self.frame = CGRectMake(originRight - self.sizeWidth, self.originUp, self.sizeWidth, self.sizeHeight);
    }
}

- (void)setOriginDown:(CGFloat)originDown {
    if (!isnan(originDown)) {
        self.frame = CGRectMake(self.originLeft, originDown - self.sizeHeight, self.sizeWidth, self.sizeHeight);
    }
}

- (void)setSizeWidth:(CGFloat)sizeWidth {
    if (!isnan(sizeWidth)) {
        self.frame = CGRectMake(self.originLeft, self.originUp, sizeWidth, self.sizeHeight);
    }
}

- (void)setSizeHeight:(CGFloat)sizeHeight {
    if (!isnan(sizeHeight)) {
        self.frame = CGRectMake(self.originLeft, self.originUp, self.sizeWidth, sizeHeight);
    }
}

- (void)setSize:(CGSize)size {
    if (!isnan(size.height)) {
        self.frame = CGRectMake(self.originLeft, self.originUp, size.width, size.height);
    }
}

- (void)setOrigin:(CGPoint)origin {
    if (!isnan(origin.x)) {
        self.frame = CGRectMake(origin.x, origin.y, self.sizeWidth, self.sizeHeight);
    }
}

- (void)setCenterX:(CGFloat)centerX {
    if (!isnan(centerX)) {
        self.center = CGPointMake(centerX, self.center.y);
    }
}

- (void)setCenterY:(CGFloat)centerY {
    if (!isnan(centerY)) {
        self.center = CGPointMake(self.center.x, centerY);
    }
}

- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


@end
