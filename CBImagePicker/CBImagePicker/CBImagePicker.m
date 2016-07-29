//
//  CBImagePicker.m
//  CBImagePicker
//
//  Created by 陈超邦 on 16/6/10.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import "CBImagePicker.h"
#import "CBAssetsViewCell.h"
#import "CBAlbumTableView.h"
#import "CBNavigationBarTitleView.h"
#import "CBAlbumTableView.h"
#import "UIImage+Addition.h"
#import "CBImageBrowser.h"
#import "CBImageModel.h"
#import "CBAssetsModel.h"
#import "UIView+Addition.h"
#import "CBHorizontalScrollView.h"
#import "UIView+Addition.h"

@interface CBImagePicker ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong, readwrite) NSMutableArray           *assetsGroupArray;

@property (nonatomic, strong, readwrite) NSMutableArray           *assetsArray;

@property (nonatomic, strong, readwrite) NSMutableArray           *cellArray;

@property (nonatomic, strong, readwrite) NSMutableArray           *seletedImageArray;

@property (nonatomic, assign, readwrite) NSInteger                seletedImageNum;

@property (nonatomic, assign, readwrite) NSInteger                currentAssetsIndex;

@property (nonatomic, strong, readwrite) PHImageManager           *imageManager;

@property (nonatomic, strong, readwrite) PHFetchResult            *currentFetchResult;

@property (nonatomic, strong, readwrite) UIView                   *bgView;

@property (nonatomic, strong, readwrite) UICollectionView         *imageCollectionView;

@property (nonatomic, strong, readwrite) UIImageView              *authorizationStatusDeniedView;

@property (nonatomic, strong, readwrite) UIBarButtonItem          *commitItem;

@property (nonatomic, strong, readwrite) CBAlbumTableView         *albumTableView;

@property (nonatomic, strong, readwrite) CBNavigationBarTitleView *navigationBarTitleView;

@property (nonatomic, strong, readwrite) CBHorizontalScrollView   *horizontalScrollView;

@property (nonatomic, strong, readwrite) CBImageBrowser           *imageBrowser;

@end

@implementation CBImagePicker

#pragma 视图初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _assetsArray = [[NSMutableArray alloc] init];
    
    _assetsGroupArray = [[NSMutableArray alloc] init];
    
    _seletedImageArray = [[NSMutableArray alloc] init];
    
    _cellArray = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self judgeIsHavePhotoAblumAuthority];
    
    [self initImageCollectionView];
    
    [self initAuthorizationStatusDeniedView];
    
    [self initCBHorizontalScrollView];
    
    [self initAlbumTableView];
    
    [self initNavigationButton];
    
    [self initNavigationBarTitleView];
}

#pragma 判断是否具有权限
- (void)judgeIsHavePhotoAblumAuthority {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"返回"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 _authorizationStatusDeniedView.hidden = NO;
                                                             }];
        
        UIAlertAction *setUpAction = [UIAlertAction actionWithTitle:@"前往设置"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                                 
                                                                 if([[UIApplication sharedApplication] canOpenURL:url]) {
                                                                     NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                                     
                                                                     [[UIApplication sharedApplication] openURL:url];
                                                                 }
                                                             }];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                            message:@"没有获取权限，请在设置中授予权限"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:cancelAction];
        
        [alertController addAction:setUpAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }else if(status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self initALAssetsLibrary];
            }else {
                _authorizationStatusDeniedView.hidden = NO;
            }
        }];
    }else {
        [self initALAssetsLibrary];
    }
}

#pragma 初始化
- (void)initAuthorizationStatusDeniedView {
    if (!_authorizationStatusDeniedView) {
        _authorizationStatusDeniedView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 2, self.view.frame.size.width / 2)];
        
        _authorizationStatusDeniedView.center = self.view.center;
        
        _authorizationStatusDeniedView.image = [UIImage imageNamed:@"authorization"];
        
        _authorizationStatusDeniedView.hidden = YES;
        
        [self.view addSubview:_authorizationStatusDeniedView];
    }
}

- (void)initCBHorizontalScrollView {
    if (!_horizontalScrollView) {
        _horizontalScrollView = [[CBHorizontalScrollView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height, self.view.sizeWidth, 2 * COLLECTION_CELL_SIZE_HEIGHT)];
        
        _horizontalScrollView.hidden = YES;
        
        _horizontalScrollView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_horizontalScrollView];
    }
}

- (void)initNavigationBarTitleView {
    if (!_navigationBarTitleView) {
        _navigationBarTitleView = [[CBNavigationBarTitleView alloc] initWithFrame:CGRectMake(0, 0, 120.f, self.navigationController.navigationBar.bounds.size.height) selectedBlock:^{
            [self showAssetsTableViewWithAnimated:YES directionUp:NO];
        } unSelectedBlock:^{
            [self showAssetsTableViewWithAnimated:YES directionUp:YES];
        }];
        
        self.navigationItem.titleView = _navigationBarTitleView;
        
        if (_assetsGroupArray) {
            [_navigationBarTitleView.navigationBarTitleButton setTitle:NSLocalizedString([_assetsGroupArray[0] localizedTitle], nil) forState:UIControlStateNormal];
        }
    }
}

