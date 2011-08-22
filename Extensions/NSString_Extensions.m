//
//  NSString_Extensions.m
//  PickADisk
//
//  Created by PolyMicro Systems on 10/6/08.
//  Copyright 2008 PolyMicro Systems. All rights reserved.
//

#import "NSString_Extensions.h"

#include <openssl/evp.h>
#include <openssl/err.h>

@implementation NSString(PMExtensions)

-(NSData*)md5Data
{
	// compute an MD5 digest
	EVP_MD_CTX		mdctx;
	unsigned char	md_value[EVP_MAX_MD_SIZE];
	unsigned int	md_len;
	const char*		str = [self UTF8String];
	
	EVP_DigestInit(&mdctx, EVP_md5());
	EVP_DigestUpdate(&mdctx, (const void*)str, strlen(str));
	EVP_DigestFinal(&mdctx, md_value, &md_len);
	
	return [NSData dataWithBytes: md_value length: md_len];
}

-(NSString*)md5String
{
	// compute an MD5 digest
	EVP_MD_CTX		mdctx;
	unsigned char	md_value[EVP_MAX_MD_SIZE];
	unsigned int	md_len;
	unsigned int	md_index;
	const char*		str = [self UTF8String];
	char			hex_output[EVP_MAX_MD_SIZE*2 + 1];

	EVP_DigestInit(&mdctx, EVP_md5());
	EVP_DigestUpdate(&mdctx, (const void*)str, strlen(str));
	EVP_DigestFinal(&mdctx, md_value, &md_len);
	
	for (md_index = 0; md_index < md_len; md_index++ )
		sprintf(hex_output + md_index * 2, "%02x", md_value[md_index]);
	
	return [NSString stringWithUTF8String:hex_output];
}

-(float)rankWithString:(NSString*)other compareOptions:(NSStringCompareOptions)findOptions
{
	float		rank = 0.0;
	NSRange		foundRange;
	
	if( [self localizedCaseInsensitiveCompare:other] == NSOrderedSame ) rank = 1.0;
	else {
		foundRange = [self rangeOfString:other options:findOptions];
		if( foundRange.length != 0 ) rank = (foundRange.length*1.0) / ([self length]*1.0);
	}

	// NSLog(@"Rank:%f String:%@ Other:%@", rank, self, other);
	
	return rank;
}

+(NSString*)stringFromByteCount:(NSNumber*)inBytes
{
	double		bytesLeft = [inBytes doubleValue];
	int			reductionCount = 0;
	NSArray*	abvrArray = [NSArray arrayWithObjects:@"B", @"KB", @"MB", @"GB", @"TB", @"PB", @"EB", @"ZB", @"YB", nil];
	
	while ( bytesLeft > 1024 ) {
		reductionCount++;
		bytesLeft /= 1024.0f;
		if( reductionCount == 8 ) break;
	}
	
	return [NSString stringWithFormat:@"%.02f %@", bytesLeft, [abvrArray objectAtIndex:reductionCount]];
}

#define ellipsis @"…"

- (NSString*)stringByTruncatingBeginningToLength:(NSUInteger)length;
{
	// Create copy that will be the returned result
#ifndef CLANG_ENABLE_OBJC_ARC
	NSMutableString *truncatedString = [self mutableCopy];
#else
    NSMutableString *truncatedString = [[self mutableCopy] autorelease];
#endif
    
	NSUInteger selfLength = [self length];
	
	// Make sure string is longer than requested length
	if (selfLength > length)
	{
		// Get range for prefix characters in string
		NSRange range = {0, ((selfLength - length) +1)};
		[truncatedString replaceCharactersInRange:range withString:ellipsis];
	}
	
	return truncatedString;
}

- (NSString*)stringByTruncatingEndToLength:(NSUInteger)length;
{
	// Create copy that will be the returned result
#ifndef CLANG_ENABLE_OBJC_ARC
	NSMutableString *truncatedString = [self mutableCopy];
#else
    NSMutableString *truncatedString = [[self mutableCopy] autorelease];
#endif
	NSUInteger selfLength = [self length];

	// Make sure string is longer than requested length
	if (selfLength > length)
	{
		// Get range for last characters in string
		NSRange range = {length - 1, ((selfLength - length) + 1)};
		[truncatedString replaceCharactersInRange:range withString:ellipsis];
	}
	
	return truncatedString;
}

- (NSString*)stringByTruncatingMiddleToLength:(NSUInteger)length
{
	// Create copy that will be the returned result
#ifndef CLANG_ENABLE_OBJC_ARC
	NSMutableString *truncatedString = [self mutableCopy];
#else
    NSMutableString *truncatedString = [[self mutableCopy] autorelease];
#endif
	NSUInteger selfLength = [self length];
	if (selfLength > length) {
		NSRange r;		
		// compute the ends length
		NSUInteger middle = selfLength / 2;
		NSUInteger ends = ((selfLength - length) / 2);
		// set range to middle
		r.location = (middle - ends);
		r.length = (((middle + ends) - r.location) + 1);
		[truncatedString replaceCharactersInRange:r withString:ellipsis];
	}	
	return truncatedString;
}

@end


@implementation NSMutableString(PMExtensions)
-(NSString*)md5String
{
	// compute an MD5 digest
	EVP_MD_CTX		mdctx;
	unsigned char	md_value[EVP_MAX_MD_SIZE];
	unsigned int	md_len;
	unsigned int	md_index;
	const char*		str = [self UTF8String];
	char			hex_output[EVP_MAX_MD_SIZE*2 + 1];
	
	EVP_DigestInit(&mdctx, EVP_md5());
	EVP_DigestUpdate(&mdctx, (const void*)str, strlen(str));
	EVP_DigestFinal(&mdctx, md_value, &md_len);
	
	for (md_index = 0; md_index < md_len; md_index++ )
		sprintf(hex_output + md_index * 2, "%02x", md_value[md_index]);
	
	return [NSString stringWithUTF8String:hex_output];
}
@end

