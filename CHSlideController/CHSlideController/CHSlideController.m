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


#define kSwipeAnimationTime 0.3f
#define kSlidingViewShadowOpacity 0.5f
#define kSlidingViewShadowRadius 4.0f
#define kAnimatedOffsetFactor 0.25f
#define kDimViewMaxAlpha 0.5f

typedef NS_ENUM(NSInteger, CHSlideDirection)
{
    CHSlideDirectionLeft = -1,
    CHSlideDirectionRight = 1,
};


// Private Interface
#pragma mark - Private Interface
@interface CHSlideController () <UIGestureRecognizerDelegate>
{
    
    UIPanGestureRecognizer *_leftSwipe;  // used for interactiv sliding
    UIPanGestureRecognizer *_rightSwipe; // used for interactiv sliding
    

    
    CHSlideDirection direction; // active interactive sliding direction
    
    // Helpers for detecting swipe directions
    CGFloat _xPosStart;
    CGFloat _xPosLastSample;
    CGFloat _xPosCurrent;
    CGFloat _xPosEnd;
    
    CGFloat _percentageOfDraggingCompleted; // value betwwen 0.0 and 1.0 telling how much of the dragging distance of the sliding view is completed, used for interactive sliding. 1.0 when slideview totally visibly
    
    
    UIView *statusBar;
    
}

@property (nonatomic, strong) UIView *leftSafeAreaView;
@property (nonatomic, strong) UIView *rightSafeAreaView;
@property (nonatomic, strong) UIView *dimView;

// On that view the left staticcontrollers view gets added as a subview
@property (strong, nonatomic, readonly) UIView *leftStaticView;

// On that view the right staticcontrollers view gets added as a subview
@property (strong, nonatomic, readonly) UIView *rightStaticView;

// On that view the slidingcontrollers view gets added as a subview
@property (strong, nonatomic, readonly) UIView *slidingView;

// adds the left static viewcontrollers view as a subview of the left static view
-(void)CH_updateLeftStaticView;

// adds the right static viewcontrollers view as a subview of the right static view
-(void)CH_updateRightStaticView;

// adds the sliding viewcontrollers view as a subview of the sliding view
-(void)CH_updateSlidingView;

// does the layouting according to the current interface orientation
-(void)CH_layoutForOrientation;

-(void)CH_applySlidingViewDim;

-(BOOL)CH_isSlidingViewVisibleOnScreen;

-(void)CH_positionStatusBar;

// delegate calls refactored

-(void)CH_willShowSlidingView;
-(void)CH_willShowLeftStaticView;
-(void)CH_willShowRightStaticView;

-(void)CH_didShowSlidingView;
-(void)CH_didShowLeftStaticView;
-(void)CH_didShowRightStaticView;

-(void)CH_willHideSlidingView;
-(void)CH_willHideLeftStaticView;
-(void)CH_willHideRightStaticView;

-(void)CH_didHideSlidingView;
-(void)CH_didHideLeftStaticView;
-(void)CH_didHideRightStaticView;

@end

/////////////////// Implementation //////////////////////
#pragma mark - Implementation

@implementation CHSlideController

@synthesize delegate;

/////////////////// Initialisation //////////////////////
#pragma mark - Initialisation

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // Setting up defaults
        
        isLeftStaticViewVisible = YES;
        isRightStaticViewVisible = NO;
        
        _drawShadow = YES;
        
        _allowEdgeSwipingForSlideingView = YES;
        
        _animateLeftStaticViewWhenSliding = NO;
        _animateRightStaticViewWhenSliding = NO;
        
        _dimSlidingViewWhenNoCoveringStaticView = YES;

        _stickStatusBarToSlidingView = NO;
        
        
        

        

        
    }
    return self;
}




/////////////////// Public methods //////////////////////
#pragma mark - Public methods

