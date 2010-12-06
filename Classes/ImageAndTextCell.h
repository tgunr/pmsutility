/*
 *  ImageAndTextCell.h
 *  PickADisc
 *
 *  Created by Dave Carlton on 05/27/08.
 *  Copyright 2008 Polymicro Systems. All rights reserved.
 *
 */

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

enum {
	// Our trackable icon in the cell
	NSCellHitIconArea = 1 << 8,
};

@interface ImageAndTextCell : NSTextFieldCell {
@private
    NSImage *image;
	BOOL	busy;
	BOOL	busyBody;
	NSInteger busyCount;
}

- (NSRect)spinnerRectForBounds:(NSRect)cellFrame;

- (void)setImage:(NSImage *)anImage;
- (NSImage *)image;

- (void)setBusy:(BOOL)spin;
- (BOOL)busy;

- (NSInteger)busyCount;
- (void)setBusyCount:(NSInteger)count;

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;
- (NSSize)cellSize;

@end
