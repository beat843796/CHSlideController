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
#define kDefaultSlideViewPaddingRight 0
#define kSwipeAnimationTime 0.20
#define kSlidingViewShadowOpacity 0.5




// Private Interface
#pragma mark - Private Interface

@interface CHSlideController (private) <UIGestureRecognizerDelegate>

// adds the left static viewcontrollers view as a subview of the left static view
-(void)updateLeftStaticView;

// adds the right static viewcontrollers view as a subview of the right static view
-(void)updateRightStaticView;

// adds the sliding viewcontrollers view as a subview of the sliding view
-(void)updateSlidingView;

// does the layouting according to the current interface orientation
-(void)layoutForOrientation:(UIInterfaceOrientation)orientation;


// delegate calls refactored
-(void)informDelegateOfShowingSlidingView;
-(void)informDelegateOfShowingLeftStaticView;
-(void)informDelegateOfShowingRightStaticView;
-(void)informDelegateOfMaximizingStaticView;
-(void)informDelegateOfUnmaximizingStaticView;
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
 
//@synthesize slideViewPaddingLeft = _slideViewPaddingLeft;
@synthesize slideViewVisibleWidthWhenHidden = _slideViewVisibleWidthWhenHidden;

@synthesize leftStaticViewWidth = _leftStaticViewWidth;
@synthesize rightStaticViewWidth = _rightStaticViewWidth;
@synthesize drawShadow = _drawShadow;
@synthesize allowInteractiveSliding = _allowInteractiveSliding;





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
        
        //_slideViewPaddingLeft = kDefaultSlideViewPaddingLeft;
        _slideViewVisibleWidthWhenHidden = kDefaultSlideViewPaddingRight;
        
        _allowInteractiveSliding = YES;
        _isVisibleStaticViewMaximized = NO;
    }
    return self;
}






/////////////////// Public methods //////////////////////
#pragma mark - Public methods

-(void)showSlidingViewAnimated:(BOOL)animated
{

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
        
        [UIView animateWithDuration:kSwipeAnimationTime delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            [self layoutForOrientation:self.interfaceOrientation];
        } completion:^(BOOL finished) {
            [self informDelegateOfShowingSlidingView];
            
            lastVisibleController = nil;
        }];
        
        
        
    }else {
        [self layoutForOrientation:self.interfaceOrientation];

        [self informDelegateOfShowingSlidingView];
        
        lastVisibleController = nil;
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
        [UIView animateWithDuration:kSwipeAnimationTime delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            [self layoutForOrientation:self.interfaceOrientation];
        } completion:^(BOOL finished) {
            
            
            [self informDelegateOfShowingLeftStaticView];
            
        }];
    }else {
        [self layoutForOrientation:self.interfaceOrientation];
        
        [self informDelegateOfShowingLeftStaticView];
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
    
    // TODO: refactor delegate calls
    
    if (animated) {
        [UIView animateWithDuration:kSwipeAnimationTime delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            [self layoutForOrientation:self.interfaceOrientation];
        } completion:^(BOOL finished) {
            [self informDelegateOfShowingRightStaticView];
 
        }];
    }else {
        [self layoutForOrientation:self.interfaceOrientation];
        
        [self informDelegateOfShowingRightStaticView];
    }
}


// maximizes the visible staticview (left or right)
-(void)maximizeStaticViewAnimated:(BOOL)animated
{
    
    _isVisibleStaticViewMaximized = YES;
    
    
    // inform delegate
    if (delegate && [delegate respondsToSelector:@selector(slideController:willMaximizeAnimated:)]) {
        [delegate slideController:self willMaximizeAnimated:animated];
    }
    
    if (animated) {
        [UIView animateWithDuration:kSwipeAnimationTime delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            [self layoutForOrientation:self.interfaceOrientation];
        } completion:^(BOOL finished) {
            
            [self informDelegateOfMaximizingStaticView];
            
        }];
    }else {
        [self layoutForOrientation:self.interfaceOrientation];
        
        [self informDelegateOfMaximizingStaticView];
    }
    
}

