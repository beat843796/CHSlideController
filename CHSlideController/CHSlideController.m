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

// adds the left static viewcontrollers view as a subview of the left static view
-(void)updateLeftStaticView;

// adds the right static viewcontrollers view as a subview of the right static view
-(void)updateRightStaticView;

// adds the sliding viewcontrollers view as a subview of the sliding view
-(void)updateSlidingView;



// does the layouting according to the current interface orientation
-(void)layoutForOrientation:(UIInterfaceOrientation)orientation;


@end

/////////////////// Implementation //////////////////////
#pragma mark - Implementation

@implementation CHSlideController

@synthesize delegate;

@synthesize leftStaticView = _leftStaticView;
@synthesize rightStaticView = _rightStaticView;
@synthesize slidingView = _slidingView;

@synthesize leftStaticViewController = _leftStaticViewController;
@synthesize rightStaticViewController = _rightStaticViewController;
@synthesize slidingViewController = _slidingViewController;
 
@synthesize slideViewPaddingLeft = _slideViewPaddingLeft;
@synthesize slideViewPaddingRight = _slideViewPaddingRight;

@synthesize leftStaticViewWidth = _leftStaticViewWidth;
@synthesize rightStaticViewWidth = _rightStaticViewWidth;
@synthesize drawShadow = _drawShadow;
@synthesize allowInteractiveSlideing = _allowInteractiveSlideing;

/////////////////// Initialisation //////////////////////
#pragma mark - Initialisation

- (id)init
{
    self = [super init];
    if (self) {

        // Setting up defaults
        
        isLeftStaticViewVisible = YES;
        isRightStaticViewVisible = NO;
        _drawShadow = YES;
        
        _slideViewPaddingLeft = kDefaultSlideViewPaddingLeft;
        _slideViewPaddingRight = kDefaultSlideViewPaddingRight;
        
        _allowInteractiveSlideing = YES;
    }
    return self;
}



/////////////////// Public methods //////////////////////
#pragma mark - Public methods

-(void)showSlidingViewAnimated:(BOOL)animated
{
    NSLog(@"WTF");
    // Inform delegate of will hiding left static controller event
    if (isLeftStaticViewVisible) {
        if (delegate && [delegate respondsToSelector:@selector(slideController:willHideLeftStaticController:)]) {
            [delegate slideController:self willHideLeftStaticController:_leftStaticViewController];
        }
    }
    
    // Inform delegate of will hiding right static controller event
    if (isRightStaticViewVisible) {
        if (delegate && [delegate respondsToSelector:@selector(slideController:willHideRightStaticController:)]) {
            [delegate slideController:self willHideLeftStaticController:_rightStaticViewController];
        }
    }
    
    // Inform delegate of will showing sliding controller event
    if (delegate && [delegate respondsToSelector:@selector(slideController:willShowSlindingController:)]) {
        [delegate slideController:self willShowSlindingController:self.slidingViewController];
    }
    
    if (isLeftStaticViewVisible) {
        lastVisibleController = _leftStaticViewController;
    }
    
    if (isRightStaticViewVisible) {
        lastVisibleController = _rightStaticViewController;
    }
    
    isLeftStaticViewVisible = NO;
    isRightStaticViewVisible = NO;
    
    if (animated) {
        [UIView animateWithDuration:kSwipeAnimationTime animations:^{
            [self layoutForOrientation:self.interfaceOrientation];
        } completion:^(BOOL finished) {
            // inform delegate
            
            // Inform delegate of did showing sliding controller event
            if (delegate && [delegate respondsToSelector:@selector(slideController:didShowSlindingController:)]) {
                [delegate slideController:self didShowSlindingController:self.slidingViewController];
            }
            
            // Inform delegate of did hiding left static controller event
            
            if (lastVisibleController == _leftStaticViewController) {
                if (delegate && [delegate respondsToSelector:@selector(slideController:didHideLeftStaticController:)]) {
                    [delegate slideController:self didHideLeftStaticController:_leftStaticViewController];
                }
            }
            
                
            
            // Inform delegate of did hiding right static controller event
            
            if (lastVisibleController == _rightStaticViewController) {
                if (delegate && [delegate respondsToSelector:@selector(slideController:didHideRightStaticController:)]) {
                    [delegate slideController:self didHideRightStaticController:_rightStaticViewController];
                }
            }
            
            lastVisibleController = nil;

            
        }];
    }else {
        [self layoutForOrientation:self.interfaceOrientation];
    }
}

