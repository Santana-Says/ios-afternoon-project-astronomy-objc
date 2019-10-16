//
//  JSSolDescription.h
//  Astrnomy-C
//
//  Created by Jeffrey Santana on 10/14/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(SolDescription)
@interface JSSolDescription : NSObject

@property int sol;
@property int totalPhotos;
@property NSArray<NSString *> *cameras;

- (instancetype)initWithDictionary:(NSDictionary *)solDict;

@end

NS_ASSUME_NONNULL_END
