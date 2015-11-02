//
//  ViewController.m
//  WebkitDemp
//
//  Created by wangqianzhou on 13-8-3.
//  Copyright (c) 2013年 uc. All rights reserved.
//

#import "ViewController.h"
#import "QuadCurveMenu.h"
#import <QuartzCore/QuartzCore.h>
#import <WebKit/WebKit.h>
#import <objc/message.h>

@interface ViewController ()<QuadCurveMenuDelegate, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>
@property(nonatomic, retain)WKWebView* wkview;
@property(nonatomic, retain)WKWebView* wkview_1;
@property(nonatomic, retain)WKWebViewConfiguration* wkCfg;
@end

@implementation ViewController
@synthesize wkview = _wkview;
@synthesize wkview_1 = _wkview_1;
@synthesize wkCfg = _wkCfg;

- (id)init
{
    if (self = [super init])
    {
        
    }
    
    return self;
}

- (void)loadView
{
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    UIView* mainView = [[[UIView alloc] initWithFrame:rect] autorelease];
    mainView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = mainView;
    
    WKWebViewConfiguration* cfg = [[[WKWebViewConfiguration alloc] init] autorelease];
    self.wkCfg = cfg;
    
    WKPreferences* wkPrefer = [self preferences];
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
//    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
//    [webView addObserver:self forKeyPath:@"hasOnlySecureContent" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
//    [webView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];

    
    [self setButtonsWithFrame:rect];
}

- (WKPreferences*)preferences
{
    WKPreferences* wkPrefer = [[[WKPreferences alloc] init] autorelease];
    
    return wkPrefer;
}

- (void)setButtonsWithFrame:(CGRect)rect
{
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    
    UIImage *starImage = [UIImage imageNamed:@"icon-star.png"];
    
    QuadCurveMenuItem *starMenuItem1 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:starImage
                                                        highlightedContentImage:nil];
    QuadCurveMenuItem *starMenuItem2 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:starImage
                                                        highlightedContentImage:nil];
    QuadCurveMenuItem *starMenuItem3 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:starImage
                                                        highlightedContentImage:nil];
    QuadCurveMenuItem *starMenuItem4 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:starImage
                                                        highlightedContentImage:nil];
    QuadCurveMenuItem *starMenuItem5 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:starImage
                                                        highlightedContentImage:nil];
    QuadCurveMenuItem *starMenuItem6 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:starImage
                                                        highlightedContentImage:nil];
    QuadCurveMenuItem *starMenuItem7 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:starImage
                                                        highlightedContentImage:nil];
    QuadCurveMenuItem *starMenuItem8 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:starImage
                                                        highlightedContentImage:nil];
    
    NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, starMenuItem5, starMenuItem6, starMenuItem7,starMenuItem8, nil];
    [starMenuItem1 release];
    [starMenuItem2 release];
    [starMenuItem3 release];
    [starMenuItem4 release];
    [starMenuItem5 release];
    [starMenuItem6 release];
    [starMenuItem7 release];
    [starMenuItem8 release];
    
    QuadCurveMenu *menu = [[QuadCurveMenu alloc] initWithFrame:rect menus:menus];
	
	// customize menu
	/*
     menu.rotateAngle = M_PI/3;
     menu.menuWholeAngle = M_PI;
     menu.timeOffset = 0.2f;
     menu.farRadius = 180.0f;
     menu.endRadius = 100.0f;
     menu.nearRadius = 50.0f;
     */
	
    menu.delegate = self;
    [self.view addSubview:menu];
    [menu release];
}

- (void)dealloc
{
    [_wkview release], _wkview = nil;
    [_wkCfg release], _wkCfg = nil;
    
    [super dealloc];
}

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


#pragma mark- QuadCurveMenuDelegate
- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx
{
    NSString* selName = [NSString stringWithFormat:@"onBtn_%ld", (long)idx];
    SEL sel = NSSelectorFromString(selName);
    
    ((void(*)(id, SEL))objc_msgSend)(self, sel);
}

- (void)onBtn_0
{
    [self openlink];
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

#pragma mark- ButtonActions
- (void)openlink
{
    NSString* link =
    @"http://m.hao123.com";
    
    
    [self loadWithURLString:link];
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
    
    decisionHandler( WKNavigationActionPolicyAllow );
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
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)())completionHandler
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

@end
