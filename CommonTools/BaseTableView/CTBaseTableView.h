//
//  CTBaseTableView.h
//  Pods
//
//  Created by zhy on 9/5/16.
//  Copyright © 2016 OCT. All rights reserved.
//


#import <UIKit/UIKit.h>
//#import "UIScrollView+GifPullToRefresh.h"

@protocol CTBaseTableViewDelegate <NSObject>

@optional
- (void)requestFirstPage;
- (void)requestNextPage;

@end

@interface CTBaseTableView : UIView// <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, strong) UIImageView *blankIV;
@property (nonatomic, assign) NSInteger currentSection;

@property (nonatomic, assign) BOOL loading;

@property (nonatomic, assign) BOOL hasNextPage;
/**
 *  存放每页的数据源
 */
@property (nonatomic, strong) NSMutableArray *modelArray;

@property (nonatomic, weak) id<CTBaseTableViewDelegate> delegate;

@property (nonatomic, strong) NSString *keyword;

@property (nonatomic, copy) void (^scrollBlock)();
//子类需要调用如下两个方法
- (void)finishedLoadData:(NSInteger)currentPage dataSource:(NSArray *)dataSource totalPage:(NSInteger)totalPage reloadData:(BOOL)needReloadData;

- (void)failLoadData;


- (void)viewWillAppear;

- (void)viewWillDisappear;


- (void)requestFirstPage;
- (void)requestNextPage;

- (void)showLoadingIndicatorView;
@end
