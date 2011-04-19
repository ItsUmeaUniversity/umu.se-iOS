//
//  WelcomeViewController.h
//  UmuApp3
//
//  Created by Johan Forssell on 2010-06-11.
//  Copyright 2010 Umeå University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalWebView.h"
#import "BaseViewController.h"


@interface WelcomeViewController : BaseViewController {
	ModalWebView * modalWebView;
    UIInterfaceOrientation newOrientation;
}

@property (retain) ModalWebView * modalWebView;
@property UIInterfaceOrientation newOrientation;

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
                                         duration:(NSTimeInterval)duration;
- (void) updateLayoutForNewOrientation:(UIInterfaceOrientation)interfaceOrientation;

- (void) setupButtons;

- (void) pressNewsButton;
- (void) pressFbButton;
- (void) pressYoutubeButton;
- (void) pressMapButton;

- (void) pressKontaktaIPhone;

- (void) removeWelcomeTab;
- (void) dismissModalWebView;

#define W_BUTTON_NEWS 87648761
#define W_BUTTON_FB   89734982
#define W_BUTTON_YT   89724483
#define W_BUTTON_MAP  89900984
#define W_BUTTON_MAIL 86600985
#define W_ROW_PADDING 132
#define W_COL_PADDING 132

@end