-(void)showSlidingViewAnimated:(BOOL)animated
{
    
    [self CH_willShowSlidingView];
    
    BOOL wasLeftViewVisible = NO;
    BOOL wasRightViewVisible = NO;
    
    if (isLeftStaticViewVisible) {
        [self CH_willHideLeftStaticView];
        wasLeftViewVisible = YES;
    }
    
    
    if (isRightStaticViewVisible) {
        [self CH_willHideRightStaticView];
        wasRightViewVisible = YES;
    }
    
    isLeftStaticViewVisible = NO;
    isRightStaticViewVisible = NO;
    
    NSTimeInterval animationDuration = 0;
    
    if (animated) {
        animationDuration = kSwipeAnimationTime;
    }
    
    _percentageOfDraggingCompleted = 1.0;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self CH_layoutForOrientation];
        
        
    } completion:^(BOOL finished) {
        if (wasLeftViewVisible) {
            [self CH_didHideLeftStaticView];
        }
        
        
        if (wasRightViewVisible) {
            [self CH_didHideRightStaticView];
        }
        
        [self CH_didShowSlidingView];
        

    }];
    
}


-(void)showLeftStaticView:(BOOL)animated
{
    
    _leftStaticView.alpha = 1.0;
    _rightStaticView.alpha = 0.0;
    
    
    [self CH_willHideSlidingView];
    [self CH_willShowLeftStaticView];
    
    isLeftStaticViewVisible = YES;
    isRightStaticViewVisible = NO;
    
    NSTimeInterval animationDuration = 0;
    
    if (animated) {
        animationDuration = kSwipeAnimationTime;
    }
    
    _percentageOfDraggingCompleted = 0.0;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self CH_layoutForOrientation];
        
        
    } completion:^(BOOL finished) {
        
        [self CH_didShowLeftStaticView];
        [self CH_didHideSlidingView];
        

        
    }];
    
}



-(void)showRightStaticView:(BOOL)animated
{
    
    _leftStaticView.alpha = 0.0;
    _rightStaticView.alpha = 1.0;
    
    [self CH_willHideSlidingView];
    [self CH_willShowRightStaticView];
    
    isLeftStaticViewVisible = NO;
    isRightStaticViewVisible = YES;
    
    NSTimeInterval animationDuration = 0;
    
    if (animated) {
        animationDuration = kSwipeAnimationTime;
    }
    
    _percentageOfDraggingCompleted = 0.0;
    
    [UIView animateWithDuration:kSwipeAnimationTime animations:^{
        [self CH_layoutForOrientation];
        
        
    } completion:^(BOOL finished) {
        
        [self CH_didShowRightStaticView];
        [self CH_didHideSlidingView];
        

        
    }];
    
}

-(BOOL)isLeftStaticViewMaximized
{
    return _leftStaticView.bounds.size.width >= self.view.bounds.size.width;
}

-(BOOL)isRightStaticViewMaximized
{
    return _rightStaticView.bounds.size.width >= self.view.bounds.size.width;
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
        [self CH_updateLeftStaticView];
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
        [self CH_updateRightStaticView];
    }
}

-(void)setSlidingViewController:(UIViewController *)slidingViewController
{
    
    // Doing viewcontroller containment magic
    
    [_slidingViewController willMoveToParentViewController:nil];
    [_slidingViewController removeFromParentViewController];
    
    [_leftSafeAreaView removeFromSuperview];
    [_rightSafeAreaView removeFromSuperview];
    
    [_dimView removeFromSuperview];
    
    [_slidingViewController.view removeFromSuperview];
    
    _slidingViewController = slidingViewController;
    
    if (_slidingViewController == nil) {
        return;
    }
    
    [self addChildViewController:_slidingViewController];
    [_slidingViewController didMoveToParentViewController:self];
    
    if ([self isViewLoaded]) {
        [self CH_updateSlidingView];
    }
}

-(void)setLeftStaticViewWidth:(CGFloat)staticViewWidth
{
    
    if (staticViewWidth <= 0) {
        NSLog(@"Warning: Left static view width must not be <= 0");
        return;
    }
    
    _leftStaticViewWidth = staticViewWidth;
    
    [self.view setNeedsLayout];
    
}

-(void)setRightStaticViewWidth:(CGFloat)rightStaticViewWidth
{
    
    if (rightStaticViewWidth <= 0) {
        NSLog(@"Warning: Right static view width must not be <= 0");
        return;
    }
    
    _rightStaticViewWidth = rightStaticViewWidth;
    
    [self.view setNeedsLayout];
}


