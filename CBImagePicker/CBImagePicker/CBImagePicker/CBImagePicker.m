//
//  CBImagePicker.m
//  CBImagePicker
//
//  Created by 陈超邦 on 16/6/10.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import "CBImagePicker.h"

@interface CBImagePicker ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong, readwrite) NSMutableArray           *assetsGroupArray;

@property (nonatomic, strong, readwrite) NSMutableDictionary      *assetsDic;

@property (nonatomic, strong, readwrite) NSMutableDictionary      *cellDic;

@property (nonatomic, strong, readwrite) NSMutableArray           *seletedImageArray;

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

@property (nonatomic, strong, readwrite) UICollectionReusableView *collectionHeardView;

@end

@implementation CBImagePicker

#pragma - setter and getter

- (CGFloat)collectionCellWidthCompareToScreen {
    if (!_collectionCellWidthCompareToScreen) {
        return 4;
    }else {
        return _collectionCellWidthCompareToScreen;
    }
}

- (void)setNavigationBarColor:(UIColor *)navigationBarColor {
    _navigationBarColor = navigationBarColor;
    
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    
    _navigationBarTitleView.titleColor = titleColor;
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    
    _navigationBarTitleView.indicatorColor = indicatorColor;
}

- (void)setNavigationItemTitleColor:(UIColor *)navigationItemTitleColor {
    _navigationItemTitleColor = navigationItemTitleColor;
    
    NSMutableDictionary *itemStyleDic = [[NSMutableDictionary alloc] init];

    itemStyleDic[NSFontAttributeName] = [UIFont systemFontOfSize:13.f];
    
    itemStyleDic[NSForegroundColorAttributeName] = _navigationItemTitleColor;
    
    [_commitItem setTitleTextAttributes:itemStyleDic forState:UIControlStateNormal];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    
    _imageCollectionView.backgroundColor = backgroundColor;
    
    self.view.backgroundColor = backgroundColor;
}

#pragma - view init.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _assetsDic = [[NSMutableDictionary alloc] init];
    
    _assetsGroupArray = [[NSMutableArray alloc] init];
    
    _seletedImageArray = [[NSMutableArray alloc] init];
    
    _cellDic = [[NSMutableDictionary alloc] init];
    
    self.view.backgroundColor = _backgroundColor ? _backgroundColor : [UIColor whiteColor];
    
    if (_navigationBarColor) {
        self.navigationController.navigationBar.barTintColor = _navigationBarColor;
    }
    
    [self judgeIfHavePhotoAblumAuthority];
    
    [self initImageCollectionView];
    
    [self initNavigationButton];
    
    [self initCBHorizontalScrollView];
    
    [self initAlbumTableView];
    
    [self initAuthorizationStatusDeniedView];
    
    [self initNavigationBarTitleView];
}


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
        
        _horizontalScrollView = [[CBHorizontalScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.sizeWidth, 2 * ([UIScreen mainScreen].bounds.size.width - 10) / self.collectionCellWidthCompareToScreen)];
        _horizontalScrollView.backgroundColor = [UIColor clearColor];
    }
}

