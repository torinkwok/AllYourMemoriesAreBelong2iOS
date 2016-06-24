### What's this

A frequently asked question on StackOverflow.net:

> I'd like to test my app functions well in low memory conditions, but it's difficult to test. How can I induce low memory warnings that trigger the [`didReceiveMemoryWarning`](https://developer.apple.com/reference/uikit/uiviewcontroller/1621409-didreceivememorywarning?language=objc) or [`applicationDidReceiveMemoryWarning:`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIApplicationDelegate_Protocol/#//apple_ref/occ/intfm/UIApplicationDelegate/applicationDidReceiveMemoryWarning:) method in my **ViewControllers** or **AppDelegate** when the app is running on the real device, NOT the simulator? Or what are some ways I can test my app under these possible conditions?

> The reason I can't use the simulator is my app uses Game Center and invites don't work on the simulator.

Okay, this tool simulates iOS on-device memory warnings like a hero.

### Features

* It induces memory warnings through pressing the physical **volume button** on iOS devices

* It works *transparently*. In other words, to use *AllYourMemoriesAreBelong2iOS*, you need just linking this framework into your app and hit the `Run` button to build and then run the **Debug** scheme. You will never be asked to configure anything and the debug codes in this framework will never be shipped in releasing version

* It supports hot-swapability for [KVOController](https://github.com/facebook/KVOController) from Facebook. In other words, if your app has linked *KVOController.framework*, the internal mechanism of *AllYourMemoriesAreBelong2iOS* would take advantage of it, otherwise the raw KVO API would be applied instead

### How to use

1. Clone and incorporate this repo into your project with `git submodule`:
	
	`git submodule add https://github.com/TorinKwok/AllYourMemoriesAreBelong2iOS.git ${YOUR_DIR} --recursive`

2. Hit `File` -> `Add Files to "${YOUR_PROJECT_NAME}"` item in Xcode menu bar, then choose the `AllYourMemoriesAreBelong2iOS.xcodeproj`

3. Link *AllYourMemoriesAreBelong2iOS* in `General` panel

4. Make sure build and run your project in **Debug** scheme. *AllYourMemoriesAreBelong2iOS* includes the invocation of Apple private API, its implementation was masked in releasing version as it will be rejected by Apple

5. Press physical volume button on your iOS devices to induce the system memory warnings. You will want to process those notifications in [`didReceiveMemoryWarning`](https://developer.apple.com/reference/uikit/uiviewcontroller/1621409-didreceivememorywarning?language=objc) or [`applicationDidReceiveMemoryWarning:`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIApplicationDelegate_Protocol/#//apple_ref/occ/intfm/UIApplicationDelegate/applicationDidReceiveMemoryWarning:) method in the **ViewControllers** or **AppDelegate**

### Author

Torin Kwok.

### Contact me

* Email: `dG9yaW5Aa3dvay5pbQ==` (base64ed)
* OpenPGP/GnuGPG: [fetch pub key](https://keybase.io/kwok)
* GitHub: [@TorinKwok](https://github.com/TorinKwok)

### License

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">AllYourMemoriesAreBelong2iOS</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="https://keybase.io/kwok" property="cc:attributionName" rel="cc:attributionURL">Torin Kwok</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.
