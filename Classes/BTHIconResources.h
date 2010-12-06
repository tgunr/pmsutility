//
// BTHIconResources.h
// Icon Resources for converting between IconRefs and NSImages
//
// Created by Blain Hamon of Unlogica on Sept 2007
// Parts were taken from IconGrabber ( http://boredzo.org/icongrabber/ )
// 
// Released as PUBLIC DOMAIN. No license, no warranty, no fitness of purpose.
// Free to use in any form desired. Attribution would be nice but isn't required.
// Copying and wrongfully claiming credit isn't copyright violation, but it is plagarism.


#import <Cocoa/Cocoa.h>

@interface NSColor (RGBColor)
+ (NSColor *)colorWithRGBColor: (RGBColor) rgbColor;
- (RGBColor) approximateRGBColor;
@end

@interface NSBitmapImageRep (IconRef)
- (id)initWithIconRef:(IconRef) icon;
- (id)initWithIconRef:(IconRef) icon width: (float) iconWidth height: (float) iconHeight;

- (id)initWithIconRef:(IconRef) icon width: (float) iconWidth height: (float) iconHeight
									 align: (IconAlignmentType) alignment transform: (IconTransformType) transformation
							 usingRGBcolor: (RGBColor *) labelColor;

//- (id)initWithIconRef:(IconRef) icon width: (float) iconWidth height: (float) iconHeight
//									 align: (IconAlignmentType) alignment transform: (IconTransformType) transformation
//							 usingRGBcolor: (RGBColor *) labelColor
//								iconBadgeRef: (IconRef)badgeIcon	align: (IconAlignmentType)badgeAlignment;

+ (NSArray *)imageRepsWithIconRef:(IconRef)icon;	/* Tries to capture multiple icon representations. */

+ (NSArray *)imageRepsWithIconRef:(IconRef)icon		/* Tries to capture multiple icon representations. */
							align: (IconAlignmentType) alignment transform: (IconTransformType) transformation
					usingRGBcolor: (RGBColor *) labelColor;

//+ (NSArray *)imageRepsWithIconRef:(IconRef)icon		/* Tries to capture multiple icon representations. */
//							align: (IconAlignmentType) alignment transform: (IconTransformType) transformation
//					usingRGBcolor: (RGBColor *) labelColor
//					iconBadgeRef: (IconRef)badgeIcon	align: (IconAlignmentType)badgeAlignment;

@end

//To have the image from a type or creator, it's tempting to have it a NSImage message
//But for the sake of consistency, it should come from NSWorkspace instead
//Actually, is it? Well, iconref comes from NSImage. Just so Imagereps don't have to be touched.
@interface NSImage (IconRef)
- (id) initWithIconRef:(IconRef) icon;
- (id) initWithIconRef:(IconRef) icon style: (IconTransformType) transformation tinting: (NSColor *) customTint;
//- (id) initWithIconRef:(IconRef) icon style: (IconTransformType) transformation tinting: (NSColor *) customTint
//					iconBadgeRef: (IconRef)badgeIcon	align: (IconAlignmentType)badgeAlignment;
@end

@interface NSWorkspace (CarbonIcons)
- (NSImage *)iconForCreator:(NSString *)creator Type: (NSString *)iconType;

//- (NSImage *)iconForCreator:(NSString *)creator Type: (NSString *)iconType
//		style: (IconTransformType) transformation tinting: (NSColor *) customTint
//		badge: (NSString *)badgeType;

- (NSImage *)iconForMIME:(NSString *)mimetype;

//- (NSImage *)iconForMIME:(NSString *)mimetype
//		style: (IconTransformType) transformation tinting: (NSColor *) customTint
//		badge: (NSString *)badgeType;

@end

OSStatus GetIconRefFromUTI(CFStringRef typeIdent, IconRef * outIconRef);
OSStatus GetIconImagesFromUTI(CFStringRef typeIdent, NSImage ** outIconImage, NSImage ** outAlternateIconImage);
