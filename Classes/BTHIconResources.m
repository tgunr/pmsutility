//
// BTHIconResources.m
// Icon Resources for converting between IconRefs and NSImages
//
// Created by Blain Hamon of Unlogica on Sept 2007
// Parts were taken from IconGrabber ( http://boredzo.org/icongrabber/ )
// 
// Released as PUBLIC DOMAIN. No license, no warranty, no fitness of purpose.
// Free to use in any form desired. Attribution would be nice but isn't required.
// Copying and wrongfully claiming credit isn't copyright violation, but it is plagarism.


#import "BTHIconResources.h"


@implementation NSColor (RGBColor)
+ (NSColor *)colorWithRGBColor: (RGBColor) rgbColor {
	return [NSColor colorWithCalibratedRed: (float)rgbColor.red / (float)SHRT_MAX
									 green: (float)rgbColor.green / (float)SHRT_MAX
									  blue: (float)rgbColor.blue / (float)SHRT_MAX
								     alpha:(float)1.0];
}

- (RGBColor) approximateRGBColor {
	RGBColor result;
	CGFloat resultingRed, resultingGreen, resultingBlue;
	NSColor * calibratedColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	[calibratedColor getRed:&resultingRed green:&resultingGreen blue:&resultingBlue alpha:NULL];

	result.red = (resultingRed * (float)SHRT_MAX);
	result.green = (resultingGreen * (float)SHRT_MAX);
	result.blue = (resultingBlue * (float)SHRT_MAX);
	
	return result;
}

@end


@implementation NSBitmapImageRep (IconRef)

- (id)initWithIconRef:(IconRef) icon {
	return [self initWithIconRef:icon width:(float)128.0 height:(float)128.0];
}

- (id)initWithIconRef:(IconRef) icon width: (float) iconWidth height: (float) iconHeight {

	return [self initWithIconRef:(IconRef) icon width: iconWidth height: iconHeight
									 align: kAlignNone transform: kTransformNone
									 usingRGBcolor: NULL];
}

- (id)initWithIconRef:(IconRef) icon width: (float) iconWidth height: (float) iconHeight
									 align: (IconAlignmentType) alignment transform: (IconTransformType) transformation
							 usingRGBcolor: (RGBColor *) labelColor {
	const size_t bitsPerComponent = 8U;
	size_t bytesPerRow = iconWidth * 4U; //4 bytes per pixel

	self = [self initWithBitmapDataPlanes:NULL
							   pixelsWide:iconWidth
							   pixelsHigh:iconHeight
							bitsPerSample:bitsPerComponent
						  samplesPerPixel:4
								 hasAlpha:YES
								 isPlanar:NO
						   colorSpaceName:NSDeviceRGBColorSpace
							  bytesPerRow:0
							 bitsPerPixel:0];
	if (!self) return self;

	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	if(rgb) {
		CGRect drawRect = { { 0.0f, 0.0f }, { iconWidth, iconHeight } };
		CGImageAlphaInfo alpha = kCGImageAlphaPremultipliedLast;
		CGContextRef context = CGBitmapContextCreate([self bitmapData],
										iconWidth, iconHeight,
										bitsPerComponent, bytesPerRow, rgb, alpha);
		if(context) {
			CGContextClearRect(context,drawRect);
			PlotIconRefInContext(context, &drawRect,
									alignment, transformation,
									labelColor, kPlotIconRefNormalFlags,
									icon );
			CGContextRelease(context);
		}
		CGColorSpaceRelease(rgb);
	}

	return self;
}

+ (NSArray *)imageRepsWithIconRef:(IconRef)icon
{	/* Tries to capture multiple icon representations. */
	return [NSBitmapImageRep imageRepsWithIconRef:icon
									 align: kAlignNone transform: kTransformNone
									 usingRGBcolor: NULL];
}

