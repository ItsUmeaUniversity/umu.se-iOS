//
//  FBTableViewController.m
//  UmuApp3
//
//  Created by Johan Forssell on 2010-05-23.
//  Copyright 2010 Umeå University. All rights reserved.
//

#import "FBTableViewController.h"
#import "umu_seAppDelegate.h"
#import "RootViewController.h"
#import "UmuFacebookWallMessage.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"

#import "UmuFBTableCell.h"
#import "ModalWebView.h"


@implementation FBTableViewController
@synthesize umuFacebookWallMessages;
@synthesize imageCache;
@synthesize rowHeights;
@synthesize modalWebView;

static NSString * const facebookFbUrl = @"fb://profile/185459445735";


-(id) initWithTabBar {
	if ([self init]) {
		self.title = @"Facebook";
		
		self.tabBarItem.image = [UIImage imageNamed:@"facebook_nav_liten.png"];
		
		self.navigationItem.title=@"Facebook";

		self.imageCache = [[NSMutableDictionary alloc] initWithCapacity:7];
		
		self.umuFacebookWallMessages = [[NSMutableArray alloc] initWithCapacity:25];

		UmuFacebookWallMessage * header = [[UmuFacebookWallMessage alloc] initEmpty];	
		header.link = [NSURL URLWithString:facebookFbUrl];
		[self.umuFacebookWallMessages addObject:header];

		self.rowHeights = [[NSMutableArray alloc] initWithCapacity:25];		
		//[self.rowHeights addObject:[NSNumber numberWithInt:FB_HEADER_ROWSIZE]];
		
		self.view.autoresizesSubviews = YES;
		self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
		// skapa en webbvy och sätt sedan action på knappen explicit
		//self.modalWebView = [[ModalWebView alloc] initWithFrame:self.view.frame];
		//[self.modalWebView addDoneButtonTarget:self action:@selector(dismissModalWebView)];
	}
	return self;
}

- (void)dealloc {
	[modalWebView release];
	[umuFacebookWallMessages release];
	[imageCache release];
	[rowHeights release];
    [super dealloc];
}



- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSURL *url = [NSURL URLWithString:NSLocalizedStringFromTable(@"facebook-graph", @"urls", @"")];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request startAsynchronous];

	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


- (void)viewDidAppear:(BOOL)animated {
    umu_seAppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.rootViewController showTabBar];
    
	[self updateLayoutForNewOrientation: self.interfaceOrientation];
}

-(void) willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation duration: (NSTimeInterval) duration {
	//NSLog(@"FB: willAnimateRotationToInterfaceOrientation %u", interfaceOrientation);
	//[super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
	[self updateLayoutForNewOrientation: interfaceOrientation];
}

- (void) updateLayoutForNewOrientation:(UIInterfaceOrientation) interfaceOrientation {
	//NSLog(@"FB: bredd tableview %f", self.tableView.frame.size.width);

    [self recalculateWidth];
}


#pragma mark Table view methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UmuFacebookWallMessage *  message = [umuFacebookWallMessages objectAtIndex:indexPath.row];

	if (message.link != nil) {
		NSString * scheme = [message.link scheme];
		
		if ([scheme isEqualToString:@"fb"])
		{
			if (![[UIApplication sharedApplication] openURL: message.link]) 
			{
				//failed to open in app.  Open the website in Safari instead.
				message.link = [NSURL URLWithString:NSLocalizedStringFromTable(@"facebook", @"urls", @"")];
			}
			
		}
		
		// Misslyckades att öppna sidan i facebook-appen, kör på webbvy
		modalWebView = [[ModalWebView alloc] initWithFrame:self.view.frame];
		[modalWebView addDoneButtonTarget:self action:@selector(dismissModalWebView)];
		[modalWebView loadUrl:message.link];	
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
							   forView:self.tabBarController.view 
								 cache:YES];

		[self.tabBarController.view addSubview:modalWebView];
		[UIView commitAnimations];
	}
}


