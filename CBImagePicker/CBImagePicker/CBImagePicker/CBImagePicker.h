//
//  CBImagePicker.h
//  CBImagePicker
//
//  Created by 陈超邦 on 16/6/10.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "CBAssetsViewCell.h"
#import "CBAlbumTableView.h"
#import "CBNavigationBarTitleView.h"
#import "CBAlbumTableView.h"
#import "UIImage+CBAddition.h"
#import "CBImageBrowser.h"
#import "CBImageModel.h"
#import "CBAssetsModel.h"
#import "UIView+CBAddition.h"
#import "CBHorizontalScrollView.h"
#import "UIView+CBAddition.h"

#define COLLECTION_CELL_SIZE_HEIGHT ([UIScreen mainScreen].bounds.size.width - 10) / 4

#define POPUPMENU_HEIGHT 100.f

#define WEAK_OBJ(o) autoreleasepool{} __weak typeof(o) o##Weak = o;

#define STRONG_OBJ(o) autoreleasepool{} __strong typeof(o) o##Strong = o;

@class CBImagePicker;

@protocol CBImagePickerDelegate <NSObject>

@optional

/**
 *  Image array delete,return a image array which contain all image you wanna select.
 *
 *  @param picker     image picker instance.
 *  @param imageArray image array.
 */
- (void)imagePicker:(CBImagePicker *)picker didFinishPickingMediaWithImageArray:(NSArray *)imageArray;

/**
 *  The cancel action delegate.
 *
 *  @param imagePicker instance.
 */
- (void)imagePickerDidCancel:(CBImagePicker *)picker;

@end

@interface CBImagePicker : UIViewController

/**
 *  Default value is 4.
 *  Width or height of the collection's cells compared to the width of the mainScreen.
 *  You can change it by adding this line of code "imagePicker.collectionCellWidthCompareToScreen = 3;",and if the value of this property was set to 3, the width and height of the collection's cells will be changed to 1 / 3 of the width of the mainScreen as well.
 */
@property (nonatomic, assign, readwrite) CGFloat collectionCellWidthCompareToScreen;

/**
 *  Color of the navigationBar.
 */
@property (nonatomic, strong, readwrite) UIColor *navigationBarColor;

/**
 *  The color of indicator;
 */
@property (nonatomic, assign, readwrite) UIColor *indicatorColor;

/**
 *  The color of title.
 */
@property (nonatomic, strong, readwrite) UIColor  *titleColor;

/**
 *  Color of the picker's backgroundView.
 */
@property (nonatomic, strong, readwrite) UIColor *backgroundColor;

/**
 *  Color of the navigatioItem's title.
 */
@property (nonatomic, strong, readwrite) UIColor *navigationItemTitleColor;

/**
 *  ImagePicker delegate instance.
 */
@property(nonatomic, weak, readwrite) id <CBImagePickerDelegate> imagePickerDelegate;

@end
