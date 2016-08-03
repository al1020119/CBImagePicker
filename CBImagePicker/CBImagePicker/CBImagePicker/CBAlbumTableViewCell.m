//
//  CBAlbumTableViewCell.m
//  CBImagePicker
//
//  Created by 陈超邦 on 16/6/12.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import "CBAlbumTableViewCell.h"

@interface CBAlbumTableViewCell()

@property (nonatomic, strong, readwrite) UIImageView *cellImageView;

@property (nonatomic, strong, readwrite) UILabel     *cellGroupNameLabel;

@property (nonatomic, strong, readwrite) UILabel     *cellGroupPicNumberLabel;

@end

@implementation CBAlbumTableViewCell

#pragma - init.
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCellImageView];
        
        [self initCellGroupNameLabel];
        
        [self initCellGroupPicNumberLabel];
    }
    return self;
}

- (void)initCellImageView {
    if (!_cellImageView) {
        _cellImageView = [[UIImageView alloc] init];
        
        _cellImageView.frame = CGRectMake(8.f, 5.f, TABLEVIEW_CELL_SIZE + 5.f, TABLEVIEW_CELL_SIZE);
        
        _cellImageView.clipsToBounds = YES;
        
        _cellImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        _cellImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        _cellImageView.backgroundColor = [UIColor blackColor];
    }
    [self addSubview:_cellImageView];
}

- (void)initCellGroupNameLabel {
    if (!_cellGroupNameLabel) {
        _cellGroupNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_cellImageView.frame.origin.x + _cellImageView.frame.size.width + 10.f, 5.f, self.contentView.frame.size.width - (_cellImageView.frame.origin.x + _cellImageView.frame.size.width + 10.f) - 20.f, _cellImageView.frame.size.height / 2)];
        
        _cellGroupNameLabel.textAlignment = NSTextAlignmentLeft;
        
        _cellGroupNameLabel.font = [UIFont systemFontOfSize:12.f];
    }
    [self addSubview:_cellGroupNameLabel];
}

- (void)initCellGroupPicNumberLabel {
    if (!_cellGroupPicNumberLabel) {
        _cellGroupPicNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(_cellImageView.frame.origin.x + _cellImageView.frame.size.width + 10.f, 5.f + _cellGroupNameLabel.frame.size.height, self.contentView.frame.size.width - (_cellImageView.frame.origin.x + _cellImageView.frame.size.width + 10.f) - 20.f, _cellImageView.frame.size.height / 2)];
        
        _cellGroupPicNumberLabel.textAlignment = NSTextAlignmentLeft;
        
        _cellGroupPicNumberLabel.textColor = [UIColor darkGrayColor];
        
        _cellGroupPicNumberLabel.font = [UIFont systemFontOfSize:12.f];
    }
    [self addSubview:_cellGroupPicNumberLabel];
}

#pragma - cell data loader.
- (void)figureCellData:(PHAssetCollection *)collection {
    _cellGroupNameLabel.text = collection.localizedTitle;
    
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    
    _cellGroupPicNumberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)fetchResult.count];
    
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];

    [imageManager requestImageForAsset:fetchResult[0]
                            targetSize:PHImageManagerMaximumSize
                           contentMode:PHImageContentModeAspectFill
                               options:nil
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             if (result) {
                                 [_cellImageView setImage:result];
                             }
                         }];
}

#pragma 选择Action
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
