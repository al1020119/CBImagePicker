//
//  UIImage+Addition.m
//  CBImagePicker
//
//  Created by 陈超邦 on 2016/7/24.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import "UIImage+Addition.h"

@implementation UIImage (Addition)

#pragma Getter
- (CGFloat)sizeWidth {
    return self.size.width;
}

- (CGFloat)sizeHeight {
    return self.size.height;
}

#pragma Setter
- (void)setSizeWidth:(CGFloat)sizeWidth {
    if (!isnan(sizeWidth)) {
        self.size = CGSizeMake(sizeWidth, self.sizeHeight);
    }
}

- (void)setSizeHeight:(CGFloat)sizeHeight {
    if (!isnan(sizeHeight)) {
        self.size = CGSizeMake(self.sizeWidth, sizeHeight);
    }
}

- (void)setSize:(CGSize)size {
    self.size = CGSizeMake(size.width, size.height);
}

@end
