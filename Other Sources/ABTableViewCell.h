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
//  ABTableViewCell.h
//
//  Created by Loren Brichter
//  Copyright 2008 Loren Brichter. All rights reserved.
//

#import <UIKit/UIKit.h>


// to use: subclass ABTableViewCell and implement -drawContentView:

@interface ABTableViewCell : UITableViewCell
{
	UIView *contentView;
}

- (void)drawContentView:(CGRect)r; // subclasses should implement


+ (CGSize)calculateRowSizeWithText:(NSString *)text 
						  fontSize:(CGFloat)fontSize 
						  maxWidth:(CGFloat)maxWidth;

+ (CGFloat) calcTextWidth;

//
// Some constants
//

// Font size
#define FONT_SIZE_LARGE 12.0f
#define FONT_SIZE_SMALL 10.0f

// Padding between objects
#define PADDING 8.0f

// Text field sizes
#define FULL_WIDTH 320.0f
#define IMAGE_WIDTH 50.0f
#define ADI_WIDTH 20.0f



@end
