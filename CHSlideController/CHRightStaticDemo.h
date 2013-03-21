//
//  CHRightStaticDemo.h
//  CHSlideController
//
//  Created by Clemens Hammerl on 21.03.13.
//
//

#import <UIKit/UIKit.h>

@protocol CHRightStaticDemoDelegate <NSObject>

-(void)maximizeAnimated;
-(void)maximize;

@end

@interface CHRightStaticDemo : UIViewController
{
    __weak id<CHRightStaticDemoDelegate> delegate;
    
    @private
    UIButton *maximizeButton;
    UIButton *maximizeAnimatedButton;
}

@property (nonatomic, weak) id<CHRightStaticDemoDelegate> delegate;

@end
