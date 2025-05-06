#import <Foundation/Foundation.h>

@interface LastLookManager : NSObject
@property (nonatomic, assign, readwrite) BOOL isActive;

+ (instancetype)sharedInstance;
@end