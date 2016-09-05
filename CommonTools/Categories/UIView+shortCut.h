//
//  UIView+shortCut.h
//  Pods
//
//  Created by zhy on 9/5/16.
//  Copyright © 2016 OCT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (shortCut)

@property (nonatomic, assign) CGFloat top;

@property (nonatomic, assign) CGFloat left;

@property (nonatomic, assign) CGFloat bottom;

@property (nonatomic, assign) CGFloat right;

@property (nonatomic, assign) CGFloat viewWidth;

@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, assign) CGFloat centerX;

@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, readonly) CGPoint viewCenter;
@end
