//
//  CHRightStaticDemo.m
//  CHSlideController
//
//  Created by Clemens Hammerl on 21.03.13.
//
//

#import "CHRightStaticDemo.h"

@implementation CHRightStaticDemo

-(void)viewDidLoad
{
    [super viewDidLoad];
    
   
    
    demoLabel = [[UILabel alloc] init];
    demoLabel.text = @"DEMO\nRight Static ViewController";
    demoLabel.font = [UIFont boldSystemFontOfSize:16];
    demoLabel.numberOfLines = 2;
    demoLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:demoLabel];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    demoLabel.frame = self.view.bounds;
}

@end