+ (NSArray *)imageRepsWithIconRef:(IconRef)icon		/* Tries to capture multiple icon representations. */
							align: (IconAlignmentType) alignment transform: (IconTransformType) transformation
					usingRGBcolor: (RGBColor *) labelColor
{
	NSMutableArray * result = [[[NSMutableArray alloc] init] autorelease];
	unsigned int iconSizesToMake = 128; //A bitflag that has the set bits correspond to the size.

	AcquireIconRef(icon);
	
	//only use IsDataAvailableInIconRef on 10.3 and later. -- Heh. We need 10.4 for core data anways.
	//on earlier versions, use now-deprecated GetIconSizesFromIconRef.
	if(IsDataAvailableInIconRef(kHuge32BitData, icon)
			|| IsDataAvailableInIconRef(kHuge8BitData, icon)
			|| IsDataAvailableInIconRef(kHuge4BitData, icon))
		iconSizesToMake |= 64U;
		iconSizesToMake &= ~128U;
	if(IsDataAvailableInIconRef(kLarge32BitData, icon)
			|| IsDataAvailableInIconRef(kLarge8BitData, icon)
			|| IsDataAvailableInIconRef(kLarge4BitData, icon))
		iconSizesToMake |= 32U;
		iconSizesToMake &= ~128U;
	if(IsDataAvailableInIconRef(kSmall32BitData, icon)
			|| IsDataAvailableInIconRef(kSmall8BitData, icon)
			|| IsDataAvailableInIconRef(kSmall4BitData, icon))
		iconSizesToMake |= 16U;
		iconSizesToMake &= ~128U;
	if(IsDataAvailableInIconRef(kMini8BitData, icon)
			|| IsDataAvailableInIconRef(kMini4BitData, icon)) {
		iconSizesToMake |= 8U;
		iconSizesToMake &= ~128U;
	}
	if(IsDataAvailableInIconRef(kThumbnail32BitData, icon)){
		iconSizesToMake |= 128U;
	}

	unsigned int currentIcon = 8;
	while (iconSizesToMake != 0) {
		if (iconSizesToMake & currentIcon) {
			[result addObject:
				[[[NSBitmapImageRep alloc]
					initWithIconRef:icon width:currentIcon height:currentIcon
							  align: alignment transform: transformation
					  usingRGBcolor: labelColor
					] autorelease]];
			iconSizesToMake &= ~currentIcon;
		}
		currentIcon = currentIcon << 1;
	}

	ReleaseIconRef(icon);
	return result;

}

@end

@implementation NSImage (IconRef)
- (id) initWithIconRef:(IconRef) icon {
	return [self initWithIconRef:icon
				style:kTransformNone tinting:NULL];
}

- (id) initWithIconRef:(IconRef) icon
					style: (IconTransformType) transformation
					tinting: (NSColor *) customTint
{
	self = [self initWithSize: NSMakeSize(128,128)];
	RGBColor rgbColor, * rgbColorPtr;

	if (!self) return nil;

	if (customTint) {
		rgbColor = [customTint approximateRGBColor];
		rgbColorPtr = &rgbColor;
	} else {
		rgbColorPtr = NULL;
	}
	[self addRepresentations:
		[NSBitmapImageRep imageRepsWithIconRef:icon
					align:kAlignNone transform:transformation usingRGBcolor:rgbColorPtr]];
	[self setScalesWhenResized:YES];
	[self setDataRetained:YES];
	return self;
}
@end

@implementation NSWorkspace (CarbonIcons)

- (NSImage *)iconForCreator:(NSString *)creator Type: (NSString *)iconType {
	return [self iconForCreator:creator Type:iconType
			style:kNoTransform tinting:nil];
}

- (NSImage *)iconForCreator:(NSString *)creator Type: (NSString *)iconType
		style: (IconTransformType) transformation tinting: (NSColor *) customTint {

	IconRef icon;
	OSStatus err;
	OSType fileType, creatorType;

	creatorType = UTGetOSTypeFromString((CFStringRef) creator);
	if ([iconType length]) {
		fileType = UTGetOSTypeFromString((CFStringRef) iconType);
	} else {
		fileType = kSystemIconsCreator;
	}

	err = GetIconRef(kOnSystemDisk, creatorType, fileType, &icon);
	if(!icon || err) {
		return nil;
	}

	NSImage *image = [[[NSImage alloc] initWithIconRef:icon
				style:transformation tinting:customTint] autorelease];
	ReleaseIconRef(icon);
	return image;
}

