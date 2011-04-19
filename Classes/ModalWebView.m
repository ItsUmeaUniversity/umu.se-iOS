//
//  ModalWebView.m
//  umu.se
//
//  Created by Johan Forssell on 2010-06-13.
//  Copyright 2010 Umeå University. All rights reserved.
//

#import "ModalWebView.h"


@implementation ModalWebView

@synthesize viewUrl;
@synthesize doneButton;

- (id)initWithFrame:(CGRect)frame
{
	NSLog(@"modalWebView frame at initialization %@", NSStringFromCGRect(frame));
    if ((self = [super initWithFrame:CGRectMake(0,0, frame.size.width, frame.size.height+TABBAR_HEIGHT)])) {
		[self setLooper:NO];
        self.viewUrl = nil;
				
		UIWebView * wv = [[UIWebView alloc] initWithFrame:CGRectMake(0, TOOLBAR_HEIGHT, frame.size.width, frame.size.height-TOOLBAR_HEIGHT+TABBAR_HEIGHT)];
		wv.tag = WEBVIEW_TAG;
		
		wv.scalesPageToFit = YES;
		//wv.autoresizesSubviews = YES;
		//wv.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
		
		wv.delegate = self;
		
		[self addSubview:wv];
		[wv release];
		
		UIToolbar * toolbar = [[UIToolbar alloc] init]; 
		[toolbar setFrame:CGRectMake(0, 0, frame.size.width, TOOLBAR_HEIGHT)];
		
        toolbar.tag = WEBVIEW_TOOLBAR_TAG;
		toolbar.barStyle = UIBarStyleBlack;
		
		// sätter target och action på den här knappen i ett senare skede, utifrån
		doneButton = [[UIBarButtonItem alloc]
									   initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
									   target:nil
									   action:nil];
		
		UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
								   initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
								   target:nil
								   action:nil];
		
		UIBarButtonItem *safariButton = [[UIBarButtonItem alloc]
										 initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
										 target:self 
										 action:@selector(openInSafari)];

		NSArray * buttons = [NSArray arrayWithObjects:doneButton, spacer, safariButton, nil];
		[spacer release];
		[safariButton release];
		
		[toolbar setItems:buttons];
		[self addSubview:toolbar];
		[toolbar release];
		
    }
    return self;
}

/*
 Kallas från anropande ViewController när den ändrar storlek
 */
- (void) updateLayoutForNewWidth:(CGFloat)width andHeight:(CGFloat)height {
    
    //NSLog(@"Modal: updateLayoutForNewWidth width %f and frame height %f ", width, height);
    
    // storlek på egen frame
    self.frame = CGRectMake(0, 
                            0, 
                            width, 
                            height); 
    // storlek på toolbar
    UIToolbar *tb = (UIToolbar *)[self viewWithTag:WEBVIEW_TOOLBAR_TAG];
	tb.frame = CGRectMake(0, 0, width, TOOLBAR_HEIGHT);
    // storlek på webbvy
	UIWebView *wv = (UIWebView *)[self viewWithTag:WEBVIEW_TAG];
	wv.frame = CGRectMake(0, 
                          TOOLBAR_HEIGHT, 
                          width, 
                          height-TOOLBAR_HEIGHT);
}




- (void)dealloc 
{
	UIWebView *wv = (UIWebView *)[self viewWithTag:WEBVIEW_TAG];
	wv.delegate = nil;
	
	
	[doneButton release];
	[viewUrl release];
    [super dealloc];
}

- (void)drawRect:(CGRect)rect 
{
    [super drawRect:rect];
}


// Sätt target och action för knappen "utifrån" - så att man kan peka på en metod utanför den här klassen
- (void)addDoneButtonTarget:(id)target action:(SEL)action 
{
	doneButton.target = target;
	doneButton.action = action;
}



- (void) loadUrl: (NSURL *) url
{
	self.viewUrl = url;

	UIWebView *wv = (UIWebView *)[self viewWithTag:WEBVIEW_TAG];
	[wv setNeedsDisplay];
	[wv loadRequest:[NSURLRequest requestWithURL:self.viewUrl]];
}


- (void) loadHtml: (NSString *) html
{
	UIWebView *wv = (UIWebView *)[self viewWithTag:WEBVIEW_TAG];
	[wv loadHTMLString:html baseURL:nil];    
}


- (void) clearWebView
{
	[self setLooper:NO];
	UIWebView *wv = (UIWebView *)[self viewWithTag:WEBVIEW_TAG];
	[wv loadHTMLString:@"<html><body><p>...</p></body></html>" baseURL:nil];
}


- (void) openInSafari
{
	if (self.viewUrl)
		[[UIApplication sharedApplication] openURL:self.viewUrl];	
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;	
}


// Logga om vi får ett fel.
// Workaround för att komma runt ett konstigt fel: ladda sidan igen så funkar det. Kommer med skydd mot oändliga loopar.
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	if ([error code] == -999 && !looper) {
		[self loadUrl:self.viewUrl];
		[self setLooper:YES];
	} else {
		NSLog(@"didFailLoadWithError: %@", error);
	}
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	return YES;
}


- (BOOL) isLooper
{
	return looper;
}

- (void) setLooper: (BOOL) l
{
	looper = l;
}

@end