-(void)setLeftStaticViewWidth:(CGFloat)leftStaticViewWidth animated:(BOOL)animated
{
    if (leftStaticViewWidth <= 0) {
        NSLog(@"Warning: Left static view width must not be <= 0");
        return;
    }
    
    NSTimeInterval animationDuration = 0;
    
    if (animated) {
        animationDuration = kSwipeAnimationTime;
    }
    
    _leftStaticViewWidth = leftStaticViewWidth;


    [UIView animateWithDuration:animationDuration animations:^{
        
        
        [self CH_layoutForOrientation];
        
        if ([_leftStaticViewController isKindOfClass:[UINavigationController class]] && [_leftStaticViewController respondsToSelector:@selector(navigationBar)]) {

            [[(UINavigationController *)_leftStaticViewController navigationBar] layoutSubviews];

        }
        
        

        
    }];
    

    
}



-(void)setRightStaticViewWidth:(CGFloat)rightStaticViewWidth animated:(BOOL)animated
{
    if (rightStaticViewWidth <= 0) {
        NSLog(@"Warning: Right static view width must not be <= 0");
        return;
    }
    
    NSTimeInterval animationDuration = 0;
    
    if (animated) {
        animationDuration = kSwipeAnimationTime;
    }
    
    _rightStaticViewWidth = rightStaticViewWidth;
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        [self CH_layoutForOrientation];
        
        // needed to smoothly animate navbar if present without jumping title and buttons
        if ([_rightStaticViewController isKindOfClass:[UINavigationController class]] && [_rightStaticViewController respondsToSelector:@selector(navigationBar)]) {
            [[(UINavigationController *)_rightStaticViewController navigationBar] layoutSubviews];
        }
    }];
}


-(void)setAllowEdgeSwipingForSlideingView:(BOOL)allowEdgeSwiping
{
    _leftSwipe.enabled = allowEdgeSwiping;
    _rightSwipe.enabled = allowEdgeSwiping;
    
    _leftSafeAreaView.userInteractionEnabled = allowEdgeSwiping;
    _rightSafeAreaView.userInteractionEnabled = allowEdgeSwiping;
}

// overriden
-(void)setDrawShadow:(BOOL)drawShadow
{
    _drawShadow = drawShadow;
    
    [self.view setNeedsLayout];
    
}

-(void)setDimSlidingViewWhenNoCoveringStaticView:(BOOL)dimSlidingViewWhenNoCoveringStaticView
{
    _dimSlidingViewWhenNoCoveringStaticView = dimSlidingViewWhenNoCoveringStaticView;
    
    [self.view setNeedsLayout];
}

-(void)setStickStatusBarToSlidingView:(BOOL)stickStatusBarToSlidingView
{
    _stickStatusBarToSlidingView = stickStatusBarToSlidingView;
    
    if (_stickStatusBarToSlidingView) {
        
        NSString *key = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x73, 0x74, 0x61, 0x74, 0x75, 0x73, 0x42, 0x61, 0x72} length:9] encoding:NSASCIIStringEncoding];
        id object = [UIApplication sharedApplication];
        
        @try {
            if ([object respondsToSelector:NSSelectorFromString(key)]) {
                statusBar = [object valueForKey:key];
            }
        }
        @catch (NSException *exception) {
            
        }
        
    }
    
    [self CH_positionStatusBar];
}

///////////////////////// Updating Views //////////////////////////
#pragma mark - Updating views

-(void)CH_updateLeftStaticView
{
    _leftStaticViewController.view.frame = _leftStaticView.bounds;
    [_leftStaticView addSubview:_leftStaticViewController.view];
}

-(void)CH_updateRightStaticView
{
    _rightStaticViewController.view.frame = _rightStaticView.bounds;
    [_rightStaticView addSubview:_rightStaticViewController.view];
}


-(void)CH_updateSlidingView
{
    _slidingViewController.view.frame = _slidingView.bounds;
    [_slidingView addSubview:_slidingViewController.view];
    
    [_slidingViewController.view addSubview:_dimView];
    
    [_slidingViewController.view addSubview:_leftSafeAreaView];
    [_slidingViewController.view addSubview:_rightSafeAreaView];
    
    
    // if sliding viewcontroller is a navigationcontroller make sure that the navigationbar
    // is always on top of safeAreaViews that are needed for swipe gesture recognition for
    // interactive sliding of the slidingview.
    
    if ([_slidingViewController isKindOfClass:[UINavigationController class]] && [_slidingViewController respondsToSelector:@selector(navigationBar)]) {


        [_slidingViewController.view bringSubviewToFront:[(UINavigationController *)_slidingViewController navigationBar]];
        
    }
    
}


