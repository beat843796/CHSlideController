//
//  UIStaticDemo.h
//  CHSlideController
//
//  Created by Clemens Hammerl on 19.10.12.
//  Copyright (c) 2012 appingo mobile e.U. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHStaticDemoDelegate <NSObject>

// method to inform slidecontroller that something has been selected
-(void)staticDemoDidSelectText:(NSString *)text;

@end

@interface CHStaticDemo : UITableViewController
{
    __weak id<CHStaticDemoDelegate> delegate;
}

@property (nonatomic, weak) id<CHStaticDemoDelegate> delegate;
@property (nonatomic, strong) NSArray *data;

@end
