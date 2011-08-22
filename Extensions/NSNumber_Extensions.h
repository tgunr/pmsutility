//
//  NSNumber_Extensions.h
//  PMSUtility
//
//  Created by Dave Carlton on 08/01/11.
//  Copyright 2011 Polymicro Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString_Extensions.h"

@interface NSNumber(PMSExtensions)

+(NSNumber*)zero;

-(NSString*)md5String;
-(NSNumber*)addToNumber:(NSNumber*)otherNum;

@end	//	NSNumber(StandardDigest)
