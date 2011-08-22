//
//  NSNumber_Extensions.m
//  PMSUtility
//
//  Created by Dave Carlton on 08/01/11.
//  Copyright 2011 Polymicro Systems. All rights reserved.
//

#import "NSNumber_Extensions.h"

@implementation NSNumber(PMSExtensions)

+(NSNumber*)zero
{	return [NSNumber numberWithInt:0];	}

-(NSString*)md5String
{	return [[self stringValue] md5String];	}

-(NSNumber*)addToNumber:(NSNumber*)otherNum
{	return [NSNumber numberWithDouble:([self doubleValue] + [otherNum doubleValue])];	}

@end		//	NSNumber(StandardDigest)
