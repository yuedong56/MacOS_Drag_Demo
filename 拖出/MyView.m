//
//  MyView.m
//  MacOS_Drag_Demo
//
//  Created by yuedongkui on 2017/6/12.
//  Copyright © 2017年 LY. All rights reserved.
//


#import "MyView.h"

@interface MyView ()<NSPasteboardItemDataProvider, NSDraggingSource>
{
    NSImage *_image;
}
@end




@implementation MyView

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _image = [NSImage imageNamed:@"abc.png"];
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
    
    [@"可拖拽区域" drawInRect:NSMakeRect(0, (h-str_h)/2, w, str_h) withAttributes:attributes];
    
    if (_image)
    {
        [_image drawInRect:NSMakeRect(0, 0, _image.size.width, _image.size.height)
                  fromRect:NSZeroRect
                 operation:NSCompositingOperationSourceOver
                  fraction:1.0];
    }
    
// 我们把可以拖拽的视图(view)或窗口(window)称为 拖放源(Drag Sources),接收拖放的视图或窗口称为 拖放目标(Drag Destination)。
// 拖放开始时会出现代表拖放源Drag Sources的图标顺着鼠标轨迹运动,直到拖放目标Drag Destination 接收了这个拖放请求，就完成了一次成功的拖放。如果拖放目标不能响应这个拖放请求，代表拖放源Drag Sources的图标会以动画形式弹回到拖放源以前的位置。
// 拖放源和拖放目标之间数据交换是通过使用系统的剪贴板(NSPasteboard)保存数据来完成的。

}

//是否必须是活动窗口才能拖拽，YES非活动窗口也能拖拽，NO必须是活动窗口才能拖拽
- (BOOL)acceptsFirstMouse:(NSEvent *)event
{
     return YES;
}

// 用户鼠标点击 NSView/NSWindow 触发 mouseDown: 事件, 调用 beginDraggingSessionWithItems 方法
// 开始建立一个拖放的session, 开始启动拖放过程。
- (void)mouseDown:(NSEvent*)event
{
    /* 使用 NSPasteboardItem 定义拖放携带的基本数据信息 */
    NSPasteboardItem *pbItem = [[NSPasteboardItem alloc] init];
    
    /* 设置代理，定义哪些类型拖拽的时候会执行 NSPasteboardItemDataProvider 的代理方法 */
    [pbItem setDataProvider:self forTypes:@[NSFilenamesPboardType, NSPasteboardTypeString]];

    /* 用 NSDraggingItem 包装 NSPasteboardItem */
    NSDraggingItem *dragItem = [[NSDraggingItem alloc] initWithPasteboardWriter:pbItem];
    
    /* 拖放可视化定义, 定义拖放过程中的跟随鼠标移动的图像 */
    [dragItem setDraggingFrame:NSMakeRect(0, 0, _image.size.width, _image.size.height)
                      contents:_image];
    
    /* 建立一个拖放的 session */
    NSDraggingSession *draggingSession = [self beginDraggingSessionWithItems:@[dragItem] event:event source:self];
    
    /* 拖拽失败后是否返回动画，YES有动画，NO无动画 */
    draggingSession.animatesToStartingPositionsOnCancelOrFail = YES;
//    draggingSession.draggingFormation = NSDraggingFormationNone;
}

#pragma mark - NSDraggingSource
//设置接收拖拽的目的地的图标样式
- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context
{
    switch (context)
    {
        case NSDraggingContextOutsideApplication://app外
            return NSDragOperationCopy;
        case NSDraggingContextWithinApplication://app内
            return NSDragOperationNone;
        default://其余情况
            return NSDragOperationNone;
            break;
    }
}

#pragma mark -- NSPasteboardItemDataProvider

- (void)pasteboard:(nullable NSPasteboard *)pasteboard item:(NSPasteboardItem *)item provideDataForType:(NSString *)type
{
    if ([type compare:NSPasteboardTypeString] == NSOrderedSame)
    {
        [pasteboard setString:@"hello world！" forType:NSPasteboardTypeString];
    }
    else if ([type compare:NSFilenamesPboardType] == NSOrderedSame)
    {
        [pasteboard setData:[NSData dataWithContentsOfFile:@"/Users/yuedongkui/Desktop/aaa.gif"] forType:NSFilenamesPboardType];
//        [pasteboard setPropertyList:@[] forType:NSFilenamesPboardType];//多文件时
    }
}

@end
