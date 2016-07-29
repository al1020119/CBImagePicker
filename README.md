![](http://ww4.sinaimg.cn/large/006tNc79gw1f6b1ffnpk2j305m06o3z1.jpg)
![](http://ww1.sinaimg.cn/large/006tNc79gw1f6b1feqm83j305n06ojrt.jpg)
![](http://ww4.sinaimg.cn/large/006tNc79gw1f6b1fe2jtjj305m06o0ta.jpg)

# CBImagePicker&Browser

创意来自dribbble

## Installation

1. Move CBCategory folder、CBImageBrowser folder and CBImagePicker folder into your project.
2. <u>#import "CBImageBrowser.h"</u> and <u>#import "CBImagePicker.h"</u> 
3. There you go!

## Basic Usage

- **Present**

```
CBImagePicker *imagePicker = [[CBImagePicker alloc] init];

UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:imagePicker];

[self presentViewController:nav animated:YES completion:nil];
```

- **Push**

```
CBImagePicker *imagePicker = [[CBImagePicker alloc] init];

[self.navigationController pushViewController:imagePicker animated:YES];
```

## Some Delegate Methods

- **Rrturn a seleted images array.**

```
- (void)imagePicker:(CBImagePicker *)picker didFinishPickingMediaWithImageArray:(NSArray *)imageArray;
```

- **Cancel the image picker.**

```
- (void)imagePickerDidCancel:(CBImagePicker *)picker;
```

### Other

```
Nothing else, enjoy!
```
