//
//  ScrollViewWithRows.h
//  UmuApp3
//
//  Created by Johan Forssell on 2010-06-10.
//  Copyright 2010 Umeå University. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ScrollViewWithRows : UIScrollView {
	int numRows;
	int rowHeight;
}

- (void) setNumRows: (int) number;
- (void) setRowHeight: (int) height;
- (id) initWithFrame:(CGRect)frame andRows:(int)rows ofHeight:(int) height;
- (void) drawRect:(CGRect)rect;

@end
