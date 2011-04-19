//
//  WelcomeViewController.m
//  UmuApp3
//
//  Created by Johan Forssell on 2010-06-11.
//  Copyright 2010 Umeå University. All rights reserved.
//
#import "umu_seAppDelegate.h"
#import "RootViewController.h"

#import "WelcomeViewController.h"
#import "ModalWebView.h"
#import "ABTableViewCell.h"
#import "Reachability.h"


@implementation WelcomeViewController

@synthesize modalWebView;
@synthesize newOrientation;


-(id) initWithTabBar {
	
	if ([self init]) {
		self.title = NSLocalizedString(@"Welcome", @"");
		
		self.tabBarItem.image = [UIImage imageNamed:@"53-house.png"];
		
		self.navigationItem.title=NSLocalizedString(@"Welcome", @"");
	}
	
	//[self.view setBackgroundColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bakgrund_liten.png"]];
    self.view.frame = CGRectMake(0, 0, 320, 480);
    
	
    CGRect frame = CGRectMake((320-264)/2-10, 15, 264, 60);
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:@"logga_rubrik.png"];
    [self.view addSubview:imageView];
    [imageView release];
    
    
	[self setupButtons];
    
    umu_seAppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.rootViewController toggleTabBar];    
	return self;
}

- (void)dealloc {
	[modalWebView release];
    [super dealloc];
}



- (void)viewDidLoad {
	[super viewDidLoad];
    
	// Se till att programmet varnar om internettillgång saknas
	if (![[Reachability reachabilityWithHostName:@"www.umu.se"] currentReachabilityStatus]) {
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Kan inte nå umu.se" 
														 message:@"umu.se kan för tillfället inte nås\nDenna app kräver tillgång till internet för att fungera" 
														delegate:self 
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil] 
							  autorelease];
		[alert show];		
	}
}

-(void) willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation 
                                         duration: (NSTimeInterval) duration {
    
	[super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
    newOrientation = interfaceOrientation;
}


// Kallas på när man går tillbaka till fliken från de andra flikarna.
// Måste gömma flikarna igen m.h.a. hidetabbar().
-(void)viewDidAppear:(BOOL)animated {
    //NSLog(@"welcome did appear");
	[self updateLayoutForNewOrientation: self.interfaceOrientation];
    
    umu_seAppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.rootViewController toggleTabBar];    
}

// vyn har roterat klart - nu kan vi eventuellt flytta knapparna
-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"bytte från %u till %u", fromInterfaceOrientation, newOrientation);
    CGFloat goNorth = 50.0f;
    CGFloat goEast  = 40.0f;

    [UIView beginAnimations:nil context:nil]; 
    [UIView setAnimationDuration:0.6f];

    
    if (UIInterfaceOrientationIsPortrait(fromInterfaceOrientation) && UIInterfaceOrientationIsLandscape(newOrientation)) 
    {
        UIView *button = [self.view viewWithTag:W_BUTTON_NEWS];
        button.center = CGPointMake(button.center.x+goEast, button.center.y-goNorth);
        
        button = [self.view viewWithTag:W_BUTTON_FB];
        button.center = CGPointMake(button.center.x+goEast, button.center.y-goNorth);
        
        button = [self.view viewWithTag:W_BUTTON_YT];
        button.center = CGPointMake(button.center.x+goEast+W_COL_PADDING+W_COL_PADDING, button.center.y-W_ROW_PADDING-goNorth);
        
        button = [self.view viewWithTag:W_BUTTON_MAP];
        button.center = CGPointMake(button.center.x+goEast-W_COL_PADDING, button.center.y-17-goNorth);
        
        button = [self.view viewWithTag:W_BUTTON_MAIL];
        button.center = CGPointMake(button.center.x+goEast+W_COL_PADDING, button.center.y-130-goNorth);
    } 
    else if (UIInterfaceOrientationIsLandscape(fromInterfaceOrientation) && UIInterfaceOrientationIsPortrait(newOrientation))
    {
        UIView *button = [self.view viewWithTag:W_BUTTON_NEWS];
        button.center = CGPointMake(button.center.x-goEast, button.center.y+goNorth);
        
        button = [self.view viewWithTag:W_BUTTON_FB];
        button.center = CGPointMake(button.center.x-goEast, button.center.y+goNorth);
        
        button = [self.view viewWithTag:W_BUTTON_YT];
        button.center = CGPointMake(button.center.x-goEast-W_COL_PADDING-W_COL_PADDING, button.center.y+W_ROW_PADDING+goNorth);

        
        button = [self.view viewWithTag:W_BUTTON_MAP];
        button.center = CGPointMake(button.center.x-goEast+W_COL_PADDING, button.center.y+17+goNorth);
        
        button = [self.view viewWithTag:W_BUTTON_MAIL];
        button.center = CGPointMake(button.center.x-goEast-W_COL_PADDING, button.center.y+130+goNorth);
    }
    [UIView commitAnimations];            
}

- (void) updateLayoutForNewOrientation:(UIInterfaceOrientation) interfaceOrientation {
    
    // Styr upp vy och tabbar
    umu_seAppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    for(UIView *view in appDelegate.rootViewController.tabBarController.view.subviews)
    {        
        
        if([view isKindOfClass:[UITabBar class]])
        {           
            // håll vår UITabBar just utanför vyn
            [view setFrame:CGRectMake(view.frame.origin.x, self.parentViewController.view.frame.size.height, 
                                      self.parentViewController.view.frame.size.width, view.frame.size.height)];
        } else {
            // vår UIView måste också hålla rätt storlek
            [view setFrame:CGRectMake(view.frame.origin.x, 
                                      view.frame.origin.y, 
                                      self.parentViewController.view.frame.size.width, 
                                      self.parentViewController.view.frame.size.height)];          
        }
    }
}



