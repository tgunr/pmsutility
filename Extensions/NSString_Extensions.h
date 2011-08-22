//
//  NSString_Extensions.h
//
//  Copyright 2008 PolyMicro Systems. All rights reserved.
//

#ifdef PMSUTILITY
#import <Cocoa/Cocoa.h>
#endif

#ifdef PMSUTILITYIOS
#import <UIKit/UIKit.h>
#endif


@interface NSString(PMExtensions)
#ifdef PMSUtility
-(NSData*)md5Data;
-(NSString*)md5String;
#endif

-(float)rankWithString:(NSString*)other compareOptions:(NSStringCompareOptions)findOptions;

+(NSString*)stringFromByteCount:(NSNumber*)inBytes;

@end

@interface NSString (TruncateToWidth)

- (NSString*)stringByTruncatingBeginningToLength:(NSUInteger)length;
- (NSString*)stringByTruncatingEndToLength:(NSUInteger)length;
- (NSString*)stringByTruncatingMiddleToLength:(NSUInteger)length;

@end

@interface NSMutableString(PMExtensions)
#ifdef PMSUtility
-(NSString*)md5String;
#endif
@end
