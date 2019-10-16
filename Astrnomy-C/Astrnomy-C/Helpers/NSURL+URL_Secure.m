//
//  NSURL+URL_Secure.m
//  Astrnomy-C
//
//  Created by Jeffrey Santana on 10/16/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

#import "NSURL+URL_Secure.h"

@implementation NSURL (URL_Secure)

- (NSURL *)usingHTTPS {
	NSURLComponents *components = [[NSURLComponents alloc] initWithURL:self resolvingAgainstBaseURL:true];
	if (components) {
		components.scheme = @"https";
	}
	return components.URL;
}

@end
