# iOS [![Build Status](https://travis-ci.org/O2MC/objective-c-tracker.svg?branch=master)](https://travis-ci.org/O2MC/objective-c-tracker) [![codebeat badge](https://codebeat.co/badges/40e1ff86-dd97-45f4-a060-3ffb7df6c664)](https://codebeat.co/projects/github-com-o2mc-objective-c-tracker-master)

This folder contains the iOS [SDK](sdk) and an [example app](app-obj-c/) written in objective-c.

## Configuration

### View tracking

The SDK can automatically track view changes by hooking into `UIViewController`'s `viewDidAppear` and  `viewWillDisappear` methods.

View tracking isn't enabled by default. It can be enabled by defining `O2M_TRACK_VIEWS` as a boolean in `Info.plist` and set it to `YES`.

*note: at the moment it only works for objective-c apps*