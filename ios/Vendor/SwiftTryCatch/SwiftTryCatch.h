//
//  SwiftTryCatch.h (vendored)
//
//  Bridges Objective-C @try/@catch to Swift. Originally upstream
//  `williamFalcon/SwiftTryCatch` (MIT), but that version exposes only
//  the 3-arg `try:catch:finally:` form. `flutter_dynamic_icon_plus`
//  (and historically `cfr/SwiftTryCatch` which is now 404) calls the
//  2-arg `try:catch:` form. This vendored copy adds the missing
//  overload so we don't need a deleted GitHub fork to build.
//
//  MIT — Copyright (c) 2014 William Falcon.

#import <Foundation/Foundation.h>

@interface SwiftTryCatch : NSObject

/// 2-arg try/catch (used by flutter_dynamic_icon_plus). The
/// `exception` parameter is intentionally not annotated nonnull —
/// Swift bridging treats unannotated reference types as Optional, and
/// the plugin uses `exception?.reason` which would error on
/// `NSException *_Nonnull`.
+ (void)try:(__attribute__((noescape)) void (^ _Nullable)(void))tryBlock
      catch:(__attribute__((noescape)) void (^ _Nullable)(NSException *exception))catchBlock;

/// 3-arg try/catch/finally form, matching williamFalcon upstream.
+ (void)try:(__attribute__((noescape)) void (^ _Nullable)(void))tryBlock
      catch:(__attribute__((noescape)) void (^ _Nullable)(NSException *exception))catchBlock
    finally:(__attribute__((noescape)) void (^ _Nullable)(void))finallyBlock;

+ (void)throwString:(NSString * _Nonnull)s;
+ (void)throwException:(NSException * _Nonnull)e;

@end
