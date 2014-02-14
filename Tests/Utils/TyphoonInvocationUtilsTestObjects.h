//
//  TyphoonInvocationUtilsTestObjects.h
//  Tests
//
//  Created by Aleksey Garbarev on 04.02.14.
//
//

#import <Foundation/Foundation.h>

@interface ObjectInitRetained : NSObject

@end

@interface ObjectNewRetained : NSObject

+ (instancetype)newObject;

@end


@interface ObjectNewAutorelease : NSObject

+ (instancetype)object;

@end

@interface ObjectInitCluster : NSObject

- (instancetype)initOldRelease;

- (instancetype)initOldAutorelease;

- (instancetype)initReturnNil;

@end