-(void)showLeftStaticView:(BOOL)animated
{
    
    _leftStaticView.alpha = 1.0;
    _rightStaticView.alpha = 0.0;
    
    // Inform delegate of will showing left static controller
    if (delegate && [delegate respondsToSelector:@selector(slideController:willShowLeftStaticController:)]) {
        [delegate slideController:self willShowLeftStaticController:_leftStaticViewController];
    }
    
    // Inform delegate of will hiding sliding controller event
    if (delegate && [delegate respondsToSelector:@selector(slideController:willHideSlindingController:)]) {
        [delegate slideController:self willHideSlindingController:self.slidingViewController];
    }
    
    isLeftStaticViewVisible = YES;
    isRightStaticViewVisible = NO;
    
    if (animated) {
        [UIView animateWithDuration:kSwipeAnimationTime animations:^{
            [self layoutForOrientation:self.interfaceOrientation];
        } completion:^(BOOL finished) {
            // inform delegate
            
            // Inform delegate of did hiding sliding controller
            if (delegate && [delegate respondsToSelector:@selector(slideController:didHideSlindingController:)]) {
                [delegate slideController:self didHideSlindingController:self.slidingViewController];
            }
            
            // Inform delegate of did showing left static controller
            if (delegate && [delegate respondsToSelector:@selector(slideController:didShowLeftStaticController:)]) {
                [delegate slideController:self didShowLeftStaticController:_leftStaticViewController];
            }
            
            
            
        }];
    }else {
        [self layoutForOrientation:self.interfaceOrientation];
    }
}

-(void)showRightStaticView:(BOOL)animated
{
    
    _leftStaticView.alpha = 0.0;
    _rightStaticView.alpha = 1.0;
    
    // Inform delegate of will showing right static controller
    if (delegate && [delegate respondsToSelector:@selector(slideController:willShowRightStaticController:)]) {
        [delegate slideController:self willShowRightStaticController:_leftStaticViewController];
    }
    
    // Inform delegate of will hiding sliding controller
    if (delegate && [delegate respondsToSelector:@selector(slideController:willHideSlindingController:)]) {
        [delegate slideController:self willHideSlindingController:self.slidingViewController];
    }
    
    isLeftStaticViewVisible = NO;
    isRightStaticViewVisible = YES;
    
    if (animated) {
        [UIView animateWithDuration:kSwipeAnimationTime animations:^{
            [self layoutForOrientation:self.interfaceOrientation];
        } completion:^(BOOL finished) {
            // inform delegate
            
            // Inform delegate of did hide sliding controller
            if (delegate && [delegate respondsToSelector:@selector(slideController:didHideSlindingController:)]) {
                [delegate slideController:self didHideSlindingController:self.slidingViewController];
            }
            
            // Inform delegate of did showing left static controller
            if (delegate && [delegate respondsToSelector:@selector(slideController:didShowRightStaticController:)]) {
                [delegate slideController:self didShowRightStaticController:_leftStaticViewController];
            }
            
            
            
        }];
    }else {
        [self layoutForOrientation:self.interfaceOrientation];
    }
}


/////////////////////// Override Setter Properties ////////////////////
#pragma mark - Setter Methods

-(void)setLeftStaticViewController:(UIViewController *)staticViewController
{
    
    // Doing viewcontroller containment magic
    
    [_leftStaticViewController willMoveToParentViewController:nil];
    [_leftStaticViewController removeFromParentViewController];
    
    [staticViewController.view removeFromSuperview];
    
    _leftStaticViewController = staticViewController;
    
    if (_leftStaticViewController == nil) {
        return;
    }

    [self addChildViewController:_leftStaticViewController];
    [_leftStaticViewController didMoveToParentViewController:self];

    if ([self isViewLoaded]) {
        [self updateLeftStaticView];
    }
}

-(void)setRightStaticViewController:(UIViewController *)staticViewController
{
    
    // Doing viewcontroller containment magic
    
    [_rightStaticViewController willMoveToParentViewController:nil];
    [_rightStaticViewController removeFromParentViewController];
    
    [staticViewController.view removeFromSuperview];
    
    _rightStaticViewController = staticViewController;
    
    if (_rightStaticViewController == nil) {
        return;
    }
    
    [self addChildViewController:_rightStaticViewController];
    [_rightStaticViewController didMoveToParentViewController:self];
    
    if ([self isViewLoaded]) {
        [self updateRightStaticView];
    }
}

