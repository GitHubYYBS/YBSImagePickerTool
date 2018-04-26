//
//  UIButton+YBSBlock.m
//  TableViewCDemo
//
//  Created by Jason on 6/1/16.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "UIButton+YBSBlock.h"
#import <objc/runtime.h>
static const int block_key;
@interface YBStarget : NSObject
@property (nonatomic,copy)void (^block)(id sender);
@end

@implementation YBStarget
- (void)dealloc
{
    NSLog(@"buttonTarget释放");
}

- (instancetype)initWithBlock:(void(^)(id sender))block
{
    if (self = [super init]) {
        self.block = [block copy];
    }
    return self;
}
- (void)buttonAction:(id)sender
{
    if (self.block) {
        self.block(sender);
    }
}

@end

@implementation UIButton (YBSBlock)
- (void)addActionBlock:(void (^)(id))block forControlEvents:(UIControlEvents )event
{
    if (!block) {
        return;
    }
    [self addtargetBlock:block forControlEvents:event];
    
}
- (void)addtargetBlock:(void(^)(id))block forControlEvents:(UIControlEvents )event
{
    YBStarget *target = [[YBStarget alloc] initWithBlock:block];
    NSMutableArray *targets = [self _YBS_allBlockTargets];
    [targets addObject:target];
    [self addTarget:target action:@selector(buttonAction:) forControlEvents:event];
}

- (NSMutableArray *)_YBS_allBlockTargets
{
    NSMutableArray *targets = objc_getAssociatedObject(self, &block_key);
    if (!targets) {
        targets = [NSMutableArray array];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

@end
