//
//  CBHorizontalScrollView.h
//  CBImagePicker
//
//  Created by 陈超邦 on 2016/7/27.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "CBAssetsModel.h"

#define HORZONTAL_IMAGE_CELL_SIZE CGSizeMake(0.75 * self.sizeWidth, self.sizeHeight - 10.f)

@interface CBHorizontalScrollView : UIScrollView

@property (nonatomic, strong, readwrite) CBAssetsModel *imageModel;

- (void)removeAllCells;

@end
