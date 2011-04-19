//
//  YouTubeViewController.m
//  UmuApp3
//
//  Created by Johan Forssell on 2010-05-23.
//  Copyright 2010 Umeå University. All rights reserved.
//

#import "UmuYoutubeVideo.h"
#import "YouTubeViewController.h"
#import "umu_seAppDelegate.h"
#import "RootViewController.h"
#import "ASIHTTPRequest.h"
#import "XPathQuery.h"
#import "GDataServiceGoogleYouTube.h"
#import "ABTableViewCell.h"


@implementation YouTubeViewController

@synthesize youtubeVideos;
@synthesize entriesFeed; // user feed of album entries
@synthesize entriesFetchTicket;
@synthesize entriesFetchError;	
@synthesize scrollview;

NSString * const username = @"umeauniversitet";

//
-(id) initWithTabBar {
	if ([self init]) {
		self.title = @"YouTube";
		
		self.tabBarItem.image = [UIImage imageNamed:@"70-tv.png"];
		
		self.navigationItem.title=@"YouTube";
		
		self.youtubeVideos = [[NSMutableArray alloc] initWithCapacity:25];
		
		scrollview = [[UIScrollView alloc] init];

		drawAtY = 0;
	}
	return self;
}

//
- (void)dealloc {
	[youtubeVideos release];
	[entriesFeed release];
	[entriesFetchTicket release];
	[entriesFetchError release];
    [super dealloc];
}

//
- (void)viewDidLoad {
    [super viewDidLoad];	
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	[self fetchAllEntries];
}

- (void)viewDidAppear:(BOOL)animated {
    umu_seAppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.rootViewController showTabBar];
    
   	[self updateLayoutForNewOrientation: self.interfaceOrientation];
}

/**
 Html-koden som används för att embedda ett youtubeklipp.
 */
- (NSString *) getEmbedHtmlWithUrl: (NSString *) url andSize: (CGSize) size 
{
	// kontroll
	if (url == nil) 
		return nil;
	
	// skapa html med korrekt url och storlek på bilden
	NSString *embedHTML = @"\
    <html><head>\
	<style type=\"text/css\">\
	body {\
	background-color: transparent;\
	color: white;\
	}\
	</style>\
	</head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
	width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
	
	return [NSString stringWithFormat:embedHTML, url, size.width, size.height];
}






//---------------------------------------------------------------------------
// Hämta data från youtube
// get a YouTube service object with the current username/password
//
// A "service" object handles networking tasks.  Service objects
// contain user authentication information as well as networking
// state information (such as cookies and the "last modified" date for
// fetched data.)

- (GDataServiceGoogleYouTube *)youTubeService {
	
	static GDataServiceGoogleYouTube* service = nil;
	
	if (!service) {
		service = [[GDataServiceGoogleYouTube alloc] init];
		
		[service setShouldCacheDatedData:YES];
		[service setServiceShouldFollowNextLinks:YES];
		[service setIsServiceRetryEnabled:YES];
	}
	
	[service setUserCredentialsWithUsername:nil
								   password:nil];
	
	[service setYouTubeDeveloperKey:nil];
	
	return service;
}



// begin retrieving the list of the user's entries
- (void)fetchAllEntries {
	
	[self setEntriesFeed:nil];
	[self setEntriesFetchError:nil];
	[self setEntriesFetchTicket:nil];
		
	GDataServiceGoogleYouTube *service = [self youTubeService];
	GDataServiceTicket *ticket;
		
	NSURL * feedURL = [GDataServiceGoogleYouTube youTubeURLForUserID:username
														  userFeedID:kGDataYouTubeUserFeedIDUploads];
	
	ticket = [service fetchFeedWithURL:feedURL
							  delegate:self
					 didFinishSelector:@selector(entryListFetchTicket:finishedWithFeed:error:)];

	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;	
	
	[self setEntriesFetchTicket:ticket];
}


// feed fetch callback
- (void)entryListFetchTicket:(GDataServiceTicket *)ticket
            finishedWithFeed:(GDataFeedYouTubeVideo *)feed
                       error:(NSError *)error {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;	
	
	[self setEntriesFeed:feed];
	[self setEntriesFetchError:error];
	[self setEntriesFetchTicket:nil];
	
	NSArray *  entries = [feed entries];
	
	for (GDataFeedYouTubeVideo * entry in entries)
	{
		UmuYoutubeVideo * video = [[UmuYoutubeVideo alloc] init];
		
		video.titel = [[entry title] contentStringValue];
		video.kropp = [[[entry mediaGroup] mediaDescription] contentStringValue];
		video.url   = [[entry linkWithRelAttributeValue:@"alternate"] href];
		video.datum = [[[[entry publishedDate] date] description] substringToIndex:19];
				
		[youtubeVideos addObject:video];	
		[video release];
	}
	
	[self drawRows: self.interfaceOrientation];
}

//---------------------------------------------------------------------------
//---------------------------------------------------------------------------

-(void) willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation duration: (NSTimeInterval) duration {
	//NSLog(@"YT: willAnimateRotationToInterfaceOrientation %u", interfaceOrientation);
	[self updateLayoutForNewOrientation: interfaceOrientation];	
}

