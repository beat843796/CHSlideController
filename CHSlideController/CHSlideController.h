//
//  CHSlideController.h
//  CHSlideController
//
//  This controller is build up using ViewController Containment
//  and tries to mimic the Controllerstyle of the facebook app. 
//  The Static ViewController holds a controller that does not move and can
//  be used as a menu or selection view. The Sliding View Controller
//  should be used to display the main app content. The Slinding ViewController
//  is hierachically always on top of the static one and can be slided in
//  and out automatically, with and without animation and interactively
//  
//  If you are using this Controller you should subclass ist to handle the
//  communication between static and sliding view controller
//
//  Created by Clemens Hammerl on 19.10.12.
//  Copyright (c) 2012 appingo mobile e.U. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHSlideController;
@protocol CHSlideControllerDelegate <NSObject>

@optional
-(void)slideController:(CHSlideController *)slideController willShowSlindingController:(UIViewController *)slidingController;
-(void)slideController:(CHSlideController *)slideController willHideSlindingController:(UIViewController *)slidingController;
-(void)slideController:(CHSlideController *)slideController didShowSlindingController:(UIViewController *)slidingController;
-(void)slideController:(CHSlideController *)slideController didHideSlindingController:(UIViewController *)slidingController;

@end

@interface CHSlideController : UIViewController
{
    __weak id<CHSlideControllerDelegate> delegate;
    
    @protected
    BOOL useFixedStaticViewWidth;       // Indicates the use of a fixed with, gets set with setStaticSlideWidth automatically
    BOOL isStaticViewVisible;           // Indicates if the static view is fully visible or not
    
    // Helpers for detecting swipe directions
    
    @private
    NSInteger xPosStart;
    NSInteger xPosLastSample;
    NSInteger xPosCurrent;
    NSInteger xPosEnd;
    NSInteger direction; // -1 = left, +1 = right, 0 = no movement
}

@property (nonatomic, weak) id<CHSlideControllerDelegate> delegate;

// On that view the staticcontrollers view gets added as a subview
@property (strong, nonatomic, readonly) UIView *staticView;

// On that view the slidingcontrollers view gets added as a subview
@property (strong, nonatomic, readonly) UIView *slidingView;

// The Static Controller that does not move
@property (strong, nonatomic) UIViewController *staticViewController;

// The sliding controller that covers the staticcontroller and is moving left/right
@property (strong, nonatomic) UIViewController *slidingViewController;

// If set to yes a shadow will be drawn under the slidingView. Defaults to YES
@property (assign, nonatomic) BOOL drawShadow;

// If set to yes interactivly swiping the sliding view is possible. Defaults to YES
@property (assign, nonatomic) BOOL allowInteractiveSlideing;

// the space staticview keeps visible when sliding view is shown
@property (assign, nonatomic) NSInteger slideViewPaddingLeft; 

// the space slideview keeps visible when static view is shown
@property (assign, nonatomic) NSInteger slideViewPaddingRight;

// If set the static view will use it as a fixed width. sets useFixedStaticViewWidth to YES
@property (assign, nonatomic) NSInteger staticViewWidth;

// Animates the Sliding View in
-(void)showSlidingViewAnimated:(BOOL)animated;

// Animated the Sliding View out
-(void)hideSlidingViewAnimated:(BOOL)animated;

@end
