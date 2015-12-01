//
//  CHSlideController.h
//  CHSlideController v2.0
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

// TODO: implement interactive sliding support for right static view

#import <UIKit/UIKit.h>

@class CHSlideController;
@protocol CHSlideControllerDelegate <NSObject>

@optional
-(void)slideController:(CHSlideController *)slideController willShowSlindingController:(UIViewController *)slidingController;
-(void)slideController:(CHSlideController *)slideController willHideSlindingController:(UIViewController *)slidingController;
-(void)slideController:(CHSlideController *)slideController didShowSlindingController:(UIViewController *)slidingController;
-(void)slideController:(CHSlideController *)slideController didHideSlindingController:(UIViewController *)slidingController;

-(void)slideController:(CHSlideController *)slideController willShowLeftStaticController:(UIViewController *)leftStaticController;
-(void)slideController:(CHSlideController *)slideController didShowLeftStaticController:(UIViewController *)leftStaticController;
-(void)slideController:(CHSlideController *)slideController willHideLeftStaticController:(UIViewController *)leftStaticController;
-(void)slideController:(CHSlideController *)slideController didHideLeftStaticController:(UIViewController *)leftStaticController;

-(void)slideController:(CHSlideController *)slideController willShowRightStaticController:(UIViewController *)leftStaticController;
-(void)slideController:(CHSlideController *)slideController didShowRightStaticController:(UIViewController *)leftStaticController;
-(void)slideController:(CHSlideController *)slideController willHideRightStaticController:(UIViewController *)leftStaticController;
-(void)slideController:(CHSlideController *)slideController didHideRightStaticController:(UIViewController *)leftStaticController;

@end

@interface CHSlideController : UIViewController
{
    __weak id<CHSlideControllerDelegate> delegate;
    
    BOOL isLeftStaticViewVisible;       // Indicates if the left static view is fully visible or not
    BOOL isRightStaticViewVisible;      // Indicates if the right static view is fully visible or not
}

/**
 *  The CHSlideController delegate
 */
@property (nonatomic, weak) id<CHSlideControllerDelegate> delegate;

/**
 *  The Static Controller that does not move on the left side
 */
@property (strong, nonatomic) UIViewController *leftStaticViewController;

/**
 *  The Static Controller that does not move on the right side
 */
@property (strong, nonatomic) UIViewController *rightStaticViewController;

/**
 *  The sliding controller that covers the staticcontroller and is moving left/right
 */
@property (strong, nonatomic) UIViewController *slidingViewController;

/**
 *  If set to yes a shadow will be drawn under the slidingView. Defaults to YES
 */
@property (assign, nonatomic) BOOL drawShadow;

/**
 *  Dims the slinding view when it does not cover left or right static view entirely
 */
@property (assign, nonatomic) BOOL dimSlidingViewWhenNoCoveringStaticView;


/**
 *  If set to yes interactivly swiping the sliding view is possible. Defaults to YES
 */
@property (assign, nonatomic) BOOL allowEdgeSwipingForSlideingView;

/**
 *  If set the left static view will use it as a fixed width. sets useFixedStaticViewWidth to YES
 */
@property (assign, nonatomic) CGFloat leftStaticViewWidth;

/**
 *  If set the right static view will use it as a fixed width. sets useFixedStaticViewWidth to YES
 */
@property (assign, nonatomic) CGFloat rightStaticViewWidth;

/**
 *  Animates the left static view when sliding view is moved
 */
@property (assign, nonatomic) BOOL animateLeftStaticViewWhenSliding;

/**
 *  Animates the right static view when sliding view is moved
 */
@property (assign, nonatomic) BOOL animateRightStaticViewWhenSliding;

/**
 *  Animates the Sliding View in
 *
 *  @param animated YES if transition should be animated, otherwise NO
 */
-(void)showSlidingViewAnimated:(BOOL)animated;

/**
 *  Animates the Sliding View out, shows the left static view
 *
 *  @param animated YES if transition should be animated, otherwise NO
 */
-(void)showLeftStaticView:(BOOL)animated;

/**
 *  Animates the Sliding View out, shows the right static view
 *
 *  @param animated YES if transition should be animated, otherwise NO
 */
-(void)showRightStaticView:(BOOL)animated;

-(void)setLeftStaticViewWidth:(CGFloat)leftStaticViewWidth animated:(BOOL)animated;
-(void)setRightStaticViewWidth:(CGFloat)rightStaticViewWidth animated:(BOOL)animated;

-(BOOL)isLeftStaticViewMaximized;
-(BOOL)isRightStaticViewMaximized;

-(NSTimeInterval)animationTimeInterval;

@end
