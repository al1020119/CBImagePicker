//
//  CBImageBrowser.h
//  CBImagePicker
//
//  Created by 陈超邦 on 2016/7/24.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "UIView+CBAddition.h"
#import "CBImageModel.h"
#import "CBImageScrollViewCell.h"
#import "CBImageScrollView.h"

#define WEAK_OBJ(o) autoreleasepool{} __weak typeof(o) o##Weak = o;

#define STRONG_OBJ(o) autoreleasepool{} __strong typeof(o) o##Strong = o;

#define PAN_RELEASE_DISTANCE 150.f

#define CELL_PADDING 10.f

@class CBImageBrowser;

@protocol CBImageBrowserDelegate <NSObject>

@optional

/**
 *  The page index delegate.
 *
 *  @param browser browser instance.
 *  @param index   page index.
 */
- (void)imageBrowser:(CBImageBrowser *)browser index:(NSInteger)index;

@end

@interface CBImageBrowser : UIView

/**
 *  Browser delegate.
 */
@property (nonatomic, weak, readwrite  ) id <CBImageBrowserDelegate> imageBrowserDelegate;

/**
 *  Assets Arrays.
 */
@property (nonatomic, strong, readwrite) NSMutableArray         *assetArrays;

/**
 *  Instanceype mathod.
 *
 *  @param assetArray dataArray.
 *
 *  @return instance.
 */
- (instancetype)initWithAssetArrays:(NSArray *)assetArrays;

/**
 *  Present the browser.
 *
 *  @param fromView    the fromeView.
 *  @param toContainer the view which will contain the browser.
 *  @param animated    animated bool.
 *  @param completion  completion block.
 */
- (void)presentFromImageView:(UIView *)fromView
                 toContainer:(UIView *)toContainer
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion;

@end
