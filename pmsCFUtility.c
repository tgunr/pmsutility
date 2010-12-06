/*
 *  pmsCFUtility.c
 *  PickADisc
 *
 *  Created by Jack Small on 7/16/08.
 *  Copyright 2008 polyMicro Systems. All rights reserved.
 *
 */

#import "pmsCFUtility.h"
#include <sys/xattr.h>
#include <sys/stat.h>
#include <sys/errno.h>

// MD5 includes
#include <openssl/evp.h>
#include <openssl/err.h>

OSStatus		FSPathSetXattr( UInt8* pathText, CFStringRef inKeyName, CFStringRef inKeyValue )
{
	OSStatus		outResult = -1;
	const char*		keyText = CFStringCreateCString(inKeyName, kCFStringEncodingUTF8);
	void*			keyValue = NULL;
	size_t			keyValueSize = 0;
	
	if( pathText == NULL ) goto EXIT;
	if( keyText == NULL ) goto EXIT;
	
	if( inKeyValue == NULL ) {
		if( removexattr( (const char *)pathText, keyText, 0 ) == -1 ) outResult = errno;
		else outResult = 0;
		goto EXIT;
	}
	
	keyValue = CFStringCreateCString(inKeyValue, kCFStringEncodingUTF8);
	keyValueSize = strlen((const char*)keyValue);
	
	if( setxattr( (const char *)pathText, keyText, keyValue, keyValueSize, 0, 0 ) == -1 ) outResult = errno;
	else outResult = 0;
	
EXIT:
	if( keyText != NULL ) free( (void*)keyText );
	if( keyValue != NULL ) free( keyValue );
	
	return outResult;	
}

size_t			FSPathGetXattrSize( UInt8* pathText, CFStringRef inKeyName )
{
	const char*		keyText = CFStringCreateCString(inKeyName, kCFStringEncodingUTF8);
	size_t			keyValueSize = 0;
	
	if( keyText == NULL ) return keyValueSize;
	
	if( pathText != NULL ) 
		keyValueSize = getxattr( (const char *)pathText, keyText, NULL, 0, 0, 0 );
	
	free( (void*)keyText );
	return keyValueSize;
}


CFStringRef		FSPathCopyXattr( CFAllocatorRef inAllocator, UInt8* pathText, CFStringRef inKeyName, OSStatus* outError )
{
	OSStatus		outResult = -1;
	const char*		keyText = CFStringCreateCString(inKeyName, kCFStringEncodingUTF8);
	void*			keyValue = NULL;
	size_t			keyValueSize = 0;
	
	CFStringRef		keyValueString = NULL;
	
	if( pathText == NULL ) goto EXIT;
	if( keyText == NULL ) goto EXIT;
	
	keyValueSize = getxattr( (const char *)pathText, keyText, NULL, 0, 0, 0 );
	if( keyValueSize == -1 ) goto EXIT;
	
	keyValue = (UInt8*)calloc( 1, keyValueSize+1 );
	if( keyValue == NULL) goto EXIT;
	
	keyValueSize = getxattr( (const char *)pathText, keyText, keyValue, keyValueSize, 0, 0 );
	if( keyValueSize == -1 ) goto EXIT;
	
	keyValueString = CFStringCreateWithBytes( inAllocator, (const UInt8*)keyValue, (CFIndex)keyValueSize, kCFStringEncodingUTF8, FALSE );
	if( keyValueString != NULL ) outResult = 0;
	
EXIT:
	if( keyText != NULL ) free( (void*)keyText );
	if( keyValue != NULL ) free( keyValue );
	
	if( outError != NULL ) *outError = outResult;
	return keyValueString;	
}

