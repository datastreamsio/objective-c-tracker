//
//  O2MC.m
//  O2MC
//
//  Created by Nicky Romeijn on 09-08-16.
//  Copyright © 2016 Adversitement. All rights reserved.
//
#import "O2MC.h"

#import "O2MBatchManager.h"
#import "O2MConfig.h"
#import "O2MEventManager.h"
#import "Models/O2MEvent.h"
#import "O2MLogger.h"
#import "O2MUtil.h"

@interface O2MC()

// Managers
@property O2MBatchManager *batchManager;
@property O2MEventManager *eventManager;

// Misc
@property NSTimer * batchCreateTimer;
@property O2MLogger *logger;
@property dispatch_queue_t tagQueue;

@end

@implementation O2MC

#pragma mark - Constructors / initializer methods

+(nonnull instancetype) sharedInstance; {
    static O2MC *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[O2MC alloc] init];
    });

    return sharedInstance;
}

/**
 * Constructs the tracking SDK. NOTE: be sure to set an endpoint.
 * @return an O2MC instance
 */
-(nonnull instancetype) init; {
    self = [self initWithDispatchInterval:O2MConfig.dispatchInterval endpoint:O2MConfig.httpEndpoint];
    return self;
}

/**
 * Constructs the tracking SDK.
 * @param dispatchInterval time in seconds between dispatches
 * @param endpoint http(s) URL which should be publicly reachable
 * @return an O2MC instance
 */
-(nonnull instancetype) initWithDispatchInterval:(nonnull NSNumber *)dispatchInterval endpoint:(nonnull NSString *)endpoint; {
     if (self = [super init]) {
         _batchManager = [[O2MBatchManager alloc] init];
         _eventManager = [[O2MEventManager alloc] init];
         _logger = [[O2MLogger alloc] initWithTopic:"tagger"];

         _tagQueue = dispatch_queue_create("io.o2mc.sdk", DISPATCH_QUEUE_SERIAL);

         [self->_batchManager setEndpoint:endpoint];
         [self setDispatchInterval:dispatchInterval];
         [self batchWithInterval:O2MConfig.batchInterval];

         // Default setting
         [self setMaxRetries:O2MConfig.maxRetries];
     }
     return self;
}

#pragma mark - Internal methods

-(void) batchWithInterval :(NSNumber *) dispatchInterval; {
    if (self->_batchCreateTimer) {
        [self->_batchCreateTimer invalidate];
        self->_batchCreateTimer = nil;
    }
    self->_batchCreateTimer = [NSTimer timerWithTimeInterval:[dispatchInterval floatValue] target:self selector:@selector(createBatch:) userInfo:nil repeats:YES];

    // Start the dispatch timer
    [NSRunLoop.mainRunLoop addTimer:self->_batchCreateTimer forMode:NSRunLoopCommonModes];
}

-(void) createBatch:(NSTimer *)timer;{
    dispatch_async(_tagQueue, ^{
        // Check if there are any events to batch
        if(self->_eventManager.eventCount == 0) return;

        // Collect events from the event manager and push them to the batchmanager.
        // We copy the events to a new array since the events would be emptied by ARC before they
        // could be added to a batch.
        [self->_batchManager createBatchWithEvents:[[NSArray alloc] initWithArray:self->_eventManager.events]];
        [self->_eventManager clearEvents];
    });
}

-(void) clearFunnel; {
    dispatch_async(_tagQueue, ^{
        [self->_eventManager clearEvents];
        [self->_logger logD:@"clearing the funnel"];
    });
}

-(void)stopTimer; {
    if(self->_batchCreateTimer) {
        [self->_batchCreateTimer invalidate];
        self->_batchCreateTimer = nil;
    }
}

#pragma mark - Configuration methods

-(nonnull NSString*) getEndpoint; {
    return self->_batchManager.endpoint;
}

-(void) setEndpoint:(nonnull NSString *)endpoint; {
    [self->_batchManager setEndpoint:endpoint];
}

-(void) setDispatchInterval:(nonnull NSNumber*)dispatchInterval; {
    O2MConfig.dispatchInterval = dispatchInterval;
    [self->_batchManager dispatchWithInterval:dispatchInterval];
}

-(void) setMaxRetries :(NSInteger)maxRetries; {
    [_batchManager setMaxRetries: maxRetries];
}

#pragma mark - Control methods

-(void) stop; {
    [self stop:YES];
}

-(void) stop:(BOOL)clearFunnel; {
    [self->_logger logI:@"stopping tracking"];
    [self->_batchManager stop];
    [self stopTimer];
    
    if (clearFunnel == NO) return;
    
    [self clearFunnel];
}

-(void) resume; {
    if(![[self batchCreateTimer] isValid]) {
        [self batchWithInterval:O2MConfig.batchInterval];
    }

    if(![self->_batchManager isDispatching]) {
        [self->_batchManager dispatchWithInterval:O2MConfig.dispatchInterval];
    }
}

#pragma mark - Internal tracking methods
-(void)addEventToBatchWithProperties:(NSObject*)properties eventName:(NSString*)eventName; {
    dispatch_async(_tagQueue, ^{
        if (![self->_batchManager isDispatching]) return;
        [self->_logger logD:@"Track %@:%@", eventName, properties];

        [self->_eventManager addEvent: [[O2MEvent alloc] initWithProperties:eventName
                                                                 properties:properties]];
    });
}

-(void)addEventToBatch:(NSString*)eventName; {
    dispatch_async(_tagQueue, ^{
        if (![self->_batchManager isDispatching]) return;
        [self->_logger logD:@"Track %@", eventName];

        [self->_eventManager addEvent: [[O2MEvent alloc] init:eventName]];
    });
}

#pragma mark - Tracking methods

-(void)setIdentifier:(nullable NSString*) uniqueIdentifier; {
    [self->_batchManager setSessionIdentifier:uniqueIdentifier];
}

-(void)setSessionIdentifier; {
    [self->_batchManager setSessionIdentifier:[[NSUUID UUID] UUIDString]];
}

-(void)track:(NSString*)eventName; {
    [self addEventToBatch:eventName];
}

-(void)trackWithProperties:(NSObject*)properties eventName:(NSString*)eventName;
{
    [self addEventToBatchWithProperties:properties eventName:eventName];
}

-(void)trackWithBool:(BOOL)eventValue eventName:(nonnull NSString*)eventName; {
    // Convert BOOL with NSNumber since we only want objects when serializing.
    [self addEventToBatchWithProperties:[[NSNumber alloc] initWithBool:eventValue] eventName:eventName];
}
-(void)trackWithString:(nonnull NSString*)eventValue eventName:(nonnull NSString*)eventName; {
    [self addEventToBatchWithProperties:eventValue eventName:eventName];
}

-(void)trackWithNumber:(nonnull NSNumber*)eventValue eventName:(nonnull NSString*)eventName; {
    [self addEventToBatchWithProperties:eventValue eventName:eventName];
}
@end

