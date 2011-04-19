//
//  umu_seAppDelegate.h
//  umu.se
//
//  Created by Johan Forssell on 6/11/10.
//  Copyright Umeå University 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface umu_seAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	RootViewController *rootViewController;
	UIImageView *splashView;  
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) RootViewController *rootViewController;
@property (nonatomic, retain) UIImageView *splashView;  

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;  


@end