- (void) updateLayoutForNewOrientation:(UIInterfaceOrientation) interfaceOrientation {
	//NSLog(@"YT: updateLayoutForNewOrientation %u", interfaceOrientation);
	[scrollview removeFromSuperview];
	scrollview = [[UIScrollView alloc] init];
	[self drawRows: interfaceOrientation];
}

- (void) drawRows:(UIInterfaceOrientation) interfaceOrientation {
	//NSLog(@"YT: drawRows %u", interfaceOrientation);
	drawAtY = 0;
	
	//NSLog(@"YT: bredd %f", self.view.frame.size.width);
	//NSLog(@"YT:  höjd %f", self.view.frame.size.height);

	/*
	CGRect scrollFrame;
	if (interfaceOrientation == UIInterfaceOrientationPortrait 
		|| interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) { 
		scrollFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } else {
		scrollFrame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);	
	}
    */

	scrollview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
		
	// Skapa en hjälpsam storleksguide för webbvyn
	CGSize wvSize = CGSizeMake(WEBVIEW_SIZE, WEBVIEW_SIZE);
	
	
	for (UmuYoutubeVideo *vid in youtubeVideos)
	{
		// Skapa en frame stor nog för webbvyn
		CGRect wvFrame = CGRectMake(ROW_PADDING, [self drawAtY], WEBVIEW_SIZE, WEBVIEW_SIZE);
		
		// Skapa webbvy med storlek och html
		UIWebView * webView = [[UIWebView alloc] initWithFrame:wvFrame];
		[webView loadHTMLString:[self getEmbedHtmlWithUrl:vid.url andSize:wvSize] baseURL:nil];
		
		[scrollview addSubview:webView];
		[webView release];
		
		UILabel * title = [self titleLabelRelativeTo:wvFrame withText:vid.titel];
		[scrollview addSubview:title];
		
		UILabel * kroppen = [self bodyLabelRelativeTo:title.frame withText:vid.kropp];
		[scrollview addSubview:kroppen];
		
		int separatorY = wvFrame.origin.y+ROW_HEIGHT-4;
		UIView * separator = [self separatorBelowRow: separatorY];

		[scrollview addSubview:separator];
	}
	
	// Räkna ut hur hög scrollvyn ska vara (320 fyller fönstret på bredden)
	CGSize contentSize = CGSizeMake(scrollview.frame.size.width, [self drawAtY]);
		
	[scrollview setContentSize:contentSize];
		
	[self.view addSubview:scrollview];
	//[scrollview release];
	
	[self.view setNeedsLayout];
}



- (int) drawAtY
{
	if (drawAtY == 0)
		drawAtY += ROW_PADDING;
	else
		drawAtY += ROW_HEIGHT;
	
	return drawAtY;
}


// Ge mig en UILabel att rita titeln i
- (UILabel * ) titleLabelRelativeTo: (CGRect) wvFrame withText:(NSString *) text
{
	//NSLog(@"YT: titleLabelRelativeTo ");

	
	UIFont * fontOfChoice = [UIFont boldSystemFontOfSize:14.0f];
	
	// Calculate min height given a certain width, an "unlimited" height and word wrapping
	// bredden är 320 - 8 - 100 - 8 - 8 = 196
	CGSize cgSize = [text sizeWithFont:fontOfChoice 
					 constrainedToSize:CGSizeMake(scrollview.frame.size.width - 124, 9999) 
						 lineBreakMode:UILineBreakModeWordWrap];
	
	
	CGRect correctFrame = CGRectMake(wvFrame.origin.x+ROW_PADDING+WEBVIEW_SIZE, 
									 wvFrame.origin.y, 
									 cgSize.width, 
									 cgSize.height);
	UILabel * label = [[UILabel alloc] initWithFrame:correctFrame];
	
	label.font = fontOfChoice;
	label.numberOfLines = 0;
	label.adjustsFontSizeToFitWidth = NO;
	label.text = text;

	return [label autorelease];
}


- (UILabel *) bodyLabelRelativeTo: (CGRect) titleLabelFrame withText:(NSString *) text
{
	//NSLog(@"YT: bodyLabelRelativeTo ");

	
	UIFont * fontOfChoice = [UIFont systemFontOfSize:FONT_SIZE_SMALL];

	// Begränsa till 190 bred och X hög
	CGSize textSize = [text sizeWithFont:fontOfChoice 
					   constrainedToSize:CGSizeMake(scrollview.frame.size.width - 130, 
													ROW_HEIGHT-titleLabelFrame.size.height-ROW_PADDING) 
						   lineBreakMode:UILineBreakModeTailTruncation];
	
	CGRect correctFrame = CGRectMake(titleLabelFrame.origin.x, 
									 titleLabelFrame.origin.y+titleLabelFrame.size.height, 
									 textSize.width, 
									 textSize.height);
	UILabel * label = [[UILabel alloc] initWithFrame:correctFrame];
	
	label.font = fontOfChoice;
	label.numberOfLines = 0;
	label.lineBreakMode = UILineBreakModeTailTruncation;
	label.adjustsFontSizeToFitWidth = NO;
	label.text = text;
	
	return [label autorelease];
}


- (UIView *) separatorBelowRow: (int) where
{
	CGRect correctFrame = CGRectMake(0, 
									 where, 
									 scrollview.frame.size.width, 
									 1);
	
	UIView * separator = [[UIView alloc] initWithFrame:correctFrame];	
	separator.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
	
	return [separator autorelease];
}
@end

