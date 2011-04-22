#import <Foundation/Foundation.h>

@interface NSArray(MyExtensions)

-(BOOL)containsObjectIdenticalTo:(id)object;

-(NSArray*)arrayOfURLsFromPaths;
-(NSArray*)arrayOfPathsFromURLs;

-(NSArray*)arrayOfPathsThatConformToUTIs:(NSArray*)theUTIs resultsAsURL:(BOOL)saveURLs;

-(id)randomObject;

-(NSString*)md5String;

@end	//	NSArray(MyExtensions)

@interface NSMutableArray(MyExtensions)

-(void)insertObjectsFromArray:(NSArray *)array atIndex:(NSInteger)index;

-(id)reverseObjects;

-(id)insertUniqueObjectsFromArray:(NSArray*)newArray atIndex:(NSInteger)index;
-(id)addUniqueObjectsFromArray:(NSArray*)newArray;

@end	//	NSMutableArray(MyExtensions)

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
