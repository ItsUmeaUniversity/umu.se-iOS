//
//  UmuFBTableCell.m
//  UmuApp3
//
//  Created by Johan Forssell on 2010-06-01.
//  Copyright 2010 Umeå University. All rights reserved.
//

#import "UmuFBTableCell.h"

@implementation UmuFBTableCell

@synthesize messageText;
@synthesize infoText;
@synthesize image;
@synthesize messageTextSize;
@synthesize infoTextSize;


static UIFont * messageTextFont = nil;
static UIFont * infoTextFont = nil;
static UIFont * headerTextFont = nil;
static NSString * const fbHeaderText = @"Umeå universitet finns på Facebook";

+ (void)initialize
{
	if(self == [UmuFBTableCell class])
	{
		messageTextFont = [[UIFont systemFontOfSize:FONT_SIZE_LARGE] retain];
		infoTextFont = [[UIFont systemFontOfSize:FONT_SIZE_SMALL] retain];
		headerTextFont = [[UIFont boldSystemFontOfSize:FONT_SIZE_HEADER] retain];
	}
}

- (CGFloat) calculateFromWidth {
	
	return self.frame.size.width - PADDING-IMAGE_WIDTH-PADDING-ADI_WIDTH-5; 	
	
}

- (void)dealloc
{
	[headerTextFont release];
	[messageTextFont release];
	[infoTextFont release];
	[messageText release];
	[infoText release];
	[image release];
    [super dealloc];
}



- (void)setMessageText:(NSString *)string {
	[messageText release];
	messageText = [string retain];
	CGSize size  = [messageText sizeWithFont:messageTextFont
						   constrainedToSize:CGSizeMake([self calculateFromWidth], 999.9f)
							   lineBreakMode:UILineBreakModeWordWrap];
	self.messageTextSize = size;
	[self setNeedsDisplay]; 
}

- (void)setInfoText:(NSString *)string {
	[infoText release];
	infoText = [string copy];

	CGSize size  = [infoText sizeWithFont:infoTextFont 
								 forWidth:[self calculateFromWidth]
							lineBreakMode:UILineBreakModeTailTruncation];
	self.infoTextSize = size;
	[self setNeedsDisplay]; 
}


- (void)drawContentView:(CGRect)rectToDrawIn
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIColor *backgroundColor = [UIColor whiteColor];
	UIColor *textColor = [UIColor blackColor];
	UIColor *headerColor = [UIColor blackColor];
	UIColor *infoTextColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
	
	if(self.selected)
	{
		backgroundColor = [UIColor clearColor];
		textColor = [UIColor whiteColor];
		headerColor = [UIColor whiteColor];
		NSLog(@"selected, headercolor=%@", headerColor);
	}
	
	[backgroundColor set];
	CGContextFillRect(context, rectToDrawIn);
	
	// Börja rita bilden till vänster
	// punkten p beskriver alltid var vi ska börja rita
	CGPoint p;
	p.x = PADDING;
	p.y = PADDING;
	
	
	if ([self.infoText length] < 1) // rita headern på 32x32 pixlar
	{
		p.x += (FB_PROFILE_IMAGE_SIZE-FB_LOGO_SIZE);	// 50 är bredden på standardbild >> högerjustera bild
		p.y =  (FB_HEADER_ROWSIZE-FB_LOGO_SIZE)/2;		// centrera på den 44 pixlar höga raden
		[image drawAtPoint:p]; //32x32 stor bild

		// flytta till höger för att rita text
		p.x += FB_LOGO_SIZE + PADDING;	
		p.y += (FB_LOGO_SIZE- 15)/2;
		
		[[UIColor blackColor] set];
		[fbHeaderText drawInRect:CGRectMake(p.x, p.y, 220, FB_HEADER_ROWSIZE) withFont:headerTextFont];
	} 
	else // rita en vanlig cell
	{
		if (image != nil) {
			[image drawAtPoint:p];
			// flytta till höger för att rita text
			p.x += ((NSInteger)[image size].width) + PADDING;		
			p.y -= 1.0f;
		} 
		
		[textColor set];
		[self.messageText drawInRect:CGRectMake(p.x, p.y, self.messageTextSize.width, self.messageTextSize.height) 
							withFont:messageTextFont];
		
		[infoTextColor set];
		
		// nästa ritpunkt nedåt
		p.y += self.messageTextSize.height + PADDING_SMALL; 
		[self.infoText drawInRect:CGRectMake(p.x, p.y, self.infoTextSize.width, self.infoTextSize.height) 
						 withFont:infoTextFont 
					lineBreakMode:UILineBreakModeTailTruncation];
	}
}


// Räkna ut hur hög hela cellen måste vara
- (CGFloat) getCellHeight 
{
	CGFloat cellHeight = PADDING + self.messageTextSize.height + PADDING + self.infoTextSize.height + PADDING;
	CGFloat imageHeightWithPaddingAboveAndBelow = PADDING + IMAGE_WIDTH + PADDING;
	
	
	if (cellHeight < imageHeightWithPaddingAboveAndBelow)
		cellHeight = imageHeightWithPaddingAboveAndBelow;
	
	return cellHeight;
}

@end
