//
//  DemoSlideControllerSubclass.m
//  CHSlideController
//
//  Created by Clemens Hammerl on 19.10.12.
//  Copyright (c) 2012 appingo mobile e.U. All rights reserved.
//

#import "DemoSlideControllerSubclass.h"

@interface DemoSlideControllerSubclass ()
{
    BOOL maximizedLeftView;
}
-(void)pressedLeftButton;
-(void)pressedRightButton;

@end

@implementation DemoSlideControllerSubclass

@synthesize textDisplayController = _textDisplayController;
@synthesize textSelectionController = _textSelectionController;


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // Creating the controllers
        _textDisplayController = [[CHSlidingDemo alloc] init];
        _textDisplayController.title = @"Sliding controller";

        _textSelectionController = [[CHStaticDemo alloc] init];
        _textSelectionController.searchController.searchBar.delegate = self;
        _textSelectionController.searchController.delegate = self;
        //_textSelectionController.searchController.hidesNavigationBarDuringPresentation = NO;
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
        

        
        _textSelectionController.title = @"Left static controller";
        self.allowEdgeSwipingForSlideingView = YES;
        
        UINavigationController *leftNav = [[UINavigationController alloc] initWithRootViewController:_textSelectionController];
       
        // Assign the controllers
        self.leftStaticViewController = leftNav;
        self.rightStaticViewController = _rightController;
        self.slidingViewController = nav;
        
        //self.dimSlidingViewWhenNoCoveringStaticView = NO;
        
       // self.stickStatusBarToSlidingView = YES;
        
        self.leftAnimationSlidingAnimationFactor = 0.75;
        self.rightAnimationSlidingAnimationFactor = 1.0;

        
    }
    return self;
}

-(void)willPresentSearchController:(UISearchController *)searchController
{


    [UIView animateWithDuration:self.animationTimeInterval animations:^{
        
        //[_textSelectionController.navigationController setNavigationBarHidden:YES animated:NO];
        [self setLeftStaticViewWidth:self.view.bounds.size.width animated:YES];
        
        [self->_textSelectionController.searchController.searchBar layoutSubviews];
        

    }];
    
}

-(void)willDismissSearchController:(UISearchController *)searchController
{

    [UIView animateWithDuration:self.animationTimeInterval animations:^{
        
        [self->_textSelectionController.navigationController setNavigationBarHidden:NO animated:NO];
        [self setLeftStaticViewWidth:self.view.bounds.size.width-55 animated:YES];
        
        [self->_textSelectionController.searchController.searchBar layoutSubviews];
        
        
    }];
    
    
    
}

//-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
//{
//    NSLog(@"Searchbar cancel");
//    [self setLeftStaticViewWidth:self.view.bounds.size.width-55 animated:YES];
//}


// Our subclass is responsible for handling events happening
// in static and sliding controller and for showing/hiding stuff

-(void)staticDemoDidSelectText:(NSString *)text
{
    
    
    if ([text isEqualToString:@"Test 1"]) {
        

        _textDisplayController.textLabel.text = text;
        [self showSlidingViewAnimated:YES];
    }else if([text isEqualToString:@"Test 2"]){
        

        _textDisplayController.textLabel.text = text;
        [self showSlidingViewAnimated:YES];
        
    }else if([text isEqualToString:@"Test 3"]){

        _textDisplayController.textLabel.text = text;
        [self showSlidingViewAnimated:YES];
    }else if([text isEqualToString:@"Hide Navigationbar"]) {
        
        
       [_textDisplayController.navigationController setNavigationBarHidden:!_textDisplayController.navigationController.isNavigationBarHidden animated:YES];
        
    }else if([text isEqualToString:@"Hide Statusbar"]) {
        
        [[UIApplication sharedApplication] setStatusBarHidden:![UIApplication sharedApplication].isStatusBarHidden withAnimation:UIStatusBarAnimationSlide];
        
    }else if([text isEqualToString:@"Shadow ON/OFF"]) {
        self.drawShadow = !self.drawShadow;
    }else if([text isEqualToString:@"Change Width"]) {
        
        maximizedLeftView = !maximizedLeftView;
        
        if (maximizedLeftView) {
            [self setLeftStaticViewWidth:self.view.bounds.size.width animated:YES];
        }else {
            [self setLeftStaticViewWidth:self.view.bounds.size.width-55 animated:YES];

            
        }
        
        
        
    }else if ([text isEqualToString:@"DIM ON/OFF"]) {
        
        self.dimSlidingViewWhenNoCoveringStaticView = !self.dimSlidingViewWhenNoCoveringStaticView;
        
    }    

   // [self.view setNeedsLayout];
    
    
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
