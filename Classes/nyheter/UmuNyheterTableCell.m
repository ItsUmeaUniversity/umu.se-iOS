//
//  UmuNyheterTableCell.m
//  UmuApp3
//
//  Created by Johan on 2010-06-01.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UmuNyheterTableCell.h"
#import "ABTableViewCell.h"


@implementation UmuNyheterTableCell
@synthesize headlineText;
@synthesize headlineTextSize;
@synthesize bodyText;
@synthesize bodyTextSize;

static UIFont *headlineTextFont = nil;
static UIFont *bodyTextFont = nil;

+ (void)initialize
{
	if(self == [UmuNyheterTableCell class])
	{
		headlineTextFont = [[UIFont systemFontOfSize:FONT_SIZE_LARGE] retain];
		bodyTextFont = [[UIFont systemFontOfSize:FONT_SIZE_SMALL] retain];
		// this is a good spot to load any graphics you might be drawing in -drawContentView:
		// just load them and retain them here (ONLY if they're small enough that you don't care about them wasting memory)
		// the idea is to do as LITTLE work (e.g. allocations) in -drawContentView: as possible
	}
}

- (void)dealloc
{
	[headlineText release];
	[bodyText release];
    [super dealloc];
}



- (void)setHeadlineText:(NSString *)string
{
	[headlineText release];
	headlineText = [string retain];
	headlineTextSize = CGSizeMake(1, 1);//[ABTableViewCell calculateRowSizeWithText:headlineText fontSize:FONT_SIZE_LARGE maxWidth:[ABTableViewCell calcTextWidth]];
	[self setNeedsDisplay]; 
}

- (void)setBodyText:(NSString *)string
{
	[bodyText release];
	bodyText = [string copy];
	bodyTextSize = CGSizeMake(1, 1);//[ABTableViewCell calculateRowSizeWithText:bodyText fontSize:FONT_SIZE_SMALL maxWidth:[ABTableViewCell calcTextWidth]];
	[self setNeedsDisplay]; 
}

/**
 Rita upp cellen
 */
- (void)drawContentView:(CGRect)rectToDrawIn
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIColor *backgroundColor = [UIColor whiteColor];
	UIColor *headlineTextColor = [UIColor blackColor];
	UIColor *bodyTextColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
	
	if(self.selected)
	{
		backgroundColor = [UIColor clearColor];
		headlineTextColor = [UIColor whiteColor];
	}
	
	[backgroundColor set];
	CGContextFillRect(context, rectToDrawIn);
	
	// Börja rita bilden till vänster
	// punkten p beskriver alltid var vi ska börja rita
	CGPoint p;
	p.x = PADDING;
	p.y = PADDING;
	
	NSLog(@"%fx%f",p.x, p.y);
		
//	NSLog(@"%fx%f",p.x, p.y);
	
	// rita text
	[headlineTextColor set];
	[self.headlineText drawInRect:CGRectMake(p.x, p.y, self.headlineTextSize.width, self.headlineTextSize.height) withFont:headlineTextFont];
	
//	NSLog(@"%fx%f",p.x, p.y);
	
	
	// rita infotext
	[bodyTextColor set];
	
	// nästa ritpunkt nedåt
	p.y += self.headlineTextSize.height + PADDING; 
	[self.bodyText drawInRect:CGRectMake(p.x, p.y, self.bodyTextSize.width, self.bodyTextSize.height) withFont:bodyTextFont];
	
//	NSLog(@"%fx%f",p.x, p.y);
//	NSLog(@"///////////////////////");
}


@end
