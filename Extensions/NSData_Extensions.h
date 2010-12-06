//
//  NSData_Extensions.h
//  PickADisk
//
//  Created by Jack Small on 10/6/08.
//  Copyright 2008 Jack Small. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSData(StandardDigest)

-(NSString*)hexString;

-(NSData*)md5Data;
-(NSString*)md5String;

-(NSData*)sha1Data;

@end
