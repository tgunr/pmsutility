//
//  NSData_Extensions.m
//  PickADisk
//
//  Created by Jack Small on 10/6/08.
//  Copyright 2008 Jack Small. All rights reserved.
//

#import "NSData_Extensions.h"
#include <openssl/evp.h>
#include <openssl/err.h>

@implementation NSData(StandardDigest)

//	hexString returns an NSString representation of our NSData
//	This function may temp allocate over 4 times size of NSData!
//	The output string is at least 2 times size of NSData

-(NSString*)hexString		
{
	NSString*		outString = nil;
	const char*		myBytes = [self bytes];
	unsigned int	myLength = [self length];
	unsigned int	myIndex;
	char*			hexChars = NULL;
	
	hexChars = (char*)calloc( myLength*2+1, sizeof(char) );
	if( hexChars == NULL ) return outString;
	
	for (myIndex = 0; myIndex < myLength; myIndex++ )
		sprintf(hexChars + myIndex * 2, "%02x", myBytes[myIndex]);

	outString = [NSString stringWithUTF8String:hexChars];

	free( hexChars );
	return outString;
}


-(NSData*)md5Data
{
	// compute an MD5 digest.
	EVP_MD_CTX		mdctx;
	unsigned char	md_value[EVP_MAX_MD_SIZE];
	unsigned int	md_len;
	
	EVP_DigestInit(&mdctx, EVP_md5());
	EVP_DigestUpdate(&mdctx, [self bytes], [self length]);
	EVP_DigestFinal(&mdctx, md_value, &md_len);
	
	return [NSData dataWithBytes: md_value length: md_len];
}

-(NSString*)md5String
	{ return [[self md5Data] hexString]; }

-(NSData*)sha1Data
{
	// compute an SHA1 digest.
	EVP_MD_CTX		mdctx;
	unsigned char	md_value[EVP_MAX_MD_SIZE];
	unsigned int	md_len;
	
	EVP_DigestInit(&mdctx, EVP_sha1());
	EVP_DigestUpdate(&mdctx, [self bytes], [self length]);
	EVP_DigestFinal(&mdctx, md_value, &md_len);
	
	return [NSData dataWithBytes: md_value length: md_len];
}

@end