OSStatus		CFURLSetXattr( CFURLRef inURL, CFStringRef inKeyName, CFStringRef inKeyValue )
{
	UInt8			pathText[4096];
	Boolean			goodPath = FALSE;
	OSStatus		outResult = -1;
	const char*		keyText = CFStringCreateCString(inKeyName, kCFStringEncodingUTF8);
	void*			keyValue = NULL;
	size_t			keyValueSize = 0;

	if( keyText == NULL ) goto EXIT;

	goodPath = CFURLGetFileSystemRepresentation( inURL, TRUE, (UInt8*)&pathText, 4096 );
	if( !goodPath ) goto EXIT;

	if( inKeyValue == NULL ) {
		if( removexattr( (const char *)&pathText, keyText, 0 ) == -1 ) outResult = errno;
		else outResult = 0;
		goto EXIT;
	}
	
	keyValue = CFStringCreateCString(inKeyValue, kCFStringEncodingUTF8);
	keyValueSize = strlen((const char*)keyValue);
	
	if( setxattr( (const char *)&pathText, keyText, keyValue, keyValueSize, 0, 0 ) == -1 ) outResult = errno;
	else outResult = 0;
	
EXIT:
	if( keyText != NULL ) free( (void*)keyText );
	if( keyValue != NULL ) free( keyValue );
	
	return outResult;	
}

size_t			CFURLGetXattrSize( CFURLRef inURL, CFStringRef inKeyName )
{
	UInt8			pathText[4096];
	const char*		keyText = CFStringCreateCString(inKeyName, kCFStringEncodingUTF8);
	size_t			keyValueSize = 0;
	
	if( keyText == NULL ) return keyValueSize;
	
	if( CFURLGetFileSystemRepresentation( inURL, TRUE, (UInt8*)&pathText, 4096 ) ) 
		keyValueSize = getxattr( (const char *)&pathText, keyText, NULL, 0, 0, 0 );
	
	free( (void*)keyText );
	return keyValueSize;
}

CFStringRef		CFURLCopyXattr( CFAllocatorRef inAllocator, CFURLRef inURL, CFStringRef inKeyName, OSStatus* outError )
{
	UInt8			pathText[4096];
	Boolean			goodPath = FALSE;
	OSStatus		outResult = -1;
	const char*		keyText = CFStringCreateCString(inKeyName, kCFStringEncodingUTF8);
	void*			keyValue = NULL;
	size_t			keyValueSize = 0;
	
	CFStringRef		keyValueString = NULL;
	
	if( keyText == NULL ) goto EXIT;

	goodPath = CFURLGetFileSystemRepresentation( inURL, TRUE, (UInt8*)&pathText, 4096 );
	if( !goodPath ) goto EXIT;

	keyValueSize = getxattr( (const char *)&pathText, keyText, NULL, 0, 0, 0 );
	if( keyValueSize == -1 ) goto EXIT;
	
	keyValue = (UInt8*)calloc( 1, keyValueSize+1 );
	if( keyValue == NULL) goto EXIT;
	
	keyValueSize = getxattr( (const char *)&pathText, keyText, keyValue, keyValueSize, 0, 0 );
	if( keyValueSize == -1 ) goto EXIT;
	
	keyValueString = CFStringCreateWithBytes( inAllocator, (const UInt8*)keyValue, (CFIndex)keyValueSize, kCFStringEncodingUTF8, FALSE );
	if( keyValueString != NULL ) outResult = 0;
	
EXIT:
	if( keyText != NULL ) free( (void*)keyText );
	if( keyValue != NULL ) free( keyValue );
	
	if( outError != NULL ) *outError = outResult;
	return keyValueString;	
}

OSStatus		FSSetXattr( FSRef* inLocation, CFStringRef inKeyName, CFStringRef inKeyValue )
{
	UInt8			pathText[4096];
	Boolean			goodPath = FALSE;
	OSStatus		outResult = -1;
	const char*		keyText = CFStringCreateCString(inKeyName, kCFStringEncodingUTF8);
	void*			keyValue = NULL;
	size_t			keyValueSize = 0;
	
	if( keyText == NULL ) goto EXIT;
	
	goodPath = (Boolean)(FSRefMakePath( inLocation, (UInt8*)&pathText, 4096 ) == 0);
	if( !goodPath ) goto EXIT;
	
	if( inKeyValue == NULL ) {
		if( removexattr( (const char *)&pathText, keyText, 0 ) == -1 ) outResult = errno;
		else outResult = 0;
		goto EXIT;
	}
	
	keyValue = CFStringCreateCString(inKeyValue, kCFStringEncodingUTF8);
	keyValueSize = strlen((const char*)keyValue);
	
	if( setxattr( (const char *)&pathText, keyText, keyValue, keyValueSize, 0, 0 ) == -1 ) outResult = errno;
	else outResult = 0;
	
EXIT:
	if( keyText != NULL ) free( (void*)keyText );
	if( keyValue != NULL ) free( keyValue );
	
	return outResult;	
}

