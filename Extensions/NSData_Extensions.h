//
//  NSData_Extensions.h
//  PickADisk
//
//  Created by PolyMicro Systems on 10/6/08.
//  Copyright 2008 PolyMicro Systems. All rights reserved.
//

#ifdef PMSUTILITY
#import <Cocoa/Cocoa.h>
#endif

#ifdef PMSUTILITYIOS
#import <UIKit/UIKit.h>
#endif

@interface NSData(StandardDigest)

-(NSString*)hexString;

-(NSData*)md5Data;
-(NSString*)md5String;

-(NSData*)sha1Data;

@end
