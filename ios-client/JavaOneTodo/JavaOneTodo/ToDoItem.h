//
//  ToDoItem.h
//  JavaOneTodo
//
//  Created by Ryan Cuprak on 8/28/13.
//  Copyright (c) 2013 Ryan Cuprak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoItem : NSObject

@property (nonatomic, strong) NSString *myId;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *description;

@property BOOL completed;

-(id) init:(NSString *)description;
-(id) init:(NSString *)theTitle description: (NSString *)theDescription;
-(NSString *) toJSON;

@end