// 30 - 108 - x - 108 - 30
// 3
- (void)setupButtons
{	 
	float x = 40.0;
	float y = 120.0;
	float w = 108.0;
	float h = 108.0;
	
	CGRect frame = CGRectMake(x, y, w, h);
    
    UIImage * img = [UIImage imageNamed:@"nyheter_knapp.png"];
	UIButton * newsButton = [[UIButton alloc] initWithFrame:frame];
    [newsButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [newsButton setImage:img forState:UIControlStateNormal];
    [newsButton addTarget:self action:@selector(pressNewsButton) forControlEvents:UIControlEventTouchUpInside];
    [newsButton setTag:W_BUTTON_NEWS];
	[self.view addSubview:newsButton];
	[newsButton release];
    img = nil;
    
    
    x += W_COL_PADDING;
    frame = CGRectMake(x, y, w, h);
    img = [UIImage imageNamed:@"facebook_knapp.png"];
	UIButton * fbButton = [[UIButton alloc] initWithFrame:frame];
    [fbButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [fbButton setImage:img forState:UIControlStateNormal];
    [fbButton addTarget:self action:@selector(pressFbButton) forControlEvents:UIControlEventTouchUpInside];
    [fbButton setTag:W_BUTTON_FB];
	[self.view addSubview:fbButton];
	[fbButton release];
    img = nil;
    
    
    x -= W_COL_PADDING;
    y += W_ROW_PADDING;
    frame = CGRectMake(x, y, w, h);
    img = [UIImage imageNamed:@"youtube_knapp.png"];
	UIButton * youtubeButton = [[UIButton alloc] initWithFrame:frame];
    [youtubeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [youtubeButton setImage:img forState:UIControlStateNormal];
    [youtubeButton addTarget:self action:@selector(pressYoutubeButton) forControlEvents:UIControlEventTouchUpInside];
    [youtubeButton setTag:W_BUTTON_YT];
	[self.view addSubview:youtubeButton];
	[youtubeButton release];
    img = nil;
    
    
    x += W_COL_PADDING;
    frame = CGRectMake(x, y, w, h);
    img = [UIImage imageNamed:@"karta_knapp.png"];
	UIButton * mapButton = [[UIButton alloc] initWithFrame:frame];
    [mapButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [mapButton setImage:img forState:UIControlStateNormal];
    [mapButton addTarget:self action:@selector(pressMapButton) forControlEvents:UIControlEventTouchUpInside];
    [mapButton setTag:W_BUTTON_MAP];
	[self.view addSubview:mapButton];
	[mapButton release];
    img = nil;
    
    
    x = 30;
	y = 380;
    w = self.view.frame.size.width-x-x;
    h = 50;
	frame = CGRectMake(x, y, w, h);
	UIButton * kontaktaOssIPhone = [[UIButton alloc] initWithFrame:frame];
	[kontaktaOssIPhone setImage:[UIImage imageNamed:@"vad_tycker_du.png"] forState:UIControlStateNormal];
	[kontaktaOssIPhone setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
	[kontaktaOssIPhone addTarget:self action:@selector(pressKontaktaIPhone) forControlEvents:UIControlEventTouchUpInside];
    [kontaktaOssIPhone setTag:W_BUTTON_MAIL];
	[self.view addSubview:kontaktaOssIPhone];
	[kontaktaOssIPhone release];
}


- (void) pressNewsButton {
    [self removeWelcomeTab];
    umu_seAppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.rootViewController.tabBarController setSelectedIndex:0];    
    [appDelegate.rootViewController.tabBarController.selectedViewController viewDidAppear:YES];  
}
- (void) pressFbButton {
    [self removeWelcomeTab];
    umu_seAppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.rootViewController.tabBarController setSelectedIndex:1];    
    [appDelegate.rootViewController.tabBarController.selectedViewController viewDidAppear:YES];  
}
- (void) pressYoutubeButton {
    [self removeWelcomeTab];
    umu_seAppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.rootViewController.tabBarController setSelectedIndex:2];    
    [appDelegate.rootViewController.tabBarController.selectedViewController viewDidAppear:YES];
}
- (void) pressMapButton {
    [self removeWelcomeTab];
    umu_seAppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.rootViewController.tabBarController setSelectedIndex:3];    
    [appDelegate.rootViewController.tabBarController.selectedViewController viewDidAppear:YES];
}


- (void) pressKontaktaIPhone {
	[[UIApplication sharedApplication] 
	 openURL:[NSURL URLWithString:@"mailto:iphone@umu.se?subject=Ume%C3%A5%20universitets%20iPhoneapp"]];
}

- (void) removeWelcomeTab {
    NSMutableArray * vcs = [NSMutableArray arrayWithArray:[self.tabBarController viewControllers]];
	[vcs removeObjectAtIndex:0];
	[self.tabBarController setViewControllers:vcs];
}



- (void) dismissModalWebView
{
	//NSLog(@"Dismissing");
	[UIView beginAnimations:nil context:NULL];
	
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight 
						   forView:self.tabBarController.view 
							 cache:YES];
	[self.modalWebView removeFromSuperview];
	
	[UIView commitAnimations];
    
    [modalWebView release];
    modalWebView = nil;
}

@end
