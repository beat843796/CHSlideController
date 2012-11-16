//
//  DemoSlideControllerSubclass.m
//  CHSlideController
//
//  Created by Clemens Hammerl on 19.10.12.
//  Copyright (c) 2012 appingo mobile e.U. All rights reserved.
//

#import "DemoSlideControllerSubclass.h"

@interface DemoSlideControllerSubclass (private) 

-(void)pressedButton;
    
@end

@implementation DemoSlideControllerSubclass

@synthesize textDisplayController = _textDisplayController;
@synthesize textSelectionController = _textSelectionController;


- (id)init
{
    self = [super init];
    if (self) {
        
        // Creating the controllers
        
        _textDisplayController = [[CHSlidingDemo alloc] init];
        _textDisplayController.title = @"Details";
        
        _textSelectionController = [[CHStaticDemo alloc] init];

        
        // Assigning the delegate to get informed when somethin has been selected
        _textSelectionController.delegate = self;
        
        // uncomment for using a fixed width for the static view
        //[self setStaticViewWidth:150]; 
        
        // Adding navcontroller and barbutton
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_textDisplayController];
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(slideButtonPressed:)];
        
        _textDisplayController.navigationItem.leftBarButtonItem = button;
        _textDisplayController.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
        
        // finally assigning the controllers as static and sliding view controller
        // to the CHSlideController
        
        self.staticViewController = _textSelectionController;
        self.slidingViewController = nav;
        
    }
    return self;
}

// Our subclass is responsible for handling events happening
// in static and sliding controller and for showing/hiding stuff

-(void)staticDemoDidSelectText:(NSString *)text
{
    
    UIViewController *controller;
    
    if ([text isEqualToString:@"Test 1"]) {
        
        controller = _textDisplayController;
        _textDisplayController.textLabel.text = text;
        
    }else if([text isEqualToString:@"Test 2"]){
        
        controller = [[UIViewController alloc] init];
        controller.view.backgroundColor = [UIColor blueColor];
        
        
    }else if([text isEqualToString:@"Test 3"]){
        controller = [[UIViewController alloc] init];
        controller.view.backgroundColor = [UIColor redColor];
        
    }
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(slideButtonPressed:)];
    
    controller.navigationItem.leftBarButtonItem = button;
    controller.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    
    self.slidingViewController = nav;
    
    [self showSlidingViewAnimated:YES];
}

-(void)pressedButton
{
    
    if (isStaticViewVisible) {
        [self showSlidingViewAnimated:YES];
    }else {
        [self hideSlidingViewAnimated:YES];
    }
    
    
}

@end
