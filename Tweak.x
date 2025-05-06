#import <notify.h>
#import <UIKit/UIKit.h>

#import "Headers/CCUIModuleInstanceManager.h"
#import "Headers/SBBacklightController.h"

@interface LastLookManager : NSObject
+ (instancetype)sharedInstance;
@end

BOOL isLastLookEnabled(void) {
    LastLookManager *llman = [%c(LastLookManager) sharedInstance];
    if (class_getInstanceVariable([llman class], "enabled") == NULL) {
        return NO;
    }

    if (![[llman valueForKey:@"enabled"] boolValue]) {
        return NO;
    }

    NSArray *modules = [[%c(CCUIModuleInstanceManager) sharedInstance] moduleInstances];
    for (CCUIModuleInstance *instance in modules) {
        if ([instance.metadata.moduleIdentifier isEqualToString:@"com.anthopak.lastlookmainmodule"]) {
            if (!instance.module.selected) {
                return NO;
            }
        }
    }

    return YES;
}

void notifyBlankedScreen(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    SBBacklightController *sbbc = [%c(SBBacklightController) sharedInstanceIfExists];

    if (sbbc.screenIsOn) {
        if (!isLastLookEnabled()) {
            return;
        }

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [sbbc _startFadeOutAnimationFromLockSource:3];
        });
    }
}

%hook SBBacklightController
- (void)_notifyObserversWillTransitionToBacklightState:(NSInteger)state source:(NSInteger)source {
    %orig;

    // Source 12 is a notification...
    if (state == 1 && source == 12 && isLastLookEnabled()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            SBBacklightController *sbbc = [%c(SBBacklightController) sharedInstanceIfExists];
            [sbbc setBacklightState:1 source:667];
            [sbbc setBacklightState:3 source:667];
        });
    }
}
%end

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notifyBlankedScreen, CFSTR("com.apple.springboard.hasBlankedScreen"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}