// unmaximizes the visible staticview (left or right)
-(void)unmaximizeStaticViewAnimated:(BOOL)animated
{

    _isVisibleStaticViewMaximized = NO;
    
    if (delegate && [delegate respondsToSelector:@selector(slideController:willUnmaximizeAnimated:)]) {
        [delegate slideController:self willUnmaximizeAnimated:animated];
    }
    
    if (animated) {
        [UIView animateWithDuration:kSwipeAnimationTime delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            [self layoutForOrientation:self.interfaceOrientation];
        } completion:^(BOOL finished) {
            [self informDelegateOfUnmaximizingStaticView];
            
        }];
    }else {
        [self layoutForOrientation:self.interfaceOrientation];
        
        [self informDelegateOfUnmaximizingStaticView];
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
    
    if (staticViewWidth <= 0) {
        NSLog(@"Warning: Left static view width must not be <= 0");
        return;
    }
    
    useFixedLeftStaticViewWidth = YES;
    _leftStaticViewWidth = staticViewWidth;
    
}

-(void)setRightStaticViewWidth:(NSInteger)rightStaticViewWidth
{
    
    if (rightStaticViewWidth <= 0) {
        NSLog(@"Warning: Right static view width must not be <= 0");
        return;
    }
    
    useFixedRightStaticViewWidth = YES;
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
    
    
    if (!useFixedLeftStaticViewWidth) {
        
        // default mode, use screenwidth for staticview width
        
        _leftStaticView.frame = CGRectMake(0, 0, self.view.bounds.size.width-_slideViewVisibleWidthWhenHidden, self.view.bounds.size.height);

    }else {
        
        CGFloat cuttedOffLeftStaticWidth = _leftStaticViewWidth;

        if (cuttedOffLeftStaticWidth > self.view.bounds.size.width-_slideViewVisibleWidthWhenHidden) {
            cuttedOffLeftStaticWidth = self.view.bounds.size.width-_slideViewVisibleWidthWhenHidden;
        }

        _leftStaticView.frame = CGRectMake(0, 0, cuttedOffLeftStaticWidth, self.view.bounds.size.height);
        
    }
    
    
    if (!useFixedRightStaticViewWidth) {

        _rightStaticView.frame = CGRectMake(_slideViewVisibleWidthWhenHidden, 0, self.view.bounds.size.width-_slideViewVisibleWidthWhenHidden, self.view.bounds.size.height);
        
    }else {

        CGFloat cuttedOffRightStaticWidth = _rightStaticViewWidth;

        if (cuttedOffRightStaticWidth > self.view.bounds.size.width-_slideViewVisibleWidthWhenHidden) {
            cuttedOffRightStaticWidth = self.view.bounds.size.width-_slideViewVisibleWidthWhenHidden;
        }

        _rightStaticView.frame = CGRectMake(self.view.bounds.size.width-cuttedOffRightStaticWidth, 0, cuttedOffRightStaticWidth, self.view.bounds.size.height);
    }
    
    
    CGFloat leftStaticWidth = _leftStaticView.bounds.size.width;
    CGFloat rightStaticWidth = _rightStaticView.bounds.size.width;
    CGFloat slidingWidth = self.view.bounds.size.width;
    
    
    // new feature of maximizing visible static view
    
    if (_isVisibleStaticViewMaximized) {
        
        if (isLeftStaticViewVisible) {
            leftStaticWidth = self.view.bounds.size.width;
            _leftStaticView.frame = CGRectMake(0, 0, leftStaticWidth, self.view.bounds.size.height);
        }
        
        if (isRightStaticViewVisible) {
            rightStaticWidth = self.view.bounds.size.width;
            _rightStaticView.frame = CGRectMake(self.view.bounds.size.width-rightStaticWidth, 0, rightStaticWidth, self.view.bounds.size.height);
        }

    }
    
    // setting the frame of sliding view
    
    if (isLeftStaticViewVisible) {
        
        // Static view is uncovered
        
        _slidingView.frame = CGRectMake(leftStaticWidth, 0, slidingWidth, self.view.bounds.size.height);
        
    }else if (isRightStaticViewVisible) {
        
        _slidingView.frame = CGRectMake(_rightStaticView.frame.origin.x-slidingWidth, 0, slidingWidth, self.view.bounds.size.height);
        
    }else {
        
        // Static view is covered
        
        _slidingView.frame = CGRectMake(0, 0, slidingWidth, self.view.bounds.size.height);
    }
    
    if (_drawShadow) {
        
        _slidingView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_slidingView.bounds].CGPath;
        
        if (!_isVisibleStaticViewMaximized) {
            _slidingView.layer.shadowOpacity = kSlidingViewShadowOpacity;
        }else {
            _slidingView.layer.shadowOpacity = 0.0;
        }
        
        
    }
    
}