size_t			FSGetXattrSize( FSRef* inLocation, CFStringRef inKeyName )
{
	UInt8			pathText[4096];
	const char*		keyText = CFStringCreateCString(inKeyName, kCFStringEncodingUTF8);
	size_t			keyValueSize = 0;
	
	if( keyText == NULL ) return keyValueSize;
	
	if( (FSRefMakePath( inLocation, (UInt8*)&pathText, 4096 )) == 0 )
		keyValueSize = getxattr( (const char *)&pathText, keyText, NULL, 0, 0, 0 );
	
	free( (void*)keyText );
	return keyValueSize;
}

CFStringRef		FSCopyXattr( CFAllocatorRef inAllocator, FSRef* inLocation, CFStringRef inKeyName, OSStatus* outError )
{
	UInt8			pathText[4096];
	Boolean			goodPath = FALSE;
	OSStatus		outResult = -1;
	const char*		keyText = CFStringCreateCString(inKeyName, kCFStringEncodingUTF8);
	void*			keyValue = NULL;
	size_t			keyValueSize = 0;
	
	CFStringRef		keyValueString = NULL;
	
	if( keyText == NULL ) goto EXIT;

	goodPath = (Boolean)(FSRefMakePath( inLocation, (UInt8*)&pathText, 4096 ) == 0);
	if( !goodPath ) goto EXIT;
	
	keyValueSize = getxattr( (const char *)&pathText, keyText, NULL, 0, 0, 0 );
	if( keyValueSize == -1 ) goto EXIT;
	
	keyValue = (UInt8*)calloc( 1, keyValueSize+1 );
	if( keyValue == NULL) goto EXIT;
	
	keyValueSize = getxattr( (const char *)&pathText, keyText, keyValue, keyValueSize, 0, 0 );
	if( keyValueSize == -1 ) goto EXIT;
	
	keyValueString = CFStringCreateWithBytes( inAllocator, (const UInt8*)keyValue, (CFIndex)keyValueSize, kCFStringEncodingUTF8, FALSE );
	if( keyValueString != NULL ) outResult = 0;
	
EXIT:
	if( keyText != NULL ) free( (void*)keyText );
	if( keyValue != NULL ) free( keyValue );
	
	if( outError != NULL ) *outError = outResult;
	return keyValueString;	
}

OSStatus		FSSetXattrProperty( CFAllocatorRef inAllocator, FSRef* inLocation, CFStringRef inKeyName, CFPropertyListRef inKeyValue )
{
	OSStatus	outStatus = -1;
	
	CFDataRef	workValue = NULL;
	CFStringRef	workString = NULL;
	
	if( CFPropertyListIsValid( inKeyValue, kCFPropertyListXMLFormat_v1_0 ) )
		workValue = CFPropertyListCreateXMLData( inAllocator, inKeyValue );
	
	if( workValue != NULL )
		workString = CFStringCreateWithBytes( inAllocator, CFDataGetBytePtr(workValue), CFDataGetLength(workValue), kCFStringEncodingUTF8, TRUE );
		
	if( workString != NULL )
		outStatus = FSSetXattr( inLocation, inKeyName, workString );
	
	return outStatus;
}

