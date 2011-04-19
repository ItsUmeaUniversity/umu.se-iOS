//
//  NyheterTableViewController.h
//  UmuApp3
//
//  Created by Johan Forssell on 2010-05-23.
//  Copyright 2010 Umeå University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalWebView.h"
#import "BaseTableViewController.h"

@interface NyheterTableViewController : BaseTableViewController {
	NSMutableArray * rssTitles;
	NSMutableArray * rssUrl;
	NSMutableArray * rssBody;
	NSMutableArray * rssTime;
	NSMutableArray * rowHeights;
	ModalWebView *modalWebView;
}

@property (retain) NSMutableArray * rssTitles;
@property (retain) NSMutableArray * rssUrl;
@property (retain) NSMutableArray * rssBody;
@property (retain) NSMutableArray * rssTime;
@property (retain) NSMutableArray * rowHeights;
@property (retain) ModalWebView *modalWebView;

- (id)initWithTabBar;
- (void)createArrayFromResponse: (NSData *) response;
- (NSNumber *) calculateRowSizeWithHeadline:(NSString *)headline andBody:(NSString *)body withWidth:(CGFloat) width;
- (void) recalculateWidth;
- (void) dismissModalWebView;


#define FONT_SIZE_NYHETER 14.0f
#define FONT_SIZE_NYHETER_DETAIL 12.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
#define CELL_CONTENT_PADDING 25

@end
