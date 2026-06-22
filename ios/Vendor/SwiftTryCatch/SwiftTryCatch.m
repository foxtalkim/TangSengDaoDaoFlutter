//
//  SwiftTryCatch.m (vendored)
//  See header for context.
//

#import "SwiftTryCatch.h"

@implementation SwiftTryCatch

+ (void)try:(void (^)(void))tryBlock
      catch:(void (^)(NSException *exception))catchBlock {
    [self try:tryBlock catch:catchBlock finally:nil];
}

+ (void)try:(void (^)(void))tryBlock
      catch:(void (^)(NSException *exception))catchBlock
    finally:(void (^)(void))finallyBlock {
    @try {
        if (tryBlock) tryBlock();
    }
    @catch (NSException *exception) {
        if (catchBlock) catchBlock(exception);
    }
    @finally {
        if (finallyBlock) finallyBlock();
    }
}

+ (void)throwString:(NSString *)s {
    @throw [NSException exceptionWithName:s reason:s userInfo:nil];
}

+ (void)throwException:(NSException *)e {
    @throw e;
}

@end