- (void)initNavigationButton {
    _commitItem = [[UIBarButtonItem alloc] initWithTitle:@"确认选择"
                                                   style:UIBarButtonItemStylePlain
                                                  target:self
                                                  action:@selector(commit:)];
    
    NSMutableDictionary *itemStyleDic = [[NSMutableDictionary alloc] init];
    
    itemStyleDic[NSFontAttributeName] = [UIFont systemFontOfSize:13.f];
    
    itemStyleDic[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.257 green:0.609 blue:0.504 alpha:1.000];
    
    [_commitItem setTitleTextAttributes:itemStyleDic forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = _commitItem;
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(cancelAction:)];
    
    [cancelButtonItem setTitleTextAttributes:itemStyleDic forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
}

- (void)initAlbumTableView {
    if (!_albumTableView) {
        _bgView = [[UIView alloc] initWithFrame:self.view.frame];
        
        _bgView.backgroundColor = [UIColor blackColor];
        
        _bgView.alpha = 0.35f;
        
        _bgView.hidden = YES;
        
        UITapGestureRecognizer *bgViewSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction:)];
        
        bgViewSingleTap.numberOfTapsRequired = 1;
        
        [_bgView addGestureRecognizer:bgViewSingleTap];
        
        UITapGestureRecognizer *bgViewDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
        
        bgViewDoubleTap.numberOfTapsRequired = 2;
        
        [_bgView addGestureRecognizer:bgViewDoubleTap];
        
        [bgViewSingleTap requireGestureRecognizerToFail:bgViewDoubleTap];
        
        [self.view addSubview:_bgView];

        CGFloat ablunTableViewHeight = _assetsGroupArray.count > 5 ? 5 * 50.f : _assetsGroupArray.count * 50.f;
        
        _albumTableView = [[CBAlbumTableView alloc] initWithFrame:CGRectMake(4, -ablunTableViewHeight , self.view.frame.size.width - 8, ablunTableViewHeight) selectedBlock:^(long index) {
            if (_currentAssetsIndex != index) {
                _currentAssetsIndex = index;
                
                [self initAssetArray];
                
                [_navigationBarTitleView navigationBarTitleButtonAction:nil];
                
                [_navigationBarTitleView.navigationBarTitleButton setTitle:NSLocalizedString([_assetsGroupArray[_currentAssetsIndex] localizedTitle], nil) forState:UIControlStateNormal];
                
                [_cellArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    CBAssetsViewCell *cell = (CBAssetsViewCell *)obj;
                    
                    cell.seletedStaus = @NO;
                }];
                
                _commitItem.title = @"确认选择";
                
                _commitItem.enabled = NO;
                
                _seletedImageNum = 0;
                
                [_horizontalScrollView removeAllCells];
                
                [_imageCollectionView reloadData];
                
                [self moveCollectionWithAnimationUp:YES];
            }else {
                [_navigationBarTitleView navigationBarTitleButtonAction:nil];
            }
        }];
        
        _albumTableView.assetsGroupArray = _assetsGroupArray;
        
        _albumTableView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_albumTableView];
    }
}

- (void)initImageCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing = 2.0;
    
    layout.minimumInteritemSpacing = 2.0;
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];

    [_imageCollectionView registerClass:[CBAssetsViewCell class] forCellWithReuseIdentifier:@"CBAssetsViewCell"];

    _imageCollectionView.backgroundColor = [UIColor clearColor];

    _imageCollectionView.alwaysBounceVertical = YES;
    
    _imageCollectionView.delegate = self;
    
    _imageCollectionView.dataSource = self;
    
    _imageCollectionView.showsHorizontalScrollIndicator = YES;
    
    [self.view addSubview:_imageCollectionView];
}

- (void)initALAssetsLibrary {
    _imageManager = [[PHCachingImageManager alloc] init];

    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection  * _Nonnull collection, NSUInteger idx, BOOL *stop) {
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];

        if (fetchResult.count > 0) {
            [self.assetsGroupArray addObject:collection];
        }
    }];
    
    [topLevelUserCollections enumerateObjectsUsingBlock:^(PHAssetCollection  * _Nonnull collection, NSUInteger idx, BOOL *stop) {
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];

        if (fetchResult.count > 0) {
            [self.assetsGroupArray addObject:collection];
        }
    }];
    
    [self initAssetArray];
}

- (void)initAssetArray {
    [_assetsArray removeAllObjects];
    
    _currentFetchResult = [PHAsset fetchAssetsInAssetCollection:_assetsGroupArray[_currentAssetsIndex] options:nil];
    
    [_currentFetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = obj;
        
        PHImageRequestOptions *options = [PHImageRequestOptions new];
        
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        options.synchronous = YES;
        
        [_imageManager requestImageForAsset:asset
                                 targetSize:CGSizeMake(0.75 * self.view.sizeWidth, 0.75 * self.view.sizeWidth)
                                contentMode:PHImageContentModeAspectFill
                                    options:options
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  if (result) {
                                      CBAssetsModel *assetsModel = [[CBAssetsModel alloc] init];
                                      
                                      assetsModel.image = result;
                                      
                                      assetsModel.selectedStaus = @NO;
                                      
                                      [_assetsArray addObject:assetsModel];
                                  }
                              }];
    }];
}

