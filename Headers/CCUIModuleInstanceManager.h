#import "CCUIModuleInstance.h"

@interface CCUIModuleInstanceManager : NSObject
@property (nonatomic, assign, readonly) NSArray <CCUIModuleInstance *> *moduleInstances;

+ (instancetype)sharedInstance;
@end