//
//  ViewController.m
//  WebkitDemp
//
//  Created by wangqianzhou on 13-8-3.
//  Copyright (c) 2013年 uc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <WebKit/WebKit.h>
#import <objc/message.h>
#import <NetworkExtension/NetworkExtension.h>
#import "ViewController.h"
#import "CustomButton.h"
#import "UIView+Addtions.h"
#import "URLViewController.h"

const CGFloat TOP_BAR_HEIGHT = 60.0;

@interface ViewController ()<WKNavigationDelegate,
                            WKUIDelegate,
                            WKScriptMessageHandler,
                            UIViewControllerPreviewingDelegate,
                            URLViewControllerDelegate,
                            UIScrollViewDelegate>

@property(nonatomic, retain)WKWebView* wkview;
@property(nonatomic, retain)UIView* topbar;
@property(nonatomic, retain)WKWebViewConfiguration* wkCfg;
@end

@implementation ViewController
@synthesize wkview = _wkview;
@synthesize wkCfg = _wkCfg;

- (id)init
{
    if (self = [super init])
    {
        
    }
    
    return self;
}

- (void)dealloc
{
    [_topbar release], _topbar = nil;
    [_wkview release], _wkview = nil;
    [_wkCfg release], _wkCfg = nil;
    
    [super dealloc];
}

- (void)loadView
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    UIView* mainView = [[[UIView alloc] initWithFrame:rect] autorelease];
    mainView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = mainView;
    
    [self initWebViewOnView:mainView withBounds:rect];
    
    self.topbar = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, TOP_BAR_HEIGHT)] autorelease];
    _topbar.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:_topbar];
    
    
    [self initAllButtons];
}

- (void)initWebViewOnView:(UIView*)mainView withBounds:(CGRect)rect
{
    WKWebViewConfiguration* cfg = [[[WKWebViewConfiguration alloc] init] autorelease];
    self.wkCfg = cfg;
    
    WKPreferences* wkPrefer = [[[WKPreferences alloc] init] autorelease];
    _wkCfg.preferences = wkPrefer;
    
    WKUserContentController* ucc = [[[WKUserContentController alloc] init] autorelease];
    [ucc addScriptMessageHandler:self name:@"msgctr"];
    
    NSString* injectScript = @"";
    WKUserScript* us = [[[WKUserScript alloc] initWithSource:injectScript injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES] autorelease];
    [ucc addUserScript:us];
    
    _wkCfg.userContentController = ucc;
    
    WKWebView* webView = [[[WKWebView alloc] initWithFrame:rect configuration:cfg] autorelease];
    webView.allowsBackForwardNavigationGestures = YES;
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    
    [mainView addSubview:webView];
    self.wkview = webView;
    
    //    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    //    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    //    [webView addObserver:self forKeyPath:@"hasOnlySecureContent" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    //    [webView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    [webView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    
    self.wkview.scrollView.contentInset = UIEdgeInsetsMake(TOP_BAR_HEIGHT, 0, 0, 0);
    self.wkview.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(TOP_BAR_HEIGHT, 0, 0, 0);
    
    self.wkview.scrollView.delegate = self;
    
    UIView* contentView = [self contentViewFromWKWebView:self.wkview];
    
    CGRect contentFrame = contentView.frame;
    contentFrame.origin.y = TOP_BAR_HEIGHT;
    contentView.frame = contentFrame;
    
    
    self.wkview.scrollView.contentInset = UIEdgeInsetsMake(0, 0, TOP_BAR_HEIGHT, 0);
}

- (UIView*)contentViewFromWKWebView:(WKWebView*)webview
{
    UIView* view = nil;
    NSArray* subviews = [webview.scrollView subviews];
    for (UIView* subview in subviews)
    {
        if ([NSStringFromClass([subview class]) isEqualToString:@"WKContentView"])
        {
            view = subview;
            break;
        }
    }
    
    return view;
}

#pragma mark- ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self registerForPreviewingWithDelegate:self sourceView:self.view];
}
#pragma mark- ButtonActions
- (void)initAllButtons
{
    //打开
    CustomButton* btn = [self buttonWithTitle:@"O"];
    btn.tag = 0;
    btn.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:btn];
    
    btn = [self buttonWithTitle:@"R"];
    btn.tag = 1;
    btn.right = self.view.right;
    btn.backgroundColor = [[UIColor cyanColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:btn];
    
    btn = [self buttonWithTitle:@"<"];
    btn.tag = 2;
    btn.centerY = self.view.centerY;
    btn.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:btn];
    
    btn = [self buttonWithTitle:@">"];
    btn.tag = 3;
    btn.right = self.view.right;
    btn.centerY = self.view.centerY;
    btn.backgroundColor = [[UIColor brownColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:btn];
}

