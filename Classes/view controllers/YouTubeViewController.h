//
//  YouTubeViewController.h
//  UmuApp3
//
//  Created by Johan Forssell on 2010-05-23.
//  Copyright 2010 Umeå University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UmuYoutubeVideo.h"
#import "GDataServiceGoogleYouTube.h"
#import "GDataFeedYouTubeVideo.h"
#import "BaseViewController.h"


@interface YouTubeViewController : BaseViewController {
	NSMutableArray * youtubeVideos;
	
	GDataFeedYouTubeVideo * entriesFeed;
	GDataServiceTicket * entriesFetchTicket;
	NSError * entriesFetchError;	
	UIScrollView *scrollview;
	int drawAtY;
}

@property (retain) NSMutableArray * youtubeVideos;
@property (retain) GDataFeedYouTubeVideo * entriesFeed;
@property (retain) GDataServiceTicket * entriesFetchTicket;
@property (retain) NSError * entriesFetchError;
@property (retain) UIScrollView *scrollview;


- (int) drawAtY;


- (id)   initWithTabBar;

- (NSString *) getEmbedHtmlWithUrl: (NSString *) url andSize: (CGSize) size;
- (GDataServiceGoogleYouTube *) youTubeService;
- (void) fetchAllEntries;

- (void) drawRows:(UIInterfaceOrientation) interfaceOrientation;

- (UILabel * ) titleLabelRelativeTo: (CGRect) wvFrame withText:(NSString *) text;
- (UILabel *) bodyLabelRelativeTo: (CGRect) titleLabelFrame withText:(NSString *) text;
- (UIView *) separatorBelowRow: (int) where;

//
// Defines
//
#define ROW_PADDING 10.0f
#define ROW_HEIGHT 110.0f	// 100 + Padding
#define WEBVIEW_SIZE 100.0f	// en fyrkant på 100x100 

@end
