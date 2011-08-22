//
//  NSSlider_Animation.h
//  AnimatedSlider
//
//  Created by jcr on Tue Nov 06 2001.
//  Copyright (c) 2002  Apple Computer, Inc. All rights reserved.

// See legal notice below.

#ifdef PMSUTILITY
#import <Cocoa/Cocoa.h>
#endif

#ifdef PMSUTILITYIOS
#import <UIKit/UIKit.h>
#endif

@interface NSSlider (SliderAnimation)

- (IBAction) animateToFloatValueFrom: sender;
- (void) animateToFloatValue:(float) newValue allowsTicksOnly:(BOOL)ticksOnly;

@end

@interface NSSliderCell (SliderAnimation)

- (IBAction) animateToFloatValueFrom: sender;
- (void) animateToFloatValue:(float) newValue allowsTicksOnly:(BOOL)ticksOnly;

@end


