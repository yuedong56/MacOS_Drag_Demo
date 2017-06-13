//
//  MyView.m
//  MacOS_Drag_Demo
//
//  Created by yuedongkui on 2017/6/12.
//  Copyright © 2017年 LY. All rights reserved.
//

#import "MyView.h"

@interface MyView ()
{
    BOOL canDrag;
}
@end


@implementation MyView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self)
    {
        //接收拖拽事件, NSFilenamesPboardType：文件  NSStringPboardType：文本
        [self registerForDraggedTypes:@[NSStringPboardType, NSFilenamesPboardType]];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle alloc] init];
    [textStyle setAlignment:NSTextAlignmentCenter];
    [textStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    
    
    NSDictionary *attributes = @{NSFontAttributeName: [NSFont systemFontOfSize:18],
                                 NSForegroundColorAttributeName: [NSColor whiteColor],
                                 NSParagraphStyleAttributeName: textStyle};
    
    
    float w = self.frame.size.width;
    float h = self.frame.size.height;
    float str_h = 20;
    
    [@"拖入到灰色区域" drawInRect:NSMakeRect(0, (h-str_h)/2, w, str_h) withAttributes:attributes];
}

#pragma mark - Drap

//拖拽进入该视图时调用（一次），判断拖拽类型
- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    NSLog(@"%s", __FUNCTION__);

    NSPasteboard *pb = [sender draggingPasteboard];
    NSArray *types = [pb types];
    if ([types containsObject:NSFilenamesPboardType])
    {//若是文件
        NSArray *allFileUrls = [pb propertyListForType:NSFilenamesPboardType];
        NSArray *array = [allFileUrls filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension.lowercaseString IN %@", @[@"mp3"]]];
        if (array.count > 0) {
            canDrag = YES;
            return NSDragOperationCopy;
        }
    }
    else if ([types containsObject:NSStringPboardType])
    {//若是文本
        canDrag = YES;
        return NSDragOperationCopy;
    }
    return NSDragOperationNone;
}

//拖拽进入时调用（多次），用于显示拖拽的小图标
- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender
{
//    NSLog(@"%s", __FUNCTION__);
    if (canDrag) {
        return NSDragOperationCopy;
    }
    return NSDragOperationNone;
}

//松开手时调用（一次），NO图标会返回到远来位置，YES图标不会返回，表示已经接收成功
- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    if (canDrag) {
        canDrag = NO;//第二次拖拽文件前要置为NO
        return YES;
    }
    return NO;
}

//松开手时调用（一次），可用于执行收到拖拽内容后的操作
- (void)draggingEnded:(id<NSDraggingInfo>)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    NSPasteboard *pb = [sender draggingPasteboard];
    NSArray *types = [pb types];
    if ([types containsObject:NSFilenamesPboardType])
    {//若是文件
        NSArray *allFileUrls = [pb propertyListForType:NSFilenamesPboardType];
        NSLog(@"拖入的文件地址 ==== %@，接下来继续写代码...", allFileUrls);
    }
    else if ([types containsObject:NSStringPboardType])
    {//若是文本，浏览器地址栏拖拽可以打印出来
        NSArray *stringArray = [pb propertyListForType:NSStringPboardType];
        NSLog(@"拖入的文本 ==== %@，接下来继续写代码...", stringArray);
    }
}

@end
