//
//  ModalWebView.h
//  umu.se
//
//  Created by Johan Forssell on 2010-06-13.
//  Copyright 2010 Umeå University. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ModalWebView : UIView  {
	NSURL * viewUrl;
	UIBarButtonItem * doneButton;
	BOOL looper;
}

@property (retain) NSURL * viewUrl;
@property (retain) UIBarButtonItem * doneButton;


//-(void) willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation duration: (NSTimeInterval) duration ;
- (void) updateLayoutForNewWidth:(CGFloat)width andHeight:(CGFloat)height;
- (void)addDoneButtonTarget:(id)target action:(SEL)action;
- (void) loadUrl: (NSURL *) url;
- (void) loadHtml: (NSString *) html;
- (void) clearWebView;
- (void) openInSafari;
- (BOOL) isLooper;
- (void) setLooper: (BOOL) l;



#define WEBVIEW_TAG 9827
#define WEBVIEW_TOOLBAR_TAG 9828
#define TOOLBAR_HEIGHT 44
#define TABBAR_HEIGHT 49

@end
