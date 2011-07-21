#import <Foundation/Foundation.h>

@interface NSArray(PMSExtensions)

-(BOOL)containsObjectIdenticalTo:(id)object;
-(NSArray*)arrayOfURLsFromPaths;
-(NSArray*)arrayOfPathsFromURLs;

-(NSArray*)arrayOfPathsThatConformToUTIs:(NSArray*)theUTIs resultsAsURL:(BOOL)saveURLs;

-(id)randomObject;

-(NSString*)md5String;

@end	//	NSArray(MyExtensions)

@interface NSDictionary(StandardDigest)

-(NSString*)md5String;

@end	//	NSDictionary(StandardDigest)

@interface NSMutableDictionary(MyExtensions)

-(void)addEntryFromDictionary:(NSDictionary*)otherDict forKey:(id)otherKey;

@end	//	NSMutableDictionary(MyExtensions)


@interface NSNumber(StandardDigest)

+(NSNumber*)zero;

-(NSString*)md5String;
-(NSNumber*)addToNumber:(NSNumber*)otherNum;

@end	//	NSNumber(StandardDigest)
