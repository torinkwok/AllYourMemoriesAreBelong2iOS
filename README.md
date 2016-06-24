### What's this?

Question:

> I'd like to test my app functions well in low memory conditions, but it's difficult to test. How can I induce low memory warnings that trigger the [`didReceiveMemoryWarning`](https://developer.apple.com/reference/uikit/uiviewcontroller/1621409-didreceivememorywarning?language=objc) or [`applicationDidReceiveMemoryWarning:`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIApplicationDelegate_Protocol/#//apple_ref/occ/intfm/UIApplicationDelegate/applicationDidReceiveMemoryWarning:) method in my **ViewControllers** or **AppDelegate** when the app is running on the real device, NOT the simulator? Or what are some ways I can test my app under these possible conditions?

> The reason I can't use the simulator is my app uses Game Center and invites don't work on the simulator.

Okay, this tool simulates iOS on-device memory warnings like a hero.