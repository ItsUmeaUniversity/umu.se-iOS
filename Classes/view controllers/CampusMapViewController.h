//
//  CampusMapViewController.h
//  umu.se
//
//  Created by Johan Bucht on 2011-01-17.
//  Copyright 2011 UMU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "OverlayViewController.h"
#import "ModalWebView.h"

@class OverlayViewController;

@interface CampusMapViewController : BaseViewController<UISearchBarDelegate, UIWebViewDelegate> {
	UIWebView *webView;
	UISearchBar *searchBar;
	OverlayViewController *overlay;
	ModalWebView *modalWebView;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) OverlayViewController *overlay;
@property (retain) ModalWebView *modalWebView;

- (void) hideKeyboard;
- (void) createOverlay;
- (void) updateLayoutForNewOrientation:(UIInterfaceOrientation) interfaceOrientation;

@end