-(void)setSlidingViewController:(UIViewController *)slidingViewController
{

    // Doing viewcontroller containment magic
    
    [_slidingViewController willMoveToParentViewController:nil];
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

-(void)setLeftStaticViewWidth:(NSInteger)staticViewWidth
{
    useFixedStaticViewWidth = YES;
    _leftStaticViewWidth = staticViewWidth;
    
}

-(void)setRightStaticViewWidth:(NSInteger)rightStaticViewWidth
{
    useFixedStaticViewWidth = YES;
    _rightStaticViewWidth = rightStaticViewWidth;
}

///////////////////////// Updating Views //////////////////////////
#pragma mark - Updating views

-(void)updateLeftStaticView
{
    _leftStaticViewController.view.frame = _leftStaticView.bounds;
    [_leftStaticView addSubview:_leftStaticViewController.view];
}

-(void)updateRightStaticView
{
    _rightStaticViewController.view.frame = _rightStaticView.bounds;
    [_rightStaticView addSubview:_rightStaticViewController.view];
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
        
        _leftStaticView.frame = CGRectMake(0, 0, self.view.bounds.size.width-_slideViewPaddingRight, self.view.bounds.size.height);
        _rightStaticView.frame = CGRectMake(_slideViewPaddingRight, 0, self.view.bounds.size.width-_slideViewPaddingRight, self.view.bounds.size.height);
    }else {
        
        // using a fixed width for the static view. slideviewpaddingRight is ignored here
        
        CGFloat cuttedOffLeftStaticWidth = _leftStaticViewWidth;
        CGFloat cuttedOffRightStaticWidth = _rightStaticViewWidth;
        
        if (cuttedOffLeftStaticWidth > self.view.bounds.size.width) {
            cuttedOffLeftStaticWidth = self.view.bounds.size.width;
        }
        
        if (cuttedOffRightStaticWidth > self.view.bounds.size.width) {
            cuttedOffRightStaticWidth = self.view.bounds.size.width;
        }
        
        _leftStaticView.frame = CGRectMake(0, 0, cuttedOffLeftStaticWidth, self.view.bounds.size.height);
        _rightStaticView.frame = CGRectMake(0, 0, cuttedOffRightStaticWidth, self.view.bounds.size.height);
    }
    
    CGFloat leftStaticWidth = _leftStaticView.bounds.size.width;
    //CGFloat rightStaticWidth = _rightStaticView.bounds.size.width;
    CGFloat slidingWidth = self.view.bounds.size.width-_slideViewPaddingLeft;
    
    // setting the frame of sliding view
    
    if (isLeftStaticViewVisible) {
        
        // Static view is uncovered
        
        _slidingView.frame = CGRectMake(leftStaticWidth, 0, slidingWidth, self.view.bounds.size.height);
        
    }else if (isRightStaticViewVisible) {
        
        _slidingView.frame = CGRectMake(_rightStaticView.frame.origin.x-slidingWidth, 0, slidingWidth, self.view.bounds.size.height);
        
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
    
    if (isRightStaticViewVisible) {
        // Swiping to right controller not implemented yet
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    
    // Save the swipe start point
    // also set it as lastsample point
    
    xPosStart = touchPoint.x;
    xPosLastSample = touchPoint.x;
    

    _leftStaticView.alpha = 1.0;
    _rightStaticView.alpha = 0.0;
    
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_allowInteractiveSlideing) {
        return;
    }
    
    if (isRightStaticViewVisible) {
        // Swiping to right controller not implemented yet
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
    

    
        if (newSlidingRect.origin.x < _leftStaticView.frame.origin.x+_slideViewPaddingLeft) {
            newSlidingRect.origin.x = _leftStaticView.frame.origin.x+_slideViewPaddingLeft;
        }
        
        
        if (newSlidingRect.origin.x > _leftStaticView.frame.origin.x+_leftStaticView.frame.size.width) {
            newSlidingRect.origin.x = _leftStaticView.frame.origin.x+_leftStaticView.frame.size.width;
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
    
    if (isRightStaticViewVisible) {
        // Swiping to right controller not implemented yet
        return;
    }
    
    if (direction == 1) {
        [self showLeftStaticView:YES];
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
        [self showLeftStaticView:YES];
    }else {
        [self showSlidingViewAnimated:YES];
    }
}

/////////////////////// View Lifecycle ////////////////////
#pragma mark - View Lifecycle

- (void)loadView
{
    [super loadView];
    
    _leftStaticView = [[UIView alloc] init];
    _rightStaticView = [[UIView alloc] init];
    _slidingView = [[UIView alloc] init];
    
    if (_drawShadow) {
        _slidingView.layer.shadowColor = [UIColor blackColor].CGColor;
        _slidingView.layer.shadowOpacity = 0.5;
        _slidingView.layer.shadowOffset = CGSizeMake(0, 0);
        
        _slidingView.layer.shadowRadius = 10.0;
    }
    
    
    
    [self.view addSubview:_leftStaticView];
    [self.view addSubview:_rightStaticView];
    [self.view addSubview:_slidingView];
    
    if (isLeftStaticViewVisible) {
        _leftStaticView.alpha = 1.0;
        _rightStaticView.alpha = 0.0;
    }else if(isRightStaticViewVisible) {
        _leftStaticView.alpha = 0.0;
        _rightStaticView.alpha = 1.0;
    }
    
    // Debug
    
    _leftStaticView.backgroundColor = [UIColor darkGrayColor];
    _rightStaticView.backgroundColor = [UIColor lightGrayColor];
    _slidingView.backgroundColor = [UIColor grayColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateLeftStaticView];
    [self updateRightStaticView];
    [self updateSlidingView];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [_leftStaticView removeFromSuperview];
    [_rightStaticView removeFromSuperview];
    [_slidingView removeFromSuperview];
    
    _leftStaticView = nil;
    _rightStaticView = nil;
    _slidingView = nil;
}

-(void)viewWillLayoutSubviews
{
    [self layoutForOrientation:self.interfaceOrientation];
}

@end
