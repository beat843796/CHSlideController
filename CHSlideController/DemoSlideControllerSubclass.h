//
//  DemoSlideControllerSubclass.h
//  CHSlideController
//
//  Created by Clemens Hammerl on 19.10.12.
//  Copyright (c) 2012 appingo mobile e.U. All rights reserved.
//

#import "CHSlideController.h"
#import "CHStaticDemo.h"
#import "CHSlidingDemo.h"

@interface DemoSlideControllerSubclass : CHSlideController <CHStaticDemoDelegate>

// Defining the controllers we wanna display in the slide controller
@property (nonatomic, strong) CHSlidingDemo *textDisplayController;
@property (nonatomic, strong) CHStaticDemo *textSelectionController;
@property (nonatomic, strong) UIViewController *rightController;

@end
