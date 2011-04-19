//
//  UmuYTTableCell.h
//  UmuApp3
//
//  Created by Johan Forssell on 6/9/10.
//  Copyright 2010 Umeå University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UmuYoutubeVideo.h"
#import "ABTableViewCell.h"

@interface UmuYTTableCell : ABTableViewCell {
	UmuYoutubeVideo * content;
}

@property (retain) UmuYoutubeVideo * content;




@end
