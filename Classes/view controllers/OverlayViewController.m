//
//  OverlayViewController.m
//  umu.se
//
//  Created by Johan Bucht on 2011-01-27.
//  Copyright 2011 UMU. All rights reserved.
//

#import "OverlayViewController.h"


@implementation OverlayViewController

@synthesize campusMapViewController;

- (id) initWithFrame: (CGRect) frame {
	self = [super init];
	
	self.view = [[UIView alloc] initWithFrame:frame];
	return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[campusMapViewController hideKeyboard];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];}

- (void)dealloc {
	[self.view release];
	[campusMapViewController release];
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}
@end
