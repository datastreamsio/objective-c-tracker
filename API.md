# SDK API

This document describes the SDK's API methods.

## Configuration and initialization

This is how you'd initialize the O2MC tracking SDK:

`[[O2MC sharedInstance] setEndpoint:@"<endpoint>"];`

Please consider defining the development or production URL based on the build configuration.

### setDispatchInterval

```objective-c
/**
 * Configures the dispatch interval in seconds.
 * Defining a lower interval results in more realtime and lower chance of
 * data loss. On the other hand a lower interval will result in more data
 * usage and resource usage from the end user's device.
 * @param dispatchInterval interval of sending data to the server (defaults to 10)
 */
-(void) setDispatchInterval:(nonnull NSNumber*)dispatchInterval;
```

> Invoke method by executing the following statement

`[[O2MC sharedInstance] setDispatchInterval:<#(NSInteger)#>]`

### getEndpoint

```objective-c
/**
 * Returns configured endpoint.
 * @return endpoint
 */
-(nonnull NSString*) getEndpoint;
```

> Invoke method by executing the following statement

`[[O2MC sharedInstance] getEndpoint]`

### setMaxRetries

```objective-c
/**
 * The max amount of connection retries before stopping dispatching.
 * @param maxRetries retry amount (defaults to 5)
 */
-(void) setMaxRetries:(NSInteger)maxRetries;
```

> Invoke method by executing the following statement

`[[O2MC sharedInstance] setMaxRetries:<#(NSInteger)#>]`

## Tracking configuration

### setIdentifier

```objective-c
/**
 * Sets an identifier for a user. This identifier will be sent along the tracked events.
 * This could be useful to correlate various batches with each other.
 *
 * @param uniqueIdentifier unique string which identifies a user.
 */
-(void)setIdentifier:(nullable NSString*) uniqueIdentifier;
```

> Invoke method by executing the following statement

`[[O2MC sharedInstance] setIdentifier:@"john-doe"]`

### setSessionIdentifier

```objective-c
/**
 * Sets a random session identifier to identify a user.
 * The identifier is based on a UUID.
 */
-(void)setSessionIdentifier;
```

> Invoke method by executing the following statement

`[[O2MC sharedInstance] setSessionIdentifier]`

### View tracking

The SDK can automatically track view changes by hooking into `UIViewController`'s `viewDidAppear` and  `viewWillDisappear` methods.

View tracking isn't enabled by default. It can be enabled by defining `O2M_TRACK_VIEWS` as a boolean in `Info.plist` and set it to `YES`.

*note: at the moment view tracking only works with objective-c code bases*

## Control methods

### stop

```objective-c
/**
 * Stops tracking of events.
 */
-(void) stop;
```

> Invoke method by executing the following statement

`[[O2MC sharedInstance] stop]`

Optionally the stop method also accepts a BOOL. If true, the currently queued events will be removed.

```objective-c
/**
 * Stops tracking of events.
 * @param clearFunnel clears any existing events
 */
-(void) stop:(BOOL)clearFunnel;
```

> Invoke method by executing the following statement

`[[O2MC sharedInstance] stop:YES]`

### resume

```objective-c
/**
 * Resumes tracking when stopped.
 */
-(void) resume;
```

> Invoke method by executing the following statement

`[[O2MC sharedInstance] stop:YES]`

## Tracking methods

### track

```objective-c
/**
 * Tracks an event.
 * Essentially adds a new event with the String parameter as name to be dispatched on the next dispatch interval.
 * @param eventName name of tracked event
 */
-(void)track:(nonnull NSString*)eventName;
```

> Invoke method by executing the following statement

`[[O2MC sharedInstance] track:@"<eventname>"];`

### trackWithProperties

```objective-c
/**
 * Tracks an event with additional data.
 * Essentially adds a new event with the String parameter as name and any additional properties.
 * @param properties anything you'd like to keep track of
 * @param eventName name of tracked event
 */
-(void)trackWithProperties:(nonnull NSDictionary*)properties eventName:(nonnull NSString*)eventName;
```

> Invoke method by executing the following statement

`[[O2MC sharedInstance] trackWithProperties:@"<eventname>" properties:@{@"<prop1>": @1, @"<prop2>": @2}];`

