//
//  UIView+Utility.m
//  OneAppEveryDay
//
//  Created by ShotaTakai on 2015/05/27.
//  Copyright (c) 2015年 ShotaTakai. All rights reserved.
//

#import "UIView+Utility.h"

@implementation UIView(Utility)
- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setX:(CGFloat)x
{
    CGRect rect = self.frame;
    rect.origin.x = x;
    [self setFrame:rect];
}

- (void)setY:(CGFloat)y
{
    CGRect rect = self.frame;
    rect.origin.y = y;
    [self setFrame:rect];
}

- (void)setWidth:(CGFloat)width
{
    CGRect rect = self.frame;
    rect.size.width = width;
    [self setFrame:rect];
}

- (void)setHeight:(CGFloat)height
{
    CGRect rect = self.frame;
    rect.size.height = height;
    [self setFrame:rect];
}
@end
