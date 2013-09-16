//
//  ToDoListControllerViewController.h
//  JavaOneTodo
//
//  Created by Ryan Cuprak on 8/28/13.
//  Copyright (c) 2013 Ryan Cuprak. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ToDoItem;

@interface ToDoViewController : UIViewController <UITableViewDataSource , UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteBtn;
@property (weak, nonatomic) IBOutlet UITableView *toDoTable;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (nonatomic) BOOL addToDoItem;


- (IBAction)addItem:(UIBarButtonItem *)sender;

- (IBAction)deleteItem:(UIBarButtonItem *)sender;

- (void) dismissSaveSuccess: (ToDoItem *) todoItem;

- (void) dismissSaveFailure: (ToDoItem *) todoItem;

@end
