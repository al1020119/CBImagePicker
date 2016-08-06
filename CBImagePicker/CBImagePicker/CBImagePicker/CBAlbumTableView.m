//
//  CBAlbumTableView.m
//  CBImagePicker
//
//  Created by 陈超邦 on 16/6/12.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import "CBAlbumTableView.h"
#import "CBAlbumTableViewCell.h"
#import "UIView+CBAddition.h"

@interface CBAlbumTableView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong, readwrite) albumTableViewSelectedBlock inSelectedBlock;

@end

@implementation CBAlbumTableView

#pragma - init.
- (instancetype)initWithFrame:(CGRect)frame
                selectedBlock:(albumTableViewSelectedBlock)selectedBlock {
    self = [super initWithFrame:frame];
    if (self) {
        _assetsGroupArray = [[NSMutableArray alloc] init];
        
        self.clipsToBounds = YES;
                
        self.delegate = self;
        
        self.dataSource = self;
        
        _inSelectedBlock = selectedBlock;
    }
    return self;
}

- (void)setAssetsGroupArray:(NSMutableArray *)assetsGroupArray {
    _assetsGroupArray = assetsGroupArray;
    
    CGFloat ablunTableViewHeight = _assetsGroupArray.count > 5 ? 5 * 50.f : _assetsGroupArray.count * 50.f;
    
    self.frame = CGRectMake(4, -ablunTableViewHeight , [UIScreen mainScreen].bounds.size.width - 8, ablunTableViewHeight);
}

#pragma - TableView delegate.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _assetsGroupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CBAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CBAlbumTableViewCell"];
    
    if (cell == nil) {
        cell = [[CBAlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CBAlbumTableViewCell"];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    
    [cell figureCellData:_assetsGroupArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _inSelectedBlock ? _inSelectedBlock(indexPath.row) : nil;
}

@end
