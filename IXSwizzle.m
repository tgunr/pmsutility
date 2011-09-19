
#import "IXSwizzle.h"

#import <objc/objc.h>
#import <objc/runtime.h>

#if DEBUG

BOOL IXSwizzleMethod(Class cls, SEL selA, SEL selB)
{
	Method methodA = class_getInstanceMethod(cls, selA);
    if (!methodA) return NO;
	
	Method methodB = class_getInstanceMethod(cls, selB);
	if (!methodB) return NO;
	
	class_addMethod(cls, selA, class_getMethodImplementation(cls, selA), method_getTypeEncoding(methodA));
	class_addMethod(cls, selB, class_getMethodImplementation(cls, selB), method_getTypeEncoding(methodB));
	
	method_exchangeImplementations(class_getInstanceMethod(cls, selA), class_getInstanceMethod(cls, selB));

	return YES;
}

#endif