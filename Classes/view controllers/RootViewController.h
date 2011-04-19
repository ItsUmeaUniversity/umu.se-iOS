//
//  RootViewController.h
//  UmuApp3
//
//  Created by Johan Forssell on 2010-05-23.
//  Copyright 2010 Umeå University. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RootViewController : UIViewController <UITabBarControllerDelegate> {
    
	UITabBarController *tabBarController;
    BOOL hiddenTabBar;
}

@property (retain) UITabBarController *tabBarController;
@property (nonatomic) BOOL hiddenTabBar;


- (void) toggleTabBar;
- (void) showTabBar;

@end
