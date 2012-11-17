//
//  CHAppDelegate.m
//  CHSlideController
//
//  Created by Clemens Hammerl on 19.10.12.
//  Copyright (c) 2012 appingo mobile e.U. All rights reserved.
//

#import "CHAppDelegate.h"
#import "DemoSlideControllerSubclass.h"

@implementation CHAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // creating root controller
    DemoSlideControllerSubclass *root = [[DemoSlideControllerSubclass alloc] init];
    root.delegate = self;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // setting root controller
    self.window.rootViewController = root;

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

////////////////////////////////////////////////////////////
#pragma mark - CHSlideController Delegate

-(void)slideController:(CHSlideController *)slideController willShowSlindingController:(UIViewController *)slidingController
{
    NSLog(@"Will show sliding controller");
}

-(void)slideController:(CHSlideController *)slideController didShowSlindingController:(UIViewController *)slidingController
{
    NSLog(@"Did show sliding controller");
}

-(void)slideController:(CHSlideController *)slideController willHideSlindingController:(UIViewController *)slidingController
{
    NSLog(@"Will hide sliding controller");
}

-(void)slideController:(CHSlideController *)slideController didHideSlindingController:(UIViewController *)slidingController
{
    NSLog(@"Did hide sliding controller");
}

@end
