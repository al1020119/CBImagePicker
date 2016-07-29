//
//  CBAlbumTableView.h
//  CBImagePicker
//
//  Created by 陈超邦 on 16/6/12.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^albumTableViewSelectedBlock)(long index);

@interface CBAlbumTableView : UITableView

/**
 *  图片数组
 */
@property (nonatomic, strong, readwrite) NSMutableArray *assetsGroupArray;

/**
 *  初始化方法
 *
 *  @param frame         frame
 *  @param selectedBlock 选择回调
 *
 *  @return 实例化对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                selectedBlock:(albumTableViewSelectedBlock)selectedBlock;

@end
