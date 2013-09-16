//
//  JavaOneViewController.h
//  JavaOneTodo
//
//  Created by Ryan Cuprak on 8/24/13.
//  Copyright (c) 2013 Ryan Cuprak. All rights reserved.
//

#import <UIKit/UIKit.h>

         

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

- (void) authenticated: (NSNotification *)note;

@end