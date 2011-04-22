//
//  NSApplication_Extensions.h
//  PickADisc
//
//  Created by PolyMicro Systems on 7/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/*
@interface NSApplication(MyExtensions)

IBOutlet id addVolumeController;

- (id)addVolumeController;
- (void)setAddVolumeController:(id)inAVC;

@end
*/

extern const	time_t	kTimeOneDayInSeconds;

@interface NSDate(MyExtensions)

+(NSDate*)tomorrow;
+(NSDate*)yesterday;

-(BOOL)isBetweenStartDate:(NSDate*)startDate andEndDate:(NSDate*)endDate;
-(float)rankWithDate:(id)other withOptions:(NSMutableDictionary*)options;

-(NSString*)formatDateString:(NSString*)dateFormat useNatural:(BOOL)doNatural;
-(NSString*)naturalDateString;
-(NSString*)shorterDateString;
-(NSString*)longerDateString;

@end