- (NSImage *)iconForMIME:(NSString *)mimetype {
	return [self iconForMIME:mimetype
			style:kNoTransform tinting:nil];
}

- (NSImage *)iconForMIME:(NSString *)mimetype
		style: (IconTransformType) transformation tinting: (NSColor *) customTint {
	IconRef icon;
	OSStatus err = GetIconRefFromTypeInfo(/*creator*/ 0, /*type*/ 0, /*extension*/ NULL, (CFStringRef)mimetype, kIconServicesNormalUsageFlag, &icon);
	if(!icon || err) {
		return nil;
	}

	NSImage *image = [[[NSImage alloc] initWithIconRef:icon
				style:transformation tinting:customTint] autorelease];
	ReleaseIconRef(icon);
	return image;
}


@end

NSMutableDictionary * iconRefFromUTIDict = nil;

OSStatus GetIconRefFromUTI(CFStringRef typeIdent, IconRef * outIconRef){
	OSStatus err; 

	if (outIconRef == NULL) return paramErr;

	if (iconRefFromUTIDict == nil){
		iconRefFromUTIDict = [[NSMutableDictionary alloc] init];
	} else {
		NSData * cachedResult = [iconRefFromUTIDict objectForKey: (id)typeIdent];
		if (cachedResult != nil) {
			[cachedResult getBytes:outIconRef];
			AcquireIconRef(*outIconRef);
			return noErr;
		}
	}
	CFStringRef ourFileExtension = nil;
	OSType ourCreator = 0;
	OSType ourType = 0;
	CFStringRef ourMimeType = nil;

	if ( CFStringCompare(typeIdent, kUTTypeFolder, kCFCompareCaseInsensitive) == kCFCompareEqualTo ){ //IF Folder:
		ourCreator = kSystemIconsCreator;
		ourType = kGenericFolderIcon;
	} else {//Not a folder
		//Extract what kind of icon it's going to be.
		//If generic:
			//if .com, .exe, .bat
				//Set values accordingly.
		//else
			//EXTRACT META FROM IDENT
		ourType = UTGetOSTypeFromString(UTTypeCopyPreferredTagWithClass(typeIdent,kUTTagClassOSType));
		ourMimeType = UTTypeCopyPreferredTagWithClass(typeIdent,kUTTagClassMIMEType);
		ourFileExtension = UTTypeCopyPreferredTagWithClass(typeIdent,kUTTagClassFilenameExtension);
	}

	err = GetIconRefFromTypeInfo(ourCreator, ourType, (CFStringRef)ourFileExtension, (CFStringRef)ourMimeType, kIconServicesNormalUsageFlag, outIconRef);
	if (err == noErr) {
		AcquireIconRef(*outIconRef);
		NSData * cachedResult = [NSData dataWithBytes:outIconRef length:sizeof(IconRef)];
		[iconRefFromUTIDict setObject:cachedResult forKey: (id)typeIdent];
	}
	CFRelease(ourMimeType);
	CFRelease(ourFileExtension);
	return err;
}

OSStatus GetIconImagesFromUTI(CFStringRef typeIdent, NSImage ** outIconImage, NSImage ** outAlternateIconImage){

	IconRef ourFileIconRef = NULL;

	OSStatus err = GetIconRefFromUTI(typeIdent, &ourFileIconRef);
	if (err == noErr){
		if (outIconImage != NULL) {
			*outIconImage = [[NSImage alloc] initWithIconRef:ourFileIconRef style:kTransformNone tinting:nil];
		}
		if (outAlternateIconImage != NULL) {
			*outAlternateIconImage = [[NSImage alloc] initWithIconRef:ourFileIconRef style:kTransformSelected tinting:nil];
		}
		ReleaseIconRef(ourFileIconRef);
	}
	return err;
}












