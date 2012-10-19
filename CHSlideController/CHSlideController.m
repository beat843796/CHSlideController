//
//  CHSlideController.m
//  CHSlideController
//
//  Created by Clemens Hammerl on 19.10.12.
//  Copyright (c) 2012 appingo mobile e.U. All rights reserved.
//

#import "CHSlideController.h"
#import <QuartzCore/QuartzCore.h>

// Defining some defaults being set in the init
#pragma mark - Constants

#define kDefaultSlideViewPaddingLeft 0
#define kDefaultSlideViewPaddingRight 53
#define kSwipeAnimationTime 0.20

// Private Interface
#pragma mark - Private Interface

@interface CHSlideController (private)

// adds the static viewcontrollers view as a subview of the static view
-(void)updateStaticView;

// adds the sliding viewcontrollers view as a subview of the sliding view
-(void)updateSlidingView;

// shows or hides the sliding view
-(void)slideButtonPressed:(id)sender;

// does the layouting according to the current interface orientation
-(void)layoutForOrientation:(UIInterfaceOrientation)orientation;


@end

/////////////////// Implementation //////////////////////
#pragma mark - Implementation

@implementation CHSlideController

@synthesize staticView = _staticView;
@synthesize slidingView = _slidingView;

@synthesize staticViewController = _staticViewController;
@synthesize slidingViewController = _slidingViewController;
 
@synthesize slideViewPaddingLeft = _slideViewPaddingLeft;
@synthesize slideViewPaddingRight = _slideViewPaddingRight;

@synthesize staticViewWidth = _staticViewWidth;
@synthesize drawShadow = _drawShadow;
@synthesize allowInteractiveSlideing = _allowInteractiveSlideing;

/////////////////// Initialisation //////////////////////
#pragma mark - Initialisation

- (id)init
{
    self = [super init];
    if (self) {

        // Setting up defaults
        
        isStaticViewVisible = YES;
        _drawShadow = YES;
        
        _slideViewPaddingLeft = kDefaultSlideViewPaddingLeft;
        _slideViewPaddingRight = kDefaultSlideViewPaddingRight;
        
        _allowInteractiveSlideing = YES;
    }
    return self;
}

////////////////////// Default implementation of Showing the Sliding View action //////////////////////
#pragma mark - Default Button Action

-(void)slideButtonPressed:(id)sender
{
    
    if (isStaticViewVisible) {
        [self showSlidingViewAnimated:YES];
    }else {
        [self hideSlidingViewAnimated:YES];
    }
}

/////////////////// Public methods //////////////////////
#pragma mark - Public methods

-(void)showSlidingViewAnimated:(BOOL)animated
{
    isStaticViewVisible = NO;
    
    if (animated) {
        [UIView animateWithDuration:kSwipeAnimationTime animations:^{
            [self layoutForOrientation:self.interfaceOrientation];
        } ];
    }else {
        [self layoutForOrientation:self.interfaceOrientation];
    }
}

-(void)hideSlidingViewAnimated:(BOOL)animated
{
    isStaticViewVisible = YES;
    
    if (animated) {
        [UIView animateWithDuration:kSwipeAnimationTime animations:^{
            [self layoutForOrientation:self.interfaceOrientation];
        } ];
    }else {
        [self layoutForOrientation:self.interfaceOrientation];
    }
}


/////////////////////// Override Setter Properties ////////////////////
#pragma mark - Setter Methods

-(void)setStaticViewController:(UIViewController *)staticViewController
{
    
    // Doing viewcontroller containment magic
    
    [_staticViewController didMoveToParentViewController:nil];
    [_staticViewController removeFromParentViewController];
    
    [staticViewController.view removeFromSuperview];
    
    _staticViewController = staticViewController;
    
    if (_staticViewController == nil) {
        return;
    }

    [self addChildViewController:_staticViewController];
    [_staticViewController didMoveToParentViewController:self];

    if ([self isViewLoaded]) {
        [self updateStaticView];
    }
}

-(void)setSlidingViewController:(UIViewController *)slidingViewController
{

    // Doing viewcontroller containment magic
    
    [_slidingViewController didMoveToParentViewController:nil];
    [_slidingViewController removeFromParentViewController];
    
    [_slidingViewController.view removeFromSuperview];
    
    _slidingViewController = slidingViewController;
    
    if (_slidingViewController == nil) {
        return;
    }
    
    [self addChildViewController:_slidingViewController];
    [_slidingViewController didMoveToParentViewController:self];
    
    if ([self isViewLoaded]) {
        [self updateSlidingView];
    }
}

-(void)setStaticViewWidth:(NSInteger)staticViewWidth
{
    useFixedStaticViewWidth = YES;
    _staticViewWidth = staticViewWidth;
    
}

///////////////////////// Updating Views //////////////////////////
#pragma mark - Updating views

-(void)updateStaticView
{
    _staticViewController.view.frame = _staticView.bounds;
    [_staticView addSubview:_staticViewController.view];
}

