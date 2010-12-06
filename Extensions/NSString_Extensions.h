//
//  NSString_Extensions.h
//  PickADisk
//
//  Created by Jack Small on 10/6/08.
//  Copyright 2008 Jack Small. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSString(MyExtensions)

-(NSData*)md5Data;
-(NSString*)md5String;

-(float)rankWithString:(NSString*)other compareOptions:(NSStringCompareOptions)findOptions;

+(NSString*)stringFromByteCount:(NSNumber*)inBytes;

@end
