/*
 *  pms.c
 *  PickADisk*
 *
 *  Created by Dave Carlton on 10/12/09.
 *  Copyright 2009 PolyMicro Systems. All rights reserved.
 *
 */


#include <stdio.h>
#include <stdarg.h>
#include <sys/time.h>
#include <CoreServices/CoreServices.h>
#import "pms.h"

#ifdef PMDEBUG
int				gDebugLevel = 0;
Boolean			gVerbose = TRUE;
#else
Boolean			gVerbose = FALSE;
int				gDebugLevel = 7;
#endif

int				gVerboseIndex = 0;
Boolean			gVerboseStack[256];
UInt64			startTime = 0;

// PMLOGSetVerbose sets a new debug level
void PMLOGSetVerbose(Boolean value) { gDebugLevel = value; }

// PMLOGPushVerbose sets a new debug setting and saves the previous one
// Use this to reduce debug output inside loops etc.
void PMLOGPushVerbose(Boolean value) {
	gVerboseStack[gVerboseIndex] = gDebugLevel;
	gVerboseIndex++;
	if (gVerboseIndex > 256)
		gVerboseIndex = 256;
	gDebugLevel = value;
}

// PMLOGPopVerbose restores the previous debug setting
void PMLOGPopVerbose() {
	gVerboseIndex--;
	if (gVerboseIndex < 0)
		gVerboseIndex = 0;
	gDebugLevel = gVerboseStack[gVerboseIndex];
}

// Old C style logging
void PM_LogInternal(const char *file, const char *function, int inLevel, char *fmt, ... )
{	
    UInt64			elapsedTime, nowTime;
    UInt64			milliSecs;
	NSString *		pathString = [NSString stringWithCString:file encoding:NSUTF8StringEncoding];
	const char *	fileString = [[pathString lastPathComponent] cStringUsingEncoding: NSUTF8StringEncoding];
	
	struct timeval theTime;
	
    if( inLevel > gDebugLevel || inLevel == 0 )
    {
        // The level is not high enough to be displayed, we're skipping this item.
        return;
    }
    else
    {
		va_list		ap, ap2;
		int d;
		char c, *s;
		void *p;
		
		if (startTime == 0) {
			gettimeofday(&theTime, NULL);
			startTime = (theTime.tv_sec*1000000) + (theTime.tv_usec);
		}
		
		gettimeofday(&theTime, NULL);
		
		nowTime = (theTime.tv_sec*1000000) + (theTime.tv_usec);
		elapsedTime = nowTime - startTime;
		milliSecs = (elapsedTime / 1000);
		printf("%s:%s: %0u\n\t", fileString, function, (unsigned int)milliSecs);
		
		va_start(ap, fmt);
		va_copy(ap2, ap);
		while (*fmt) {
			c = *fmt++;
			if (c != '%') {
				printf("%c",c);
			} else {
				switch(*fmt++) {
					case 's':
						/* string */ 
						s = va_arg(ap, char *); 
						printf("%s", s); 
						break;
					case 'd':
						/* int */ 
						d = va_arg(ap, int); 
						printf("%d", d); 
						break;
					case 'x':
						/* char */ /* Note: char is promoted to int. */ 
						d = va_arg(ap, int); 
						printf("%x", d); 
						break; 
					case 'p':
						p = va_arg(ap, void *); 
						printf("%p", p); 
						break; 
                        
				}
			}
		}
		va_end(ap); 
		/* use ap2 to iterate over the arguments again */
		va_end(ap2); 
        //			NSLog(@"%s: %s: %3.3d\t", file, function, elapsedTime, inFormatString);
		printf("\n");
	}
}

static NSString* 
_PMLOGFormat(id self, NSString * prefix, NSString * format) {
	if(self != nil)
	{
		return [NSString stringWithFormat:@"%@ self(%@) %@", prefix, self, format];
	}
	else
	{
		return [NSString stringWithFormat:@"%@ %@", prefix, format];
	}
}

void _PMLOGSELF(id self, NSString * format, ...)
{
	NSString * finalFormat = _PMLOGFormat(self, @"PMLOG", format);
	va_list ap;
	va_start(ap, format);
	NSLogv(finalFormat, ap);
	va_end(ap);
}

void _PMLOG(const char *file, const char *function,  int inLevel, NSString * format, ...)
{
    if( inLevel > gDebugLevel || inLevel == 0 )
    {
		// The level is not high enough to be displayed, we're skipping this item.
		// inLevel = 0 = disabled          PMLOG(0, @"log, but disabled");
		// gDebugLevel = 1 = least verbose PMLOG(1, @"Routine log");
		// gDebugLevel = 7 = most verbose  PMLOG(5, @"Really detailed debug level");
        return;
    }
    else
    {
		NSString *		pathString = [NSString stringWithCString:file encoding:NSUTF8StringEncoding];
        const char *	fileString = [[pathString lastPathComponent] cStringUsingEncoding: NSUTF8StringEncoding];
        NSString *		finalFormat =  [NSString stringWithFormat:@"PMLOG %s: %s: %@", fileString, function, format];
        
        va_list ap;
        va_start(ap, format);
        NSLogv(finalFormat, ap);
        va_end(ap);
    }
}

void _PMERR(const char *file, const char *function, int err, NSString * format, ...) {
	NSString *		pathString = [NSString stringWithCString:file encoding:NSUTF8StringEncoding];
	const char *	fileString = [[pathString lastPathComponent] cStringUsingEncoding: NSUTF8StringEncoding];
	NSString *		finalFormat =  [NSString stringWithFormat:@"PMLOG %s: %s: %@ - err: %x", fileString, function, format, err];
	
	va_list ap;
	va_start(ap, format);
	NSLogv(finalFormat, ap);
	va_end(ap);
	
}