///////////////////////// Interactive Sliding - Touch handling /////////////////////////
#pragma mark - UIGestureRecognizerDelegate
-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (!self.allowInteractiveSliding || !gestureRecognizer.enabled)
    {
        return NO;
    }
    return YES;
}

#pragma mark - interactive sliding
- (void) handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView:self.view];
    
    switch ( recognizer.state )
    {
        case UIGestureRecognizerStateBegan:
        {
            if (!_allowInteractiveSliding) {
                return;
            }
            
            if (isRightStaticViewVisible) {
                // Swiping to right controller not implemented yet
                return;
            }
            
            xPosStart = touchPoint.x;
            xPosLastSample = touchPoint.x;
            
            _leftStaticView.alpha = 1.0;
            _rightStaticView.alpha = 0.0;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            if (!_allowInteractiveSliding) {
                return;
            }
            
            if (isRightStaticViewVisible) {
                // Swiping to right controller not implemented yet
                return;
            }
            
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
            
            if (newSlidingRect.origin.x < _leftStaticView.frame.origin.x) {
                newSlidingRect.origin.x = _leftStaticView.frame.origin.x;
            }
            
            
            if (newSlidingRect.origin.x > _leftStaticView.frame.origin.x+_leftStaticView.frame.size.width) {
                newSlidingRect.origin.x = _leftStaticView.frame.origin.x+_leftStaticView.frame.size.width;
            }
            
            _slidingView.frame = newSlidingRect;
            
            //setting the lastSamplePoint as the current one
            
            xPosLastSample = xPosCurrent;
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            if (!_allowInteractiveSliding) {
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
            break;
        }
        case UIGestureRecognizerStateCancelled:
        {
            if (!_allowInteractiveSliding) {
                return;
            }
            
            if (direction == 1) {
                [self showLeftStaticView:YES];
            }else {
                [self showSlidingViewAnimated:YES];
            }
            break;
        }
        case UIGestureRecognizerStateFailed:
            break;
        default:
            break;
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
        _slidingView.layer.shadowOpacity = kSlidingViewShadowOpacity;
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
    //_leftStaticView.backgroundColor = [UIColor darkGrayColor];
    //_rightStaticView.backgroundColor = [UIColor lightGrayColor];
    //_slidingView.backgroundColor = [UIColor grayColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateLeftStaticView];
    [self updateRightStaticView];
    [self updateSlidingView];
    
    //Add gesture recognizer to slidingView
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    gesture.delegate = self;
    [_slidingView addGestureRecognizer:gesture];
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
    [super viewWillLayoutSubviews];
    
    [self layoutForOrientation:self.interfaceOrientation];
}

/////////////////////// Refactored delegate calls ////////////////////
#pragma mark - Refactored delegate calls

-(void)informDelegateOfShowingSlidingView
{
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
}

-(void)informDelegateOfShowingLeftStaticView
{
    // inform delegate
    
    // Inform delegate of did hiding sliding controller
    if (delegate && [delegate respondsToSelector:@selector(slideController:didHideSlindingController:)]) {
        [delegate slideController:self didHideSlindingController:self.slidingViewController];
    }
    
    // Inform delegate of did showing left static controller
    if (delegate && [delegate respondsToSelector:@selector(slideController:didShowLeftStaticController:)]) {
        [delegate slideController:self didShowLeftStaticController:_leftStaticViewController];
    }
}

-(void)informDelegateOfShowingRightStaticView
{
    // Inform delegate of did hide sliding controller
    if (delegate && [delegate respondsToSelector:@selector(slideController:didHideSlindingController:)]) {
        [delegate slideController:self didHideSlindingController:self.slidingViewController];
    }
    
    // Inform delegate of did showing left static controller
    if (delegate && [delegate respondsToSelector:@selector(slideController:didShowRightStaticController:)]) {
        [delegate slideController:self didShowRightStaticController:_leftStaticViewController];
    }
}

-(void)informDelegateOfMaximizingStaticView
{
    // inform delegate
    if (delegate && [delegate respondsToSelector:@selector(slideControllerDidMaximize:)]) {
        [delegate slideControllerDidMaximize:self];
    }
}

-(void)informDelegateOfUnmaximizingStaticView
{
    // inform delegate
    
    if (delegate && [delegate respondsToSelector:@selector(slideControllerDidUnmaximize:)]) {
        [delegate slideControllerDidUnmaximize:self];
    }
}

@end
