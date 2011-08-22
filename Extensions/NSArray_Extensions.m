/*
    NSArray_Extensions.m
    Copyright (c) 2001-2006, Apple Computer, Inc., all rights reserved.
    Author: Chuck Pisula

    Milestones:
    * 03-01-2001: Initial creation by Chuck Pisula

    NSArray and NSMutableArray categories (PMSExtensions).
*/

/*
 IMPORTANT:  This Apple software is supplied to you by Apple Computer, Inc. ("Apple") in
 consideration of your agreement to the following terms, and your use, installation, 
 modification or redistribution of this Apple software constitutes acceptance of these 
 terms.  If you do not agree with these terms, please do not use, install, modify or 
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and subject to these 
 terms, Apple grants you a personal, non-exclusive license, under Apple’s copyrights in 
 this original Apple software (the "Apple Software"), to use, reproduce, modify and 
 redistribute the Apple Software, with or without modifications, in source and/or binary 
 forms; provided that if you redistribute the Apple Software in its entirety and without 
 modifications, you must retain this notice and the following text and disclaimers in all 
 such redistributions of the Apple Software.  Neither the name, trademarks, service marks 
 or logos of Apple Computer, Inc. may be used to endorse or promote products derived from 
 the Apple Software without specific prior written permission from Apple. Except as expressly
 stated in this notice, no other rights or licenses, express or implied, are granted by Apple
 herein, including but not limited to any patent rights that may be infringed by your 
 derivative works or by other works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO WARRANTIES, 
 EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, 
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS 
 USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL 
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS 
 OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, 
 REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND 
 WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR 
 OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "NSArray_Extensions.h"
#import "NSString_Extensions.h"
//#import "pmsCFUtility.h"
#import "pmsNSUtility.h"

@implementation NSArray (PMSExtensions)

-(BOOL)containsObjectIdenticalTo: (id)obj { 
    return [self indexOfObjectIdenticalTo: obj]!=NSNotFound; 
}

-(NSArray*)arrayOfURLsFromPaths
{
	NSInteger		pathCount = [self count];
	NSInteger		index = 0;
	NSMutableArray*	urlArray = [NSMutableArray arrayWithCapacity:pathCount];
	NSURL*			workURL = nil;
	NSArray*		outArray = nil;
	
	//	Create array of urls from array of paths
	for( index=0; index < pathCount; index++ ) {
		workURL = [[NSURL alloc] initFileURLWithPath:[self objectAtIndex:index]];
		if( workURL )
			[urlArray addObject:workURL];
	}
	
	outArray = [NSArray arrayWithArray:urlArray];
	return outArray;
}

-(NSArray*)arrayOfPathsFromURLs
{
	NSInteger		pathCount = [self count];
	NSInteger		index = 0;
	NSMutableArray*	urlArray = [NSMutableArray arrayWithCapacity:pathCount];
	NSString*		workString = nil;
	NSArray*		outArray = nil;
	
	//	Create array of urls from array of paths
	for( index=0; index < pathCount; index++ ) {
		workString = [[NSString alloc] initWithString:[[self objectAtIndex:index] path]];
		if( workString )
			[urlArray addObject:workString];
	}
	
	outArray = [NSArray arrayWithArray:urlArray];
	return outArray;
}

-(NSArray*)arrayOfPathsThatConformToUTIs:(NSArray*)theUTIs resultsAsURL:(BOOL)saveURLs
{
	NSArray*			outArray = nil;
	NSMutableArray*		workArray = [[NSMutableArray alloc] initWithCapacity:0];
	NSEnumerator*		workEnum = [self objectEnumerator];
	NSString*			workPath = nil;
	NSURL*				workURL = nil;
	
	if( workArray != nil )
	{
		while ( (workPath = (NSString*)[workEnum nextObject]) ) {
			workURL = [NSURL fileURLWithPath:workPath];
			if( workURL != nil )
				if( CFURLConfromsToUTIs( kCFAllocatorDefault, (CFURLRef)workURL, (CFArrayRef)theUTIs, NULL ) )
					[workArray addObject:( saveURLs == YES ) ? workURL : [NSString stringWithString:workPath]];
		}
	
		outArray = [NSArray arrayWithArray:workArray];
		[workArray release];
	}
	
	return outArray;
}

-(id)randomObject
{
	id			outObject = nil;
	float		randFloat = ( random() / (pow(2, 31) - 1) );
	NSInteger	selfCount = [self count];
	NSInteger	randIndex = randFloat * selfCount;
	
	if( randIndex == selfCount )
		randIndex--;
	
	if( selfCount > 0 )
		outObject = [self objectAtIndex:randIndex];
	
	return outObject;
}

-(NSString*)md5String
{
	NSEnumerator*		infoEnum = [self objectEnumerator];
	id					infoItem = nil;
	NSMutableString*	infoString = [NSMutableString stringWithString:@""];
	
	while ( (infoItem = [infoEnum nextObject]) ) 
		[infoString appendString:[infoItem md5String]];
	
	return [infoString md5String];
}

@end		//	NSArray(PMSExtensions)

@implementation NSDictionary(StandardDigest)

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


@implementation NSNumber(StandardDigest)

+(NSNumber*)zero
	{	return [NSNumber numberWithInt:0];	}

-(NSString*)md5String
	{	return [[self stringValue] md5String];	}

-(NSNumber*)addToNumber:(NSNumber*)otherNum
	{	return [NSNumber numberWithDouble:([self doubleValue] + [otherNum doubleValue])];	}

@end		//	NSNumber(StandardDigest)

