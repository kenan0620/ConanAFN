#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AFNConanAPI.h"
#import "AFNConanEnumType.h"
#import "AFNConanNetworkManager.h"

FOUNDATION_EXPORT double ConanAFNVersionNumber;
FOUNDATION_EXPORT const unsigned char ConanAFNVersionString[];

