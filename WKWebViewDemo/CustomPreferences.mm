//
//  CustomPreferences.m
//  UIWebViewDemo
//
//  Created by wangqianzhou on 15/12/3.
//  Copyright © 2015年 uc. All rights reserved.
//

#import "CustomPreferences.h"
#import "CustomURLProtocol.h"
#import <objc/message.h>

@implementation CustomPreferences

+ (void)initPreferences
{
    [self initCustomProtocol];
}

+ (void)initCustomProtocol
{
    [self registerScheme:@"http"];
    [self registerScheme:@"https"];
    [self registerScheme:@"uclink"];
    [NSURLProtocol registerClass:[CustomURLProtocol class]];
}

+ (void)registerScheme:(NSString*)scheme
{
    id cls = NSClassFromString(@"WKBrowsingContextController");
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL sel = @selector(registerSchemeForCustomProtocol:);
#pragma clang diagnostic pop
    
    [cls performSelector:sel withObject:scheme];
}


+ (void)unregisterScheme:(NSString*)scheme
{
    id cls = NSClassFromString(@"WKBrowsingContextController");
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL sel = @selector(unregisterSchemeForCustomProtocol:);
#pragma clang diagnostic pop
    
    [cls performSelector:sel withObject:scheme];
}
@end
