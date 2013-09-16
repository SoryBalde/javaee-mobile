//
//  ToDoItemCell.m
//  JavaOneTodo
//
//  Created by Ryan Cuprak on 8/28/13.
//  Copyright (c) 2013 Ryan Cuprak. All rights reserved.
//

#import "ToDoItemCell.h"
#import "ToDoItemStore.h"
#import "ToDoItem.h"

@implementation ToDoItemCell

@synthesize checkbox;

@synthesize table;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)toggleCheckBox:(UIButton *)sender {
    NSIndexPath *indexPath = [table indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    if (!checkbox) {
        [sender setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
        checkbox = YES;
    }
    
    else if (checkbox) {
        [sender setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        checkbox = NO;
    }
    ToDoItem *item = [[ToDoItemStore sharedStore] itemForIndex:[indexPath item]];
    item.completed = checkbox;
}

- (void) configureCell: (UITableView* ) table title: (NSString *) title selected:(BOOL) selected {
    if (!selected) {
        [self.checkBoxButton setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
        checkbox = YES;
    } else {
        [self.checkBoxButton setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        checkbox = NO;
    }
    self.descriptionLabel.text = title;
}
@end
