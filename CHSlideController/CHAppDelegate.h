//
//  CHAppDelegate.h
//  CHSlideController
//
//  Created by Clemens Hammerl on 19.10.12.
//  Copyright (c) 2012 appingo mobile e.U. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoSlideControllerSubclass.h"

@interface CHAppDelegate : UIResponder <UIApplicationDelegate, CHSlideControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