CFPropertyListRef	FSCopyXattrProperty( CFAllocatorRef inAllocator, FSRef* inLocation, CFStringRef inKeyName, OSStatus* outError )
{
	OSStatus			outStatus = -1;
	CFPropertyListRef	outValue = NULL;
	
	CFDataRef			workValue = NULL;
	CFStringRef			workString = NULL;
	CFStringRef			errorString = NULL;
	
	workString = FSCopyXattr( inAllocator, inLocation, inKeyName, outError );
	if( workString == NULL ) goto BAIL;

	workValue = CFStringCreateExternalRepresentation( inAllocator, workString, kCFStringEncodingUTF8, 0 );
	if( workValue == NULL ) goto BAIL;
	
	outValue = CFPropertyListCreateFromXMLData( inAllocator, workValue, kCFPropertyListMutableContainers, &errorString );
	
BAIL:
	if( errorString != NULL ) CFRelease( errorString );
	if( workString != NULL ) CFRelease( workString );
	if( workValue != NULL ) CFRelease( workValue );
	
	if( outError != NULL ) *outError = outStatus;
	return outValue;
}





char*			CFStringCreateCString( CFStringRef theString, CFStringEncoding theEncoding )
{
	char*		cstring;
	CFIndex			maxlen;
	Boolean			goodCoerce = FALSE;
	
	maxlen = CFStringGetMaximumSizeForEncoding( CFStringGetLength( theString ), theEncoding ) + 1;
	cstring = (char*)calloc( 1, maxlen );
	if( cstring != NULL ) goodCoerce = CFStringGetCString(theString, cstring, maxlen, theEncoding);
	if( !goodCoerce & (cstring != NULL) ) {
		free( cstring );
		cstring = NULL;
	}
	
	return( cstring );
}

static SpeechChannel g_CFUTILS_SYSTEM_SPEECHCHANNEL;

OSErr			CFStringSpeak( CFStringRef theWords, Boolean interrupt, SpeechChannel onChannel )
{
	if( g_CFUTILS_SYSTEM_SPEECHCHANNEL == NULL ) NewSpeechChannel( NULL, &g_CFUTILS_SYSTEM_SPEECHCHANNEL );
	if( g_CFUTILS_SYSTEM_SPEECHCHANNEL == NULL ) return( memFullErr );
	
	if( onChannel == NULL ) onChannel = g_CFUTILS_SYSTEM_SPEECHCHANNEL;
	
	OSErr				theErr;
	SInt32				theFlags = (interrupt) ? 0 : kNoSpeechInterrupt;
	char*				theText = NULL;
	unsigned long		theLength = 0;
	
	if( theWords != NULL ) {
		theText = CFStringCreateCString( theWords, kCFStringEncodingUTF8 );
		theLength = strlen( theText );
	}
	
	theErr = SpeakBuffer( onChannel, (const void*)theText, theLength, theFlags );
	//if(theErr != noErr) fprintf( stderr, "CFStringSpeak Error: %i", theErr );
	
	return theErr;
}

CFStringRef		CFStringCreateFromCommandPipe( CFAllocatorRef inAllocator, CFURLRef inCommandURL, CFStringRef inCommandArgs, OSStatus* outError )
{
	OSStatus		outResult = kIOReturnBadArgument;
	CFStringRef		outCFText = NULL;
//	CFStringRef		theCommand = CFSTR("carousel");
//	CFStringRef		errUnknown = CFSTR("carousel.sh:");
//	CFURLRef		commandURL = CFBundleCopyResourceURL( CFBundleGetMainBundle(), theCommand, CFSTR("sh"), NULL );
	CFStringRef		doCFCommand;
	char*			doCommand = NULL;
	char*			utf8Name = NULL;
	FILE*			pipe;
	int				pipeSize = 8192;
	
	
	if( inAllocator == NULL ) inAllocator = kCFAllocatorDefault;
	
	doCFCommand = CFStringCreateWithFormat(	inAllocator, NULL, CFSTR("\"%@\" %@"), inCommandURL, inCommandArgs );
	if( doCFCommand == NULL ) goto BAIL;
	
	//	NSLog( (NSString*)doCFCommand );
	
	doCommand = CFStringCreateCString( doCFCommand, kCFStringEncodingUTF8 );	
	if( doCommand == NULL ) goto BAIL;
	
	//	printf("Carousel command: %s", doCommand);
	
	utf8Name = (char*)calloc(1, pipeSize);
	if( doCommand == NULL ) goto BAIL;
	
	pipe = popen( doCommand, "r" );
	if ( pipe ) {
		pipeSize = fread( utf8Name, 1, pipeSize, pipe );
		outResult = pclose( pipe );
	}
	
	if( pipeSize > 2 ) {
		utf8Name[pipeSize-1] = 0;
		outCFText = CFStringCreateWithCString( inAllocator, utf8Name, kCFStringEncodingUTF8 );
		
//		if( CFStringHasPrefix( outCFText, errUnknown ) == TRUE ) {
//			CFRelease( outCFText );
//			outCFText = (CFStringRef)NULL;
//		}
	} 
	
BAIL:
	if( outError ) *outError = outResult;
	if( utf8Name ) free( utf8Name );
	if( doCFCommand ) CFRelease( doCFCommand );
	//	if( commandURL ) CFRelease( commandURL );
	//	if( commandPathURL ) CFRelease( commandPathURL );
	if( doCommand ) free( doCommand );
	return( outCFText );
}

