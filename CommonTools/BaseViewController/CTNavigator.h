//
//  CTNavigator.h
//  Pods
//
//  Created by zhy on 9/5/16.
//  Copyright © 2016 OCT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTNavigator : NSObject

@property (nonatomic, strong) UINavigationController *rootNavigationController;

@property (nonatomic, strong) UINavigationController *currentNavigationController;

+ (instancetype)getInstance;

- (void)pushViewController:(UIViewController *)viewController parameters:(NSDictionary *)dict animated:(BOOL)animated;

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (UIViewController *)popViewController:(UIViewController *)UIViewController animated:(BOOL)animated;


- (BOOL)presentNavigationViewController:(UIViewController *)viewController parameters:(NSDictionary *)dict animated:(BOOL)animated completion:(void (^)(void))completion;

//- (BOOL)presentNavigationViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

- (BOOL)presentNavigationViewController:(UIViewController *)viewController parameters:(NSDictionary *)dict animated:(BOOL)animated completion:(void (^)(void))completion gaussEffect:(BOOL)gaussEffect;

//- (BOOL)presentNavigationViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion gaussEffect:(BOOL)gaussEffect;

- (BOOL)dismissViewController:(BOOL)animated completion:(void (^)(void))completion;
@end

@interface UIViewController (validateParameter)
/**
 *  用于控制器验证参数，可用于传参
 *  @param dict 数据源
 *  @return 验证结果
 */
- (BOOL)validateParameter:(NSDictionary *)dict;
@end

@interface UINavigationController (KMNavigator)

@property (nonatomic, strong, readonly) UIViewController *topVisibleViewController;
@end