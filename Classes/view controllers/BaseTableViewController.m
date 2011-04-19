//
//  BaseTableViewController.m
//  umu.se
//
//  Created by Johan Bucht on 2011-01-17.
//  Copyright 2011 UMU. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ASIHTTPRequest.h"



@implementation BaseTableViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	NSError *error = [request error];
	NSLog(@"%@", error);
}

- (void) updateLayoutForNewOrientation:(UIInterfaceOrientation) interfaceOrientation {
}



@end
