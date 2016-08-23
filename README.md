![](http://ww1.sinaimg.cn/large/006tNc79gw1f6b3upjfi4j307v0a3gmo.jpg)
![](http://ww4.sinaimg.cn/large/006tNc79gw1f6b1k1bvtrj307v0a4aaz.jpg)
![](http://ww1.sinaimg.cn/large/006tNc79gw1f6b1k9dmhhj307v0a7ab6.jpg)

# CBImagePicker&Browser



[![Build Status](https://travis-ci.org/cbangchen/CBImagePicker.svg?branch=master.png)](https://travis-ci.
org/xianlinbox/iOSCIDemo)[![MIT Licence](https://badges.frapsoft.com/os/mit/mit.svg?v=102)](https://opensource.org/licenses/mit-license.php) [![Open Source Love](https://badges.frapsoft.com/os/v2/open-source.svg?v=102)](https://github.com/ellerbrock/open-source-badge/)    

创意来自[Photo Picker Interaction](https://dribbble.com/shots/2362476-Photo-Picker-Interaction)

## Installation

1. Move CBCategory folder、CBImageBrowser folder and CBImagePicker folder into your project.
2. **#import "CBImageBrowser.h"** and **#import "CBImagePicker.h"**
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

- **Return a seleted images array.**

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
