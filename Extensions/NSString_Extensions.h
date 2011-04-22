//
//  NSString_Extensions.h
//
//  Copyright 2008 PolyMicro Systems. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSString(PMExtensions)

-(NSData*)md5Data;
-(NSString*)md5String;

-(float)rankWithString:(NSString*)other compareOptions:(NSStringCompareOptions)findOptions;

+(NSString*)stringFromByteCount:(NSNumber*)inBytes;

@end

@interface NSString (TruncateToWidth)

- (NSString*)stringByTruncatingBeginningToLength:(NSUInteger)length;
- (NSString*)stringByTruncatingEndToLength:(NSUInteger)length;
- (NSString*)stringByTruncatingMiddleToLength:(NSUInteger)length;

@end