/**
 Alla radhöjder förkalkyleras och sparas i en array.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
	NSNumber * heightAtIndex = [rowHeights objectAtIndex:indexPath.row];
	return [heightAtIndex floatValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [umuFacebookWallMessages count]; // vi har en headerrad på toppen
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	//NSString *name = [NSString stringWithFormat: @"cachedFBCell"];
	UmuFBTableCell *cell = (UmuFBTableCell *)[tableView dequeueReusableCellWithIdentifier:  @"cachedFBCell"];
	
	if (cell == nil) {
		cell = [[UmuFBTableCell alloc] initWithFrame:self.view.frame reuseIdentifier:  @"cachedFBCell"];
	}

	// Putta efter index med ett, för att föra in vår egna header på första raden
	UmuFacebookWallMessage * message = [umuFacebookWallMessages objectAtIndex:indexPath.row]; 
		
	if (message != nil)
	{
		if (message.link != nil) {
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		
		if (message.wallMessage != nil)
		{
			cell.messageText = message.wallMessage;
			cell.infoText = [NSString stringWithFormat:@"%@ - %@", message.fromName, message.createdAt];
			cell.image = [UIImage imageWithData:message.imageData];
		} 
		else // tom cell -specialbehandlas när den ritas upp
		{
			cell.messageText = @"";
			cell.infoText = @"";
			cell.image = [UIImage imageNamed:@"facebook_stor.gif"];		
		}
		
	}

	return cell;
}	



/**
 Räkna ut hur hög en rad ska vara givet en text i viss storlek
 */
- (NSNumber *) calculateRowSizeWithText:(UmuFacebookWallMessage *)message withWidth: (CGFloat) width {
	
	CGSize maxSize = CGSizeMake(width - PADDING - PADDING-IMAGE_WIDTH-PADDING-ADI_WIDTH, 999.9f);
	CGSize wallTextSize = [message.wallMessage sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE_LARGE]			 
									constrainedToSize:maxSize
										lineBreakMode:UILineBreakModeWordWrap];

	CGSize infoTextSize = [message.createdAt sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE_SMALL]];
	
	CGFloat height = wallTextSize.height + infoTextSize.height + PADDING + PADDING_SMALL + PADDING;
		
	if (height < 50.0f + PADDING + PADDING)
		height = 50.0f + PADDING + PADDING;
	
	return [NSNumber numberWithFloat:height];
}



- (void) recalculateWidth {
	//NSLog(@"recalculateWithWidth: %f (self...width: %f)", width, self.tableView.frame.size.width);
	[self.rowHeights removeAllObjects];
	
    if (modalWebView != nil) {
        [modalWebView updateLayoutForNewWidth:self.tableView.frame.size.width andHeight:self.parentViewController.view.frame.size.height];
    }
    
	for (UmuFacebookWallMessage * mess in umuFacebookWallMessages) {
		if (mess != nil) {
			NSNumber* height = [self calculateRowSizeWithText:mess withWidth: self.tableView.frame.size.width]; 
			[self.rowHeights addObject: height];
		}
	}
	
    [self.tableView reloadData];
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] 
                          withRowAnimation:UITableViewRowAnimationNone];
}


/*
 */
- (void)requestFinished:(ASIHTTPRequest *)request {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	NSString * data = [request responseString];
	[self createArrayFromResponse:data];
}


/**
 Create array of UMUFacebookWallMessages from fetched JSON-data
 */
- (void)createArrayFromResponse:(NSString *)responseString {
	NSError *error = nil;
	SBJSON *json = [[[SBJSON alloc] init] autorelease];
	NSDictionary * umuFacebookWallDictionary = [json objectWithString:responseString error:&error];
	
	if (umuFacebookWallDictionary == nil) {
		//NSLog(@"dict är nil, vi fick ingen data från FB");
	} else {
		for (NSDictionary * messageDict in [umuFacebookWallDictionary objectForKey:@"data"]) {
			UmuFacebookWallMessage * mess = [[[UmuFacebookWallMessage alloc] 
											 initFromName:[[messageDict objectForKey:@"from"] objectForKey:@"name"]
											 fromId:[[messageDict objectForKey:@"from"] objectForKey:@"id"] 
											 wallMessage:[messageDict objectForKey:@"message"]
											 link:[messageDict objectForKey:@"link"]
											 createdAt:[messageDict objectForKey:@"created_time"] 
											 withImageCache:imageCache] autorelease];			
			
			if (mess != nil) {
				[umuFacebookWallMessages addObject:mess];				
			}
		}
	}
	[self recalculateWidth];
	[self.tableView reloadData];
}

// Flippa bort webvyn
- (void) dismissModalWebView
{
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

