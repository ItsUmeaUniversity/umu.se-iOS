//
//  umu_seAppDelegate.m
//  umu.se
//
//  Created by Johan Forssell on 6/11/10.
//  Copyright Umeå University 2010. All rights reserved.
//

#import "umu_seAppDelegate.h"
#import "RootViewController.h"


@implementation umu_seAppDelegate

@synthesize window;
@synthesize rootViewController;
@synthesize splashView;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	
	rootViewController = [[RootViewController alloc] init];
	[window addSubview:rootViewController.view];
	[window makeKeyAndVisible];
	
	splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
	splashView.image = [UIImage imageNamed:@"Default.png"];

	[window addSubview:splashView];
	[window bringSubviewToFront:splashView];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:window cache:YES];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
	splashView.alpha = 0.0;
	splashView.frame = CGRectMake(-60, -85, 440, 635);
	[UIView commitAnimations];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Laddas inte tidigt nog, ser konstigt ut tillsammans med splash screen
	[application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
}


- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[self.splashView removeFromSuperview];
	[self.splashView release];
}

- (void)dealloc {
	[splashView release];
	[rootViewController release];
    [window release];
    [super dealloc];
}


@end
