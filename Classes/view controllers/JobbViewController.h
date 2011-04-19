//
//  JobbViewController.h
//  UmuApp3
//
//  Created by Johan Forssell on 2010-05-24.
//  Copyright 2010 Umeå University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalWebView.h"
#import "BaseTableViewController.h"

@interface JobbViewController : BaseTableViewController {
	NSMutableArray * rssTitles;
	NSMutableArray * rssUrl;
	NSMutableArray * rssTime;
	NSMutableArray * rowHeights;
	ModalWebView * modalWebView;
}
@property (retain) NSMutableArray * rssTitles;
@property (retain) NSMutableArray * rssUrl;
@property (retain) NSMutableArray * rssTime;
@property (retain) NSMutableArray * rowHeights;
@property (retain) ModalWebView * modalWebView;


- (id)initWithTabBar;
- (void)createArrayFromResponse: (NSData *) response;
- (void) dismissModalWebView;

#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
#define WEBVIEW_TAG 9827
#define TOOLBAR_HEIGHT 44


@end
