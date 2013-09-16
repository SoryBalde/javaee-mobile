//
//  ChatViewController.h
//  JavaOneTodo
//
//  Created by Ryan Cuprak on 9/12/13.
//  Copyright (c) 2013 Ryan Cuprak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRWebSocket.h"

@interface ChatViewController : UIViewController <SRWebSocketDelegate,UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITextView *inputView;

- (void)reconnect;
@end
