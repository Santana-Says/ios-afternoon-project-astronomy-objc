//
//  JSRover.m
//  Astrnomy-C
//
//  Created by Jeffrey Santana on 10/14/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

#import "JSRover.h"
#import "JSSolDescription.h"

@implementation JSRover

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    });
    return dateFormatter;
}

- (instancetype)initWithDictionary:(NSDictionary *)roverDict {
	self = [super init];
	if (self) {
		NSDictionary *manifestDict = roverDict[@"photo_manifest"];
		NSArray *rawPhotos = manifestDict[@"photos"];
		NSMutableArray *photos = [[NSMutableArray alloc] init];
		
		_name = manifestDict[@"name"];
		_launchDate = [[[self class] dateFormatter] dateFromString:manifestDict[@"launch_date"]];
		_landingDate = [[[self class] dateFormatter] dateFromString:manifestDict[@"landing_date"]];
		_maxSol = [manifestDict[@"max_sol"] intValue];
		_maxDate = [[[self class] dateFormatter] dateFromString:manifestDict[@"max_date"]];
		_numberOfPhotos = [manifestDict[@"total_photos"] intValue];
		
		for (NSDictionary *photoDict in rawPhotos) {
			[photos addObject:[[JSSolDescription alloc] initWithDictionary:photoDict]];
		}
		_solDescriptions = photos;
	}
	return self;
}

@end
