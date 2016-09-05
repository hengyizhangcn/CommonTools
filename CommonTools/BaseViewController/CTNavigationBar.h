//
//  CTNavigationBar.h
//  Pods
//
//  Created by zhy on 9/5/16.
//  Copyright © 2016 OCT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTNavigationBar : UIView

@property (nonatomic, strong) UIView *leftBarItem;

@property (nonatomic, strong) UIView *rightBarItem;

@property (nonatomic, strong) UIView *titleView;

- (void)hideLine;
- (void)showLine;
@end
