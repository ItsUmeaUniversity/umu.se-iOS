//
//  UmuYoutubeVideo.h
//  UmuApp3
//
//  Created by Johan Forssell on 6/9/10.
//  Copyright 2010 Umeå University. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UmuYoutubeVideo : NSObject {
	NSString * titel;
	NSString * url;
	NSString * kropp;
	NSString * datum;
}

@property (retain) NSString * titel;
@property (retain) NSString * url;
@property (retain) NSString * kropp;
@property (retain) NSString * datum;

- (id) init;
- (NSString *) getEmbedHtmlWithSize: (CGSize) size;

@end
