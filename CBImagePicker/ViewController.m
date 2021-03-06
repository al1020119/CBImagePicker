//
//  ViewController.m
//  CBImagePicker
//
//  Created by 陈超邦 on 16/6/9.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import "ViewController.h"
#import "CBImagePicker.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)selectImages:(id)sender {
    CBImagePicker *imagePicker = [[CBImagePicker alloc] init];
    
    imagePicker.indicatorColor = [UIColor lightGrayColor];
        
    if ([[(UIButton *)sender titleLabel].text isEqualToString:@"Present"]) {
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:imagePicker];
        
        [self presentViewController:nav animated:YES completion:nil];
    }else {
        
        [self.navigationController pushViewController:imagePicker animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStausbarStyle {
    return UIStatusBarStyleLightContent;
}

@end
