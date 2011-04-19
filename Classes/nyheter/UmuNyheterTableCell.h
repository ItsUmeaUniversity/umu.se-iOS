//
//  UmuNyheterTableCell.h
//  UmuApp3
//
//  Created by Johan on 2010-06-01.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ABTableViewCell.h"

@interface UmuNyheterTableCell : ABTableViewCell {
	NSString *headlineText;
	CGSize   headlineTextSize;
	NSString *bodyText;
	CGSize   bodyTextSize;
}

@property (nonatomic, retain) NSString *headlineText;
@property (nonatomic, retain) NSString *bodyText;
@property (nonatomic) CGSize headlineTextSize;
@property (nonatomic) CGSize bodyTextSize;


@end