- (void)initNavigationBarTitleView {
    if (!_navigationBarTitleView) {
        _navigationBarTitleView = [[CBNavigationBarTitleView alloc] initWithFrame:CGRectMake(0, 0, 120.f, self.navigationController.navigationBar.bounds.size.height) selectedBlock:^{
            [self showAssetsTableViewWithAnimated:YES directionUp:NO];
        } unSelectedBlock:^{
            [self showAssetsTableViewWithAnimated:YES directionUp:YES];
        }];
        
        if (_indicatorColor) {
            _navigationBarTitleView.indicatorColor = _indicatorColor;
        }
        
        if (_titleColor) {
            _navigationBarTitleView.titleColor = _titleColor;
        }
        
        self.navigationItem.titleView = _navigationBarTitleView;
        
        if (_assetsGroupArray.count) {
            [_navigationBarTitleView.navigationBarTitleButton setTitle:NSLocalizedString([_assetsGroupArray[0] localizedTitle], nil) forState:UIControlStateNormal];
        }else {
            [_navigationBarTitleView.navigationBarTitleButton setTitle:NSLocalizedString(@"All Photos", nil) forState:UIControlStateNormal];
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
    
    itemStyleDic[NSForegroundColorAttributeName] = _navigationItemTitleColor ? _navigationItemTitleColor : [UIColor blackColor];
    
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
        
        _albumTableView = [[CBAlbumTableView alloc] initWithFrame:CGRectMake(4, -ablunTableViewHeight , [UIScreen mainScreen].bounds.size.width - 8, ablunTableViewHeight) selectedBlock:^(long index) {
            if (_currentAssetsIndex != index) {
                _currentAssetsIndex = index;
                
                [self initAssetArray];
                
                [_navigationBarTitleView navigationBarTitleButtonAction:nil];
                
                [_cellDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    CBAssetsViewCell *cell = (CBAssetsViewCell *)obj;
                    
                    cell.seletedStaus = @NO;
                }];
                
                _commitItem.title = @"确认选择";
                
                _commitItem.enabled = NO;
                
                [_seletedImageArray removeAllObjects];
                
                if (_imageCollectionView.originUp == 0) {
                    [_horizontalScrollView removeAllCells];

                    [self moveCollectionWithAnimationUp:YES];
                }
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
    
    [layout setHeaderReferenceSize:CGSizeMake(self.view.sizeWidth, 2 * (([UIScreen mainScreen].bounds.size.width - 10) / self.collectionCellWidthCompareToScreen))];
    
    _imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -2 * (([UIScreen mainScreen].bounds.size.width - 10) / self.collectionCellWidthCompareToScreen), self.view.sizeWidth, self.view.sizeHeight + 2 * (([UIScreen mainScreen].bounds.size.width - 10) / self.collectionCellWidthCompareToScreen)) collectionViewLayout:layout];
    
    _imageCollectionView.contentSize = CGSizeMake(0, self.view.sizeHeight + 2 * (([UIScreen mainScreen].bounds.size.width - 10) / self.collectionCellWidthCompareToScreen));
    
    [_imageCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    
    [_imageCollectionView registerClass:[CBAssetsViewCell class] forCellWithReuseIdentifier:@"CBAssetsViewCell"];
    
    _imageCollectionView.backgroundColor = self.view.backgroundColor;
    
    _imageCollectionView.alwaysBounceVertical = YES;
    
    _imageCollectionView.delegate = self;
    
    _imageCollectionView.dataSource = self;
    
    _imageCollectionView.showsHorizontalScrollIndicator = YES;
    
    [self.view addSubview:_imageCollectionView];
}

#pragma - authorization judgement.
- (void)judgeIfHavePhotoAblumAuthority {
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
                _commitItem.title = nil;
                
                _commitItem.enabled = NO;
            }
        }];
    }else {
        [self initALAssetsLibrary];
    }
}

#pragma - Photo Library.
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
    
    _albumTableView.assetsGroupArray = _assetsGroupArray;
    
    [_albumTableView reloadData];
}

- (void)initAssetArray {
    [_assetsDic removeAllObjects];
    
    _currentFetchResult = [PHAsset fetchAssetsInAssetCollection:_assetsGroupArray[_currentAssetsIndex] options:nil];
    
    [_imageCollectionView reloadData];
}

#pragma Action
- (void)viewTapAction:(id)sender {
    [_navigationBarTitleView navigationBarTitleButtonAction:nil];
}

