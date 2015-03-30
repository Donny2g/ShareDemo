//
//  BaiduAuthorizeViewController.m
//  Baidu SDK
//
//  Created by xiawh on 12-9-25.
//  Copyright (c) 2012年 Baidu. All rights reserved.
//
#import "BaiduAuthorizeViewController.h"
#import "BaiduUtility.h"
#import "BaiduMacroDef.h"
#import "BaiduConfig.h"
#import "BaiduError.h"
#import "BaiduUserSessionManager.h"
#import <QuartzCore/QuartzCore.h>

#define BAIDU_AUTH_LOADING_VIEW_TAG         101
#define BAIDU_AUTH_WEB_VIEW_TAG             102

#define BAIDU_AUTH_STATUS_BAR_HEIGHT        20
#define BAIDU_AUTH_NAVIGATION_BAR_HEIGHT    45

@interface BaiduAuthorizeViewController()

- (NSURL *)oauthRequestURLWithScope:(NSString *)scope;

@end

@implementation BaiduAuthorizeViewController
@synthesize scope = _scope;
@synthesize delegate = _delegate;
@synthesize targetController = _targetController;
@synthesize isShowRegisterPage = _isShowRegisterPage;

- (id)init
{
    self = [super init];
    if (self) {
        self.isShowRegisterPage = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    // Custom initialization
    [super loadView];
    CGFloat startY = 0.0f;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        startY = BAIDU_AUTH_STATUS_BAR_HEIGHT;
    }
    
    startY = 0;
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] init];
    navigationBar.frame = CGRectMake(0, startY, self.view.bounds.size.width, BAIDU_AUTH_NAVIGATION_BAR_HEIGHT);
    [navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setBackgroundColor:[UIColor whiteColor]];
    navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"百度帐号"];
    navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close)] autorelease];
    navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)] autorelease];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem release];
    
    [self.view addSubview:navigationBar];
    [navigationBar release];
    
    UIWebView *authWeb = [[UIWebView alloc] init];
    authWeb.frame = CGRectMake(0, startY + BAIDU_AUTH_NAVIGATION_BAR_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - (startY + BAIDU_AUTH_NAVIGATION_BAR_HEIGHT));
    authWeb.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    authWeb.tag = BAIDU_AUTH_WEB_VIEW_TAG;
    [self.view addSubview:authWeb];
    [authWeb release];
    
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor blackColor];
    indicatorView.bounds = CGRectMake(0, 0, 100, 100);
    indicatorView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    indicatorView.tag = BAIDU_AUTH_LOADING_VIEW_TAG;
    indicatorView.layer.cornerRadius = 8;
    indicatorView.layer.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7].CGColor;
    [self.view addSubview:indicatorView];
    
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = CGPointMake(50, 40);
    [indicatorView addSubview:activityView];
    [activityView release];
    [activityView startAnimating];
    
    UILabel *loadingLable = [[UILabel alloc] initWithFrame:CGRectMake(0,60,100,30)];
    loadingLable.text = [NSString stringWithFormat:@"加载中"];
    loadingLable.backgroundColor = [UIColor clearColor];
    loadingLable.textColor = [UIColor whiteColor];
    loadingLable.textAlignment = NSTextAlignmentCenter;
    [indicatorView addSubview:loadingLable];
    [loadingLable release];
    [indicatorView release];
    
    indicatorView.hidden = YES;
    
    NSURL *url = [self oauthRequestURLWithScope:self.scope];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 10;
    [authWeb loadRequest:request];
    authWeb.delegate = self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UIWebViewDelegate Method

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    BDLog(@"auth url:%@",[url absoluteString]);
    NSString *query = [url fragment]; // url中＃字符后面的部分。
    if (!query) {
        query = [url query];
    }
    NSDictionary *params = [BaiduUtility parseURLParams:query];
    NSString *errorReason = [params objectForKey:@"error"];
    NSString *q = [url absoluteString];
    if( errorReason != nil && [q hasPrefix:BDAUTHORIZE_REDIRECTURI]) {
    
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(loginFailedWithError:)]) {
            BaiduError *error = [BaiduError errorWithOAuthResult:params];
            [self.delegate loginFailedWithError:error];
        }
        [self performSelector:@selector(close)];

        return NO;
    }
    
    NSString *accessToken = [params objectForKey:@"access_token"];
    if (nil != accessToken) {
        [[BaiduUserSessionManager shareUserSessionManager].currentUserSession saveUserSessionInfo:params];
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(loginDidSuccess)]) {
            [self.delegate loginDidSuccess];
        }
        [self performSelector:@selector(close)];
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    UIView *indicatorView = [[webView superview] viewWithTag:BAIDU_AUTH_LOADING_VIEW_TAG];
    indicatorView.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSURL *url = webView.request.URL;
    if ([[url absoluteString] hasPrefix:@"http://wappass.baidu.com/passport/reg"] && self.isShowRegisterPage) {
        NSString *javascript = @"var traget=document.getElementById(\"goBack\");traget.style.display=\"none\"";
        [webView stringByEvaluatingJavaScriptFromString:javascript];
    }
    
    UIView *indicatorView = [[webView superview] viewWithTag:BAIDU_AUTH_LOADING_VIEW_TAG];
    indicatorView.hidden = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (( [error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102)
        || ( [error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == NSURLErrorCancelled )) {
        return;
    }
    
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(loginFailedWithError:)]) {
        [self.delegate loginFailedWithError:error];
        [self close];
    }
}

- (NSURL *)oauthRequestURLWithScope:(NSString *)scope
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[BaiduConfig shareConfig].apiKey,@"client_id",
                                   scope,@"scope",
                                   BDAUTHORIZE_REDIRECTURI,@"redirect_uri",
                                   @"token",@"response_type",
                                   @"mobile",@"display",nil];
    
    NSLog(@"%@",params.description);
    
    NSURL *loadUrl = nil;
    if (!self.isShowRegisterPage) {
        loadUrl = [BaiduUtility generateURL:BDAUTHORIZE_HOSTURL params:params];
    } else {
        NSURL *authUrl = [BaiduUtility generateURL:BDAUTHORIZE_REGAUTHURL params:params];
        NSString *authUrlStr = [authUrl absoluteString];
        
        loadUrl = [BaiduUtility generateURL:BDAUTHORIZE_REGSTERURL params:[NSDictionary dictionaryWithObjectsAndKeys:authUrlStr,@"u",@"smarttv",@"adapter", nil]];
    }
    
    return loadUrl;
}

- (void)close
{
    if ([NSClassFromString(@"UIViewController") instancesRespondToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:YES completion:^{
            //nothing
        }];
    } else if ([NSClassFromString(@"UIViewController") instancesRespondToSelector:@selector(dismissModalViewControllerAnimated:)]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)refresh
{
    UIWebView *authWeb = (UIWebView *)[self.view viewWithTag:BAIDU_AUTH_WEB_VIEW_TAG];
    [authWeb reload];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc
{
    self.scope = nil;
    [super dealloc];
}
@end


