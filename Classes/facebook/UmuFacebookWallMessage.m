//
//  UmuFacebookWallMessage.m
//  UmuApp2
//
//  Created by Johan Forssell on 2010-05-09.
//  Copyright 2010 Umeå University. All rights reserved.
//

#import "UmuFacebookWallMessage.h"


@implementation UmuFacebookWallMessage

@synthesize fromName;
@synthesize fromId;
@synthesize wallMessage;
@synthesize createdAt;
@synthesize imageData;
@synthesize imageCache;
@synthesize link;

- (id) init {
	if (self = [super init]) {
		[self setFromName:@""];
		[self setFromId:@""];
		[self setWallMessage:@""];
		[self setCreatedAt:@""];
		[self setImageData:nil];
		[self setLink:nil];
	}
	return self;
}

- (id) initFromName:(NSString *)fName 
			 fromId:(NSString *)fId 
		wallMessage:(NSString *)wMessage 
			   link:(NSString *)url
		  createdAt:(NSString *)creAt 
	 withImageCache:(NSMutableDictionary *)iCache
{
	if (self = [super init]) {
		self.fromName = fName;
		self.fromId = fId;
		self.wallMessage = wMessage;
		
		if (url != nil && [url length] > 3)
			self.link = [NSURL URLWithString:url];
		
		
		// "Parse" datestring in format 2010-05-07T17:50:58+0000
		if (creAt != nil) {
			NSMutableString	* dateString = [[NSMutableString alloc] initWithString:[creAt substringToIndex:10]];
			self.createdAt = dateString;
			[dateString release];
		}
		
		self.imageCache = iCache;		
		self.imageData = [self getImageFromId:self.fromId];
	}
	return self;
}

- (id) initEmpty
{
	if (self = [super init])
	{
		self.createdAt = nil;
		self.fromId = nil;
		self.fromName = nil;
		self.imageCache = nil;
		self.imageData = nil;
		self.link = nil;
		self.wallMessage = nil;
	}
	return self;
}


- (void) dealloc {
	[fromName release]; 
	[fromId release]; 
	[wallMessage release];
	[createdAt release];
	[imageData release];
	[imageCache release];
	[link release];
	[super dealloc];
}


// Sätt samman url till facebookbild utifrån id
- (NSString *) getImageUrlFromId:(NSString *)facebookId {
	NSString * trimmedId = [facebookId stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

	if (trimmedId == nil || [trimmedId length] == 0) {
		return nil;
	}
	
	
	NSMutableString * url = [NSMutableString stringWithString:@"http://graph.facebook.com/"];
	[url appendString:trimmedId];
	[url appendString:@"/picture"];

	return url;
}

// Hämta (liten) facebookbild för id.
// Håller koll på tidigare hämtade bilder i en cache
- (NSData *) getImageFromId:(NSString *)facebookId {
	NSURL *url = [NSURL URLWithString:[self getImageUrlFromId:facebookId]];
	
	if (imageCache != nil) {
		NSData * cachedImage = [imageCache objectForKey:[url absoluteURL]];
		if (cachedImage) {
			return cachedImage;
		}
	}
	
	NSError *error = nil;
	NSData *data = [NSData dataWithContentsOfURL:url
										 options:0
										   error:&error];
	if (data == nil) {
		NSLog(@"error when getting data from %@: \n%@", url, [error localizedDescription]);
	} 
	
	[imageCache setObject:data forKey:[url absoluteURL]];
	return data;
}

@end
