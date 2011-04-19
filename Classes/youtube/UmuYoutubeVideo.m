//
//  UmuYoutubeVideo.m
//  UmuApp3
//
//  Created by Johan Forssell on 6/9/10.
//  Copyright 2010 Umeå University. All rights reserved.
//

#import "UmuYoutubeVideo.h"


@implementation UmuYoutubeVideo

@synthesize titel;
@synthesize url;
@synthesize kropp;
@synthesize datum;

- (id) init 
{
	if (self = [super init]) {
		[self setTitel:nil];
		[self setUrl:nil];
		[self setKropp:nil];
		[self setDatum:nil];
	}	
	return self;
}

- (void) dealloc
{
	[titel release];
	[url   release];
	[kropp release];	
	[super dealloc];
}

- (NSString *) getEmbedHtmlWithSize: (CGSize) size
{
	if (url == nil) 
		return nil;
	
	NSString *embedHTML = @"\
    <html><head>\
	<style type=\"text/css\">\
	body {\
	background-color: transparent;\
	color: white;\
	}\
	</style>\
	</head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
	width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";

	return [NSString stringWithFormat:embedHTML, url, size.width, size.height];
}



@end