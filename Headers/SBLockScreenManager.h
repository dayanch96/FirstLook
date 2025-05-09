#import <Foundation/Foundation.h>

@interface SBLockScreenManager : NSObject
@property (atomic, assign, readonly) BOOL isLockScreenActive;
@property (atomic, assign, readonly) BOOL isLockScreenVisible;

+ (instancetype)sharedInstance;
+ (instancetype)sharedInstanceIfExists;
@end