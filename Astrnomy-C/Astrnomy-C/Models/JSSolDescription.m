//
//  JSSolDescription.m
//  Astrnomy-C
//
//  Created by Jeffrey Santana on 10/14/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

#import "JSSolDescription.h"

@implementation JSSolDescription

- (instancetype)initWithDictionary:(NSDictionary *)solDict {
	self = [super init];
	if (self) {
		_sol = [solDict[@"sol"] intValue];
		_totalPhotos = [solDict[@"total_photos"] intValue];
		_cameras = solDict[@"cameras"];
	}
	return self;
}

@end
