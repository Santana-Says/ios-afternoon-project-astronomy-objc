//
//  JSPhotosController.h
//  Astrnomy-C
//
//  Created by Jeffrey Santana on 10/14/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSRover;
@class Photos;
typedef void(^myCompletion)(NSArray<NSObject *> *_Nullable);

NS_SWIFT_NAME(PhotosController)
@interface JSPhotosController : NSObject

NS_ASSUME_NONNULL_BEGIN

@property NSArray *photos;

- (NSURL *)urlForManifestFromRover:(NSString *)roverName;
- (NSURL *)urlForPhotosFromRover:(NSString *)roverName onSol:(NSNumber *)sol;
- (void)fetchManifestFromRover:(NSString *)roverName withCompletion:(myCompletion _Nullable)block;
- (void)fetchPhotosFromRover:(JSRover *)rover onSol:(NSNumber *)sol withCompletion:(myCompletion _Nullable)block;

NS_ASSUME_NONNULL_END

@end
