CHSlideController
=================

![Pod Version](https://img.shields.io/cocoapods/v/CHSlideController.svg?style=flat)
![Pod License](https://img.shields.io/cocoapods/l/CHSlideController.svg?style=flat)
![Pod Platform](https://img.shields.io/cocoapods/p/CHSlideController.svg?style=flat)

![Alt text](/Screenshots/sc1.jpeg "Screenshot 1")
![Alt text](/Screenshots/sc2.jpeg "Screenshot 2")
![Alt text](/Screenshots/sc3.jpeg "Screenshot 3")

About
---------
Easy to use ViewController Container that mimics the behaviour of the facebook menu-detail approach. It is super flexible, configurable, animating and it responses to swipe gestures. Working for iPhone and iPad. Uses ARC.


Usage
---------
- Refer to the **Demo project**.
- Drag and Drop CHSlideController to your project
- Subclass CHSlideController to handle communication between static and sliding controller


Setting up the Controller (Example)

```objective-c
	// Assign the controllers in CHSlideController subclass
     self.leftStaticViewController = [UIViewController new];
     self.rightStaticViewController = [UIViewController new];
     self.slidingViewController = [UIViewController new];
```

Default Actions

```objective-c
	// Animates the Sliding View in
	-(void)showSlidingViewAnimated:(BOOL)animated;

	// Animated the Sliding View out to the right
	-(void)showLeftStaticView:(BOOL)animated;

	// Animted the Sliding View out to the left
	-(void)showRightStaticView:(BOOL)animated;
```

Create and configure the CHSlideController and add it to your window/view

```objective-c
    DemoSlideControllerSubclass *slideController = [[DemoSlideControllerSubclass alloc] init];
	slideController.drawShadow = NO;
	slideController.allowEdgeSwipingForSlideingView = YES
	slideController.slideViewPaddingRight = 50.0;
	slideController.slideViewPaddingLeft = 50.0;
```
Check out the demo project for more examples of configurations

Cocoapods
-------
CocoaPods are the best way to manage library dependencies in Objective-C projects.
Learn more at http://cocoapods.org

Add this to your podfile to add the CHSlideController to your project:<br /> `pod 'CHSlideController', '~> 1.0'`


What to Expect in Future Updates
-----------

+ More customization options


License
--------
CHSlideController uses the MIT License:

>Copyright (c) 2013, Mainloop LLC

>Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

>The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.