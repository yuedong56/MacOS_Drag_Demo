//
//  ViewController.m
//  拖出
//
//  Created by yuedongkui on 2017/6/12.
//  Copyright © 2017年 LY. All rights reserved.
//

#import "ViewController.h"
#import "MyView.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    MyView *view = [[MyView alloc] initWithFrame:NSMakeRect(80, 80, self.view.frame.size.width-160, self.view.frame.size.height-160)];
    view.wantsLayer = YES;
    view.layer.backgroundColor = [[NSColor lightGrayColor] CGColor];
    [self.view addSubview:view];
}

@end
