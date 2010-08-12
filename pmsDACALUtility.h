/*
 *  pmsDACALUtility.h
 *  PickADisc
 *
 *  Created by Jack Small on 7/16/08.
 *  Copyright 2008 polyMicro Systems. All rights reserved.
 *
 */

#import <Cocoa/Cocoa.h>
#import <CoreFoundation/CoreFoundation.h>
#import "dacallib.h"

#ifndef _pmsDACALUtility
OSStatus		DACALRegisterIconResource( CFStringRef theIconFile, OSType theIconType );
NSImage*		DACALGetIconImageForType( OSType	theType );
IconRef			DACALGetIconRefForType( int	theType );


Boolean			CFURLIsCarousel( CFURLRef url );
Boolean			CFURLIsSlot( CFURLRef url );
Boolean			CFURLIsTopInSlot( CFAllocatorRef inAllocator, CFURLRef url );
DACALDeviceRef	CFURLCopyCarouselUUID(  CFAllocatorRef inAllocator, CFURLRef url );
DACALSlotNum	CFURLGetSlotNumber( CFURLRef url, Boolean onlySlotFolders );
IconRef			CFURLGetIcon( CFAllocatorRef allocator, CFURLRef url, OSStatus* outError );
NSImage*		CFURLGetIconAsNSImageAtSize( CFAllocatorRef allocator, CFURLRef url, NSSizePointer newSize, OSStatus* outError );
NSImage*		CFURLGetIconAsNSImage( CFAllocatorRef allocator, CFURLRef url, OSStatus* outError );
BOOL			CFURLSetIconFromNSImage( CFAllocatorRef allocator, CFURLRef url, NSImage* theImage );

Boolean			CFURLIsVisible( CFURLRef url );
CFStringRef		CFURLCopyDisplayName( CFAllocatorRef allocator, CFURLRef url, OSStatus* outError );
CFStringRef		CFURLCopyActualName( CFAllocatorRef allocator, CFURLRef url, OSStatus* outError );
CFDateRef		CFURLCopyDateSlotAdded( CFAllocatorRef inAllocator, CFURLRef url, SInt32* outError );
CFStringRef		CFURLCopyItemFlavor( CFURLRef url, OSStatus* outError );
OSStatus		CFURLSetItemFlavor( CFURLRef url, CFStringRef newFlavor );

CFStringRef		CFURLCopyReferenceTitle( CFAllocatorRef inAllocator, CFURLRef url, OSStatus* outError );
OSStatus		CFURLSetReferenceTitle( CFURLRef url, CFStringRef newTitle );

BOOL			BooleanToBOOL		(Boolean		inBoolean);
Boolean			BOOLToBoolean		(BOOL			inBool);
CFBooleanRef	BooleanToCFBoolean	(Boolean		inBoolean);
CFBooleanRef	BOOLToCFBoolean		(BOOL			inBool);
BOOL			CFBooleanToBOOL		(CFBooleanRef	inCFBoolean);
Boolean			CFBooleanToBoolean	(CFBooleanRef	inCFBoolean);
CFBooleanRef	NSNumberToCFBoolean	(NSNumber*		inNSNum);
NSNumber*		CFBooleanToNSNumber	(CFBooleanRef	inCFBoolean);

#endif