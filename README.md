## CHSlideController
Easy to use ViewController Container that mimics the behaviour of the facebook menu-detail approach. It is super flexible, configurable, animating and it responses to swipe gestures. Working for iPhone and iPad. Uses ARC.


## Usage
- Refer to the **Demo project**.
- Drag and Drop CHSlideController to your project
- Subclass CHSlideController to handle communication between static and sliding controller


Setting up the Controller (Example)

```objc
	// Create static and sliding controller
	_textDisplayController = [[CHSlidingDemo alloc] init];
	_textSelectionController = [[CHStaticDemo alloc] init];

	// connect a button in the sliding view to the default action handler
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_textDisplayController];
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self 		action:@selector(slideButtonPressed:)];

	// Assign the controllers as static and slidingViewController
	// to the CHSlideController     
	self.staticViewController = _textSelectionController;
	self.slidingViewController = nav;
```

Default Action

```objc
	// Moves the sliding view controller in or out depending on the current state
	-(void)slideButtonPressed:(id)sender
```

Create and configure the CHSlideController and add it to your window/view

```objc
    DemoSlideControllerSubclass *slideController = [[DemoSlideControllerSubclass alloc] init];
	slideController.drawShadow = NO;
	slideController.slideViewPaddingRight = 60.0;
	slideController.slideViewPaddingLeft = 30.0;
```

## License
Copyright 2012 Clemens Hammerl

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
 limitations under the License. 

Attribution is appreciated.