//
//  URLModel.m
//  UIWebViewDemo
//
//  Created by wangqianzhou on 14/01/2017.
//  Copyright © 2017 uc. All rights reserved.
//

#import "URLModel.h"

static NSString* URLList[] =
{
    @"http://hao123.com",
    @"http://m.baidu.com",
    @"http://html5test.com/",
    @"https://wangqianzhou.github.io/browser-detect/",
    @"http://a.mp.uc.cn/article.html?uc_param_str=frdnsnpfvecpntnwprdssskt&zzd_from=uc-iflow&dl_type=2&app=uc-iflow&fr=iphone&dn=13311942399-7511a41f&pf=44&ve=11.6.0.987&pc=AAQeLLz8ntugZTA7xfa663T3jL%2BzsSxc4E7%2FyEQIo1uR0sqA1yPRjBVCpDJ5YP%2FP645FHlTlpFzL7YBqvYRKAaXq&nt=99&nw=WIFI&pr=UCBrowser&ut=AATb3pCsc8uFbzRUTixV3DlWpKjauC1JU6FUK2QiFp1ybw%3D%3D&ss=0x0#!wm_aid=1d070816db474340a86b292f9edc49aa!!wm_id=c725696c680a4a8485bd9e7083531adb",
    @"https://ultradoux.ews.m.jaeapp.com/video_test.html",
    @"https://krpano.com/ios/bugs/ios8-webgl-video-cors/",
    @"https://wangqianzhou.github.io/video-crossdomain/video_cross_domain.html",
    @"https://wangqianzhou.github.io/video-crossdomain/video_test.html",
    @"https://wangqianzhou.github.io/video-crossdomain/video_test_local.html",
    @"https://market.wapa.taobao.com/abs-web/apps/63_brand_brand_1500950230894-1331340515.html"
};

@interface URLModel ( )
@property(nonatomic, strong)NSMutableArray<NSString*>* urlArray;
@property(nonatomic, strong)NSHashTable<id<URLModelDelegate>>* observers;
@end

@implementation URLModel

+ (instancetype)model
{
    static URLModel* _inst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _inst = [[[self class] alloc] init];
    });
    
    return _inst;
}

- (NSString*)savePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return  [documentsDirectory stringByAppendingPathComponent:@"url_list.data"];
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.observers = [NSHashTable weakObjectsHashTable];
        
        self.urlArray = [[NSMutableArray alloc] init];
        
        NSInteger hardCodeItemCount = sizeof(URLList)/ sizeof(URLList[0]);
        for (int i=0; i<hardCodeItemCount; i++)
        {
            [self.urlArray addObject:URLList[i]];
        }
        
        NSArray<NSString*>* savedItems = [NSArray arrayWithContentsOfFile:[self savePath]];
        [savedItems enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ( ![self.urlArray containsObject:obj] )
            {
                [self.urlArray addObject:obj];
            }
        }];
    }
    
    return self;
}

- (NSInteger)itemCount
{
    return [self.urlArray count];
}

- (NSString*)itemAtIndex:(NSInteger)index
{
    return [self.urlArray objectAtIndex:index];
}

- (void)addItem:(NSString*)url
{
    if ([url length] != 0 && ![self.urlArray containsObject:url])
    {
        [self.urlArray addObject:url];        
        [self.urlArray writeToFile:[self savePath] atomically:YES];
        
        NSEnumerator* enumerator = [self.observers objectEnumerator];
        id<URLModelDelegate> observer = [enumerator nextObject];
        while (observer)
        {
            [observer onModelChanged];
            
            observer = [enumerator nextObject];
        }
    }
}

- (void)addObserver:(id<URLModelDelegate>)observer
{
    if (observer)
    {
        [self.observers addObject:observer];
    }
}

- (void)removeObserver:(id<URLModelDelegate>)observer
{
    if (observer)
    {
        [self.observers removeObject:observer];
    }
}
@end