#pragma Action
- (void)viewTapAction:(id)sender {
    [_navigationBarTitleView navigationBarTitleButtonAction:nil];
}

- (void)commit:(id)sender {
    if ([self.imagePickerDelegate respondsToSelector:@selector(imagePicker:didFinishPickingMediaWithImageArray:)]) {
        
        NSMutableArray *imageArr = [[NSMutableArray alloc] init];
        
        [_seletedImageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_imageManager requestImageForAsset:obj
                                     targetSize:PHImageManagerMaximumSize
                                    contentMode:PHImageContentModeAspectFill
                                        options:nil
                                  resultHandler:^(UIImage *result, NSDictionary *info) {
                                      if (result) {
                                          [imageArr addObject:result];
                                      }
                                      if (imageArr.count == _seletedImageArray.count) {
                                          [self.imagePickerDelegate imagePicker:self didFinishPickingMediaWithImageArray:imageArr];
                                      }
                                  }];
        }];
    }
    
    [self turnBack:nil];
}

- (void)cancelAction:(id)sender {
    if ([self.imagePickerDelegate respondsToSelector:@selector(imagePickerDidCancel:)]) {
        [self.imagePickerDelegate imagePickerDidCancel:self];
    }   
    [self turnBack:nil];
}

- (void)turnBack:(id)sender {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showAssetsTableViewWithAnimated:(BOOL)animated directionUp:(BOOL)directionUp{
    directionUp ? nil : [_bgView setHidden:NO] ;
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.3f];
  
    CGPoint point = _albumTableView.center;
    
    CGFloat moveDistance = _albumTableView.frame.size.height + self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height + 4;
    
    if (directionUp) {
        point.y -= moveDistance;
    }else {
        point.y += moveDistance;
    }
    
    [_albumTableView setCenter:point];
    
    [UIView commitAnimations];
        
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        directionUp ? [_bgView setHidden:YES] : nil;
    });
}

#pragma CollectionView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    [_cellArray removeAllObjects];

    return _currentFetchResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CBAssetsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CBAssetsViewCell" forIndexPath:indexPath];
    
    CBAssetsModel *assetsModel = (CBAssetsModel *)_assetsArray[indexPath.row];
    
    [cell configureWithModel:assetsModel];
    
    if (_cellArray.count <= _currentFetchResult.count) {
        [_cellArray addObject:cell];
    }

    [cell buttonSelectBlock:^(NSNumber *seletedStaus) {
        
        assetsModel.selectedStaus = seletedStaus;
                
        assetsModel.index = indexPath.row;
        
        if ([assetsModel.selectedStaus isEqual:@YES]) {
            
            _seletedImageNum += 1;
            
            assetsModel.imageAsset = _currentFetchResult[indexPath.row];
            
            assetsModel.image = assetsModel.image;
            
            [_seletedImageArray addObject:_currentFetchResult[indexPath.row]];
        }else {
            _seletedImageNum -= 1;
            
            [_seletedImageArray removeObject:_currentFetchResult[indexPath.row]];
        }
        _horizontalScrollView.imageModel = assetsModel;
        
        [_assetsArray replaceObjectAtIndex:indexPath.row withObject:assetsModel];
        
        if (_seletedImageNum) {
            if (_seletedImageNum == 1) {
                [self moveCollectionWithAnimationUp:NO];
            }
            
            _commitItem.enabled = YES;
            
            _commitItem.title = [NSString stringWithFormat:@"确认选择(%lu)",_seletedImageNum];
        }else {
            [self moveCollectionWithAnimationUp:YES];
            
            _commitItem.title = @"确认选择";
            
            _commitItem.enabled = NO;
        }
    }];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(COLLECTION_CELL_SIZE_HEIGHT, COLLECTION_CELL_SIZE_HEIGHT);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

#pragma 具体的动画实现
- (void)moveCollectionWithAnimationUp:(BOOL)animationUp {
    if (!animationUp) {
        _horizontalScrollView.originLeft = self.view.sizeWidth;
    }
    
    [UIView animateWithDuration:0.3f
                          delay:0.f
         usingSpringWithDamping:1.f
          initialSpringVelocity:25.f
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
                            if (animationUp) {
                                _horizontalScrollView.hidden = YES;

                                _imageCollectionView.originUp = 0;
                                
                                _imageCollectionView.size = CGSizeMake(self.view.sizeWidth, self.view.sizeHeight);
                                
                                _horizontalScrollView.originLeft = self.view.sizeWidth;
                            }else {
                                _horizontalScrollView.hidden = NO;

                                _imageCollectionView.originUp = 5 / 2 * COLLECTION_CELL_SIZE_HEIGHT;
                                
                                _imageCollectionView.size = CGSizeMake(self.view.sizeWidth, self.view.sizeHeight - _imageCollectionView.originUp);
                                
                                _horizontalScrollView.originLeft = 0;
                            }
    } completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
