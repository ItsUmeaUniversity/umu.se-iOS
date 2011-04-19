//
//  UmuFBTableCell.h
//  UmuApp3
//
//  Created by Johan Forssell on 2010-06-01.
//  Copyright 2010 Umeå University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABTableViewCell.h"


@interface UmuFBTableCell : ABTableViewCell {
	NSString *messageText;
	CGSize   messageTextSize;
	NSString *infoText;
	CGSize   infoTextSize;
	UIImage  *image;
}

@property (nonatomic, retain) NSString *messageText;
@property (nonatomic, retain) NSString *infoText;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic) CGSize messageTextSize;
@property (nonatomic) CGSize infoTextSize;



- (CGFloat) getCellHeight;

#define FONT_SIZE_HEADER 12.0f
#define FB_PROFILE_IMAGE_SIZE IMAGE_WIDTH
#define FB_LOGO_SIZE 32.0f
#define FB_HEADER_ROWSIZE 44.0f

@end
