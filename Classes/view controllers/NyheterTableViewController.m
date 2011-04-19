//
//  NyheterTableViewController.m
//  UmuApp3
//
//  Created by Johan Forssell on 2010-05-23.
//  Copyright 2010 Umeå University. All rights reserved.
//

#import "NyheterTableViewController.h"
#import "umu_seAppDelegate.h"
#import "RootViewController.h"
#import "ASIHTTPRequest.h"
#import "XPathQuery.h"
#import "ABTableViewCell.h"
#import "ModalWebView.h"



@implementation NyheterTableViewController

@synthesize rssTitles;
@synthesize rssUrl;
@synthesize rssBody;
@synthesize rssTime;
@synthesize rowHeights;
@synthesize modalWebView;

-(id) initWithTabBar {
	if ([self init]) {
        //NSLog(@"initWithTabBar");
        
		self.title = NSLocalizedString(@"News", @"");
		
		self.tabBarItem.image = [UIImage imageNamed:@"nyheter_nav_liten.png"];
		
		self.navigationItem.title=NSLocalizedString(@"News", @"");
		
		self.rssTitles = [[NSMutableArray alloc] init];
		self.rssUrl = [[NSMutableArray alloc] init];
		self.rssBody = [[NSMutableArray alloc] init];
		self.rssTime = [[NSMutableArray alloc] init];
		self.rowHeights = [[NSMutableArray alloc] init];

		self.view.autoresizesSubviews = YES;
		self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	}
	return self;
}

- (void)dealloc {
	[rowHeights release];
	[rssTitles release];
	[rssUrl release];
	[rssBody release];
	[rssTime release];
    [super dealloc];
}

-(void) viewWillAppear: (BOOL) animated {
	[self updateLayoutForNewOrientation: self.interfaceOrientation];
}

-(void) willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation duration: (NSTimeInterval) duration {
	//NSLog(@"nyheter: willAnimateRotationToInterfaceOrientation %u", interfaceOrientation);

	[self updateLayoutForNewOrientation: interfaceOrientation];
}


- (void) updateLayoutForNewOrientation:(UIInterfaceOrientation) interfaceOrientation {
    //NSLog(@"nyheter updateLayoutForNewOrientation");
    [super updateLayoutForNewOrientation:interfaceOrientation];

    //NSLog(@"update layout for new orientation with width %f ", self.tableView.frame.size.width);
    

    [self recalculateWidth];  
    if (modalWebView != nil) {
        [modalWebView updateLayoutForNewWidth:self.tableView.frame.size.width andHeight:self.parentViewController.view.frame.size.height];
    }         
}




- (void)viewDidLoad {
    //NSLog(@"viewDidLoad");
    [super viewDidLoad];

	NSURL *url = [NSURL URLWithString:NSLocalizedStringFromTable(@"news", @"urls", @"")];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request startAsynchronous];
	//NSLog(@"har startat hämtning från %@", [url standardizedURL]);
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)viewDidAppear:(BOOL)animated {    
    //NSLog(@"nyheter viewDidAppear");    
    umu_seAppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.rootViewController showTabBar];

	[self updateLayoutForNewOrientation: self.interfaceOrientation];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [rssTitles count];
}


// hjälpreda för att bygg kroppen på meddelandet
id buildBodyText(NSString *rssTime, NSString *rssBody) {
	int length = [rssTime length] - 7;
	return [NSString stringWithFormat:@"%@\n- %@", rssBody, [rssTime substringToIndex:length]];
}

//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	
	if ([rssTitles objectAtIndex:indexPath.row] != nil) {
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		cell.textLabel.text = [rssTitles objectAtIndex:indexPath.row];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE_LARGE];
		cell.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
		cell.textLabel.numberOfLines = 0;
		
		cell.detailTextLabel.text = buildBodyText([rssTime objectAtIndex:[indexPath row]], [rssBody objectAtIndex:[indexPath row]]);			
		cell.detailTextLabel.font = [UIFont systemFontOfSize:FONT_SIZE_LARGE];
		cell.detailTextLabel.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
		cell.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
		cell.detailTextLabel.numberOfLines = 0;
	}
	
    return cell;
}

