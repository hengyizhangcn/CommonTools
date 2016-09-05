//
//  CTBaseViewController.h
//  Pods
//
//  Created by zhy on 9/5/16.
//  Copyright © 2016 OCT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTBaseTableView.h"
#import "CTNavigationBar.h"

@interface CTBaseViewController : UIViewController

@property (nonatomic, assign) BOOL forbiddenPanBack;

@property (nonatomic, strong) CTBaseTableView *tableView;

@property (nonatomic, strong) CTNavigationBar *navigationBar;

@property (nonatomic, strong) UIView *statusBar;

- (void)backBtnControlEventAction;

- (BOOL)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (BOOL)popViewControllerAnimated:(BOOL)animated;
@end