CFStringRef	CFBundleRunShellScript( CFAllocatorRef inAllocator, CFBundleRef inBundle, CFStringRef inScriptName, CFStringRef inScriptArgs, OSStatus* outError )
{
	CFURLRef		scriptURL = CFBundleCopyResourceURL( inBundle, inScriptName, CFSTR("sh"), NULL );
	CFStringRef		resultString = NULL;
	
	if( scriptURL != NULL )
		resultString = CFStringCreateFromCommandPipe( inAllocator, scriptURL, inScriptArgs, outError );
	
	if( scriptURL ) CFRelease( scriptURL );
	return resultString;
}

CFDateRef	CFURLCopyDateModified( CFAllocatorRef inAllocator, CFURLRef url, SInt32* outError )
{
	CFDateRef			outDate = NULL;
	SInt32				outResult = 0;
	
	outDate = (CFDateRef)CFURLCreatePropertyFromResource( inAllocator, url, kCFURLFileLastModificationTime, &outResult );
	
	if( outError ) *outError = outResult;
	return( outDate );
}

// Time of file creation. Only set once when the file is created. 
// On filesystems where birthtime is not available, this returns the ctime (last inode data modification) instead.
// Some of this inspired by Darwin.  See http://www.opensource.apple.com/darwinsource/10.5.4/CF-476.14/CFFileUtilities.c
// Specifically _CFGetFileProperties()

CFDateRef	CFURLCopyDateCreated( CFAllocatorRef inAllocator, CFURLRef url, SInt32* outError )
{
	SInt32		theErr = kCFURLUnknownError;
	CFDateRef	outDate = (CFDateRef)NULL;
	
	Boolean		fileExists = FALSE;
    Boolean		isDirectory = FALSE;
		
    struct stat64	statBuf;
    char			path[4096];
	
	if (!CFURLGetFileSystemRepresentation( url, TRUE, (uint8_t *)path, 4096)) goto BAIL;
	
    if (stat64(path, &statBuf) != 0)
	{
        // stat failed, but why?
        if (errno == ENOENT) {
            fileExists = false;
			theErr = ENOENT;
        } else {
            theErr = errno;
			goto BAIL;
        }
    } else {
        fileExists = true;
        isDirectory = ((statBuf.st_mode & S_IFMT) == S_IFDIR);
    }
	
	if (fileExists)
	{
		CFAbsoluteTime theTime = (CFAbsoluteTime)statBuf.st_birthtimespec.tv_sec - kCFAbsoluteTimeIntervalSince1970;
	    theTime += (CFAbsoluteTime)statBuf.st_birthtimespec.tv_nsec / 1000000000.0;
		outDate = CFDateCreate( inAllocator, theTime );
		if( outDate ) theErr = 0;
	}
	
BAIL:
	if( outError ) *outError = theErr;
	return( outDate );
}

// Time when file data last accessed. Changed by the mknod(2) , utimes(2) and read(2) system calls.

