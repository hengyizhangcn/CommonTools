//
//  CTBaseTableView.m
//  Pods
//
//  Created by zhy on 9/5/16.
//  Copyright © 2016 OCT. All rights reserved.
//

#import "CTBaseTableView.h"
#import "UIView+shortCut.h"

@interface CTBaseTableView ()

@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicatorView;
@end

@implementation CTBaseTableView

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

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
    self.currentPage = 1;
    self.currentSection = 0;
    self.backgroundColor = [UIColor whiteColor];
    
    self.modelArray = [[NSMutableArray alloc] init];
    
    self.tableView = [[UITableView alloc] init];//WithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight) style:UITableViewStylePlain];
    //    self.tableView.delegate = self;
    //    self.tableView.dataSource = self;
    
    self.tableView.scrollsToTop = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    self.loadingIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.loadingIndicatorView.hidden = YES;
    [self addSubview:self.loadingIndicatorView];
    self.loadingIndicatorView.frame = self.tableView.frame;
}

- (void)showLoadingIndicatorView
{
    self.tableView.hidden = YES;
    self.loadingIndicatorView.hidden = NO;
    [self.loadingIndicatorView startAnimating];
}

- (void)finishedLoadData:(NSInteger)currentPage dataSource:(NSArray *)dataSource totalPage:(NSInteger)totalPage reloadData:(BOOL)needReloadData
{
    self.loading = NO;
    
    if (currentPage == 1) {
        [self.modelArray removeAllObjects];
    }
    
    if (dataSource.count > 0 && [dataSource isKindOfClass:[NSArray class]])
    {
        [self.modelArray addObjectsFromArray:dataSource];
    }
    
    self.currentPage = currentPage;
    if (totalPage > currentPage && dataSource.count > 0) {
        _hasNextPage = YES;
    } else {
        _hasNextPage = NO;
    }
    if (needReloadData) {
        [self.tableView reloadData];
    }
    
    if (!self.modelArray.count) {
        //添加blankview
    }
    
    if (_hasNextPage) {
        self.tableView.tableFooterView = self.footerView;
    } else {
        self.tableView.tableFooterView = nil;
    }
    
    
    if (self.modelArray.count || totalPage == 1) {
        self.tableView.hidden = NO;
    }
    self.tableView.hidden = NO;
    self.loadingIndicatorView.hidden = YES;
    [self.loadingIndicatorView stopAnimating];
}

- (void)failLoadData
{
    self.loadingIndicatorView.hidden = YES;
    self.loading = NO;
    if (!self.modelArray.count) {
        //添加blankview
    }
}

- (void)viewWillAppear
{
    self.tableView.scrollsToTop = YES;
}

- (void)viewWillDisappear
{
    self.tableView.scrollsToTop = NO;
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowsCount = [self tableView:tableView numberOfRowsInSection:self.currentSection];
    
    if (self.currentSection == indexPath.section && _hasNextPage && self.modelArray.count > 0 && (indexPath.row == rowsCount - 1) && !self.loading) {
        if ([self.delegate respondsToSelector:@selector(requestNextPage)]) {
            [self.delegate requestNextPage];
        } else {
            [self requestNextPage];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (void)requestFirstPage
{}
- (void)requestNextPage
{}

- (void)dealloc
{
}

- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 44)];
        
        UIActivityIndicatorView *loadHUDIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadHUDIndicatorView.frame = CGRectMake(0, 0, 30, 30);
        loadHUDIndicatorView.center = _footerView.viewCenter;
        [_footerView addSubview:loadHUDIndicatorView];
        [loadHUDIndicatorView startAnimating];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 0.5)];
        topLine.backgroundColor = [UIColor lightGrayColor];
        topLine.alpha = 0.5;
        [_footerView addSubview:topLine];
    }
    return _footerView;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.scrollBlock) {
        self.scrollBlock();
    }
}
@end
