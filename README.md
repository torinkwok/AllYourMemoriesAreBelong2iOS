### Broken English?

[Yep](https://en.wikipedia.org/wiki/All_your_base_are_belong_to_us).

### What's this?

A kind of questions frequently asked on StackOverflow:

> I'd like to test my app functions well in low memory conditions, but it's difficult to test. How can I induce low memory warnings that trigger the [`didReceiveMemoryWarning`](https://developer.apple.com/reference/uikit/uiviewcontroller/1621409-didreceivememorywarning?language=objc) or [`applicationDidReceiveMemoryWarning:`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIApplicationDelegate_Protocol/#//apple_ref/occ/intfm/UIApplicationDelegate/applicationDidReceiveMemoryWarning:) method in my **ViewControllers** or **AppDelegate** when the app is running on the real device, NOT the simulator? Or what are some ways I can test my app under these possible conditions?

> The reason I can't use the simulator is my app uses Game Center and invites don't work on the simulator.

Well, *AllYourMemoriesAreBelong2iOS* is an elegant solution. With using it, it became incredibly easy to simulate iOS on-device memory warnings.

![pod-validablity-badge](https://cocoapod-badges.herokuapp.com/v/AllYourMemoriesAreBelong2iOS/badge.png)
![version-badge](https://cocoapod-badges.herokuapp.com/p/AllYourMemoriesAreBelong2iOS/badge.png)
![license-badge](https://cocoapod-badges.herokuapp.com/l/AllYourMemoriesAreBelong2iOS/badge.svg)

### Features

* Induces memory warnings through simply pressing the physical **volume buttons** on iOS devices (like a hero)

* Works *transparently*. To use *AllYourMemoriesAreBelong2iOS*, all you have to do is just to link this framework to your app and hit the `Run` button to build/run the **Debug** scheme. You would never be bothered configuring anything. Also, the debug codes within this framework would never be shipped in releasing version

* Supports hot-swapability for [*facebook/KVOController*](https://github.com/facebook/KVOController). That is to say, once your app has linked to *KVOController.framework*, the internal mechanism of *AllYourMemoriesAreBelong2iOS* would take advantage of it automatically, otherwise the raw KVO API will be choosen instead

### Installation

#### CocoaPods

To install using [*CocoaPods*](https://github.com/cocoapods/cocoapods), add the following to your project Podfile:

```
pod 'AllYourMemoriesAreBelong2iOS', '~>1.0.2'
```

#### Git Submodule

1. Clone and incorporate this repo into your project with `git submodule` command:
	
	`git submodule add https://github.com/TorinKwok/AllYourMemoriesAreBelong2iOS.git ${YOUR_DIR} --recursive`

2. Click `File` -> `Add Files to "${YOUR_PROJECT_NAME}"` item in Xcode menu bar. Choose the `AllYourMemoriesAreBelong2iOS.xcodeproj`

3. Embed *AllYourMemoriesAreBelong2iOS* in `General` panel

### Usage

1. Make sure that your project is being built with the **Debug** scheme. Keep in mind that *AllYourMemoriesAreBelong2iOS* is impossible without invocations to Apple private APIs, hence its all internal implementation was masked in releasing version since, if not so, there's a distinct possibility that your app would be rejected by iTunes Connect reviewers

2. Press physical volume buttons on your iOS devices to induce the system memory warnings. You will want to process those notifications in [`didReceiveMemoryWarning`](https://developer.apple.com/reference/uikit/uiviewcontroller/1621409-didreceivememorywarning?language=objc) or [`applicationDidReceiveMemoryWarning:`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIApplicationDelegate_Protocol/#//apple_ref/occ/intfm/UIApplicationDelegate/applicationDidReceiveMemoryWarning:) method in the **ViewControllers** or **AppDelegate**

### Author

Torin Kwok.

### Contact me

* Email: `dG9yaW5Aa3dvay5pbQ==` (base64ed)
* OpenPGP/GnuPG: [fetch pub key](https://keybase.io/kwok)
* GitHub: [@TorinKwok](https://github.com/TorinKwok)

### License

[MIT](./LICENSE).