//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRowAtIndexPath");

	modalWebView = [[ModalWebView alloc] initWithFrame:self.view.frame];
	[modalWebView addDoneButtonTarget:self action:@selector(dismissModalWebView)];
	
	[modalWebView loadUrl:[rssUrl objectAtIndex:indexPath.row]];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
						   forView:self.tabBarController.view 
							 cache:NO];

	[self.tabBarController.view addSubview:modalWebView];
	[UIView commitAnimations];	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
	NSNumber * heightAtIndex = [rowHeights objectAtIndex:indexPath.row];
	return [heightAtIndex floatValue];
}


- (void)requestFinished:(ASIHTTPRequest *)request {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	NSData * data = [request responseData];
	[self createArrayFromResponse:data];
}

- (void)createArrayFromResponse: (NSData *) response
{

	NSString *xpathQueryString = @"//item";
	NSArray * parseResults = PerformXMLXPathQuery(response, xpathQueryString);
	
	for (id itemDict in parseResults) {
		NSString * nodeName = [itemDict valueForKey:@"nodeName"];
		
		if ([nodeName compare:@"item"] == 0) {
			NSString * aTitle = nil;
			NSString * aBody = nil;
			NSString * aTime = nil;
			NSURL * anUrl = nil;
			
			for (id contentDict in [itemDict valueForKey:@"nodeChildArray"]) {
				NSString * nodeName = [contentDict valueForKey:@"nodeName"];
				NSString * nodeContent = [contentDict valueForKey:@"nodeContent"];
				
				if ([nodeName compare:@"title"] == 0) {
					aTitle = nodeContent;
				} else if ([nodeName compare:@"description"] == 0) {
					aBody = nodeContent;
				} else if ([nodeName compare:@"pubDate"] == 0) {
					aTime = nodeContent;
				} else if ([nodeName compare:@"guid"] == 0) {
					anUrl = [NSURL URLWithString:nodeContent];
				}				
			}
			[self.rssTitles addObject:aTitle];
			[self.rssBody addObject:aBody];
			[self.rssTime addObject:aTime];
			[self.rssUrl addObject:anUrl];
			[self.rowHeights addObject:[self calculateRowSizeWithHeadline:aTitle andBody:buildBodyText(aTime, aBody) withWidth:self.tableView.frame.size.width]];

		}
		
	}	
	
	[self.tableView reloadData];
}


/**
 Räkna ut hur hög en rad ska vara givet en text i viss storlek
 */
- (NSNumber *) calculateRowSizeWithHeadline:(NSString *)headline andBody:(NSString *)body withWidth:(CGFloat) width
{
    //NSLog(@"calculateRowSizeWithHeadline");
	CGSize maxSize = CGSizeMake(self.view.frame.size.width - 40, 999.9f);
	
	CGSize headlineTextSize = [headline sizeWithFont:[UIFont boldSystemFontOfSize:FONT_SIZE_LARGE]			 
								   constrainedToSize:maxSize
									   lineBreakMode:UILineBreakModeWordWrap];
	
	CGSize bodyTextSize = [body sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE_LARGE]			 
						   constrainedToSize:maxSize
							   lineBreakMode:UILineBreakModeTailTruncation];
	
	CGFloat height = headlineTextSize.height + bodyTextSize.height + PADDING + PADDING;

	return [NSNumber numberWithFloat:height];
}

/*
 Räkna om radhöjder givet viss skärmbredd
 */
- (void) recalculateWidth {  
    [self.rowHeights removeAllObjects];

    for (int i = 0; i < rssTitles.count; ++i) {
        [rowHeights addObject:[self calculateRowSizeWithHeadline:[rssTitles objectAtIndex:i] 
                                                         andBody:buildBodyText([rssTime objectAtIndex:i], 
                                                                               [rssBody objectAtIndex:i]) 
                                                       withWidth:self.tableView.frame.size.width]];
    }
    
    [self.tableView reloadData];
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows]
                          withRowAnimation:UITableViewRowAnimationNone];
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

