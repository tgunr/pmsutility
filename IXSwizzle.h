//
//  IXSwizzle.h
//

#import <Foundation/Foundation.h>

#if DEBUG
extern BOOL IXSwizzleMethod(Class cls, SEL selA, SEL selB);
#else
#define IXSwizzleMethod(CLS, SELA, SELB)
#endif