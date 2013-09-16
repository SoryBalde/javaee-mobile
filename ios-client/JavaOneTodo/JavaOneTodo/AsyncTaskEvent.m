//
//  AsyncTaskEvent.m
//  JavaOneTodo
//
//  Created by Ryan Cuprak on 8/28/13.
//  Copyright (c) 2013 Ryan Cuprak. All rights reserved.
//

#import "AsyncTaskEvent.h"

@implementation AsyncTaskEvent

-(id) init:(NSObject *)theTarget successSEL: (SEL)theSuccessSEL failureSEL: (SEL) theFailureSelector data: (NSObject *) theData {
    self = [super init];
    if(self) {
        self.target = theTarget;
        successSelector = theSuccessSEL;
        failureSelector = theFailureSelector;
        self.data = theData;
    }
    return self;
}

- (void) invokeSuccess {
    [self.target performSelector:successSelector withObject: self.data];
}

- (void) invokeFailure {
    [self.target performSelector:failureSelector withObject: self.data];
}


@end
