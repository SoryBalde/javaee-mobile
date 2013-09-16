//
//  ChatViewController.m
//  JavaOneTodo
//
//  Created by Ryan Cuprak on 9/12/13.
//  Copyright (c) 2013 Ryan Cuprak. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatCell.h"
#import "ChatMessage.h"
#import "TodoClient.h"

@interface ChatViewController ()
    
@end

@implementation ChatViewController

SRWebSocket *_webSocket;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messages = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated; {
    [super viewDidAppear:animated];
    [self.inputView becomeFirstResponder];
}

- (void)reconnect {
    _webSocket.delegate = nil;
    [_webSocket close];
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://localhost:8080/javaee-server/chat"]]];
    _webSocket.delegate = self;
    [_webSocket open];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    
    _webSocket.delegate = nil;
    [_webSocket close];
    _webSocket = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reconnect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    return _messages.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath; {
    ChatCell *chatCell = (id)cell;
    ChatMessage *message = [_messages objectAtIndex:indexPath.row];
    chatCell.textView.text = message.message;
    chatCell.nameLabel.text = message.fromMe ? @"Me" : message.user;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    ChatMessage *message = [_messages objectAtIndex:indexPath.row];
    return [self.tableView dequeueReusableCellWithIdentifier:message.fromMe ? @"SentCell" : @"ReceivedCell"];
}

#pragma mark - SocketRocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
   NSData* data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if(error != nil) {
        NSLog(@"Got message!");
    }
    if(!([[dictionary valueForKey:@"user"] isEqualToString: [[TodoClient sharedClient] username]])) {
        ChatMessage *chatMessage  = [[ChatMessage alloc] init: dictionary];
        [self.messages addObject:chatMessage];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView scrollRectToVisible:self.tableView.tableFooterView.frame animated:YES];
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"WebSocket Opened.");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"WebSocket failed %@",error.description);
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                      message:error.description
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"Websocket closed");
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {
    if ([text rangeOfString:@"\n"].location != NSNotFound) {
        NSString *message = [[textView.text stringByReplacingCharactersInRange:range withString:text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        ChatMessage *chatMessage = [[ChatMessage alloc] init: [[TodoClient sharedClient] username] message: message fromMe:YES];
        [_webSocket send:[chatMessage toJSON]];
        [self.messages addObject:chatMessage];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView scrollRectToVisible:self.tableView.tableFooterView.frame animated:YES];
        
        textView.text = @"";
        return NO;
    }
    return YES;
}
@end
