//
//  ToDoListControllerViewController.m
//  JavaOneTodo
//
//  Created by Ryan Cuprak on 8/28/13.
//  Copyright (c) 2013 Ryan Cuprak. All rights reserved.
//

#import "ToDoViewController.h"
#import "ToDoItemStore.h"
#import "ToDoItem.h"
#import "ToDoItemCell.h"
#import "EditItemViewController.h"
#import "AsyncTaskEvent.h"

@interface ToDoViewController ()

@end

@implementation ToDoViewController

@synthesize addToDoItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // optional
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Load the NIB file
    UINib *nib = [UINib nibWithNibName:@"ToDoItemCell" bundle:nil];
    [self.toDoTable registerNib:nib forCellReuseIdentifier:@"ToDoItemCell"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTable:)
                                                 name:@"todoUpdate"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [[[ToDoItemStore sharedStore] allItems] count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ToDoItem *item = [[[ToDoItemStore sharedStore] allItems]
                   objectAtIndex:[indexPath row]];
    ToDoItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToDoItemCell"];
    [cell configureCell: tableView title: item.title selected: item.completed];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        ToDoItem *item = [[ToDoItemStore sharedStore] itemForIndex:[indexPath item]];
        [[ToDoItemStore sharedStore] itemForIndex:[indexPath item]];
        AsyncTaskEvent *asyncTask = [[AsyncTaskEvent alloc] init:self successSEL:@selector(dismissSaveSuccess:) failureSEL:@selector(dismissSaveFailure:) data:item];
        [[ToDoItemStore sharedStore] deleteItem:item asyncTask:asyncTask];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void) dismissSaveSuccess: (ToDoItem *) todoItem {
    // do nothing
}

- (void) dismissSaveFailure: (ToDoItem *) todoItem {
    // do nothing 
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier: @"edit" sender: self];
    
    if(self.toDoTable.editing) {
        [self.toDoTable setEditing:NO animated:YES];
        [self.deleteBtn setTitle:@"Edit"];
    }
}

- (IBAction)addItem:(UIBarButtonItem *)sender {
    self.addToDoItem = YES;
    [self performSegueWithIdentifier: @"edit" sender: self];
    if(self.toDoTable.editing) {
        [self.toDoTable setEditing:NO animated:YES];
        [self.deleteBtn setTitle:@"Edit"];
    }
}

- (IBAction) deleteItem:(UIBarButtonItem *)sender
{
    if(self.toDoTable.editing) {
        [self.toDoTable setEditing:NO animated:YES];
        [sender setTitle:@"Delete"];
    } else {
        [self.toDoTable setEditing:YES animated:YES];
        [sender setTitle:@"Done"];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"edit"] && self.addToDoItem == NO){
        EditItemViewController *controller = (EditItemViewController *)segue.destinationViewController;
        NSIndexPath *path = [self.toDoTable indexPathForSelectedRow];
        NSUInteger lastIndex = [path indexAtPosition:[path length] - 1];
        ToDoItem *item = [[ToDoItemStore sharedStore] itemForIndex:lastIndex];
        [controller setToDoItem: item];
    }
    self.addToDoItem = NO;
}

- (void) refreshTable:(NSNotification *)note {
    [self.toDoTable reloadData];
}

@end
