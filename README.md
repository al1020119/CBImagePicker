![](http://ww1.sinaimg.cn/large/006tNc79gw1f6b1k9dmhhj307v0a7ab6.jpg)
![](http://ww4.sinaimg.cn/large/006tNc79gw1f6b1k1bvtrj307v0a4aaz.jpg)
![](http://ww1.sinaimg.cn/large/006tNc79gw1f6b1k9dmhhj307v0a7ab6.jpg)

# CBImagePicker&Browser

创意来自[Photo Picker Interaction](https://dribbble.com/shots/2362476-Photo-Picker-Interaction)

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
