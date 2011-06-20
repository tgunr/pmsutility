//
//  NSApplication_Extensions.m
//
//  Created by PolyMicro Systems on 7/14/08.
//  Copyright 2008 PolyMicro Systems. All rights reserved.
//

#import <PMSUtility/NSApplication_Extensions.h>
#import "pmsCFUtility.h"

/*
@implementation NSApplication(MyExtensions)

- (id)addVolumeController { return addVolumeController; }
- (void)setAddVolumeController:(id)inAVC
{
	addVolumeController = [inAVC retain];
//    if (!addVolumeController || ![addVolumeController isEqual:inAVC]) {
//		[addVolumeController release];
//		addVolumeController = [inAVC retain];
//    }
}
@end
*/

const	time_t	kTimeOneDayInSeconds = 86400.0;

@implementation NSDate(MyExtensions)

+(NSDate*)tomorrow
{ return [[NSDate date] addTimeInterval:kTimeOneDayInSeconds]; }

+(NSDate*)yesterday
	{ return [[NSDate date] addTimeInterval:-kTimeOneDayInSeconds]; }

-(BOOL)isBetweenStartDate:(NSDate*)startDate andEndDate:(NSDate*)endDate
{
	BOOL	isBetween = NO;
	
	NSDate*	lowDate = startDate;
	NSDate*	hiDate = endDate;
	
	if( [lowDate compare:hiDate] != NSOrderedAscending )
	{
		lowDate = endDate;
		endDate = startDate;
	}
	
	if( [self compare:lowDate] != NSOrderedAscending )
		if( [self compare:hiDate] != NSOrderedDescending )
			isBetween = YES;
	
	return isBetween;
}

-(NSString*)formatDateString:(NSString*)dateFormat useNatural:(BOOL)doNatural
{
	NSString*			outDateString = nil;
	NSDateFormatter*	formatFormatter = nil;
	
	if( doNatural == YES )
		formatFormatter = [[NSDateFormatter alloc] initWithDateFormat:dateFormat allowNaturalLanguage:doNatural];
	else 
	{
		formatFormatter = [[NSDateFormatter alloc] init];
		[formatFormatter setDateFormat:dateFormat];
	}
	
	if( formatFormatter != nil )
		outDateString = [formatFormatter stringFromDate:self];
	
	return outDateString;
}

-(NSString*)naturalDateString
	{	return [self formatDateString:@"%c" useNatural:YES];	}

-(NSString*)shorterDateString
{	return [self formatDateString:@"MMM d, yyyy h:mm a" useNatural:NO];	}

-(NSString*)longerDateString
{	return [self formatDateString:@"EEEE, MMMM d, yyyy h:mm a, z" useNatural:NO];	}


/*{
	NSString*			outDateString = nil;
	NSDateFormatter*	naturalFormatter = [[NSDateFormatter alloc] initWithDateFormat:@"%c" allowNaturalLanguage:YES];
	
	if( naturalFormatter != nil )
		outDateString = [naturalFormatter stringFromDate:self];
	
	return outDateString;
}
*/

// if other == nil then the current time is used.
// if other = @"Yesterday" then yesterday is used.
// else other = NSDate* 

-(float)rankWithDate:(id)other withOptions:(NSMutableDictionary*)options
{
	CFDateRef	ourDate = (CFDateRef)self;
	
	CFAbsoluteTime  distantTime = (ourDate!=NULL) ? CFDateGetAbsoluteTime(ourDate) : 0.0;
	CFAbsoluteTime	anchorTime = 0.0;
	CFAbsoluteTime	limitTime = 0.0;
	float			rank = 0.0;
	NSString*		whichKind = nil;
	
	whichKind = (NSString*)[options objectForKey:@"Range"];
	
	if( [whichKind isEqual:@"Day Count"] ) {
		CFTimeInterval	dayCount = [[options objectForKey:@"Days"] doubleValue];
		CFTimeInterval	daySeconds = dayCount * 86400;
		
		if( other == nil ) other = [NSDate date];
		if( ([other isKindOfClass:[NSString class]] ) && ([(NSString *)other compare:@"Yesterday"] == NSOrderedSame) )
			other = [NSDate yesterday];
		
		if( (other != nil) && (ourDate != nil) )
		{
			anchorTime = CFDateGetAbsoluteTime((CFDateRef)other);
			limitTime = anchorTime + daySeconds;
			//otherDate = (CFDateRef)[(NSDate*)other addTimeInterval:(NSTimeInterval)daySeconds];
			
			//timeBetween = CFDateGetTimeIntervalSinceDate( ourDate, otherDate );
			if( CFAbsoluteTimeBetweenTimes( limitTime, distantTime, anchorTime ) )
				rank = (anchorTime-distantTime)/daySeconds;
			if( rank < 0.0 ) rank = -rank;
		}
	}	
	
	// if( rank )
	//	NSLog(@"Search distantDate:%f anchorDate:%f limitDate:%f  rank:%f", distantTime, anchorTime, limitTime, rank );
	
	return( rank );
}


@end		//NSDate(MyExtensions)