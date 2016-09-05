//
//  UIView+shortCut.m
//  Pods
//
//  Created by zhy on 9/5/16.
//  Copyright © 2016 OCT. All rights reserved.
//

#import "UIView+shortCut.h"

@implementation UIView (shortCut)

- (void)setTop:(CGFloat)top
{
    CGRect rect = self.frame;
    rect.origin.y = top;
    self.frame = rect;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setLeft:(CGFloat)left
{
    CGRect rect = self.frame;
    rect.origin.x = left;
    self.frame = rect;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect rect = self.frame;
    rect.origin.y = bottom - rect.size.height;
    self.frame = rect;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setRight:(CGFloat)right
{
    CGRect rect = self.frame;
    rect.origin.x = right - rect.size.width;
    self.frame = rect;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setViewWidth:(CGFloat)viewWidth
{
    CGRect rect = self.frame;
    rect.size.width = viewWidth;
    self.frame = rect;
}

- (CGFloat)viewWidth
{
    return self.frame.size.width;
}

- (void)setViewHeight:(CGFloat)viewHeight
{
    CGRect rect = self.frame;
    rect.size.height = viewHeight;
    self.frame = rect;
}

- (CGFloat)viewHeight
{
    return self.frame.size.height;
}

- (void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (CGPoint)viewCenter
{
    return CGPointMake(self.viewWidth/2, self.viewHeight/2);
}
@end
