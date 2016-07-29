//
//  CBAlbumTableView.m
//  CBImagePicker
//
//  Created by 陈超邦 on 16/6/12.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import "CBAlbumTableView.h"
#import "CBAlbumTableViewCell.h"

@interface CBAlbumTableView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong, readwrite) albumTableViewSelectedBlock inSelectedBlock;

@end

@implementation CBAlbumTableView

#pragma 初始化
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

#pragma TableView代理
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
    
    if (indexPath.row <= _assetsGroupArray.count - 1) {
        [cell figureCellData:_assetsGroupArray[indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _inSelectedBlock ? _inSelectedBlock(indexPath.row) : nil;
}

@end
