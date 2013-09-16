//
//  ToDoItem.m
//  JavaOneTodo
//
//  Created by Ryan Cuprak on 9/3/13.
//  Copyright (c) 2013 Ryan Cuprak. All rights reserved.
//

#import "ToDoItem.h"

@implementation ToDoItem

@synthesize myId;

@synthesize title;

@synthesize description;

@synthesize completed;

-(id) init:(NSString *)theTitle {
    if(self = [super init]) {
        self.title = theTitle;
    }
    return self;
}

-(id) init:(NSString *)theTitle description: (NSString *)theDescription{
    if(self = [super init]) {
        self.title = theTitle;
        self.description = theDescription;
    }
    return self;
}

-(NSString *) toJSON {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if(self.myId != nil) {
        [dict setObject:self.myId forKey: @"id"];
    }
    [dict setObject:self.title forKey: @"title"];
    [dict setObject:self.description forKey: @"description"];
    NSData *data = [NSJSONSerialization
                    dataWithJSONObject:dict options:0 error:nil];
    NSString *result = [[NSString alloc]
                        initWithData:data encoding:NSUTF8StringEncoding];
    return result;
}

@end
