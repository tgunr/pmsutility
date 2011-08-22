//
//  NSString_Extensions.h
//
//  Copyright 2008 PolyMicro Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(PMExtensions)
-(NSData*)md5Data;
-(NSString*)md5String;
+(NSString*)stringFromByteCount:(NSNumber*)inBytes;
-(float)rankWithString:(NSString*)other compareOptions:(NSStringCompareOptions)findOptions;
- (NSString*)stringByTruncatingBeginningToLength:(NSUInteger)length;
- (NSString*)stringByTruncatingEndToLength:(NSUInteger)length;
- (NSString*)stringByTruncatingMiddleToLength:(NSUInteger)length;

@end

@interface NSMutableString(PMExtensions)
-(NSString*)md5String;
@end
