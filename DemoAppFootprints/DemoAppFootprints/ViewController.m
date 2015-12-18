//
//  ViewController.m
//  DemoAppFootprints
//
//  Created by changtang on 15/12/18.
//  Copyright © 2015年 Tencent House. All rights reserved.
//

#import "ViewController.h"

#import "QHAppFootprints.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)printFootprints:(id)sender
{
    NSString *footprints = [QHAppFootprints info];
    [UIPasteboard generalPasteboard].string = footprints;
    NSLog(@"%@", footprints);
}

@end
