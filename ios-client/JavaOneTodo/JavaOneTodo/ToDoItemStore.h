//
//  ToDoItemStore.h
//  JavaOneTodo
//
//  Created by Ryan Cuprak on 9/8/13.
//  Copyright (c) 2013 Ryan Cuprak. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ToDoItem;

@class AsyncTaskEvent;

@interface ToDoItemStore : NSObject
{
    NSMutableArray *toDoItems;
}
+ (ToDoItemStore *)sharedStore;

- (NSArray *)allItems;
- (void)addItem:(ToDoItem *) item asyncTask:(AsyncTaskEvent *) asyncTask;
- (void)deleteItem:(ToDoItem *) item asyncTask:(AsyncTaskEvent *) asyncTask;
- (void)setItems:(NSArray *) items;
- (void)updateItem:(ToDoItem *) item asyncTask:(AsyncTaskEvent *) asyncTask;
- (ToDoItem *)itemForIndex:(NSUInteger) index;

@end


