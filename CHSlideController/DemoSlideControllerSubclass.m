//
//  DemoSlideControllerSubclass.m
//  CHSlideController
//
//  Created by Clemens Hammerl on 19.10.12.
//  Copyright (c) 2012 appingo mobile e.U. All rights reserved.
//

#import "DemoSlideControllerSubclass.h"

@interface DemoSlideControllerSubclass ()

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
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(pressedLeftButton)];
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(pressedRightButton)];
        
        _textDisplayController.navigationItem.leftBarButtonItem = button;
        _textDisplayController.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
        _textDisplayController.navigationItem.rightBarButtonItem = rightButton;
        
        // finally assigning the controllers as static and sliding view controller
        // to the CHSlideController
        
        self.view.backgroundColor = [UIColor darkGrayColor];
        
        
        
        _rightController = [[CHRightStaticDemo alloc] init];

        _rightController.view.backgroundColor = [UIColor lightGrayColor];
        
        //self.allowInteractiveSlideing = YES;
        
        self.leftStaticViewWidth = self.view.bounds.size.width-55;
        self.rightStaticViewWidth = self.view.bounds.size.width-55;
        //self.slideViewVisibleWidthWhenHidden = 50;
        
        _textSelectionController.title = @"LEFT MENU";
        _rightController.title = @"RIGHT MENU";
        
        UINavigationController *leftNav = [[UINavigationController alloc] initWithRootViewController:_textSelectionController];
       
        
        self.leftStaticViewController = leftNav;
        self.rightStaticViewController = _rightController;
        self.slidingViewController = nav;
        
        self.drawShadow = NO;
        
    }
    return self;
}

// Our subclass is responsible for handling events happening
// in static and sliding controller and for showing/hiding stuff

-(void)staticDemoDidSelectText:(NSString *)text
{
    
    
    if ([text isEqualToString:@"Test 1"]) {
        

        _textDisplayController.textLabel.text = text;
        
    }else if([text isEqualToString:@"Test 2"]){
        

        _textDisplayController.textLabel.text = text;
        
        
    }else if([text isEqualToString:@"Test 3"]){

        _textDisplayController.textLabel.text = text;
        
    }
    

    
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



@end
