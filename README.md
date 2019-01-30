# iOS [![Build Status](https://travis-ci.org/O2MC/objective-c-tracker.svg?branch=master)](https://travis-ci.org/O2MC/objective-c-tracker) [![codebeat badge](https://codebeat.co/badges/40e1ff86-dd97-45f4-a060-3ffb7df6c664)](https://codebeat.co/projects/github-com-o2mc-objective-c-tracker-master)

This folder contains the iOS [SDK](sdk) and an [example app](app-obj-c/) written in objective-c.

## Installation

### 1. Obtain and install the SDK

Obtain the source code.

Drag the `O2MTracker.xcodeproj` project in the `sdk` folder to your project as a Framework.

Go to `Build Phases` -> `Link Binary With Libraries`.


Now click on the `+` sign and add the `O2MTracker.framework` to your `Link Binary With Libraries`.


### 2. Initialize the SDK

Open your app's `AppDelegate.m` and add the following header import:

```objective-c
#import <tracker/tracker.h>
```

We recommend initializing the SDK in the `didFinishLaunchingWithOptions` method.

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Be sure to define a separate end point for debug builds and production builds.
    [[O2MC sharedInstance] setEndpoint:@"http://127.0.0.1:5000/events"];
    return YES;
}
```

### 3. Start tracking!

Use the following method from anywhere to start tracking events. Be sure to import the tracker header as well.

```objective-c
[[O2MC sharedInstance] track:@"Hello world!"];
```


## Configuration

### View tracking

The SDK can automatically track view changes by hooking into `UIViewController`'s `viewDidAppear` and  `viewWillDisappear` methods.

View tracking isn't enabled by default. It can be enabled by defining `O2M_TRACK_VIEWS` as a boolean in `Info.plist` and set it to `YES`.

*note: at the moment it only works for objective-c apps*