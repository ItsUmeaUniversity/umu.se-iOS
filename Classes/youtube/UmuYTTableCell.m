//
//  UmuYTTableCell.m
//  UmuApp3
//
//  Created by Johan Forssell on 6/9/10.
//  Copyright 2010 Umeå University. All rights reserved.
//

#import "UmuYTTableCell.h"
#import "ABTableViewCell.h"

@implementation UmuYTTableCell : ABTableViewCell 

@synthesize content;

static UIFont *messageTextFont = nil;
static UIFont *infoTextFont = nil;

+ (void)initialize
{
	if(self == [UmuYTTableCell class])
	{
		messageTextFont = [[UIFont systemFontOfSize:FONT_SIZE_LARGE] retain];
		infoTextFont = [[UIFont systemFontOfSize:FONT_SIZE_SMALL] retain];
	}
}

- (void)dealloc
{
	[content release];
    [super   dealloc];
}

- (void) setContent:(UmuYoutubeVideo *)video
{
	[content release];
	content = [video retain];
	[self setNeedsDisplay];
}


- (void)drawContentView:(CGRect)rectToDrawIn
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIColor *backgroundColor = [UIColor whiteColor];
	UIColor *textColor = [UIColor blackColor];
	UIColor *infoTextColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
	
	if(self.selected)
	{
		backgroundColor = [UIColor clearColor];
		textColor = [UIColor whiteColor];
	}
	
	[backgroundColor set];
	CGContextFillRect(context, rectToDrawIn);
	
	// Börja rita bilden till vänster
	// punkten p beskriver alltid var vi ska börja rita
	CGPoint p;
	p.x = PADDING + 100.0f + PADDING;
	p.y = PADDING;
	
	
	CGSize videoSize;
	videoSize.height = 100;
	videoSize.width = 100;
	
	CGRect frame = CGRectMake(PADDING, PADDING, videoSize.width, videoSize.height);
	
	UIWebView * videoView = [[UIWebView alloc] initWithFrame:frame];
	[videoView loadHTMLString:content.url baseURL:nil];

	[textColor set];
	[self.content.titel drawInRect:CGRectMake(p.x, p.y, 320-p.x-PADDING, 20.0f) withFont:messageTextFont];

	[infoTextColor set];
	
	// nästa ritpunkt nedåt
	p.y += PADDING + PADDING; 
	[self.content.kropp drawInRect:CGRectMake(p.x, p.y, 320-p.x-PADDING, 70.0f) withFont:infoTextFont];
}


@end
