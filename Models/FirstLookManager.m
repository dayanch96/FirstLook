#import "FirstLookManager.h"

@implementation FirstLookManager {
    NSTimer *_timer;
}

+ (instancetype)sharedInstance {
    static FirstLookManager *instance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        instance = [FirstLookManager new];
    });

    return instance;
}

- (void)scheduleScreenDim {
    [self cancelSchedule];

    _timer = [NSTimer scheduledTimerWithTimeInterval:self.stayOnDuration repeats:NO block:^(NSTimer * _Nonnull timer) {
        if (self.isLastLookActive) {
            SBBacklightController *sbbc = [NSClassFromString(@"SBBacklightController") sharedInstanceIfExists];
            [sbbc setBacklightState:1 source:667];
            [sbbc setBacklightState:3 source:667];
        }
    }];
}

- (void)cancelSchedule {
    [_timer invalidate];
    _timer = nil;
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

- (BOOL)isLastLookActive {
    return [[NSClassFromString(@"LastLookManager") sharedInstance] isActive];
}

@end