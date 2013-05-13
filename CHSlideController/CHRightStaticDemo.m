//
//  CHRightStaticDemo.m
//  CHSlideController
//
//  Created by Clemens Hammerl on 21.03.13.
//
//

#import "CHRightStaticDemo.h"

@interface CHRightStaticDemo (private)

-(void)pressedMaximize;
-(void)pressedMaximizeAnimated;

@end

@implementation CHRightStaticDemo

@synthesize delegate;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    maximizeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [maximizeButton setTitle:@"Maximize" forState:UIControlStateNormal];
    [maximizeButton addTarget:self action:@selector(pressedMaximize) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:maximizeButton];
    
    maximizeAnimatedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [maximizeAnimatedButton setTitle:@"Maximize Animated" forState:UIControlStateNormal];
    [maximizeAnimatedButton addTarget:self action:@selector(pressedMaximizeAnimated) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:maximizeAnimatedButton];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat margin = 10;

    maximizeButton.frame = CGRectMake(margin, margin, self.view.bounds.size.width-2*margin, 44);
    maximizeAnimatedButton.frame = CGRectMake(margin, margin+maximizeButton.bounds.size.height+margin, self.view.bounds.size.width-2*margin, 44);

}

-(void)pressedMaximize
{
    if (delegate && [delegate respondsToSelector:@selector(maximize)]) {
        [delegate maximize];
    }
}

-(void)pressedMaximizeAnimated
{
    if (delegate && [delegate respondsToSelector:@selector(maximizeAnimated)]) {
        [delegate maximizeAnimated];
    }
}

@end