- (void)commit:(id)sender {
    if ([self.imagePickerDelegate respondsToSelector:@selector(imagePicker:didFinishPickingMediaWithImageArray:)]) {
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

#pragma CollectionView delegate.
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    [_cellDic removeAllObjects];

    if (_assetsGroupArray.count) {
        [_navigationBarTitleView.navigationBarTitleButton setTitle:NSLocalizedString([_assetsGroupArray[_currentAssetsIndex] localizedTitle], nil) forState:UIControlStateNormal];
    }
    
    return _currentFetchResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CBAssetsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CBAssetsViewCell" forIndexPath:indexPath];
    
    CBAssetsModel *assetsModel;
    
    if (_assetsDic.count < _currentFetchResult.count) {
        assetsModel = [[CBAssetsModel alloc] init];
        
        @autoreleasepool {
            [_imageManager requestImageForAsset:_currentFetchResult[indexPath.row]
                                     targetSize:CGSizeMake(200, 200)
                                    contentMode:PHImageContentModeAspectFill
                                        options:nil
                                  resultHandler:^(UIImage *result, NSDictionary *info) {
                                      if (result) {
                                          assetsModel.image = result;
                                          
                                          assetsModel.selectedStaus = @NO;
                                          
                                          [_assetsDic setObject:assetsModel forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                                          
                                          [_cellDic setObject:cell forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                                          
                                          [cell configureWithModel:assetsModel];
                                      }
                                  }];
        }
        
    }else {
        assetsModel = (CBAssetsModel *)[_assetsDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        
        [_cellDic setObject:cell forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        
        [cell configureWithModel:assetsModel];
    }
    
    [cell buttonSelectBlock:^(NSNumber *seletedStaus) {
        
        assetsModel.selectedStaus = seletedStaus;
        
        assetsModel.index = indexPath.row;
        
        assetsModel.imageAsset = _currentFetchResult[indexPath.row];
        
        if ([assetsModel.selectedStaus isEqual:@YES]) {
            
            [_seletedImageArray addObject:assetsModel];
            
            if (_seletedImageArray.count == 1) {
                [self moveCollectionWithAnimationUp:NO];
            }
            
            _commitItem.enabled = YES;
            
        }else {
            [_seletedImageArray removeObject:assetsModel];
            
            if (!_seletedImageArray.count) {
                [self moveCollectionWithAnimationUp:YES];
                
                _commitItem.title = @"确认选择";
                
                _commitItem.enabled = NO;
            }
        }
        _commitItem.title = [NSString stringWithFormat:@"确认选择(%lu)",_seletedImageArray.count];
        
        @autoreleasepool {
            _horizontalScrollView.imageModel = assetsModel;
        }
        
        [_assetsDic setObject:assetsModel forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((([UIScreen mainScreen].bounds.size.width - 10) / self.collectionCellWidthCompareToScreen), (([UIScreen mainScreen].bounds.size.width - 10) / self.collectionCellWidthCompareToScreen));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *collectionHeardView;
    
    if (kind == UICollectionElementKindSectionHeader){
        collectionHeardView = (UICollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
        
        collectionHeardView.backgroundColor = [UIColor clearColor];
        
        [collectionHeardView addSubview:_horizontalScrollView];
    }
     return collectionHeardView;
}

#pragma - show with animation.
- (void)moveCollectionWithAnimationUp:(BOOL)animationUp {
    if (animationUp) {
        _horizontalScrollView.originLeft = self.view.sizeWidth;
    }
    
    [UIView animateWithDuration:0.3f
                          delay:0.f
         usingSpringWithDamping:1.f
          initialSpringVelocity:25.f
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
                            if (animationUp) {
                                _imageCollectionView.originUp = -2 * (([UIScreen mainScreen].bounds.size.width - 10) / self.collectionCellWidthCompareToScreen);
                                
                                _imageCollectionView.sizeHeight += 2 * (([UIScreen mainScreen].bounds.size.width - 10) / self.collectionCellWidthCompareToScreen);
                                
                                [_imageCollectionView setContentOffset:CGPointMake(0, -self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height) animated:YES];
                            }else {
                                _imageCollectionView.originUp = 0;
                                
                                _imageCollectionView.sizeHeight -= 2 * (([UIScreen mainScreen].bounds.size.width - 10) / self.collectionCellWidthCompareToScreen);
                                
                                _horizontalScrollView.originLeft = 0;
                                
                                [_imageCollectionView setContentOffset:CGPointMake(0, -self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height) animated:YES];
                            }
    } completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
