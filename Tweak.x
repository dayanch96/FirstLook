#import <notify.h>
#import <UIKit/UIKit.h>

#import "Models/FirstLookManager.h"

void notifyBlankedScreen(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    SBBacklightController *sbbc = [%c(SBBacklightController) sharedInstanceIfExists];

    if (sbbc.screenIsOn) {
        if (![FirstLookManager sharedInstance].isLastLookEnabled) {
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

    FirstLookManager *flman = [FirstLookManager sharedInstance];

    // Source 12 is a notification...
    if (state == 1 && source == 12 && flman.isLastLookEnabled) {
        [flman scheduleScreenDim];
    }

    else {
        [flman cancelSchedule];
    }
}
%end

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notifyBlankedScreen, CFSTR("com.apple.springboard.hasBlankedScreen"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}