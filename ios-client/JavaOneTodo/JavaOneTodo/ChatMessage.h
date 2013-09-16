//
//  ChatMessage.h
//  JavaOneTodo
//
//  Created by Ryan Cuprak on 9/12/13.
//  Copyright (c) 2013 Ryan Cuprak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatMessage : NSObject

@property (nonatomic,strong) NSString *user;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSDate *timestamp;
@property (nonatomic) BOOL fromMe;

-(id) init:(NSDictionary *)json;
-(id) init:(NSString *)theUser message: (NSString *)theMessage fromMe:(BOOL) isFromMe;
-(NSString *) toJSON;

@end
