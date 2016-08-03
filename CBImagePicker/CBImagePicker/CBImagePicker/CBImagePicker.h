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

#define SELECTED_NUM_LIMIT 10

#define WEAK_OBJ(o) autoreleasepool{} __weak typeof(o) o##Weak = o;

#define STRONG_OBJ(o) autoreleasepool{} __strong typeof(o) o##Strong = o;

@class CBImagePicker;

@protocol CBImagePickerDelegate <NSObject>

@optional

/**
 *  Image array delete,return a image array which contain all image you seleted.
 *
 *  @param picker     image picker instance.
 *  @param imageArray image array.
 */
- (void)imagePicker:(CBImagePicker *)picker didFinishPickingMediaWithImageArray:(NSArray *)imageArray;

/**
 *  The cancel picker delegate.
 *
 *  @param image picker instance.
 */
- (void)imagePickerDidCancel:(CBImagePicker *)picker;

@end

@interface CBImagePicker : UIViewController

/**
 *  Image picker delegate instance.
 */
@property(nonatomic, weak, readonly) id <CBImagePickerDelegate> imagePickerDelegate;

@end
