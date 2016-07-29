//
//  CBImageBrowser.h
//  CBImagePicker
//
//  Created by 陈超邦 on 2016/7/24.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

#define WEAK_OBJ(o) autoreleasepool{} __weak typeof(o) o##Weak = o;

#define STRONG_OBJ(o) autoreleasepool{} __strong typeof(o) o##Strong = o;

#define PAN_RELEASE_DISTANCE 150.f

@class CBImageBrowser;

@protocol CBImageBrowserDelegate <NSObject>

@optional

/**
 *  当前显示页面页码回调
 *
 *  @param browser 浏览器实例对象
 *  @param index   页码
 */
- (void)imageBrowser:(CBImageBrowser *)browser index:(NSInteger)index;

@end

@interface CBImageBrowser : UIView

/**
 *  浏览器代理
 */
@property(nonatomic, weak, readwrite) id <CBImageBrowserDelegate> imageBrowserDelegate;

/**
 *  数据数组
 */
@property (nonatomic, strong, readwrite) NSMutableArray *assetArrays;

/**
 *  初始化方法
 *
 *  @param assetArrays 数据数组
 *
 *  @return 实例化对象
 */
- (instancetype)initWithAssetArrays:(NSArray *)assetArrays;

/**
 *  浏览器弹出方法
 *
 *  @param fromView    源视图
 *  @param toContainer 包含视图
 *  @param animated    动画效果
 *  @param completion  回调
 */
- (void)presentFromImageView:(UIView *)fromView
                 toContainer:(UIView *)toContainer
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion;

@end
