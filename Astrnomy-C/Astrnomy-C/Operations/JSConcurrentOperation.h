//
//  JSConcurrentOperation.h
//  Astrnomy-C
//
//  Created by Jeffrey Santana on 10/15/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(ConcurrentOperation)
@interface JSConcurrentOperation : NSOperation

typedef NS_ENUM(NSInteger, State) {
	isReady,
	isExecuting,
	isFinished
};

@property State state;

- (NSString *)StringFromState:(State)state;

@end

NS_ASSUME_NONNULL_END
