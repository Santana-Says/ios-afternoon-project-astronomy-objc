//
//  JSFetchOperation.m
//  Astrnomy-C
//
//  Created by Jeffrey Santana on 10/15/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

#import "JSFetchOperation.h"
#import "JSConcurrentOperation.h"
#import "Astrnomy_C-Swift.h"
#import "NSURL+URL_Secure.h"

@interface JSFetchOperation ()

@property NSURLSessionDataTask *dataTask;

@end

@implementation JSFetchOperation

- (instancetype)initWithPhotoRef:(Photo *)photoRef {
	self = [super init];
	if (self) {
		self.photoRef = photoRef;
	}
	return self;
}

- (void)start {
	[super start];
	[self setState:isExecuting];
	
	NSURLRequest * requestUrl = [[NSURLRequest alloc] initWithURL:self.photoRef.imageURL.usingHTTPS];
	
	self.dataTask = [NSURLSession.sharedSession dataTaskWithRequest:requestUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		if (self.isCancelled) {
			[self setState:isFinished];
			return;
		}
		
		if (error) {
			NSLog(@"Error fetching photos: %@", error.localizedDescription);
			return;
		}
		
		if (data != nil) {
			NSLog(@"No data found");
			return;
		}
		self.imageData = data;
	}];
	[self.dataTask resume];
	
	
}

- (void)cancel {
	[super cancel];
	[self.dataTask cancel];
}

@end
