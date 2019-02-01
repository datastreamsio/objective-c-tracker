# Objective-C tracker SDK [![Build Status](https://travis-ci.org/O2MC/objective-c-tracker.svg?branch=master)](https://travis-ci.org/O2MC/objective-c-tracker) [![codebeat badge](https://codebeat.co/badges/40e1ff86-dd97-45f4-a060-3ffb7df6c664)](https://codebeat.co/projects/github-com-o2mc-objective-c-tracker-master)

O2MC's mobile tracking SDK for collecting and measuring analytical events.

## Getting started

These instructions will get you up and running on your local machine. There is an [example app](app-obj-c/) available for local testing.

### Prerequisites

The following tools are required.

* XCode 9+
* iOS 9+

## Installation

### 1. Obtain and install the SDK

Obtain the source code.

Drag the `O2MTracker.xcodeproj` project in the `sdk` folder to your project as a Framework.

Go to `Build Phases` -> `Link Binary With Libraries`.


Now click on the `+` sign and add the `O2MTracker.framework` to your `Link Binary With Libraries`.


### 2. Initialize the SDK

Open your app's `AppDelegate.m` and add the following header import:

```objective-c
#import <O2MTracker/O2MTracker.h>
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

Events can also contain values. Use any of the following methods when tracking additional event data.

```objective-c
// Dictionary values
[[O2MC sharedInstance] trackWithProperties:@{@"Hello": @"World", @"LuckyNumber": @7} eventName:@"trackWithDict"];

// Booleans
[[O2MC sharedInstance] trackWithBool:YES eventName:@"trackWithBool"];

// Any type of number from NSNumber
[[O2MC sharedInstance] trackWithNumber:[[NSNumber alloc] initWithInt:12345] eventName:@"trackWithNumber"];

// And of course a string!
[[O2MC sharedInstance] trackWithString:@"stringValue" eventName:@"trackWithString"];
```
## Configuration

This is how you'd initialize the O2MC tracking SDK:

```objective-c
[[O2MC sharedInstance] setEndpoint:@"<endpoint>"];
```

*Please consider defining the development or production URL based on the build configuration.*

Refer to the [API documentation](API.md) for more details on how to use and configure the SDK.

## License

[MIT license](LICENSE).

Copyright (c) Insite Innovations and Properties B.V.