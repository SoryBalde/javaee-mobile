//
//  TodoClient.h
//  JavaOneTodo
//
//  Created by Ryan Cuprak on 9/8/13.
//  Copyright (c) 2013 Ryan Cuprak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@class ToDoItem;

@class AsyncTaskEvent;

@interface TodoClient : NSObject
{
}

@property (nonatomic, strong) RKObjectManager *objectManager;

@property (nonatomic, strong) NSString *username;

@property (nonatomic, strong) NSString *password;

@property (atomic, strong) ToDoItem *currentToDoItem;

@property (atomic, strong) AsyncTaskEvent* asyncTask;

+ (TodoClient *)sharedClient;
- (void) login: (NSString *) theUsername password: (NSString *) thePassword;
- (void) deleteItem: (ToDoItem *) item asyncTask: (AsyncTaskEvent*) theAsyncTask;
- (void) addItem: (ToDoItem *) item asyncTask: (AsyncTaskEvent*) theAsyncTask;
- (void) updateItem: (ToDoItem *) item asyncTask: (AsyncTaskEvent*) theAsyncTask;
- (void) displayError:(NSError *) error;
+ (NSString *) base64EncodeString: (NSString *) strData;
@end
