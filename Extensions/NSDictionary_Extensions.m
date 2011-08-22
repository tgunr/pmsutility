//
//  NSDictionary_Extensions.m
//  PMSUtility
//
//  Created by Dave Carlton on 08/01/11.
//  Copyright 2011 Polymicro Systems. All rights reserved.
//

#import "NSDictionary_Extensions.h"
#import "NSString_Extensions.h"
#import "NSNumber_Extensions.h"
#import "pmsCFUtility.h"
#import "pmsNSUtility.h"

@implementation NSDictionary(PMSExtensions)

-(NSString*)md5String
{
	NSEnumerator*		infoEnum = [self keyEnumerator];
	NSString*			infoKey = nil;
	id					infoItem = nil;
	NSMutableString*	infoString = [NSMutableString stringWithString:@""];
	
	while ( (infoKey = [infoEnum nextObject]) ) {
		infoItem = [self objectForKey:infoKey];
		if( CFGetTypeID((CFTypeRef)infoItem) == CFBooleanGetTypeID() )
			[infoString appendString:[CFBooleanToNSNumber((CFBooleanRef)infoItem) md5String]];
		else if( CFGetTypeID((CFTypeRef)infoItem) == CFUUIDGetTypeID() )
			[infoString appendString:[(NSString*)CFUUIDCreateString(kCFAllocatorDefault,(CFUUIDRef)infoItem) md5String]];
		else if( CFGetTypeID((CFTypeRef)infoItem) == CFURLGetTypeID() )
			[infoString appendString:[(NSString*)CFURLGetString((CFURLRef)infoItem) md5String]];
		else [infoString appendString:[infoItem md5String]];
		[infoString appendString:[infoKey md5String]];
	}
    
	return [infoString md5String];
}

@end

@implementation NSMutableDictionary(PMSExtensions)

-(void)addEntryFromDictionary:(NSDictionary*)otherDict forKey:(id)otherKey
{
	id		otherValue = [otherDict objectForKey:otherKey];
	
	if( otherValue != nil )
		[self setObject:otherValue forKey:otherKey];
}

@end		//	NSMutableDictionary(PMSExtensions)


