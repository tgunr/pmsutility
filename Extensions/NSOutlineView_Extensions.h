//
//	File: NSOutlineView_Extensions.h
//  Abstract: Interface file for NSOutlineView_Extensions.m
//
//  Created by Dave Carlton on 08/09/10.
//  Copyright (c) 2010 PolyMicro Systems. All rights reserved.
//
 
#import <Cocoa/Cocoa.h>
 
@interface NSOutlineView (MyExtensions)
 
- (NSArray*)allSelectedItems;
- (void)selectItems:(NSArray*)items byExtendingSelection:(BOOL)extend;
- (unsigned long) lastSelectedRow;
- (unsigned long) nextRow:(int)curRow wrapOK:(BOOL)wrapFlag;
- (unsigned long) nextSelectedRow:(int)curSelectedRow wrapOK:(BOOL)wrapFlag;
- (unsigned long) firstSelectedRow;
 
@end
 
 
@interface MyOutlineView : NSOutlineView 
 
@end