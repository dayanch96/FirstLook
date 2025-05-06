#import <Foundation/Foundation.h>

@interface SBBacklightController : NSObject
@property (nonatomic, assign, readonly) BOOL screenIsOn;

+ (instancetype)sharedInstance;
+ (instancetype)sharedInstanceIfExists;

- (void)_startFadeOutAnimationFromLockSource:(int)source;
- (void)setBacklightState:(NSInteger)state source:(NSInteger)source;
@end