-(BOOL)CH_isSlidingViewVisibleOnScreen
{
    
    return CGRectIntersectsRect(self.view.window.frame, _slidingView.frame);
    
    
}


///////////////////////// Autorotation Stuff /////////////////////////
#pragma mark - Autorotation stuff

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self CH_layoutForOrientation];
}

- (void)CH_layoutForOrientation
{
    
    // Setting the frames of static

    CGFloat cuttedOffLeftStaticWidth = _leftStaticViewWidth;
    
    if (cuttedOffLeftStaticWidth > self.view.bounds.size.width) {
        cuttedOffLeftStaticWidth = self.view.bounds.size.width;
    }

    CGFloat cuttedOffRightStaticWidth = _rightStaticViewWidth;
    
    if (cuttedOffRightStaticWidth > self.view.bounds.size.width) {
        cuttedOffRightStaticWidth = self.view.bounds.size.width;
    }
    


    
    // setting desired frames
    _leftStaticView.frame = CGRectMake(0, 0, cuttedOffLeftStaticWidth, self.view.bounds.size.height);
    _rightStaticView.frame = CGRectMake(self.view.bounds.size.width-cuttedOffRightStaticWidth, 0, cuttedOffRightStaticWidth, self.view.bounds.size.height);
    
    
    
    
    CGFloat leftStaticWidth = _leftStaticView.bounds.size.width;
    
    CGFloat slidingWidth = self.view.bounds.size.width; // always self.view.width
    
    // setting the frame of sliding view
    
    if (isLeftStaticViewVisible) {
        
        // Static view is uncovered
        
        _slidingView.frame = CGRectMake(leftStaticWidth, 0, slidingWidth, self.view.bounds.size.height);
        
    }else if (isRightStaticViewVisible) {
        
        _slidingView.frame = CGRectMake(_rightStaticView.frame.origin.x-slidingWidth, 0, slidingWidth, self.view.bounds.size.height);
        
    }else {
        
        // Static view is covered
        _slidingView.frame = CGRectMake(0, 0, slidingWidth, self.view.bounds.size.height);
        
        
        if (_animateLeftStaticViewWhenSliding) {
            _leftStaticView.frame = CGRectMake(-1*slidingWidth*kAnimatedOffsetFactor, 0, cuttedOffLeftStaticWidth, self.view.bounds.size.height);
        }
        
        if (_animateRightStaticViewWhenSliding) {
            _rightStaticView.frame = CGRectMake(self.view.bounds.size.width-cuttedOffRightStaticWidth+slidingWidth*kAnimatedOffsetFactor, 0, cuttedOffRightStaticWidth, self.view.bounds.size.height);
        }
        
    }
    
    if (_drawShadow && [self CH_isSlidingViewVisibleOnScreen]) {
        _slidingView.layer.shadowColor = [UIColor blackColor].CGColor;
        _slidingView.layer.shadowOffset = CGSizeMake(0, 0);
        _slidingView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_slidingView.bounds].CGPath;
        _slidingView.layer.shadowRadius = kSlidingViewShadowRadius;
        _slidingView.layer.shadowOpacity = kSlidingViewShadowOpacity;
        
    }else {
        _slidingView.layer.shadowOpacity = 0.0;
    }
    
    
    _dimView.frame = _slidingView.bounds;
    
    if (!isLeftStaticViewVisible && !isRightStaticViewVisible) {
        _leftSafeAreaView.frame = CGRectMake(0, 0, 15, _slidingView.bounds.size.height);
        _rightSafeAreaView.frame = CGRectMake(_slidingView.bounds.size.width-15, 0, 15, self.view.bounds.size.height);
    }else {
        _leftSafeAreaView.frame = CGRectMake(0, 0, fabs(_slidingView.bounds.size.width-_leftStaticView.bounds.size.width), _slidingView.bounds.size.height);
        _rightSafeAreaView.frame = CGRectMake(_slidingView.bounds.size.width-fabs(_slidingView.bounds.size.width-_rightStaticView.bounds.size.width), 0, fabs(_slidingView.bounds.size.width-_rightStaticView.bounds.size.width), self.view.bounds.size.height);
    }
    
    
    [self CH_positionStatusBar];
    
    [_slidingView bringSubviewToFront:_dimView];
    
    [_slidingView bringSubviewToFront:_leftSafeAreaView];
    [_slidingView bringSubviewToFront:_rightSafeAreaView];
    
    
    [self CH_applySlidingViewDim];
    
}

