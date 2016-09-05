//
//  CTNavigationBar.m
//  Pods
//
//  Created by zhy on 9/5/16.
//  Copyright © 2016 OCT. All rights reserved.
//

#import "CTNavigationBar.h"
#import "UIView+shortCut.h"

@interface CTNavigationBar ()

@property (nonatomic, strong) UIView *line;
@end

@implementation CTNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.backgroundColor = [UIColor whiteColor];
    _line = [[UIView alloc] init];
    _line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_line];
    _line.frame = CGRectMake(0, self.viewHeight - 0.5, self.viewWidth, 0.5);
}

- (void)hideLine
{
    _line.hidden = YES;
}

- (void)showLine
{
    _line.hidden = NO;
}

- (void)setLeftBarItem:(UIView *)leftBarItem
{
    if (_leftBarItem) {
        [_leftBarItem removeFromSuperview];
    }
    _leftBarItem = leftBarItem;
    _leftBarItem.centerY = self.viewHeight/2;
    [self addSubview:_leftBarItem];
}

- (void)setRightBarItem:(UIView *)rightBarItem
{
    if (_rightBarItem) {
        [_rightBarItem removeFromSuperview];
    }
    _rightBarItem = rightBarItem;
    _rightBarItem.centerY = self.viewHeight/2;
    [self addSubview:_rightBarItem];
}

- (void)setTitleView:(UIView *)titleView
{
    if (_titleView) {
        [_titleView removeFromSuperview];
    }
    _titleView = titleView;
    _titleView.center = self.viewCenter;
    [self addSubview:_titleView];
}
@end
