//
//  JavaOneViewController.m
//  JavaOneTodo
//
//  Created by Ryan Cuprak on 8/24/13.
//  Copyright (c) 2013 Ryan Cuprak. All rights reserved.
//

#import "LoginViewController.h"
#import "TodoClient.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize username;

@synthesize password;

- (IBAction)login:(UIButton *)sender {
    if(self.username.text.length > 0 && self.password.text.length > 0) {
        [[TodoClient sharedClient] login: self.username.text password: self.password.text];
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invalid Credentials"
                                                          message:@"Username/password required."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(authenticated:)
                                                 name:@"authenticated"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) authenticated: (NSNotification *)note  {
    self.username.text = @"";
    self.password.text = @"";
    [self performSegueWithIdentifier: @"authenticated" sender: self];
}

@end