-(void)CH_positionStatusBar
{
    
    CGRect statusBarRect = statusBar.frame;
    
    if (_stickStatusBarToSlidingView) {
    
        
        statusBarRect.origin.x = _slidingView.frame.origin.x;
        statusBar.frame = statusBarRect;
        
    }else {
        
        statusBarRect.origin.x = 0;
        statusBar.frame = statusBarRect;
        
        statusBar = nil;
    }
    
}

-(void)CH_applySlidingViewDim
{
    if (_dimSlidingViewWhenNoCoveringStaticView) {
        _dimView.alpha = kDimViewMaxAlpha-_percentageOfDraggingCompleted;
    }else {
        _dimView.alpha = 0.0;
    }
}



-(void)setAnimateLeftStaticViewWhenSliding:(BOOL)animateLeftStaticViewWhenSliding
{
    _animateLeftStaticViewWhenSliding = animateLeftStaticViewWhenSliding;
    
    [self.view setNeedsLayout];
}

-(void)setAnimateRightStaticViewWhenSliding:(BOOL)animateRightStaticViewWhenSliding
{
    _animateRightStaticViewWhenSliding = animateRightStaticViewWhenSliding;
    
    [self.view setNeedsLayout];
}

///////////////////////// Interactive Sliding - Touch handling /////////////////////////
#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (!_allowEdgeSwipingForSlideingView || !gestureRecognizer.enabled)
    {
        return NO;
    }
    return YES;
}

