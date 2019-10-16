//
//  JSRover.h
//  Astrnomy-C
//
//  Created by Jeffrey Santana on 10/14/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSSolDescription;

NS_SWIFT_NAME(Rover)
@interface JSRover : NSObject

typedef NS_ENUM(NSInteger, Status) {
	ACTIVE,
	COMPLETE
};

@property NSString *name;
@property NSDate *launchDate;
@property NSDate *landingDate;
@property Status *status;
@property int maxSol;
@property NSDate *maxDate;
@property int numberOfPhotos;
@property NSArray<JSSolDescription *> *solDescriptions;

- (instancetype)initWithDictionary:(NSDictionary *)roverDict;

@end
