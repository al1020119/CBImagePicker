![](http://ww1.sinaimg.cn/large/006tNc79gw1f6b1cxb5o2j30aq0crwhc.jpg)
![](http://ww1.sinaimg.cn/large/006tNc79gw1f6b1cvec90j30ar0cq0v7.jpg)
![](http://ww1.sinaimg.cn/large/006tNc79gw1f6b1ctwck3j30an0co41g.jpg)

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
