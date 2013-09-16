//
//  AsyncTaskEvent.h
//  JavaOneTodo
//
//  Created by Ryan Cuprak on 8/28/13.
//  Copyright (c) 2013 Ryan Cuprak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsyncTaskEvent : NSObject {
    SEL successSelector;
    SEL failureSelector;
}

@property (strong, atomic) NSObject *target;
@property (strong, atomic) NSObject *data;

- (id) init:(NSObject *)theTarget successSEL: (SEL)theSuccessSEL failureSEL: (SEL) theFailureSelector data: (NSObject *) theData;

- (void) invokeSuccess;

- (void) invokeFailure;


@end
