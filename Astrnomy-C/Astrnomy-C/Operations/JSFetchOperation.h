//
//  JSFetchOperation.h
//  Astrnomy-C
//
//  Created by Jeffrey Santana on 10/15/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSConcurrentOperation.h"

@class Photo;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(FetchOperation)
@interface JSFetchOperation : JSConcurrentOperation

@property Photo *photoRef;
@property NSData *_Nullable imageData;

- (instancetype)initWithPhotoRef:(Photo *)photoRef;

@end

NS_ASSUME_NONNULL_END
