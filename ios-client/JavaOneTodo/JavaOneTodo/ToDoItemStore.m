//
//  ToDoItemStore.m
//  JavaOneTodo
//
//  Created by Ryan Cuprak on 8/28/13.
//  Copyright (c) 2013 Ryan Cuprak. All rights reserved.
//

#import "ToDoItemStore.h"
#import "ToDoItem.h"
#import "TodoClient.h"
#import "AsyncTaskEvent.h"

@implementation ToDoItemStore


- (id)init
{
    self = [super init];
    if (self) {
        toDoItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}

/**
 * Enforce usage of the static initializer.
 */
+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedStore];
}

+ (ToDoItemStore *)sharedStore {
    static ToDoItemStore *sharedStore = nil;
    if (!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    
    return sharedStore;
}

- (NSArray *)allItems {
    return toDoItems;
}

- (void)addItem:(ToDoItem *) item asyncTask:(AsyncTaskEvent *) asyncTask {
    [toDoItems addObject:item];
    [[TodoClient sharedClient] addItem:item asyncTask:asyncTask];
}

- (void)updateItem:(ToDoItem *) item asyncTask:(AsyncTaskEvent *) asyncTask {
    [[TodoClient sharedClient] updateItem:item asyncTask:asyncTask];
}

- (void)deleteItem:(ToDoItem *) item asyncTask:(AsyncTaskEvent *) asyncTask {
    [toDoItems removeObject:item];
    [[TodoClient sharedClient] deleteItem:item asyncTask:asyncTask];
}

- (ToDoItem *)itemForIndex:(NSUInteger) index {
    return [toDoItems objectAtIndex:index];
}

- (void)setItems:(NSArray *) items {
    [toDoItems removeAllObjects];
    [toDoItems setArray:items];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"todoUpdate" object:items];
}

@end
