#import <Foundation/Foundation.h>

@interface MRUCallMonitor : NSObject
@property (nonatomic, assign, readonly, getter=isOnCall) BOOL onCall;

+ (instancetype)sharedMonitor;
@end