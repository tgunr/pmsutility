//
//	File: NSOutlineView_Extensions.m
//	Abstract:Category extension to NSArray.
//
//  Created by Dave Carlton on 08/09/10.
//  Copyright (c) 2010 PolyMicro Systems. All rights reserved.
//
#import "NSOutlineView_Extensions.h"
 
@implementation NSOutlineView (MyExtensions)
 
// returns the first selected item
- (id)selectedItem { return [self itemAtRow: [self selectedRow]]; }
 
// gives all selected items
- (NSArray*)allSelectedItems {
    NSMutableArray *items = [NSMutableArray array];
    NSEnumerator *selectedRows = [self selectedRowEnumerator];
    NSNumber *selRow = nil;
    while( (selRow = [selectedRows nextObject]) ) {
        if ([self itemAtRow:[selRow intValue]]) 
            [items addObject: [self itemAtRow:[selRow intValue]]];
    }
    return items;
}
 
// select all items in the specified array
- (void)selectItems:(NSArray*)items byExtendingSelection:(BOOL)extend {
    unsigned int i;
    if (extend==NO) [self deselectAll:nil];
    for (i=0;i<[items count];i++) {
        int row = [self rowForItem:[items objectAtIndex:i]];
        if(row>=0) [self selectRow: row byExtendingSelection:YES];
    }
}
 
// given a row value, get the next row, and
// wrap around to the beginning of the list
// if specified
 
- (int) nextRow:(int)curRow wrapOK:(BOOL)wrapFlag
{
    int numRows = [self numberOfRows];
    int nextRow;
    
    // check if current row is out of range
    if ((curRow < -1) || (curRow >= numRows))
    {
        return (int)NSNotFound;
    }
    
    nextRow = curRow + 1;
    if (nextRow >= numRows)
    {
        if (YES == wrapFlag)
        {
            return (0);
        }
        else
        {
            return (int)NSNotFound;
        }
    }
 
    return (nextRow);
}
 
// given a row value, get the next selected row, and
// wrap around to the beginning of the list if specified
 
- (int) nextSelectedRow:(int)curSelectedRow wrapOK:(BOOL)wrapFlag
{
    NSUInteger nextSelRow;
    NSIndexSet *selRowIndexes = nil;
    
    selRowIndexes = [self selectedRowIndexes];
    if (nil == selRowIndexes) 
		return (int)NSNotFound;
 
    // if current selected row is bogus, return
    // the first selected row in the list
    if ((curSelectedRow < 0) || (curSelectedRow > [selRowIndexes lastIndex]))
    {
        return ([selRowIndexes firstIndex]);
    }
 
    nextSelRow = [selRowIndexes indexGreaterThanIndex: curSelectedRow];
    if (nextSelRow == NSNotFound)
    {
        if (YES == wrapFlag)
            return ([selRowIndexes firstIndex]);
        else
            return (int)NSNotFound;
    }
    
    return(nextSelRow);
}
 
// get the last selected row
- (int) lastSelectedRow
{
    NSIndexSet *selRowIndexes = [self selectedRowIndexes];
 
    if (nil == selRowIndexes) 
		return (int)NSNotFound;
 
    return([selRowIndexes lastIndex]);
}
 
// get the first selected row
- (int) firstSelectedRow
{
    NSIndexSet *selRowIndexes = [self selectedRowIndexes];
    if (nil == selRowIndexes) 
		return (int)NSNotFound;
 
    return([selRowIndexes firstIndex]);
}
 
 
@end
 
@implementation NSOutlineView (MyActiveRowExtensions)
 
 
@end
 
@implementation MyOutlineView 
 
- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)isLocal {
    if (isLocal) return NSDragOperationEvery;
    else return NSDragOperationCopy;
}
 
- (BOOL)acceptsFirstMouse:(NSEvent *)event
{
    return YES;
}
 
 
@end