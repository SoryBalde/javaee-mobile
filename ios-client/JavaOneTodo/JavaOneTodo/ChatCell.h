//
//  ChatCell.h
//  JavaOneTodo
//
//  Created by Ryan Cuprak on 9/12/13.
//  Copyright (c) 2013 Ryan Cuprak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@end
