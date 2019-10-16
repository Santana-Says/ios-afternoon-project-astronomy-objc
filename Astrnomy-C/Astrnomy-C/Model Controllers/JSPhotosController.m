//
//  JSPhotosController.m
//  Astrnomy-C
//
//  Created by Jeffrey Santana on 10/14/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

#import "JSPhotosController.h"
#import "Astrnomy_C-Swift.h"
#import "JSNasaApi.h"
#import "JSRover.h"

@interface JSPhotosController ()

@property NSURL *baseURL;
@property NSString *apiKey;

@end

@implementation JSPhotosController

- (instancetype)init {
	self = [super init];
	if (self) {
		_baseURL = [[NSURL alloc] initWithString:@"https://api.nasa.gov/mars-photos/api/v1"];
		_apiKey = [[[JSNasaApi alloc] init] apiKey];
		_photos = @[];
	}
	return self;
}

- (NSURL *)urlForManifestFromRover:(NSString *)roverName {
	NSURL *url = self.baseURL;
	url = [url URLByAppendingPathComponent:@"manifests"];
	url = [url URLByAppendingPathComponent:roverName];
	
	NSURLComponents *urlcomponents = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:true];
	[urlcomponents setQueryItems:@[
		[NSURLQueryItem queryItemWithName:@"api_key" value:self.apiKey]
	]];
	
	return urlcomponents.URL;
}

- (NSURL *)urlForPhotosFromRover:(JSRover *)rover onSol:(NSNumber *)sol {
	NSURL *url = self.baseURL;
	url = [url URLByAppendingPathComponent:@"rovers"];
	url = [url URLByAppendingPathComponent:rover.name];
	url = [url URLByAppendingPathComponent:@"photos"];
	
	NSURLComponents *urlcomponents = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:true];
	[urlcomponents setQueryItems:@[
		[NSURLQueryItem queryItemWithName:@"sol" value:[sol stringValue]],
		[NSURLQueryItem queryItemWithName:@"api_key" value:self.apiKey]
	]];
	
	return urlcomponents.URL;
}

- (void)fetchManifestFromRover:(NSString *)roverName withCompletion:(myCompletion)block {
	NSURL *url = [self urlForManifestFromRover:roverName];
	
	NSURLSessionDataTask *task =
	[[NSURLSession sharedSession] dataTaskWithURL:url
								completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
		
		if (error) {
			NSLog(@"Error fetching forecast: %@", error);
			block(nil);
			return;
		}
		
		// parse the data
		NSError *jsonError = nil;
		NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
		if (jsonError) {
			NSLog(@"JSON Error: %@", jsonError);
			block(nil);
			return;
		}
		
//		NSLog(@"JSON: %@", json);
		
		JSRover *rover = [[JSRover alloc] initWithDictionary:json];

		self.photos = [rover.solDescriptions copy];
		block(@[rover]);
	}];
	[task resume];
}

- (void)fetchPhotosFromRover:(NSString *)roverName onSol:(NSNumber *)sol withCompletion:(myCompletion)block {
	NSURL *url = [self urlForPhotosFromRover:roverName onSol:sol];
	
	NSURLSessionDataTask *task =
	[[NSURLSession sharedSession] dataTaskWithURL:url
								completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
		
		if (error) {
			NSLog(@"Error fetching forecast: %@", error);
			block(nil);
			return;
		}
		
		// parse the data
		NSError *jsonError = nil;
		NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
		if (jsonError) {
			NSLog(@"JSON Error: %@", jsonError);
			block(nil);
			return;
		}
		
		//			NSLog(@"JSON: %@", json);
		
		NSArray *rawPhotos = json[@"photos"];
		NSMutableArray *photos = [[NSMutableArray alloc] init];
		
		if (![rawPhotos isKindOfClass:NSNull.self]) {
			for (NSDictionary *photoDict in rawPhotos) {
				[photos addObject:[[Photo alloc] initWithDictionary:photoDict]];
			}
			
			self.photos = [photos copy];
			block(photos);
		}
		
		block(nil);
	}];
	[task resume];
}

@end
