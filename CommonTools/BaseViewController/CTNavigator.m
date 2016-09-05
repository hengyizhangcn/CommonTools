//
//  CTNavigator.m
//  Pods
//
//  Created by zhy on 9/5/16.
//  Copyright © 2016 OCT. All rights reserved.
//

#import "CTNavigator.h"

@interface CTNavigator ()

@property (nonatomic, strong) NSMutableArray *navigationControllerPool;
@end

@implementation CTNavigator

+ (instancetype)getInstance
{
    static dispatch_once_t predict;
    static CTNavigator *instance;
    dispatch_once(&predict, ^{
        instance = [[self alloc] init];
        instance.navigationControllerPool = [[NSMutableArray alloc] init];
    });
    return instance;
}

- (void)pushViewController:(UIViewController *)viewController parameters:(NSDictionary *)dict animated:(BOOL)animated
{
    if ([viewController validateParameter:dict]) {
        [self pushViewController:viewController animated:animated];
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (!self.rootNavigationController) {
        self.rootNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        return;
    }
    UINavigationController *nav = [self.navigationControllerPool lastObject];
    [nav pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (!self.navigationControllerPool.count) {
        return nil;
    }
    UINavigationController *nav = [self.navigationControllerPool lastObject];
    return [nav popViewControllerAnimated:animated];
}

- (BOOL)presentNavigationViewController:(UIViewController *)viewController parameters:(NSDictionary *)dict animated:(BOOL)animated completion:(void (^)(void))completion
{
    return [self presentNavigationViewController:viewController parameters:dict animated:animated completion:completion gaussEffect:NO];
}

- (BOOL)presentNavigationViewController:(UIViewController *)viewController parameters:(NSDictionary *)dict animated:(BOOL)animated completion:(void (^)(void))completion gaussEffect:(BOOL)gaussEffect
{
    if ([viewController validateParameter:dict]) {
        return [self presentNavigationViewController:viewController animated:animated completion:completion gaussEffect:gaussEffect];
    }
    return NO;
}

- (BOOL)presentNavigationViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    return [self presentNavigationViewController:viewController animated:animated completion:completion gaussEffect:NO];
}

- (BOOL)presentNavigationViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion gaussEffect:(BOOL)gaussEffect
{
    if (!self.navigationControllerPool.count) {
        return NO;
    }
    UINavigationController *nav = self.navigationControllerPool.lastObject;
    UINavigationController *presentNavController;
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        presentNavController = (UINavigationController *)viewController;
    } else {
        presentNavController = [[UINavigationController alloc] initWithRootViewController:viewController];
    }
    if (gaussEffect) {
        presentNavController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    [nav.topVisibleViewController presentViewController:presentNavController animated:animated completion:completion];
    [self.navigationControllerPool addObject:presentNavController];
    return YES;
}

- (BOOL)dismissViewController:(BOOL)animated completion:(void (^)(void))completion
{
    if (self.navigationControllerPool.count < 2) {
        return NO;
    }
    UINavigationController *nav = self.navigationControllerPool.lastObject;
    UIViewController *presentVC = nav.topVisibleViewController;
    [self.navigationControllerPool removeObject:nav];
    [presentVC dismissViewControllerAnimated:animated completion:completion];
    return YES;
}

- (void)setRootNavigationController:(UINavigationController *)rootNavigationController
{
    _rootNavigationController = rootNavigationController;
    
    [_navigationControllerPool removeAllObjects];
    [_navigationControllerPool addObject:_rootNavigationController];
}

- (UINavigationController *)currentNavigationController
{
    return self.navigationControllerPool.lastObject;
}
@end

@implementation UIViewController (validateParameter)

- (BOOL)validateParameter:(NSDictionary *)dict
{
    return YES;
}

@end

@implementation UINavigationController (KMNavigator)

- (UIViewController *)topVisibleViewController
{
    UIViewController *visibleViewController = self.visibleViewController;
    while (visibleViewController.presentedViewController) {
        visibleViewController = visibleViewController.presentedViewController;
    }
    return visibleViewController;
}

@end