//
//  CTBaseViewController.m
//  Pods
//
//  Created by zhy on 9/5/16.
//  Copyright © 2016 OCT. All rights reserved.
//

#import "CTBaseViewController.h"
#import "YAPanBackController.h"
#import "CTNavigator.h"
#import "UIView+shortCut.h"

@interface CTBaseViewController ()

@property (nonatomic, strong) YAPanBackController *panBackController;
@end

@implementation CTBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationBar.hidden = NO;
    self.statusBar.hidden = NO;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = @"未命名";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationBar.titleView = titleLabel;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backBtn setImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnControlEventAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.leftBarItem = backBtn;
    
    _panBackController = [[YAPanBackController alloc] initWithCurrentViewController:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)backBtnControlEventAction
{
    [[CTNavigator getInstance] popViewController:self animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.forbiddenPanBack) {
        [_panBackController addPanBackToView:self.view];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (!self.forbiddenPanBack) {
        [_panBackController removePanBackFromView:self.view];
    }
}

- (BOOL)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[CTNavigator getInstance] pushViewController:viewController parameters:nil animated:animated];
    return YES;
}

- (BOOL)popViewControllerAnimated:(BOOL)animated
{
    [[CTNavigator getInstance] popViewController:self animated:animated];
    return YES;
}
#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowsCount = [self tableView:tableView numberOfRowsInSection:self.tableView.currentSection];
    
    if (self.tableView.currentSection == indexPath.section && self.tableView.hasNextPage && self.tableView.modelArray.count > 0 && (indexPath.row == rowsCount - 1) && !self.tableView.loading) {
        if ([self.tableView.delegate respondsToSelector:@selector(requestNextPage)]) {
            [self.tableView.delegate requestNextPage];
        } else {
            [self.tableView requestNextPage];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

#pragma mark - AccessMethods
- (CTNavigationBar *)navigationBar
{
    if (!_navigationBar) {
        _navigationBar = [[CTNavigationBar alloc] initWithFrame:CGRectMake(0, 20, self.view.viewWidth, 44)];
        [self.view addSubview:_navigationBar];
    }
    return _navigationBar;
}

- (UIView *)statusBar
{
    if (!_statusBar) {
        _statusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.viewWidth, 20)];
        [self.view addSubview:_statusBar];
        _statusBar.backgroundColor = [UIColor whiteColor];
    }
    return _statusBar;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end
