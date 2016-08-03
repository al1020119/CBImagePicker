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
 *  The assets group array.
 */
@property (nonatomic, strong, readwrite) NSMutableArray *assetsGroupArray;

/**
 *  The instancetype method,
 *
 *  @param frame         the frame of obeject.
 *  @param selectedBlock the seleted block 
 *
 *  @return instance.
 */
- (instancetype)initWithFrame:(CGRect)frame
                selectedBlock:(albumTableViewSelectedBlock)selectedBlock;

@end
