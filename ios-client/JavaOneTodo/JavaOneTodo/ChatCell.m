//
//  ChatCell.m
//  JavaOneTodo
//
//  Created by Ryan Cuprak on 9/12/13.
//  Copyright (c) 2013 Ryan Cuprak. All rights reserved.
//

#import "ChatCell.h"

@implementation ChatCell

@synthesize nameLabel = nameLabel;
@synthesize textView = textView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size;
{
    CGSize textViewSize = self.textView.bounds.size;
    CGSize fitTextViewSize = CGSizeMake(textViewSize.width, size.height);
    CGSize sizeThatFitsSize = [self.textView sizeThatFits:fitTextViewSize];
    
    CGSize superSize = [super sizeThatFits:size];
    
    sizeThatFitsSize.height = MAX(superSize.height, sizeThatFitsSize.height);
    sizeThatFitsSize.width = superSize.width;
    
    return sizeThatFitsSize;
}


@end
