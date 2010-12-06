/*
 *  pmsCFUtility.h
 *  PickADisc
 *
 *  Created by Jack Small on 7/16/08.
 *  Copyright 2008 Polymicrosystems. All rights reserved.
 *
 */

#include <ApplicationServices/ApplicationServices.h>
#include <CoreFoundation/CoreFoundation.h>

#ifndef _pmsCFUtility

extern OSStatus		FSPathSetXattr( UInt8* pathText, CFStringRef inKeyName, CFStringRef inKeyValue );
extern size_t		FSPathGetXattrSize( UInt8* pathText, CFStringRef inKeyName );
extern CFStringRef	FSPathCopyXattr( CFAllocatorRef inAllocator, UInt8* pathText, CFStringRef inKeyName, OSStatus* outError );

extern OSStatus		CFURLSetXattr( CFURLRef inURL, CFStringRef inKeyName, CFStringRef inKeyValue );
extern size_t		CFURLGetXattrSize( CFURLRef inURL, CFStringRef inKeyName );
extern CFStringRef	CFURLCopyXattr( CFAllocatorRef inAllocator, CFURLRef inURL, CFStringRef inKeyName, OSStatus* outError );

extern OSStatus		FSSetXattr( FSRef* inLocation, CFStringRef inKeyName, CFStringRef inKeyValue );
extern size_t		FSGetXattrSize( FSRef* inLocation, CFStringRef inKeyName );
extern CFStringRef	FSCopyXattr( CFAllocatorRef inAllocator, FSRef* inLocation, CFStringRef inKeyName, OSStatus* outError );

extern OSStatus				FSSetXattrProperty( CFAllocatorRef inAllocator, FSRef* inLocation, CFStringRef inKeyName, CFPropertyListRef inKeyValue );
extern CFPropertyListRef	FSCopyXattrProperty( CFAllocatorRef inAllocator, FSRef* inLocation, CFStringRef inKeyName, OSStatus* outError );

extern char*		CFStringCreateCString( CFStringRef theString, CFStringEncoding theEncoding );
extern CFStringRef	CFStringCreateFromCommandPipe( CFAllocatorRef inAllocator, CFURLRef inCommandURL, CFStringRef inCommandArgs, OSStatus* outError );

extern CFStringRef	CFBundleRunShellScript( CFAllocatorRef inAllocator, CFBundleRef inBundle, CFStringRef inScriptName, CFStringRef inScriptArgs, OSStatus* outError );

//
// WARNING: The CFStringSpeak function leaks theWords of each call because no copy is made and
// it creates a speach channel that never gets destroyed, although it is reused, if no channel is specified.
//

OSErr				CFStringSpeak( CFStringRef theWords, Boolean interrupt, SpeechChannel onChannel );

CFDateRef	CFURLCopyDateAccessed( CFAllocatorRef inAllocator, CFURLRef url, SInt32* outError );
CFDateRef	CFURLCopyDateCreated( CFAllocatorRef inAllocator, CFURLRef url, SInt32* outError );
CFDateRef	CFURLCopyDateModified( CFAllocatorRef inAllocator, CFURLRef url, SInt32* outError );
CFStringRef	CFURLCopyUTI( CFAllocatorRef inAllocator, CFURLRef inURL, OSStatus*	outError );
Boolean		CFURLConfromsToUTIs( CFAllocatorRef inAllocator, CFURLRef testURL, CFArrayRef inUTIs, OSStatus* outError );

Boolean		CFAbsoluteTimeBetweenTimes( CFAbsoluteTime lowTime, CFAbsoluteTime unknownTime, CFAbsoluteTime hiTime );


CFDataRef	CFDataCreateMD5Digest( CFAllocatorRef inAllocator, CFDataRef inData );
CFDataRef	CFDataCreateSHA1Digest( CFAllocatorRef inAllocator, CFDataRef inData );
CFDataRef	CFStringCreateMD5Digest( CFAllocatorRef inAllocator, CFStringRef inString );
CFDataRef	CFStringCreateSHA1Digest( CFAllocatorRef inAllocator, CFStringRef inString );

CFStringRef	CFDataCreateHexString( CFAllocatorRef inAllocator, CFDataRef inData );
CFDataRef	CFStringCreateDataForHex( CFAllocatorRef inAllocator, CFStringRef inHexString );

#endif



