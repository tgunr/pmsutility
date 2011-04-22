//
//  NSData_Extensions.h
//  PickADisk
//
//  Created by PolyMicro Systems on 10/6/08.
//  Copyright 2008 PolyMicro Systems. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSData(StandardDigest)

-(NSString*)hexString;

-(NSData*)md5Data;
-(NSString*)md5String;

-(NSData*)sha1Data;

@end