CFDateRef	CFURLCopyDateAccessed( CFAllocatorRef inAllocator, CFURLRef url, SInt32* outError )
{
	SInt32		theErr = kCFURLUnknownError;
	CFDateRef	outDate = (CFDateRef)NULL;
	
	Boolean		fileExists = FALSE;
    Boolean		isDirectory = FALSE;
	
    struct stat64	statBuf;
    char			path[4096];
	
	if (!CFURLGetFileSystemRepresentation( url, TRUE, (uint8_t *)path, 4096)) goto BAIL;
	
    if (stat64(path, &statBuf) != 0)
	{
        // stat failed, but why?
        if (errno == ENOENT) {
            fileExists = false;
			theErr = ENOENT;
        } else {
            theErr = errno;
			goto BAIL;
        }
    } else {
        fileExists = true;
        isDirectory = ((statBuf.st_mode & S_IFMT) == S_IFDIR);
    }
	
	if (fileExists)
	{
		CFAbsoluteTime theTime = (CFAbsoluteTime)statBuf.st_atimespec.tv_sec - kCFAbsoluteTimeIntervalSince1970;
	    theTime += (CFAbsoluteTime)statBuf.st_atimespec.tv_nsec / 1000000000.0;
		outDate = CFDateCreate( inAllocator, theTime );
		if( outDate ) theErr = 0;
	}
	
BAIL:
	if( outError ) *outError = theErr;
	return( outDate );
}


CFStringRef	CFURLCopyUTI( CFAllocatorRef inAllocator, CFURLRef inURL, OSStatus*	outError )
{
	CFStringRef			outUTI = NULL;
	LSItemInfoRecord	theInfo;
	CFStringRef			theTag = NULL;
	OSStatus			theErr;
	
	
	theErr = LSCopyItemInfoForURL( inURL, kLSRequestExtension || kLSRequestTypeCreator, &theInfo );
	if( theErr != 0 ) goto BAIL;
	
	if( theInfo.extension != NULL )
		theTag = theInfo.extension;
	else
		theTag = UTCreateStringForOSType( theInfo.filetype );
	
	if( theTag == NULL ) {
		theErr = kCFURLUnknownError;
		goto BAIL;
	}
	
	outUTI = UTTypeCreatePreferredIdentifierForTag( kUTTagClassFilenameExtension, theTag, NULL );
	if( outUTI == NULL ) theErr = kCFURLUnknownError;
	
BAIL:
	if( theTag != NULL ) CFRelease( theTag );
	if( outError ) *outError = theErr;
	return outUTI;
}

Boolean		CFURLConfromsToUTIs( CFAllocatorRef inAllocator, CFURLRef testURL, CFArrayRef inUTIs, OSStatus* outError )
{
	Boolean		testResult = FALSE;
	CFIndex		testCount = CFArrayGetCount( inUTIs );
	CFIndex		testIndex = 0;
	CFStringRef	testUTI = CFURLCopyUTI( inAllocator, testURL, outError );
	CFStringRef	checkUTI = NULL;
	
	if( testUTI == NULL )
		testResult = FALSE;
	else
		for ( testIndex=0; testIndex < testCount; testIndex++ )
		{
			checkUTI = (CFStringRef)CFArrayGetValueAtIndex( inUTIs, testIndex );			
			if( checkUTI != NULL )
				if( UTTypeConformsTo( testUTI, checkUTI ) ) {
					testResult = TRUE;
					break;
				}
		}
	
	if( testUTI != NULL )
		CFRelease( testUTI );
	
	return testResult;
}


Boolean		CFAbsoluteTimeBetweenTimes( CFAbsoluteTime lowTime, CFAbsoluteTime unknownTime, CFAbsoluteTime hiTime )
{
	CFAbsoluteTime	actualLow = lowTime;
	CFAbsoluteTime	actualHi = hiTime;
	
	if( lowTime > hiTime ) {
		actualLow = hiTime;
		actualHi = lowTime;
	}
	
	return ( (actualLow <= unknownTime) && (unknownTime <=actualHi) );
}


//	Internal headers

CFDataRef	CFDataCreateEVPDigest( CFAllocatorRef inAllocator, CFDataRef inData, const EVP_MD* inDigestType );
CFDataRef	CFStringCreateEVPDigest( CFAllocatorRef inAllocator, CFStringRef inString, const EVP_MD* inDigestType );