#pragma mark - interactive sliding
-(void)handlePanGestureLeft:(UIPanGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView:self.view];
    
    switch ( recognizer.state )
    {
        case UIGestureRecognizerStateBegan:
        {
            if (!_allowEdgeSwipingForSlideingView) {
                return;
            }
            
            
            
            _xPosStart = touchPoint.x;
            _xPosLastSample = touchPoint.x;
            
            _leftStaticView.alpha = 1.0;
            _rightStaticView.alpha = 0.0;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            if (!_allowEdgeSwipingForSlideingView) {
                return;
            }
            
            
            
            _xPosCurrent = touchPoint.x;
            
            // determining swipedirection based on last and current sample point
            
            if (_xPosCurrent>_xPosLastSample) {
                direction = CHSlideDirectionRight;
            }else if(_xPosCurrent < _xPosLastSample) {
                direction = CHSlideDirectionLeft;
            }
            
            
            
            CGRect newSlidingRect = CGRectOffset(_slidingView.frame, _xPosCurrent-_xPosLastSample, 0);
            
            /*
             
             If we slided beyonf the screensize we must cut the
             xOffset off to stop moving the sliding view
             
             */
            
            if (newSlidingRect.origin.x < 0) {
                newSlidingRect.origin.x = 0;
            }
            
            
            if (newSlidingRect.origin.x > _leftStaticView.frame.origin.x+_leftStaticView.frame.size.width) {
                newSlidingRect.origin.x = _leftStaticView.frame.origin.x+_leftStaticView.frame.size.width;
            }
            
            _slidingView.frame = newSlidingRect;
            
            [self CH_positionStatusBar];
            
            if (_animateLeftStaticViewWhenSliding) {
                _leftStaticView.frame = CGRectOffset(_leftStaticView.frame, (_xPosCurrent-_xPosLastSample)*kAnimatedOffsetFactor, 0);
            }

            //setting the lastSamplePoint as the current one
            
            _xPosLastSample = _xPosCurrent;
            
            CGFloat totalSlidingDistance = _leftStaticView.bounds.size.width;
            
            _percentageOfDraggingCompleted = (totalSlidingDistance-_slidingView.frame.origin.x)/totalSlidingDistance;
            
            [self CH_applySlidingViewDim];
            
            
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            if (!_allowEdgeSwipingForSlideingView) {
                return;
            }
            
            
            
            if (direction == CHSlideDirectionRight) {
                [self showLeftStaticView:YES];
            }else {
                [self showSlidingViewAnimated:YES];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        {
            if (!_allowEdgeSwipingForSlideingView) {
                return;
            }
            
            if (direction == CHSlideDirectionRight) {
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


- (void) handlePanGestureRight:(UIPanGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView:self.view];
    
    switch ( recognizer.state )
    {
        case UIGestureRecognizerStateBegan:
        {
            if (!_allowEdgeSwipingForSlideingView) {
                return;
            }
            
            
            
            _xPosStart = touchPoint.x;
            _xPosLastSample = touchPoint.x;
            
            _leftStaticView.alpha = 0.0;
            _rightStaticView.alpha = 1.0;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            if (!_allowEdgeSwipingForSlideingView) {
                return;
            }
            
            
            
            _xPosCurrent = touchPoint.x;
            
            // determining swipedirection based on last and current sample point
            
            if (_xPosCurrent>_xPosLastSample) {
                direction = CHSlideDirectionRight;
            }else if(_xPosCurrent < _xPosLastSample) {
                direction = CHSlideDirectionLeft;
            }
            
            
            
            CGRect newSlidingRect = CGRectOffset(_slidingView.frame, _xPosCurrent-_xPosLastSample, 0);
            
            /*
             
             If we slide beyond the screensize we must cut the
             xOffset off to stop moving the sliding view
             
             */
            
            if (newSlidingRect.origin.x+newSlidingRect.size.width < _rightStaticView.frame.origin.x) {
                newSlidingRect.origin.x = _rightStaticView.frame.origin.x-newSlidingRect.size.width;
            }
            
            
            if (newSlidingRect.origin.x+newSlidingRect.size.width > _rightStaticView.frame.origin.x+_rightStaticView.frame.size.width) {
                newSlidingRect.origin.x = 0;
            }
            
            _slidingView.frame = newSlidingRect;
            
            [self CH_positionStatusBar];
            
            if (_animateRightStaticViewWhenSliding) {
                _rightStaticView.frame = CGRectOffset(_rightStaticView.frame, (_xPosCurrent-_xPosLastSample)*kAnimatedOffsetFactor, 0);
            }
            
            
            CGFloat totalSlidingDistance = _rightStaticView.bounds.size.width;
            
            _percentageOfDraggingCompleted = 1.0-((_slidingView.frame.origin.x)/totalSlidingDistance*-1);
            
            NSLog(@"dist %.2f",_percentageOfDraggingCompleted);
            
            [self CH_applySlidingViewDim];
            
            //setting the lastSamplePoint as the current one
            
            _xPosLastSample = _xPosCurrent;
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            if (!_allowEdgeSwipingForSlideingView) {
                return;
            }
            
            
            
            if (direction == CHSlideDirectionRight) {
                [self showSlidingViewAnimated:YES];
                
            }else {
                [self showRightStaticView:YES];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        {
            if (!_allowEdgeSwipingForSlideingView) {
                return;
            }
            
            if (direction == CHSlideDirectionRight) {
                [self showSlidingViewAnimated:YES];
                
            }else {
                [self showRightStaticView:YES];
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



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _leftStaticView = [[UIView alloc] init];
    _rightStaticView = [[UIView alloc] init];
    _slidingView = [[UIView alloc] init];
    
    
    _leftSafeAreaView = [[UIView alloc] init];
    //_leftSafeAreaView.backgroundColor = [UIColor redColor]; // debug
    _leftSafeAreaView.exclusiveTouch = YES;
    //[_slidingView addSubview:_leftSafeAreaView];
    
    _leftSafeAreaView.alpha = 0.25;
    
    
    _rightSafeAreaView = [[UIView alloc] init];
    //_rightSafeAreaView.backgroundColor = [UIColor blueColor]; // debug
    _rightSafeAreaView.exclusiveTouch = YES;
    //[_slidingView addSubview:_rightSafeAreaView];
    
    _rightSafeAreaView.alpha = 0.25;
    
    _dimView = [[UIView alloc] init];
    _dimView.backgroundColor = [UIColor blackColor];
    _dimView.userInteractionEnabled = NO;
    
    
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
    
    
    
    //Add gesture recognizer to slidingView
    _leftSwipe = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureLeft:)];
    _leftSwipe.delegate = self;
    _leftSwipe.maximumNumberOfTouches = 1;
    [_leftSafeAreaView addGestureRecognizer:_leftSwipe];
    
    _rightSwipe = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRight:)];
    _rightSwipe.delegate = self;
    _rightSwipe.maximumNumberOfTouches = 1;
    [_rightSafeAreaView addGestureRecognizer:_rightSwipe];
    
    [self setAllowEdgeSwipingForSlideingView:_allowEdgeSwipingForSlideingView];
    
    [self CH_updateLeftStaticView];
    [self CH_updateRightStaticView];
    [self CH_updateSlidingView];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [_leftSafeAreaView removeFromSuperview];
    [_rightSafeAreaView removeFromSuperview];
    
    [_leftStaticView removeFromSuperview];
    [_rightStaticView removeFromSuperview];
    [_slidingView removeFromSuperview];
    
    [_dimView removeFromSuperview];
    
    _leftSafeAreaView = nil;
    _rightSafeAreaView = nil;
    
    _dimView = nil;
    
    _leftStaticView = nil;
    _rightStaticView = nil;
    _slidingView = nil;
    
    _leftSwipe = nil;
    _rightSwipe = nil;
}



/////////////////////// Refactored delegate calls ////////////////////
#pragma mark - Refactored delegate calls


// will show

-(void)CH_willShowSlidingView
{
    if (delegate && [delegate respondsToSelector:@selector(slideController:willShowSlindingController:)]) {
        [delegate slideController:self willShowSlindingController:self.slidingViewController];
    }
}

-(void)CH_willShowLeftStaticView
{
    if (delegate && [delegate respondsToSelector:@selector(slideController:willShowLeftStaticController:)]) {
        [delegate slideController:self willShowLeftStaticController:self.leftStaticViewController];
    }
}

-(void)CH_willShowRightStaticView
{
    if (delegate && [delegate respondsToSelector:@selector(slideController:willShowRightStaticController:)]) {
        [delegate slideController:self willShowRightStaticController:self.rightStaticViewController];
    }
}

// did show

-(void)CH_didShowSlidingView
{
    if (delegate && [delegate respondsToSelector:@selector(slideController:didShowSlindingController:)]) {
        [delegate slideController:self didShowSlindingController:self.slidingViewController];
    }
}

-(void)CH_didShowLeftStaticView
{
    if (delegate && [delegate respondsToSelector:@selector(slideController:didShowLeftStaticController:)]) {
        [delegate slideController:self didShowLeftStaticController:self.leftStaticViewController];
    }
}

-(void)CH_didShowRightStaticView
{
    if (delegate && [delegate respondsToSelector:@selector(slideController:didShowRightStaticController:)]) {
        [delegate slideController:self didShowRightStaticController:self.leftStaticViewController];
    }
}

// will hide

-(void)CH_willHideSlidingView
{
    if (delegate && [delegate respondsToSelector:@selector(slideController:willHideSlindingController:)]) {
        [delegate slideController:self willHideSlindingController:self.slidingViewController];
    }
}

-(void)CH_willHideLeftStaticView
{
    if (delegate && [delegate respondsToSelector:@selector(slideController:willHideLeftStaticController:)]) {
        [delegate slideController:self willHideLeftStaticController:self.leftStaticViewController];
    }
}

-(void)CH_willHideRightStaticView
{
    if (delegate && [delegate respondsToSelector:@selector(slideController:willHideRightStaticController:)]) {
        [delegate slideController:self willHideRightStaticController:self.rightStaticViewController];
    }
}

// did hide

-(void)CH_didHideSlidingView
{
    if (delegate && [delegate respondsToSelector:@selector(slideController:didHideSlindingController:)]) {
        [delegate slideController:self didHideSlindingController:self.slidingViewController];
    }
}

-(void)CH_didHideLeftStaticView
{
    if (delegate && [delegate respondsToSelector:@selector(slideController:didHideLeftStaticController:)]) {
        [delegate slideController:self didHideLeftStaticController:self.leftStaticViewController];
    }
}

-(void)CH_didHideRightStaticView
{
    if (delegate && [delegate respondsToSelector:@selector(slideController:didHideRightStaticController:)]) {
        [delegate slideController:self didHideRightStaticController:self.rightStaticViewController];
    }
}

-(NSTimeInterval)animationTimeInterval
{
    return kSwipeAnimationTime;
}

@end
