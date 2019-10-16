//
//  JSCache.h
//  Astrnomy-C
//
//  Created by Jeffrey Santana on 10/14/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Cache)
@interface JSCache<Key, Value>: NSObject

- (void)cacheValue:(Value)value for:(Key)key;
- (Value)valueForKey:(Key)key;

@end

NS_ASSUME_NONNULL_END
