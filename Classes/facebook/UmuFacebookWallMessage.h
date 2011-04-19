//
//  UmuFacebookWallMessage.h
//  UmuApp2
//
//  Created by Johan Forssell on 2010-05-09.
//  Copyright 2010 Umeå University. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UmuFacebookWallMessage : NSObject {
	NSString * fromName;
	NSString * fromId;
	NSString * wallMessage;
	NSString * createdAt;
	NSData   * imageData;
	NSURL    * link;
	NSMutableDictionary * imageCache;
}

@property (retain) NSString * fromName;
@property (retain) NSString * fromId;
@property (retain) NSString * wallMessage;
@property (retain) NSURL    * link;
@property (retain) NSString * createdAt;
@property (retain) NSData   * imageData;
@property (retain) NSMutableDictionary * imageCache;


// ------------------------------
- (id) init;
- (id) initEmpty;
- (id) initFromName:(NSString *)fName 
			 fromId:(NSString *)fId 
		wallMessage:(NSString *)wMessage 
			   link:(NSString *)url
		  createdAt:(NSString *)creAt
     withImageCache:(NSMutableDictionary *)iCache;

- (NSString *) getImageUrlFromId:(NSString *)facebookId;
- (NSData *) getImageFromId:(NSString *)facebookId;

@end
