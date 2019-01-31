//
//  O2MEvent.h
//  O2MC
//
//  Created by Tim Slot on 19/07/2018.
//  Copyright © 2018 Adversitement. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "O2MUtil.h"

@interface O2MEvent : NSObject

@property (copy, nonatomic)NSString* event;
@property (copy, nonatomic)NSObject* properties;
@property (copy, readonly, nonatomic) NSString* timestamp;

-(instancetype) init :(NSString*) event;
-(instancetype) initWithProperties:(NSString*)event properties:(NSObject*)properties;
-(NSDictionary*) toDict;

@end
