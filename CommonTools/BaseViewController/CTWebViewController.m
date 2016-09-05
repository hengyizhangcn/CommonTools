//
//  CTWebViewController.m
//  Pods
//
//  Created by zhy on 9/5/16.
//  Copyright © 2016 OCT. All rights reserved.
//

#import "CTWebViewController.h"
#import "UIView+shortCut.h"

@interface CTWebViewController ()

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) NSString *url;

@end

@implementation CTWebViewController

- (BOOL)validateParameter:(NSDictionary *)dict
{
    if ([dict objectForKey:@"url"]) {
        self.url = [dict objectForKey:@"url"];
    } else {
        return NO;
    }
    if ([dict objectForKey:@"title"]) {
        self.title = [dict objectForKey:@"title"];
    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = self.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    if (self.title) {
        self.navigationBar.titleView = titleLabel;
    }
    
    _webView = [[UIWebView alloc] init];
    [self.view addSubview:_webView];
    _webView.frame = CGRectMake(0, 64, self.view.viewWidth, self.view.viewHeight - 64);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}
@end
