//
//  RootViewController.m
//  UmuApp3
//
//  Created by Johan Forssell on 2010-05-23.
//  Copyright 2010 Umeå University. All rights reserved.
//

#import "RootViewController.h"
#import "WelcomeViewController.h"
#import "FBTableViewController.h"
#import "NyheterTableViewController.h"
#import "YouTubeViewController.h"
#import "JobbViewController.h"
#import "CampusMapViewController.h"



@implementation RootViewController

@synthesize tabBarController;
@synthesize hiddenTabBar;

- (void)loadView {
	UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	contentView.backgroundColor = [UIColor darkGrayColor];
	self.view = contentView;
	[contentView release];
	
	tabBarController = [[UITabBarController alloc] init];
	
	CGRect tabBarFrame;
	tabBarFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	tabBarController.view.frame = tabBarFrame;
	
	NSMutableArray *localControllersArray = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
	
	
	WelcomeViewController * welcomeViewController = [[[WelcomeViewController alloc] initWithTabBar] autorelease];
	[localControllersArray addObject:welcomeViewController];
	
	NyheterTableViewController * nyheterViewController = [[[NyheterTableViewController alloc] initWithTabBar] autorelease];
	[localControllersArray addObject:nyheterViewController];
	
	FBTableViewController * fbViewController = [[[FBTableViewController alloc] initWithTabBar] autorelease];
	[localControllersArray addObject:fbViewController];
	
	
	YouTubeViewController * youtubeViewController = [[[YouTubeViewController alloc] initWithTabBar] autorelease];
	[localControllersArray addObject:youtubeViewController];
	
	CampusMapViewController *campusMapViewController = [[[CampusMapViewController alloc] initWithTabBar] autorelease];
	[localControllersArray addObject:campusMapViewController];
	
	tabBarController.viewControllers = localControllersArray;
	
	tabBarController.view.tag = 1980;
	[self.view addSubview:tabBarController.view];
	
	self.tabBarController.view.autoresizesSubviews = YES;
    
    // Delegera 
    self.tabBarController.delegate = self;
    
    //hiddenTabBar = FALSE;
}


////////////////////////////////////////////////////////////////////

/*
 Implementation of the UITabBarControllerDelegete
 */
- (void)tabBarController:(UITabBarController *)tabBarController 
 didSelectViewController:(UIViewController *)viewController 
{
    //NSLog(@"ROOT didSelectViewController %@", viewController.title);
    [viewController viewDidAppear:YES];
}
////////////////////////////////////////////////////////////////////


-(void) willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation duration: (NSTimeInterval) duration {
	//NSLog(@"Root willAnimateRotation - %u", interfaceOrientation);
	for (UIViewController *view in tabBarController.viewControllers) {
		[view willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
	}
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	for (UIViewController *view in tabBarController.viewControllers) {
		[view didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


- (void)dealloc {
    [super dealloc];
}



/*
 * Visa upp vår UITabBar för att kunna navigera
 */
//BOOL hiddenTabBar;
- (void) toggleTabBar {
    // se http://www.idev101.com/code/User_Interface/sizes.html
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1];
    
    for(UIView *view in tabBarController.view.subviews)
    {        
        if([view isKindOfClass:[UITabBar class]])
        {            
            if (hiddenTabBar) {
                [view setFrame:CGRectMake(view.frame.origin.x, self.view.frame.size.height-49, 
                                          view.frame.size.width, view.frame.size.height)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, self.view.frame.size.height, 
                                          view.frame.size.width, view.frame.size.height)];
            }
        } else {
            if (hiddenTabBar) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, 
                                          view.frame.size.width, self.view.frame.size.height-49)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, 
                                          view.frame.size.width, self.view.frame.size.height)];
            }
            
        }
    }
    
    [UIView commitAnimations];
    
    hiddenTabBar = !hiddenTabBar;
    
}

- (void) showTabBar {
    // se http://www.idev101.com/code/User_Interface/sizes.html
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1];
    
    if (hiddenTabBar) {
        for(UIView *view in tabBarController.view.subviews)
        {        
            if([view isKindOfClass:[UITabBar class]])
            {            
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-49, 
                                          view.frame.size.width, view.frame.size.height)];
                
                
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, 
                                          view.frame.size.width, view.frame.size.height-49)];
                
            }
        }
        
        // nu är den inte längre gömd
        hiddenTabBar = !hiddenTabBar;    
    }
    [UIView commitAnimations];    
}



@end
