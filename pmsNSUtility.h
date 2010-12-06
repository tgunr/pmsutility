//
//  pmsNSUtility.h
//  PDFGarden
//
//  Created by Dave Carlton on 09/24/10.
//  Copyright 2010 PolyMicro Systems. All rights reserved.
//

#import <Cocoa/Cocoa.h>


BOOL			BooleanToBOOL		(Boolean		inBoolean);
Boolean			BOOLToBoolean		(BOOL			inBool);
CFBooleanRef	BooleanToCFBoolean	(Boolean		inBoolean);
CFBooleanRef	BOOLToCFBoolean		(BOOL			inBool);
BOOL			CFBooleanToBOOL		(CFBooleanRef	inCFBoolean);
Boolean			CFBooleanToBoolean	(CFBooleanRef	inCFBoolean);
CFBooleanRef	NSNumberToCFBoolean	(NSNumber*		inNSNum);
NSNumber*		CFBooleanToNSNumber	(CFBooleanRef	inCFBoolean);

