//
//  FilterControlProvider.m
//  FDataProvider
//
//  Created by 王乾舟 on 11/3/15.
//  Copyright © 2015 wangqianzhou. All rights reserved.
//

#import "FilterControlProvider.h"

@implementation FilterControlProvider

- (void)startFilterWithCompletionHandler:(void (^)(NSError *error))completionHandler
{
	// Add code to initialize the filter.
	completionHandler(nil);
}

- (void)stopFilterWithReason:(NEProviderStopReason)reason completionHandler:(void (^)(void))completionHandler
{
	// Add code to clean up filter resources.
	completionHandler();
}

- (void)handleNewFlow:(NEFilterFlow *)flow completionHandler:(void (^)(NEFilterControlVerdict *))completionHandler
{
	// Add code to determine if the flow should be dropped or not, downloading new rules if required.
	completionHandler([NEFilterControlVerdict allowVerdictWithUpdateRules:NO]);
}

@end
