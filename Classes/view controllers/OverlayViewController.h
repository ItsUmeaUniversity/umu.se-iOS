//
//  OverlayViewController.h
//  umu.se
//
//  Created by Johan Bucht on 2011-01-27.
//  Copyright 2011 UMU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CampusMapViewController.h"

@class CampusMapViewController; 

@interface OverlayViewController : UIViewController {
	CampusMapViewController *campusMapViewController;
}

@property (nonatomic, retain) CampusMapViewController *campusMapViewController;

@end