CFDataRef	CFDataCreateEVPDigest( CFAllocatorRef inAllocator, CFDataRef inData, const EVP_MD* inDigestType )
{
	//	Compute an EVP digest
	//	See <openssl/evp.h> for details 
	
	EVP_MD_CTX mdctx;
	unsigned char md_value[EVP_MAX_MD_SIZE];
	unsigned int md_len;

	if( inData == NULL ) return (CFDataRef)NULL;
	
	EVP_DigestInit( &mdctx, inDigestType );
	EVP_DigestUpdate( &mdctx, CFDataGetBytePtr(inData), CFDataGetLength(inData) );
	EVP_DigestFinal( &mdctx, md_value, &md_len );
	return CFDataCreate( inAllocator, md_value, md_len );
}

CFDataRef	CFDataCreateMD5Digest( CFAllocatorRef inAllocator, CFDataRef inData )
{ return CFDataCreateEVPDigest( inAllocator, inData, EVP_md5() ); }

CFDataRef	CFDataCreateSHA1Digest( CFAllocatorRef inAllocator, CFDataRef inData )
{ return CFDataCreateEVPDigest( inAllocator, inData, EVP_sha1() ); }

CFDataRef	CFStringCreateEVPDigest( CFAllocatorRef inAllocator, CFStringRef inString, const EVP_MD* inDigestType )
{
	CFDataRef	theStringData = CFStringCreateExternalRepresentation( inAllocator, inString, kCFStringEncodingUTF8, 0 );
	CFDataRef	theDigest = NULL;
	
	if( theStringData == NULL )
		return theDigest;
	
	theDigest = CFDataCreateEVPDigest( inAllocator, theStringData, inDigestType );
	
	CFRelease( theStringData );
	return theDigest;
}

CFDataRef	CFStringCreateMD5Digest( CFAllocatorRef inAllocator, CFStringRef inString )
{ return CFStringCreateEVPDigest( inAllocator, inString, EVP_md5() ); }

CFDataRef	CFStringCreateSHA1Digest( CFAllocatorRef inAllocator, CFStringRef inString )
{ return CFStringCreateEVPDigest( inAllocator, inString, EVP_sha1() ); }


CFStringRef	CFDataCreateHexString( CFAllocatorRef inAllocator, CFDataRef inData )
{
	if( inData == (CFDataRef)NULL ) return (CFStringRef)NULL;
	
	CFStringRef			outString = NULL;
	const UInt8*		myBytes = CFDataGetBytePtr( inData );
	unsigned int		myLength = CFDataGetLength( inData );
	unsigned int		myIndex;
	CFMutableStringRef	workString = CFStringCreateMutable( inAllocator, myLength*2+1 );
	
	if( workString == NULL ) return outString;
	
	for (myIndex = 0; myIndex < myLength; myIndex++ )
		CFStringAppendFormat( workString, NULL, CFSTR("%02x"), myBytes[myIndex] );
	
	outString = CFStringCreateCopy( inAllocator, workString );
	
	CFRelease( outString );
	return outString;
}

CFDataRef	CFStringCreateDataForHex( CFAllocatorRef inAllocator, CFStringRef inHexString )
{
	CFDataRef			outData = NULL;
	CFIndex				myLength = CFStringGetLength( inHexString ) / 2;
	CFIndex				myIndex;
	CFRange				indexRange;
	UniChar				workValue[1] = { 0 };
	unsigned int		workResult = 0;
	CFMutableDataRef	workData = CFDataCreateMutable( inAllocator, myLength );
	
	if( workData == NULL ) return outData;
	
	for( myIndex=0; myIndex < myLength; myIndex++ )
	{
		indexRange.length = 2;
		indexRange.location = myIndex * 2;
		CFStringGetCharacters( inHexString, indexRange, workValue );
		if( sscanf( (const char*)workValue, "%02x", &workResult ) == 1 );
			CFDataAppendBytes( workData, (const UInt8*)&workResult, 1 );
	}
	
	outData = CFDataCreateCopy( inAllocator, workData );

	CFRelease( workData );
	return outData;
}


