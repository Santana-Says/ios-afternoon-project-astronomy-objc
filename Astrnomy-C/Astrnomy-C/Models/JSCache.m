//
//  JSCache.m
//  Astrnomy-C
//
//  Created by Jeffrey Santana on 10/14/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

#import "JSCache.h"

@interface JSCache ()

@property NSDictionary *cachedItems;
@property dispatch_queue_t queue;

@end

@implementation JSCache

- (instancetype)init
{
	self = [super init];
	if (self) {
		_queue = dispatch_queue_create(@"MyCacheQueue", nil);
		_cachedItems = [[NSDictionary alloc] init];
	}
	return self;
}

- (void)cacheValue:(id)value for:(id)key {
	dispatch_async(self.queue, ^{
		[self.cachedItems setValue:value forKey:key];
	});
}

- (id)valueForKey:(id)key {
	return self.cachedItems[key];
}

@end
