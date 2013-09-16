//
//  ChatMessage.m
//  JavaOneTodo
//
//  Created by Ryan Cuprak on 9/12/13.
//  Copyright (c) 2013 Ryan Cuprak. All rights reserved.
//

#import "ChatMessage.h"

@implementation ChatMessage
@synthesize user;
@synthesize message;
@synthesize timestamp;

-(id) init:(NSDictionary *)json {
    if(self = [super init]) {
        self.message = [json valueForKey:@"message"];
        self.user = [json valueForKey:@"user"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy h:mm:ss a z"];
        self.timestamp = [dateFormatter dateFromString:[json valueForKey:@"timestamp"]];
    }
    return self;
}

-(id) init:(NSString *)theUser message: (NSString *)theMessage fromMe:(BOOL) isFromMe;{
    if(self = [super init]) {
        self.message = theMessage;
        self.user = theUser;
        self.fromMe = isFromMe;
    }
    return self;
}

-(NSString *) toJSON {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:self.user forKey: @"user"];
    [dict setObject:self.message forKey: @"message"];
    NSData *data = [NSJSONSerialization
                    dataWithJSONObject:dict options:0 error:nil];
    NSString *result = [[NSString alloc]
                        initWithData:data encoding:NSUTF8StringEncoding];
    return result;
}

@end
