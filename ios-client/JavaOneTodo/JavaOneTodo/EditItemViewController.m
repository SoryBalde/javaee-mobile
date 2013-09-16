//
//  EditItemViewController.m
//  JavaOneTodo
//
//  Created by Ryan Cuprak on 8/28/13.
//  Copyright (c) 2013 Ryan Cuprak. All rights reserved.
//

#import "EditItemViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ToDoItem.h"
#import "ToDoItemStore.h"
#import "AsyncTaskEvent.h"

@interface EditItemViewController ()

@end

@implementation EditItemViewController

@synthesize dismissBlock;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.todoText.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.todoText.layer setBorderWidth:2.0];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTable:)
                                                 name:@"addSucceeded"
                                               object:nil];
    if([self toDoItem] != nil) {
        self.taskTitle.text = self.toDoItem.title;
        self.todoText.text = self.toDoItem.description;
        [self.saveButtonItem setTitle:@"Update"];
    } else {
            [self.saveButtonItem setTitle:@"Add"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    self.toDoItem = nil;
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (IBAction)save:(id)sender {
    
    if([self toDoItem] != nil) {
        self.toDoItem.title = [self.taskTitle text];
        self.toDoItem.description = [self.todoText text];
        AsyncTaskEvent *asyncTask = [[AsyncTaskEvent alloc] init:self successSEL:@selector(dismissSaveSuccess:) failureSEL:@selector(dismissSaveFailure:) data:[self toDoItem]];
        [[ToDoItemStore sharedStore] updateItem: [self toDoItem] asyncTask:asyncTask];
    } else {
        ToDoItem *newItem = [[ToDoItem alloc] init: [self.taskTitle text] description: self.todoText.text];
        AsyncTaskEvent *asyncTask = [[AsyncTaskEvent alloc] init:self successSEL:@selector(dismissSaveSuccess:) failureSEL:@selector(dismissSaveFailure:) data:newItem];
        [[ToDoItemStore sharedStore] addItem: newItem asyncTask:asyncTask];
    }
}

- (void) dismissSaveSuccess: (ToDoItem *) todoItem {
    self.toDoItem = nil;
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"todoUpdate" object:todoItem];
}

- (void) dismissSaveFailure: (ToDoItem *) todoItem {
    self.toDoItem = nil;
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];  
}

-(IBAction)backgroundTouched:(id)sender {
    [self.view endEditing:YES];
}

-(IBAction)textFieldReturn:(id)sender {
    [self.view endEditing:YES];
}


@end
