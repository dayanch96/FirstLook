#import <objc/runtime.h>

#import "../Headers/CCUIModuleInstanceManager.h"
#import "../Headers/SBBacklightController.h"
#import "../Headers/SBLockScreenManager.h"
#import "../Headers/LastLookManager.h"
#import "../Headers/LLTouchManager.h"

@interface FirstLookManager : NSObject
+ (instancetype)sharedInstance;

- (void)scheduleLastLook;
- (void)cancelLastLook;
- (void)scheduleScreenDim;
- (void)cancelScreenDim;

- (CGFloat)stayOnDuration;
- (BOOL)isLastLookEnabled;
- (BOOL)isAODEnabled;
@end