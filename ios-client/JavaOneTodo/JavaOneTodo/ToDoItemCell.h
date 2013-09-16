//
//  ToDoItemCell.h
//  JavaOneTodo
//
//  Created by Ryan Cuprak on 9/8/13.
//  Copyright (c) 2013 Ryan Cuprak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToDoItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *checkBoxButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) UITableView *table;
@property BOOL checkbox;

- (IBAction)toggleCheckBox:(UIButton *)sender;

- (void) configureCell: (UITableView* ) table title: (NSString *) title selected:(BOOL) selected;


@end
