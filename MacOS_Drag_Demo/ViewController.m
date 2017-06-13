//
//  ViewController.m
//  MacOS_Drag_Demo
//
//  Created by yuedongkui on 2017/6/12.
//  Copyright © 2017年 LY. All rights reserved.
//

#import "ViewController.h"
#import "MyView.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    MyView *view = [[MyView alloc] initWithFrame:NSMakeRect(60, 60, self.view.frame.size.width-120, self.view.frame.size.height-120)];
    view.wantsLayer = YES;
    view.layer.backgroundColor = [[NSColor lightGrayColor] CGColor];
    [self.view addSubview:view];
}

@end
