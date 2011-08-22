//
//  NSMutableArray_Extensions.m
//  pmsutility
//
//  Created by Dave Carlton on 07/20/11.
//  Copyright 2011 Polymicro Systems. All rights reserved.
//

#import "NSMutableArray_Extensions.h"

@implementation NSMutableArray (MyExtensions)

-(void)insertObjectsFromArray:(NSArray *)array atIndex:(NSInteger)index
{
	id				entry = nil;
	NSEnumerator*	enumerator = [array objectEnumerator];
	
	while ( (entry = [enumerator nextObject]) ) 
		[self insertObject:entry atIndex:index++];
}

-(id)reverseObjects
{
	NSInteger	arrayIndex, arrayCount = [self count] / 2;
	NSInteger	arrayOut = [self count] -1;
	
	for( arrayIndex=0; arrayIndex < arrayCount; arrayIndex++ )
		[self exchangeObjectAtIndex:arrayIndex withObjectAtIndex:arrayOut-arrayIndex];
	
	return self;
}

-(id)insertUniqueObjectsFromArray:(NSArray*)newArray atIndex:(NSInteger)index
{
	NSEnumerator*	newEnum = [newArray objectEnumerator];
	id				newItem = nil;
	
	while ( (newItem = [newEnum nextObject]) )
		if( [self indexOfObject:newItem] == NSNotFound )
			[self insertObject:newItem atIndex:index++];
	
	return self;
}

-(id)addUniqueObjectsFromArray:(NSArray*)newArray
{ return [self insertUniqueObjectsFromArray:newArray atIndex:[self count]]; }

@end		//	NSMutableArray (MyExtensions)

