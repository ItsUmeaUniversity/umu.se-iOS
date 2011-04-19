//
//  JobbViewController.m
//  UmuApp3
//
//  Created by Johan Forssell on 2010-05-24.
//  Copyright 2010 Umeå University. All rights reserved.
//

#import "JobbViewController.h"
#import "ASIHTTPRequest.h"
#import "XPathQuery.h"
#import "ABTableViewCell.h"
#import "ModalWebView.h"

@implementation JobbViewController


@synthesize rssTitles;
@synthesize rssUrl;
@synthesize rssTime;
@synthesize rowHeights;
@synthesize modalWebView;


-(id) initWithTabBar {
	if ([self init]) {
		self.title = @"Lediga jobb";
		
		self.tabBarItem.image = [UIImage imageNamed:@"37-suitcase.png"];
		
		self.navigationItem.title=@"Jobb";
		
		self.rssTitles = [[NSMutableArray alloc] init];
		self.rssUrl = [[NSMutableArray alloc] init];
		self.rssTime = [[NSMutableArray alloc] init];
		self.rowHeights = [[NSMutableArray alloc] init];
		
		self.modalWebView = [[ModalWebView alloc] initWithFrame:self.view.frame];
		[self.modalWebView addDoneButtonTarget:self action:@selector(dismissModalWebView)];		
	}
	return self;
}

- (void)dealloc {
	[modalWebView release];
	[rowHeights release];
	[rssTitles release];
	[rssUrl release];
	[rssTime release];
    [super dealloc];
}



- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSURL *url = [NSURL URLWithString:@"http://www.jobb.umu.se/JobbaHosOssRSS.ashx"];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request startAsynchronous];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [rssTitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	
	if ([rssTitles objectAtIndex:indexPath.row] != nil)
	{
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		cell.textLabel.text = [rssTitles objectAtIndex:indexPath.row];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE_LARGE];
		cell.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
		cell.textLabel.numberOfLines = 0;
		
		cell.detailTextLabel.text = [NSString stringWithString:[rssTime objectAtIndex:indexPath.row]];			
		cell.detailTextLabel.font = [UIFont systemFontOfSize:FONT_SIZE_SMALL];
		cell.detailTextLabel.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
		cell.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
		cell.detailTextLabel.numberOfLines = 1;
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[modalWebView loadUrl:[rssUrl objectAtIndex:indexPath.row]];

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
						   forView:self.tabBarController.view 
							 cache:NO];

	[self.tabBarController.view addSubview:modalWebView];
	[UIView commitAnimations];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
	NSNumber * heightAtIndex = [rowHeights objectAtIndex:indexPath.row];
	return [heightAtIndex floatValue];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	NSData * data = [request responseData];
	[self createArrayFromResponse:data];
	
}

- (void)createArrayFromResponse: (NSData *) response
{
	NSString *xpathQueryString = @"//item";
	NSArray * parseResults = PerformXMLXPathQuery(response, xpathQueryString);
	
	for (id itemDict in parseResults) 
	{
		NSString * nodeName = [itemDict valueForKey:@"nodeName"];
		
		if ([nodeName compare:@"item"] == 0) {
			for (id contentDict in [itemDict valueForKey:@"nodeChildArray"]) {
				NSString * nodeName = [contentDict valueForKey:@"nodeName"];
				NSString * nodeContent = [contentDict valueForKey:@"nodeContent"];
				
				if ([nodeName compare:@"title"] == 0) {
					[self.rssTitles addObject:nodeContent];
				} else if ([nodeName compare:@"pubDate"] == 0) {
					[self.rssTime addObject:nodeContent];
				} else if ([nodeName compare:@"guid"] == 0) {
					[self.rssUrl addObject:[NSURL URLWithString:nodeContent]];
				}				
			}
			
			CGFloat widthMax = 320.0f-40.0f; // maxbredd på textlabel är 280
			
			CGSize num1 = [[self.rssTitles lastObject] 
						   sizeWithFont:[UIFont boldSystemFontOfSize:FONT_SIZE_LARGE]
						   constrainedToSize:CGSizeMake(widthMax, 999.9f)
						   lineBreakMode:UILineBreakModeWordWrap];
			CGSize num2 = [[self.rssTime lastObject] 
						   sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE_SMALL]];
			
			CGFloat sum = PADDING + num1.height + num2.height;
			[self.rowHeights addObject:[NSNumber numberWithFloat:sum]];
		}
		
	}	
	
	[self.tableView reloadData];
}


- (void) dismissModalWebView
{
	[UIView beginAnimations:nil context:NULL];
	
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight 
						   forView:self.tabBarController.view 
							 cache:YES];
	[self.modalWebView removeFromSuperview];
	
	[UIView commitAnimations];
	[self.modalWebView clearWebView];
}

@end

