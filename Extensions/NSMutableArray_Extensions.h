//
//  NSMutableArray_Extensions.h
//  pmsutility
//
//  Created by Dave Carlton on 07/20/11.
//  Copyright 2011 Polymicro Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray(MyExtensions)

-(void)insertObjectsFromArray:(NSArray *)array atIndex:(NSInteger)index;

-(id)reverseObjects;

-(id)insertUniqueObjectsFromArray:(NSArray*)newArray atIndex:(NSInteger)index;
-(id)addUniqueObjectsFromArray:(NSArray*)newArray;

@end	//	NSMutableArray(MyExtensions)

