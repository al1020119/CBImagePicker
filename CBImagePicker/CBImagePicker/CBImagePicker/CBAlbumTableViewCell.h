//
//  CBAlbumTableViewCell.h
//  CBImagePicker
//
//  Created by 陈超邦 on 16/6/12.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

#define TABLEVIEW_CELL_SIZE self.contentView.frame.size.height - 10.f

@interface CBAlbumTableViewCell : UITableViewCell

/**
 *  Load the data of cell.
 *
 *  @param collection PHAssetCollection.
 */
- (void)figureCellData:(PHAssetCollection *)collection;

@end
