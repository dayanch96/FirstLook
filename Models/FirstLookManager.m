#import "FirstLookManager.h"

@implementation FirstLookManager {
    NSTimer *_lastLookTimer;
    NSTimer *_screenDimTimer;
}

+ (instancetype)sharedInstance {
    static FirstLookManager *instance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        instance = [FirstLookManager new];
    });

    return instance;
}

- (void)scheduleLastLook {
    [self cancelLastLook];

    _lastLookTimer = [NSTimer scheduledTimerWithTimeInterval:self.stayOnDuration * 0.9 repeats:NO block:^(NSTimer * _Nonnull timer) {
        SBLockScreenManager *sblsm = [NSClassFromString(@"SBLockScreenManager") sharedInstance];
        if (self.isAODEnabled && sblsm.isLockScreenActive) {
            [[NSClassFromString(@"LLTouchManager") sharedInstance] startListeningTouchEvents];

            SBBacklightController *sbbc = [NSClassFromString(@"SBBacklightController") sharedInstanceIfExists];
            [sbbc _startFadeOutAnimationFromLockSource:3];
        }
    }];
}

- (void)cancelLastLook {
    [_lastLookTimer invalidate];
    _lastLookTimer = nil;
}

- (void)scheduleScreenDim {
    [self cancelScreenDim];

    _screenDimTimer = [NSTimer scheduledTimerWithTimeInterval:self.stayOnDuration repeats:NO block:^(NSTimer * _Nonnull timer) {
        if (self.isLastLookActive) {
            SBBacklightController *sbbc = [NSClassFromString(@"SBBacklightController") sharedInstanceIfExists];
            [sbbc setBacklightState:1 source:667];
            [sbbc setBacklightState:3 source:667];
        }
    }];
}

- (void)cancelScreenDim {
    [_screenDimTimer invalidate];
    _screenDimTimer = nil;
}

- (BOOL)isLastLookActive {
    return [[NSClassFromString(@"LastLookManager") sharedInstance] isActive];
}

- (CGFloat)stayOnDuration {
    LastLookManager *llman = [NSClassFromString(@"LastLookManager") sharedInstance];
    if (class_getInstanceVariable([llman class], "normal_stayOnDuration") == NULL) {
        return 10;
    }

    return [[llman valueForKey:@"normal_stayOnDuration"] floatValue];
}

- (BOOL)isLastLookEnabled {
    LastLookManager *llman = [NSClassFromString(@"LastLookManager") sharedInstance];
    if (class_getInstanceVariable([llman class], "enabled") == NULL) {
        return NO;
    }

    if (![[llman valueForKey:@"enabled"] boolValue]) {
        return NO;
    }

    NSArray *modules = [[NSClassFromString(@"CCUIModuleInstanceManager") sharedInstance] moduleInstances];
    for (CCUIModuleInstance *instance in modules) {
        if ([instance.metadata.moduleIdentifier isEqualToString:@"com.anthopak.lastlookmainmodule"]) {
            if (!instance.module.selected) {
                return NO;
            }
        }
    }

    return YES;
}

- (BOOL)isAODEnabled {
    LastLookManager *llman = [NSClassFromString(@"LastLookManager") sharedInstance];
    if (class_getInstanceVariable([llman class], "enabled") == NULL) {
        return NO;
    }

    if (![[llman valueForKey:@"enabled"] boolValue]) {
        return NO;
    }

    if (class_getInstanceVariable([llman class], "AOD_enabled") == NULL) {
        return NO;
    }

    return [[llman valueForKey:@"AOD_enabled"] boolValue];
}

@end