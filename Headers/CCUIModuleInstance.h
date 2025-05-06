#import "CCSModuleMetadata.h"
#import "CCUIToggleModule.h"

@interface CCUIModuleInstance : NSObject
@property (nonatomic, assign, readonly) CCSModuleMetadata *metadata;
@property (nonatomic, assign, readonly) CCUIToggleModule *module;
@end