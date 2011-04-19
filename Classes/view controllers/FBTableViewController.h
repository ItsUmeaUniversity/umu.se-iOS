//
//  FBTableViewController.h
//  UmuApp3
//
//  Created by Johan Forssell on 2010-05-23.
//  Copyright 2010 Umeå University. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UmuFacebookWallMessage.h"
#import "ModalWebView.h"
#import "BaseTableViewController.h"


@interface FBTableViewController : BaseTableViewController {

	NSMutableArray * umuFacebookWallMessages; 
	NSMutableDictionary * imageCache;
	NSMutableArray * rowHeights;
	ModalWebView * modalWebView;
}

@property (retain) NSMutableArray * umuFacebookWallMessages; 
@property (retain) NSMutableDictionary * imageCache;
@property (retain) NSMutableArray * rowHeights;
@property (retain) ModalWebView * modalWebView;

- (void) recalculateWidth;
- (id) initWithTabBar;
- (void) dismissModalWebView;
- (void)createArrayFromResponse:(NSString *)responseString;


#define FONT_SIZE 12.0f
#define FONT_SIZE_DETAIL 10.0f
#define CELL_CONTENT_MARGIN 10.0f
#define CELL_CONTENT_PADDING 5.0f



@end
