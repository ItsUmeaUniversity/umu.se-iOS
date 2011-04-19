//
//  ScrollViewWithRows.m
//  UmuApp3
//
//  Created by Johan Forssell on 2010-06-10.
//  Copyright 2010 Umeå University. All rights reserved.
//

#import "ScrollViewWithRows.h"


@implementation ScrollViewWithRows 

- (void) setNumRows: (int) number
{
	numRows = number;
}

- (void) setRowHeight: (int) height
{
	rowHeight = height;
}


- (id) initWithFrame:(CGRect)frame andRows:(int)rows ofHeight:(int) height
{
	self = (ScrollViewWithRows *)[super initWithFrame:frame];
	if (self)
	{	
		self.numRows = rows;
		self.rowHeight = height;
	}
	return self;
}


//
- (void)drawRect:(CGRect)rect {

	CGFloat x = rowHeight;
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetRGBStrokeColor(ctx, 0.5, 0.5, 0.5, 1.0);
	CGContextSetLineWidth(ctx, 0.5);
	
	for (int i = 1; i < numRows; i++) {
		CGContextMoveToPoint(ctx, x-4, 0);
		CGContextAddLineToPoint(ctx, x-4, 320);
		NSLog(@"ritar på rad %f", x-4);
		x += rowHeight; 
		CGContextStrokePath(ctx);
	}
	
	[super drawRect:rect];
}
@end
