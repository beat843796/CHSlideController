//
//  CHSlideControllerDemo.m
//  CHSlideController
//
//  Created by Clemens Hammerl on 19.10.12.
//  Copyright (c) 2012 appingo mobile e.U. All rights reserved.
//

#import "CHSlidingDemo.h"

@implementation CHSlidingDemo

@synthesize textLabel = _textLabel;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setting up a label to display the selection
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.backgroundColor = [UIColor darkGrayColor];
    _textLabel.textColor = [UIColor lightGrayColor];
    _textLabel.textAlignment = UITextAlignmentCenter;
    _textLabel.text = @"Select Something";
    [self.view addSubview:_textLabel];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _textLabel.frame = self.view.bounds;
}



@end
