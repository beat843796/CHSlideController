//
//  DemoSlideControllerSubclass.m
//  CHSlideController
//
//  Created by Clemens Hammerl on 19.10.12.
//  Copyright (c) 2012 appingo mobile e.U. All rights reserved.
//

#import "DemoSlideControllerSubclass.h"

@interface DemoSlideControllerSubclass (private) 

-(void)pressedLeftButton;
-(void)pressedRightButton;

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
        

        // Adding navcontroller and barbutton
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_textDisplayController];
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(pressedLeftButton)];
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(pressedRightButton)];
        
        _textDisplayController.navigationItem.leftBarButtonItem = button;
        _textDisplayController.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
        _textDisplayController.navigationItem.rightBarButtonItem = rightButton;
        
        // finally assigning the controllers as static and sliding view controller
        // to the CHSlideController
        
        self.view.backgroundColor = [UIColor darkGrayColor];
        
        _rightController = [[CHRightStaticDemo alloc] init];
        _rightController.delegate = self;
        _rightController.view.backgroundColor = [UIColor lightGrayColor];
        
        //self.allowInteractiveSlideing = YES;
        
        self.leftStaticViewWidth = 320-55;
        self.rightStaticViewWidth = 320-55;
        //self.slideViewVisibleWidthWhenHidden = 50;
        self.leftStaticViewController = _textSelectionController;
        self.rightStaticViewController = _rightController;
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
        
    }else if([text isEqualToString:@"Maximize Animated"]){
        NSLog(@"Maximize animated");
        
        [self maximizeAnimated];
        
        
        return;
        
    }else if([text isEqualToString:@"Maximize"]){
        NSLog(@"Maximize without animation");
        
        [self maximize];
        
        return;
        
    }
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(pressedLeftButton)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(pressedRightButton)];
    
    controller.navigationItem.rightBarButtonItem = rightButton;
    controller.navigationItem.leftBarButtonItem = button;
    controller.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    
    self.slidingViewController = nav;
    
    [self showSlidingViewAnimated:YES];
}

-(void)pressedLeftButton
{
    
    if (isLeftStaticViewVisible) {
        [self showSlidingViewAnimated:YES];
    }else {
        [self showLeftStaticView:YES];
    }
    
    
}

-(void)pressedRightButton
{
    NSLog(@"Pressed right button");
    
    if (isRightStaticViewVisible) {
        [self showSlidingViewAnimated:YES];
    }else {
        [self showRightStaticView:YES];
    }
}

-(void)maximize
{
    if (self.isVisibleStaticViewMaximized) {
        [self unmaximizeStaticViewAnimated:NO];
    }else {
        [self maximizeStaticViewAnimated:NO];
    }
}

-(void)maximizeAnimated
{
    if (self.isVisibleStaticViewMaximized) {
        [self unmaximizeStaticViewAnimated:YES];
    }else {
        [self maximizeStaticViewAnimated:YES];
    }
}

@end
