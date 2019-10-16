//
//  JSConcurrentOperation.m
//  Astrnomy-C
//
//  Created by Jeffrey Santana on 10/15/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

#import "JSConcurrentOperation.h"

@interface JSConcurrentOperation ()

@property dispatch_queue_t stateQueue;

@property State internalState;

@end

@implementation JSConcurrentOperation

- (instancetype)init
{
	self = [super init];
	if (self) {
		_stateQueue = dispatch_queue_create("com.LambdaSchool.Astronomy.ConcurrentOperationStateQueue", DISPATCH_QUEUE_CONCURRENT);
		_internalState = isReady;
	}
	return self;
}

- (State)state {
	__block State result = isReady;
	dispatch_sync(self.stateQueue, ^{
		result = self.internalState;
	});
	return result;
}

- (void)setState:(State)state {
	State oldState = self.state;
	[self willChangeValueForKey:[self StringFromState:state]];
	[self willChangeValueForKey:[self StringFromState:oldState]];
	
	dispatch_sync(self.stateQueue, ^{
		self.state = state;
	});
	
	[self didChangeValueForKey:[self StringFromState:oldState]];
	[self didChangeValueForKey:[self StringFromState:state]];
}

- (NSString *)StringFromState:(State)state {
	NSString *result;
	
	switch (state) {
		case isReady:
			result = @"isReady";
			break;
		case isExecuting:
			result = @"isExecuting";
			break;
		case isFinished:
			result = @"isFinished";
			break;
	}
	return result;
}

- (BOOL)isReady {
	return (super.isReady && self.state == isReady);
}

- (BOOL)isExecuting {
	return (self.state == isExecuting);
}

- (BOOL)isFinished {
	return (self.state == isFinished);
}

- (BOOL)isAsynchronous {
	return true;
}

@end
