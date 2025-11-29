#import "EncapsulateCollectionResource.h"
#import "PivotalRecursionObserver.h"
#import "PushAnimationAction.h"
#import "SetstateMemberCache.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MediaTransitionAdapter : NSObject


- (void) rebuildCacheSingleton;

- (void) unmountedFusedResource;

@end

NS_ASSUME_NONNULL_END
        