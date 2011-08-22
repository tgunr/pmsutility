//
//	File: NSOutlineView_Extensions.m
//	Abstract:Category extension to NSArray.
//
//  Created by Dave Carlton on 08/09/10.
//  Copyright (c) 2010 PolyMicro Systems. All rights reserved.
//
#import "NSOutlineView_Extensions.h"
 
@implementation NSOutlineView (PMSExtensions)

// returns the first selected item
- (id)selectedItem { return [self itemAtRow: [self selectedRow]]; }
 
// gives all selected items
- (NSArray*)allSelectedItems {
    NSMutableArray *items = [NSMutableArray array];
    NSIndexSet *selectedRows = [self selectedRowIndexes];
	[selectedRows enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        if ([self itemAtRow:idx]) 
			[items addObject: [self itemAtRow:idx]];
	}];
	 return items;
}
 
// select all items in the specified array
- (void)selectItems:(NSArray*)items byExtendingSelection:(BOOL)extend {
    unsigned int i;
    if (extend==NO) 
		[self deselectAll:nil];
	NSMutableIndexSet * indexes = [NSIndexSet indexSet];
    for (i=0;i<[items count];i++) {
        NSUInteger row = [self rowForItem:[items objectAtIndex:i]];
        if(row) {
			[indexes addIndex:row];
		}
    }
	[self selectRowIndexes:indexes byExtendingSelection:extend];
}
 
- (void)selectItems:(NSArray*)items
{ [self selectItems:items byExtendingSelection:NO]; }

- (void)extendSelectItems:(NSArray*)items
{ [self selectItems:items byExtendingSelection:YES]; }


// given a row value, get the next row, and
// wrap around to the beginning of the list
// if specified
 
- (unsigned long) nextRow:(int)curRow wrapOK:(BOOL)wrapFlag
{
    unsigned long numRows = [self numberOfRows];
    unsigned long nextRow;
    
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
 
- (unsigned long) nextSelectedRow:(int)curSelectedRow wrapOK:(BOOL)wrapFlag
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
- (unsigned long) lastSelectedRow
{
    NSIndexSet *selRowIndexes = [self selectedRowIndexes];
 
    if (nil == selRowIndexes) 
		return (int)NSNotFound;
 
    return([selRowIndexes lastIndex]);
}
 
// get the first selected row
- (unsigned long) firstSelectedRow
{
    NSIndexSet *selRowIndexes = [self selectedRowIndexes];
    if (nil == selRowIndexes) 
		return (int)NSNotFound;
 
    return([selRowIndexes firstIndex]);
}
 
 
@end
 
