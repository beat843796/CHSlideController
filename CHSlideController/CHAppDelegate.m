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

-(void)slideController:(CHSlideController *)slideController willHideSlindingController:(UIViewController *)slidingController
{
     NSLog(@"Will hide sliding controller");
}

-(void)slideController:(CHSlideController *)slideController didShowSlindingController:(UIViewController *)slidingController
{
     NSLog(@"Did show sliding controller");
}

-(void)slideController:(CHSlideController *)slideController didHideSlindingController:(UIViewController *)slidingController
{
     NSLog(@"Did hide sliding controller");
}

-(void)slideController:(CHSlideController *)slideController willShowLeftStaticController:(UIViewController *)leftStaticController
{
     NSLog(@"Will show left static controller");
}

-(void)slideController:(CHSlideController *)slideController didShowLeftStaticController:(UIViewController *)leftStaticController
{
     NSLog(@"Did show left static controller");
}

-(void)slideController:(CHSlideController *)slideController willHideLeftStaticController:(UIViewController *)leftStaticController
{
     NSLog(@"Will hide left static controller");
}

-(void)slideController:(CHSlideController *)slideController didHideLeftStaticController:(UIViewController *)leftStaticController
{
     NSLog(@"Did hide left static controller");
}

-(void)slideController:(CHSlideController *)slideController willShowRightStaticController:(UIViewController *)leftStaticController
{
     NSLog(@"Will show right static controller");
}

-(void)slideController:(CHSlideController *)slideController didShowRightStaticController:(UIViewController *)leftStaticController
{
     NSLog(@"Did show right static controller");
}

-(void)slideController:(CHSlideController *)slideController willHideRightStaticController:(UIViewController *)leftStaticController
{
     NSLog(@"Will hide right static controller");
}

-(void)slideController:(CHSlideController *)slideController didHideRightStaticController:(UIViewController *)leftStaticController
{
     NSLog(@"Did hide right static controller");
}

@end
