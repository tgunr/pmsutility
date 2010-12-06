//
//  pmsNSUtility.m
//  PDFGarden
//
//  Created by Dave Carlton on 09/24/10.
//  Copyright 2010 PolyMicro Systems. All rights reserved.
//

#import "pmsNSUtility.h"


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


