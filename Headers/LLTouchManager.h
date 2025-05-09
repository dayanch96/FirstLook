#import <Foundation/Foundation.h>

@interface LLTouchManager : NSObject
@property (nonatomic, assign, readwrite) BOOL isListening;

+ (instancetype)sharedInstance;

- (void)startListeningTouchEvents;
- (void)stopListeningTouchEvents;
@end