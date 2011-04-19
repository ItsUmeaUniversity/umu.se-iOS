// Copyright (c) 2008 Loren Brichter
// 
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
//  ABTableViewCell.m
//
//  Created by Loren Brichter
//  Copyright 2008 Loren Brichter. All rights reserved.
//

#import "ABTableViewCell.h"

@interface ABTableViewCellView : UIView
@end

@implementation ABTableViewCellView

- (void)drawRect:(CGRect)r
{
	[(ABTableViewCell *)[self superview] drawContentView:r];
}

@end



@implementation ABTableViewCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier])
	{
		contentView = [[ABTableViewCellView alloc] initWithFrame:CGRectZero];
		contentView.opaque = YES;
		[self addSubview:contentView];
		[contentView release];
    }
    return self;
}

- (void)dealloc
{
	[super dealloc];
}

- (void)setFrame:(CGRect)f
{
	[super setFrame:f];
	CGRect b = [self bounds];
	b.size.height -= 1; // leave room for the seperator line
	[contentView setFrame:b];
}

- (void)setNeedsDisplay
{
	[super setNeedsDisplay];
	[contentView setNeedsDisplay];
}

- (void)drawContentView:(CGRect)r
{
	// subclasses should implement this
}

/**
 Räkna ut hur stor en frame ska vara för att rymma en text, givet vissa förutsättningar.
 */
+ (CGSize)calculateRowSizeWithText:(NSString *)text 
							  fontSize:(CGFloat)fontSize 
							  maxWidth:(CGFloat)maxWidth 
{
	// Calculate min height given a certain width, an "unlimited" height and word wrapping
	CGSize cgSize = [text sizeWithFont:[UIFont systemFontOfSize:fontSize]
					 constrainedToSize:CGSizeMake(maxWidth, 9999)
						 lineBreakMode:UILineBreakModeWordWrap];

	// Enforce a minimum height
	//if (cgSize.height < minHeight)
	//	cgSize.height = minHeight;
	
	NSLog(@"height: %f, width: %f", cgSize.height, cgSize.width);
	
	return cgSize;
}


// räkna ut hur mycket plats som finns för text.
+ (CGFloat) calcTextWidth
{
	CGFloat width = FULL_WIDTH;
	
	// Padding vänster om bild
	width -= PADDING;
	
	// Bild
	width -= IMAGE_WIDTH;
	
	// Padding höger om bild
	width -= PADDING;
	
	// Padding höger om text
	width -= PADDING;
	
	// Disclosure indicator
	width -= ADI_WIDTH;
	
	return width;
}


@end