- (CustomButton*)buttonWithTitle:(NSString*)title
{
    CustomButton* btn = [[CustomButton alloc] initWithFrame:CGRectMake(0, 0, DefaultBtnWidth, DefaultBtnHeight)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)onBtnClick:(id)sender
{
    NSInteger idx = [(UIButton*)sender tag];
    NSString* selName = [NSString stringWithFormat:@"onBtn_%ld", (long)idx];
    SEL sel = NSSelectorFromString(selName);
    
    ((void(*)(id,SEL))objc_msgSend)(self, sel);
}

- (void)onBtn_0
{
    URLViewController* ctl = [[URLViewController alloc] init];
    ctl.delegate = self;
    
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)onBtn_1
{

}

- (void)onBtn_2
{
    [_wkview goForward];
}

- (void)onBtn_3
{
    
}

- (void)onBtn_4
{
    [_wkview reload];
}

- (void)onBtn_5
{
    
}

- (void)onBtn_6
{
    [_wkview goBack];
}

- (void)onBtn_7
{
    
}

- (void)loadWithURLString:(NSString*)link
{
    NSURL* url = [NSURL URLWithString:link];
    NSMutableURLRequest* mRequest = [NSMutableURLRequest requestWithURL:url];
    
    [_wkview loadRequest:mRequest];
}

#pragma mark- WKNavigationDelegate
/*! @abstract Decides whether a navigation should be allowed or not.
 @param webView The WKWebView invoking the delegate method.
 @param navigationAction A description of the action that triggered the navigation request.
 @param decisionHandler The decision handler that should be called to allow or cancel the load.
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if ([navigationAction.request.URL.scheme isEqualToString:@"uclink"])
    {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else
    {
        decisionHandler( WKNavigationActionPolicyAllow );
    }
}

/*! @abstract Decides whether a navigation should be allowed or cancelled once its response is known.
 @param webView The WKWebView invoking the delegate method.
 @param navigationResponse A description of the navigation response.
 @param decisionHandler The decision handler that should be called to allow or cancel the load.
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler( WKNavigationResponsePolicyAllow );
}

/*! @abstract Invoked when a main frame page load starts.
 @param webView The WKWebView invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
}

/*! @abstract Invoked when a server redirect is received for the main frame.
 @param webView The WKWebView invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    
}

/*! @abstract Invoked if an error occurs when starting to load data for the main frame.
 @param webView The WKWebView invoking the delegate method.
 @param navigation The navigation.
 @param error Specifies the type of error that occurred during the load.
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    
}

/*! @abstract Invoked when content starts arriving for the main frame.
 @param webView The WKWebView invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}

/*! @abstract Invoked when a main frame load completes.
 @param webView The WKWebView invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
}

/*! @abstract Invoked if an error occurs loading a committed main frame page load.
 @param webView The WKWebView invoking the delegate method.
 @param navigation The navigation.
 @param error Specifies the type of error that occurred during the load.
 */
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    
}

#pragma mark- WKUIDelegate
/*! @abstract Create a new WKWebView.
 @param webView The WKWebView invoking the delegate method.
 @param configuration The configuration that must be used when creating the new WKWebView.
 @param navigationAction The navigation action that is causing the new WKWebView to be created.
 @param windowFeatures Window features requested by the webpage.
 @result A new WKWebView or nil.
 @discussion The WKWebView returned must be created with the specified configuration. WebKit will load the request in the returned WKWebView.
 */
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    return nil;
}

/*! @abstract Display a JavaScript alert panel.
 @param webView The WKWebView invoking the delegate method.
 @param message The message to display.
 @param frame Information about the frame whose JavaScript initiated this call.
 @param completionHandler The completion handler that should get called after the alert panel has been dismissed.
 @discussion Clients should visually indicate that this panel comes from JavaScript initiated by the specified frame.
 The panel should have a single "OK" button.
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler;
{
    
}

/*! @abstract Display a JavaScript confirm panel.
 @param webView The WKWebView invoking the delegate method.
 @param message The message to display.
 @param frame Information about the frame whose JavaScript initiated this call.
 @param completionHandler The completion handler that should get called after the confirm panel has been dismissed.
 Pass YES if the user chose OK, NO if the user chose Cancel.
 @discussion Clients should visually indicate that this panel comes from JavaScript initiated by the specified frame.
 The panel should have two buttons, e.g. "OK" and "Cancel".
 */
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
    
}

/*! @abstract Display a JavaScript text input panel.
 @param webView The WKWebView invoking the delegate method.
 @param message The message to display.
 @param defaultText The initial text for the text entry area.
 @param frame Information about the frame whose JavaScript initiated this call.
 @param completionHandler The completion handler that should get called after the text input panel has been dismissed. Pass the typed text if the user chose OK, otherwise nil.
 @discussion Clients should visually indicate that this panel comes from JavaScript initiated by the specified frame.
 The panel should have two buttons, e.g. "OK" and "Cancel", and an area to type text.
 */
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *result))completionHandler
{
    
}

#pragma mark- WKScriptMessageHandler
/*! @abstract Invoked when a script message is recieved from a web page.
 @param userContentController The WKUserContentController invoking the delegate method.
 @param message The script message being received.
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
}

#pragma mark- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"loading"])
    {
        BOOL bNewState = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        
        [self updateLoadingState:bNewState];
    }
}

#pragma mark- Other
- (void)updateLoadingState:(BOOL)bLoading
{
    UIColor* borderClr = nil;
    if (!bLoading)
    {
        borderClr = [UIColor clearColor];
    }
    else
    {
        borderClr = [UIColor greenColor];
    }
    
    _wkview.layer.borderWidth = 2;
    _wkview.layer.borderColor = [borderClr CGColor];
    
}

#pragma mark- URLViewControllerDelegate
- (void)onURLSelect:(NSString*)url
{
    [self loadWithURLString:url];
}

#pragma mark- UIViewControllerPreviewingDelegate
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location NS_AVAILABLE_IOS(9_0)
{
    URLViewController* ctl = [[URLViewController alloc] init];
    ctl.delegate = self;
    
    return ctl;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit NS_AVAILABLE_IOS(9_0)
{
    [self.navigationController pushViewController:viewControllerToCommit animated:NO];
}

#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view
{
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale
{
    
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    
}

@end
