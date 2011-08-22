#import <Foundation/Foundation.h>
#import "NSString_Extensions.h"

@interface NSArray(PMSExtensions)

-(BOOL)containsObjectIdenticalTo:(id)object;
-(NSArray*)arrayOfURLsFromPaths;
-(NSArray*)arrayOfPathsFromURLs;

-(NSArray*)arrayOfPathsThatConformToUTIs:(NSArray*)theUTIs resultsAsURL:(BOOL)saveURLs;

-(id)randomObject;

-(NSString*)md5String;

@end	//	NSArray(PMSExtensions)

