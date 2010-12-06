//
//  pmsNSUtility.m
//  PDFGarden
//
//  Created by Dave Carlton on 09/24/10.
//  Copyright 2010 PolyMicro Systems. All rights reserved.
//

#import "pmsNSUtility.h"

#define QUERY_DO(query) static NSString *query = @""
#define QUERY_END @"";

/*
 QUERY_DO(query)
 
 "UPDATE settings SET       "
 "  username            = ?,"
 "  password            = ?,"
 "  last_sync           = ?,"
 "  selected_feed       = ?,"
 "  selected_feed_type  = ?,"
 "  selected_entry      = ?,"
 "  selected_view       = ? "
 
 QUERY_END
 */

@interface NSObject (PMExtension)

- (NSString *)singleLineDescription;

@end


@implementation NSObject (PMExtension)

- (NSString *)singleLineDescription
{
    return [[[self description] componentsSeparatedByString:@"\n"] componentsJoinedByString:@" "];
}

/*
 Every class that descends from NSObject will respond to the singleLineDescription method.  
 For example, I sometimes find small arrays and dictionaries are easier to read when they're logged on a single line:
 
 NSArray *testArray = [NSArray arrayWithObjects:@"aaa", @"bbb", @"ccc", nil];
 NSLog(@"+++ testArray -- %@", testArray);
 NSLog(@"+++ single line -- %@", [testArray singleLineDescription]);
 
 NSDictionary *testDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
 @"one", @"1",
 @"two", @"2",
 @"three", @"3",
 nil];
 NSLog(@"+++ testDictionary -- %@", testDictionary);
 NSLog(@"+++ single line -- %@", [testDictionary singleLineDescription]);
 */

@end

@implementation PMNSUtility

@end

BOOL			BooleanToBOOL(Boolean	inBoolean)
{ return (inBoolean == TRUE) ? YES : NO; }

Boolean			BOOLToBoolean(BOOL		inBool)
{ return(inBool == YES ); }

CFBooleanRef	BooleanToCFBoolean(Boolean	inBoolean)
{ return( (inBoolean == TRUE) ? kCFBooleanTrue : kCFBooleanFalse ); }

CFBooleanRef	BOOLToCFBoolean(BOOL	inBool)
{ return( (inBool == YES) ? kCFBooleanTrue : kCFBooleanFalse ); }

BOOL			CFBooleanToBOOL(CFBooleanRef inCFBoolean)
{ return( BooleanToBOOL(CFBooleanGetValue(inCFBoolean)) ); }

Boolean			CFBooleanToBoolean(CFBooleanRef inCFBoolean)
{ return( CFBooleanGetValue(inCFBoolean) ); }

CFBooleanRef	NSNumberToCFBoolean(NSNumber*	inNSNum)
{ return( BOOLToCFBoolean([inNSNum boolValue]) ); }

NSNumber*		CFBooleanToNSNumber(CFBooleanRef inCFBoolean)
{ return [NSNumber numberWithBool:CFBooleanToBOOL(inCFBoolean)]; }


