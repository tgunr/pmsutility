/* *  ImageAndTextCell.m
 *  PickADisc
 *
 *  Created by Dave Carlton on 05/27/08.
 *  Copyright 2008 Polymicro Systems. All rights reserved.
 *
 */

#import "ImageAndTextCell.h"
#import <AppKit/NSCell.h>

#define		DACIATCImageIndent		3

@implementation ImageAndTextCell

- (id)init {
    if (self = [super init]) {
        [self setLineBreakMode:NSLineBreakByTruncatingTail];
        [self setSelectable:YES];
		busyCount = 0;
    }
    return self;
}

- (void)dealloc {
    [image release];
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
    ImageAndTextCell *cell = (ImageAndTextCell *)[super copyWithZone:zone];
    // The image ivar will be directly copied; we need to retain or copy it.
    cell->image = [image retain];
    return cell;
}

- (void)setImage:(NSImage *)anImage {
    if (anImage != image) {
        [image release];
        image = [anImage retain];
    }
}

- (NSImage *)image {
    return image;
}

- (NSRect)imageRectForBounds:(NSRect)cellFrame {
    NSRect result;
    if (image != nil) {
        result.size = [image size];
//        result.size =  NSMakeSize( 16.0, 16.0 );
        result.origin = cellFrame.origin;
        result.origin.x += DACIATCImageIndent;
        result.origin.y += ceil((cellFrame.size.height - result.size.height) / 2);
    } else {
        result = NSZeroRect;
    }
    return result;
}

// We could manually implement expansionFrameWithFrame:inView: and drawWithExpansionFrame:inView: or just properly implement titleRectForBounds to get expansion tooltips to automatically work for us
- (NSRect)titleRectForBounds:(NSRect)cellFrame {
    NSRect result;
    if (image != nil) {
        CGFloat imageWidth = [image size].width;
        result = cellFrame;
        result.origin.x += (DACIATCImageIndent + imageWidth);
        result.size.width -= (DACIATCImageIndent + imageWidth);
    } else {
        result = NSZeroRect;
    }
    return result;
}

// Returns the progress indicator rectangle best suited for the incoming rectangle
- (NSRect)spinnerRectForBounds:(NSRect)cellFrame {

    NSRect result;

	CGFloat spinSize = 16.0;		// Should probably not be hard coded...
	CGFloat spinXInset = 8.0;
	CGFloat spinYInset = 0.0;
	CGFloat cellWidth = cellFrame.size.width;
	CGFloat cellHeight = cellFrame.size.height;
	
	result = cellFrame; 
	
	result.origin.x += (cellWidth - spinSize) - spinXInset;
	result.origin.y += (cellHeight - spinSize) - spinYInset;
	result.size.width = spinSize;
	result.size.height = spinSize;

    return result;
}


- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject event:(NSEvent *)theEvent {
    NSRect textFrame, imageFrame;
    NSDivideRect (aRect, &imageFrame, &textFrame, DACIATCImageIndent + [image size].width, NSMinXEdge);
    [super editWithFrame: textFrame inView: controlView editor:textObj delegate:anObject event: theEvent];
}

- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject start:(NSInteger)selStart length:(NSInteger)selLength {
    NSRect textFrame, imageFrame;
    NSDivideRect (aRect, &imageFrame, &textFrame, DACIATCImageIndent + [image size].width, NSMinXEdge);
    [super selectWithFrame: textFrame inView: controlView editor:textObj delegate:anObject start:selStart length:selLength];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    if (image != nil) {
        NSRect	imageFrame;
        NSSize imageSize = [image size];
		NSDivideRect(cellFrame, &imageFrame, &cellFrame, DACIATCImageIndent + imageSize.width, NSMinXEdge);
        if ([self drawsBackground]) {
            [[self backgroundColor] set];
            NSRectFill(imageFrame);
        }
        imageFrame.origin.x += DACIATCImageIndent;
        imageFrame.size = imageSize;

        if ([controlView isFlipped])
            imageFrame.origin.y += ceil((cellFrame.size.height + imageFrame.size.height) / 2);
        else
            imageFrame.origin.y += ceil((cellFrame.size.height - imageFrame.size.height) / 2);

        [image compositeToPoint:imageFrame.origin operation:NSCompositeSourceOver];
    }
	
	if( (busy == YES) )									// If the node is busy, draw a chasing arrows in the corner.
	{													// Overshadow spinnerRectForBounds: to control the box
		HIThemeChasingArrowsDrawInfo arrowInfo;
		NSRect	spinRect = [self spinnerRectForBounds:cellFrame];
		HIRect	arrowFrame = CGRectMake( spinRect.origin.x, spinRect.origin.y, spinRect.size.width, spinRect.size.height);
		
		arrowInfo.version = 0;
		arrowInfo.state = kThemeStateActive;
		arrowInfo.index = jPMBusyBodyBeat;				// There is only one busy counter, so we're all spinning together.

		HIThemeDrawChasingArrows( &arrowFrame, &arrowInfo, [[NSGraphicsContext currentContext] graphicsPort], kHIThemeOrientationInverted );
	}
	
    [super drawWithFrame:cellFrame inView:controlView];
}

- (NSSize)cellSize {
    NSSize cellSize = [super cellSize];
    cellSize.width += (image ? [image size].width : 0) + DACIATCImageIndent;
    return cellSize;
}

- (NSUInteger)hitTestForEvent:(NSEvent *)event inRect:(NSRect)cellFrame ofView:(NSView *)controlView {
    NSPoint point = [controlView convertPoint:[event locationInWindow] fromView:nil];
//	NSOutlineView*	dataView = (NSOutlineView*)controlView;
	NSInteger	outHit = NSCellHitNone;
//	NSInteger	imageHit = NSCellHitNone;
	
    // If we have an image, we need to see if the user clicked on the image portion.
    if (image != nil) {
        // This code closely mimics drawWithFrame:inView:
        NSSize imageSize = [image size];
        NSRect imageFrame;
        NSDivideRect(cellFrame, &imageFrame, &cellFrame, DACIATCImageIndent + imageSize.width, NSMinXEdge);
        
        imageFrame.origin.x += DACIATCImageIndent;
        imageFrame.size = imageSize;
        // If the point is in the image rect, then it is a content hit
        if (NSMouseInRect(point, imageFrame, [controlView isFlipped])) {
            // We consider this just a content area. It is not trackable, nor it it editable text. If it was, we would or in the additional items.
            // By returning the correct parts, we allow NSTableView to correctly begin an edit when the text portion is clicked on.
			
//			if( ([event type] == NSLeftMouseDown) && ([event clickCount] == 2 ) )
//				if( [[[dataView delegate] dataSource] respondsToSelector:@selector(doubleClickImage:)] == YES )
//					[[[dataView delegate] dataSource] performSelector:@selector(doubleClickImage:) withObject:(id)[self representedObject]];
			
            outHit = NSCellHitIconArea;
			goto BAIL;
        }
	}
	outHit = [super hitTestForEvent:event inRect:cellFrame ofView:controlView]; 

//            } //else {
//		// At this point, the cellFrame has been modified to exclude the portion for the image. Let the superclass handle the hit testing at this point.
//	outHit = [super hitTestForEvent:event inRect:cellFrame ofView:controlView]; 
//		return outHit;
//	}
//	if( ([event type] == NSLeftMouseDown) && ([event clickCount] == 2 ) )
//		if( (outHit == NSCellHitNone) && (imageHit == NSCellHitNone) )
//			if( [[[dataView delegate] dataSource] respondsToSelector:@selector(doubleClickCellContent:)] == YES )
//				[[[dataView delegate] dataSource] performSelector:@selector(doubleClickCellContent:) withObject:(id)[self representedObject]];

BAIL:
	return outHit;
//	return [super hitTestForEvent:event inRect:cellFrame ofView:controlView]; 
}

- (void)setBusy:(BOOL)spin 
{ 
	if( busy == spin ) return;
	busy = spin;
}

- (BOOL)busy
	{ return busy; }

- (NSInteger)busyCount
	{ return busyCount; }

- (void)setBusyCount:(NSInteger)count
	{ busyCount = count; }

@end