-(void)updateSlidingView
{
    _slidingViewController.view.frame = _slidingView.bounds;
    [_slidingView addSubview:_slidingViewController.view];
}



///////////////////////// Autorotation Stuff /////////////////////////
#pragma mark - Autorotation stuff

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)layoutForOrientation:(UIInterfaceOrientation)orientation
{
    
    // Setting the frames of static
    
    
    if (!useFixedStaticViewWidth) {
        
        // default mode, use screenwidth for staticview width
        
        _staticView.frame = CGRectMake(0, 0, self.view.bounds.size.width-_slideViewPaddingRight, self.view.bounds.size.height);
    }else {
        
        // using a fixed width for the static view. slideviewpaddingRight is ignored here
        
        CGFloat cuttedOfStaticWidth = _staticViewWidth;
        
        if (cuttedOfStaticWidth > self.view.bounds.size.width) {
            cuttedOfStaticWidth = self.view.bounds.size.width;
        }
        
        _staticView.frame = CGRectMake(0, 0, cuttedOfStaticWidth, self.view.bounds.size.height);
    }
    
    CGFloat staticWidth = _staticView.bounds.size.width;
    CGFloat slidingWidth = self.view.bounds.size.width-_slideViewPaddingLeft;
    
    // setting the frame of sliding view
    
    if (isStaticViewVisible) {
        
        // Static view is uncovered
        
        _slidingView.frame = CGRectMake(staticWidth, 0, slidingWidth, self.view.bounds.size.height);
        
    }else {
        
        // Static view is covered
        
        _slidingView.frame = CGRectMake(_slideViewPaddingLeft, 0, slidingWidth, self.view.bounds.size.height);
    }
    
    if (_drawShadow) {
        _slidingView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_slidingView.bounds].CGPath;
    }
    
}

///////////////////////// Interactive Sliding - Touch handling /////////////////////////
#pragma mark - interactive slideing

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (!_allowInteractiveSlideing) {
        return;
    }
    
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    
    // Save the swipe start point
    // also set it as lastsample point
    
    xPosStart = touchPoint.x;
    xPosLastSample = touchPoint.x;
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_allowInteractiveSlideing) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    
    xPosCurrent = touchPoint.x;
    
    // determining swipedirection based on last and current sample point
    
    if (xPosCurrent>xPosLastSample) {
        direction = 1;
    }else if(xPosCurrent < xPosLastSample) {
        direction = -1;
    }
    
    CGRect newSlidingRect = CGRectOffset(_slidingView.frame, xPosCurrent-xPosLastSample, 0);
    
    /*
     
     If we slided beyonf the screensize we must cut the
     xOffset off to stop moving the sliding view
     
     */
    
    if (newSlidingRect.origin.x < _staticView.frame.origin.x+_slideViewPaddingLeft) {
        newSlidingRect.origin.x = _staticView.frame.origin.x+_slideViewPaddingLeft;
    }
    
    if (newSlidingRect.origin.x > _staticView.frame.origin.x+_staticView.frame.size.width) {
        newSlidingRect.origin.x = _staticView.frame.origin.x+_staticView.frame.size.width;
    }
    
    _slidingView.frame = newSlidingRect;
    
    //setting the lastSamplePoint as the current one
    
    xPosLastSample = xPosCurrent;
    
}

// show or hide sliding view based on swipe direction

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_allowInteractiveSlideing) {
        return;
    }
    
    if (direction == 1) {
        [self hideSlidingViewAnimated:YES];
    }else {
        [self showSlidingViewAnimated:YES];
    }
}

// show or hide sliding view based on swipe direction

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_allowInteractiveSlideing) {
        return;
    }
    
    if (direction == 1) {
        [self hideSlidingViewAnimated:YES];
    }else {
        [self showSlidingViewAnimated:YES];
    }
}

/////////////////////// View Lifecycle ////////////////////
#pragma mark - View Lifecycle

- (void)loadView
{
    [super loadView];
    
    _staticView = [[UIView alloc] init];
    _slidingView = [[UIView alloc] init];
    
    if (_drawShadow) {
        _slidingView.layer.shadowColor = [UIColor blackColor].CGColor;
        _slidingView.layer.shadowOpacity = 0.5;
        _slidingView.layer.shadowOffset = CGSizeMake(0, 0);
        
        _slidingView.layer.shadowRadius = 10.0;
    }
    
    
    
    [self.view addSubview:_staticView];
    [self.view addSubview:_slidingView];
    
    // Debug
    
    _staticView.backgroundColor = [UIColor darkGrayColor];
    _slidingView.backgroundColor = [UIColor grayColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateStaticView];
    [self updateSlidingView];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setStaticViewController:nil];
    [self setSlidingViewController:nil];
    
    [_staticView removeFromSuperview];
    [_slidingView removeFromSuperview];
    
    _staticView = nil;
    _slidingView = nil;
}

-(void)viewWillLayoutSubviews
{
    [self layoutForOrientation:self.interfaceOrientation];
}

@end
