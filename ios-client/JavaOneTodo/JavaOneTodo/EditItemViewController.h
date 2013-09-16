//
//  EditItemViewController.h
//  JavaOneTodo
//
//  Created by Ryan Cuprak on 9/8/13.
//  Copyright (c) 2013 Ryan Cuprak. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ToDoItem;

@interface EditItemViewController : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *taskTitle;
@property (weak, nonatomic) IBOutlet UITextView *todoText;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *canButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButtonItem;
@property (nonatomic, copy) void (^dismissBlock)(void);

@property (strong, nonatomic) ToDoItem *toDoItem;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)backgroundTouched:(id)sender;
- (IBAction)textFieldReturn:(id)sender;

@end
