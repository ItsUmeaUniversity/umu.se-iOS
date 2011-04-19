//
//  CampusMapViewController.m
//  umu.se
//
//  Created by Johan Bucht on 2011-01-17.
//  Copyright 2011 UMU. All rights reserved.
//

#import "CampusMapViewController.h"
#import "OverlayViewController.h"
#import "ModalWebView.h"
#import "umu_seAppDelegate.h"
#import "RootViewController.h"

@implementation CampusMapViewController

@synthesize overlay, webView, searchBar, modalWebView;

-(id) initWithTabBar {
	if ([self init]) {
		self.title = NSLocalizedString(@"Map", @"");
		CGRect frame = self.view.frame;
		self.tabBarItem.image = [UIImage imageNamed:@"103-map.png"];
		
		self.navigationItem.title = NSLocalizedString(@"Map", @"");
		webView = [[UIWebView alloc] init];
		
		//webView.frame = CGRectMake(0, 40, 1.0, 1.0);
		webView.frame = CGRectMake(0, 40, frame.size.width, frame.size.height);
		webView.delegate = self;
		
		searchBar = [[UISearchBar alloc] initWithFrame: CGRectMake(0.0f,0.0f,frame.size.width, 40.0f)];
		searchBar.delegate = self;
        searchBar.placeholder = @"t.ex. ub334, mikro, fysikhuset, cafe ...";
		
		[self createOverlay];
		
		
		[self.view addSubview:searchBar];
		[self.view addSubview:webView];
		[self.view insertSubview:overlay.view aboveSubview:self.view];
        
        
        self.view.autoresizesSubviews = YES;
		self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
		
		[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:NSLocalizedStringFromTable(@"google maps", @"urls", @"")]]];
		
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	}
	
	return self;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		modalWebView = [[ModalWebView alloc] initWithFrame: self.view.frame];
		[modalWebView addDoneButtonTarget:self action:@selector(dismissModalWebView)];
		
		//NSLog(@"%@", request.URL);
		[modalWebView loadUrl:request.URL];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
							   forView:self.tabBarController.view 
								 cache:NO];
		
		[self.tabBarController.view addSubview:modalWebView];
		[UIView commitAnimations];
		return NO;
	}
	
	return YES;
}

-(void) viewWillAppear: (BOOL) animated {
	//NSLog(@"viewWillAppear %u", self.interfaceOrientation);
	[self updateLayoutForNewOrientation: self.interfaceOrientation];
}

-(void) willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation duration: (NSTimeInterval) duration {
	//NSLog(@"Map: willAnimateRotationToInterfaceOrientation %u", interfaceOrientation);
	[self updateLayoutForNewOrientation: interfaceOrientation];
	[super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
}



- (void) updateLayoutForNewOrientation:(UIInterfaceOrientation) interfaceOrientation {
    CGRect frame = self.view.frame;
    //NSLog(@"frame.size.width: %f", frame.size.width);
    
    if (modalWebView != nil) {
        [modalWebView updateLayoutForNewWidth:frame.size.width andHeight:self.parentViewController.view.frame.size.height];
    } 
    
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) 
    { 
		webView.frame = CGRectMake(0, 40, frame.size.width, 370);
		searchBar.frame = CGRectMake(0.0f,0.0f,frame.size.width, 40.0f);
		overlay.view.frame = CGRectMake(0, 40, frame.size.width, 380);
        
    } else {
		webView.frame = CGRectMake(40, 0, 370, frame.size.width);	
		searchBar.frame = CGRectMake(0.0f,0.0f,40.0f, frame.size.width);
		overlay.view.frame = CGRectMake(0, 40, 380, frame.size.width);
	}
}

/**
 Create an overlay that is shown when the searchbar receives focus and 
 responds to a touch event which hides the keyboard and itself.
 */
- (void) createOverlay {
	CGRect frame = CGRectMake(0, 40, 320, 380);
	overlay = [[OverlayViewController alloc] initWithFrame: frame];
	overlay.view.backgroundColor = [UIColor grayColor];
	overlay.view.alpha = 0.5;
	overlay.campusMapViewController = self;
	overlay.view.hidden = TRUE;	
}

- (void) hideKeyboard {
	overlay.view.hidden = TRUE;
	[searchBar resignFirstResponder];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	overlay.view.hidden = FALSE;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	
	NSString * searchString = [NSString stringWithFormat:@"usearch('%@')", theSearchBar.text];
	
	overlay.view.hidden = TRUE;
	[theSearchBar resignFirstResponder];
	[webView stringByEvaluatingJavaScriptFromString:searchString];
}


- (void)dealloc {
	[overlay release];
	[searchBar release];
	[webView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad]; 
	
}

- (void)viewDidAppear:(BOOL)animated {
    //NSLog(@"map did appear");
    
    umu_seAppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.rootViewController showTabBar];
    
    [self updateLayoutForNewOrientation: self.interfaceOrientation];
}

- (void) dismissModalWebView
{
	[UIView beginAnimations:nil context:NULL];
	
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight 
						   forView:self.tabBarController.view 
							 cache:YES];
	[modalWebView removeFromSuperview];
    [UIView commitAnimations];
    
    [modalWebView release];
    modalWebView = nil;
}

@end
