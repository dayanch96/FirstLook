#import <objc/runtime.h>

#import "../Headers/CCUIModuleInstanceManager.h"
#import "../Headers/SBBacklightController.h"
#import "../Headers/LastLookManager.h"

@interface FirstLookManager : NSObject
+ (instancetype)sharedInstance;

- (void)scheduleScreenDim;
- (void)cancelSchedule;
- (CGFloat)stayOnDuration;
- (BOOL)isLastLookEnabled;
@end