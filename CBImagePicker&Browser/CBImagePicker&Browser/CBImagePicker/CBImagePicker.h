//
//  CBImagePicker.h
//  CBImagePicker
//
//  Created by 陈超邦 on 16/6/10.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

#define COLLECTION_CELL_SIZE_HEIGHT ([UIScreen mainScreen].bounds.size.width - 10) / 4

#define POPUPMENU_HEIGHT 100.f

#define SELECTED_NUM_LIMIT 10

#define WEAK_OBJ(o) autoreleasepool{} __weak typeof(o) o##Weak = o;

#define STRONG_OBJ(o) autoreleasepool{} __strong typeof(o) o##Strong = o;

@class CBImagePicker;

@protocol CBImagePickerDelegate <NSObject>

@optional

/**
 *  成功获取图片信息代理
 *
 *  @param picker     CBImagePicker
 *  @param imageArray 存储所选择图片信息的数组
 */
- (void)imagePicker:(CBImagePicker *)picker didFinishPickingMediaWithImageArray:(NSArray *)imageArray;

/**
 *  取消选择图片代理
 *
 *  @param picker CBImagePicker
 */
- (void)imagePickerDidCancel:(CBImagePicker *)picker;

@end

@interface CBImagePicker : UIViewController

/**
 *  代理
 */
@property(nonatomic, weak, readonly) id <CBImagePickerDelegate> imagePickerDelegate;

@end
