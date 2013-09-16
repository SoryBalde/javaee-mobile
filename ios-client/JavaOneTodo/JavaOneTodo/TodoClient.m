//
//  TodoClient.m
//  JavaOneTodo
//
//  Created by Ryan Cuprak on 9/8/13.
//  Copyright (c) 2013 Ryan Cuprak. All rights reserved.
//

#import "TodoClient.h"
#import "Constants.h"
#import "ToDoItem.h"
#import "ToDoItemStore.h"
#import "AsyncTaskEvent.h"
#import "base64.h"

@implementation TodoClient

@synthesize objectManager;

@synthesize username;

@synthesize password;

@synthesize currentToDoItem;

@synthesize asyncTask;

- (id)init {
    self = [super init];
    if (self) {
        [self initializeReskit];     
    }
    
    return self;
}

-(void) initializeReskit {
    RKLogConfigureByName("RestKit/Network*", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    
    //let AFNetworking manage the activity indicator
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // Initialize HTTPClient
    NSURL *baseURL = [NSURL URLWithString:SERVER_URL_RESTKIT];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    //we want to work with JSON-Data
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    
    self.objectManager = [[RKObjectManager alloc] initWithHTTPClient:client]; 
    RKObjectMapping *todoItemMapping = [RKObjectMapping mappingForClass:[ToDoItem class]];
    [todoItemMapping addAttributeMappingsFromDictionary:@{@"id":@"myId",@"title":@"title",@"description":@"description",@"completed":@"completed"}];
    
    RKRelationshipMapping *relationShipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"todo" toKeyPath:@"todo" withMapping:todoItemMapping];
    [todoItemMapping addPropertyMapping:relationShipMapping];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:todoItemMapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:@"resources/todo/rcuprak"
                                                                                           keyPath:nil
                                                                                       statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
}

/**
 * Enforce usage of the static initializer.
 */
+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedClient];
}

+ (TodoClient *)sharedClient
{
    static TodoClient *sharedClient = nil;
    if (!sharedClient)
        sharedClient = [[super allocWithZone:nil] init];
    
    return sharedClient;
}

- (void) login:(NSString *) theUsername password:(NSString *)thePassword{
    self.username = theUsername;
    self.password = thePassword;
    [objectManager.HTTPClient setAuthorizationHeaderWithUsername:theUsername password:thePassword];
    NSMutableString* path = [NSMutableString stringWithString: @"resources/todo/"];
    [path appendString:username];
    [objectManager getObjectsAtPath:path
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSArray* data = [mappingResult array];
                                [[ToDoItemStore sharedStore] setItems:data];
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"authenticated" object:@"authenticated"];
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                [self displayError: error];
                            }];
   
}

- (void) displayError:(NSError *) error  {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    });
}

- (void) addItem: (ToDoItem *) item asyncTask: (AsyncTaskEvent*) theAsyncTask {
    self.currentToDoItem = item;
    self.asyncTask = theAsyncTask;
    NSMutableString* path = [NSMutableString stringWithString: SERVER_URL];
    [path appendString:username];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setHTTPBody:[item.toJSON dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", [self username], [self password]];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [TodoClient base64EncodeString: authStr]];
    [urlRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"POST"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:queue
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error) {
         [self handleResponse: response error: error data: data];
         
     }];
}

- (void) updateItem: (ToDoItem *) item asyncTask: (AsyncTaskEvent*) theAsyncTask {
    self.currentToDoItem = item;
    self.asyncTask = theAsyncTask;
    NSMutableString* path = [NSMutableString stringWithString: SERVER_URL];
    [path appendString:username];
    [path appendString:@"/"];
    [path appendString:item.myId];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    
    [urlRequest setHTTPBody:[item.toJSON dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", [self username], [self password]];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [TodoClient base64EncodeString: authStr]];
    [urlRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    [urlRequest setHTTPBody:[item.toJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"PUT"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:queue
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error) {
         [self handleResponse: response error: error data: data];
         
     }];
}

- (void) deleteItem: (ToDoItem *) item asyncTask: (AsyncTaskEvent*) theAsyncTask {
    self.currentToDoItem = item;
    self.asyncTask = theAsyncTask;
    NSMutableString* path = [NSMutableString stringWithString: SERVER_URL];
    [path appendString:username];
    [path appendString:@"/"];
    [path appendString:item.myId];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    
    [urlRequest setHTTPBody:[item.toJSON dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", [self username], [self password]];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [TodoClient base64EncodeString: authStr]];
    [urlRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"DELETE"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:queue
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error) {
         [self handleResponse: response error: error data: data];
         
     }];
}

-(void) handleResponse: (NSURLResponse *) response error: (NSError *) error data: (NSData *) data {
    if ([data length] >0  && error == nil) {
        NSString *resp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.currentToDoItem.myId = resp;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.asyncTask invokeSuccess];
        });
    } else if(error == nil){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.asyncTask invokeSuccess];
        });
    } else if (error != nil){
        NSLog(@"Error happened = %@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [self.asyncTask invokeFailure];
        });
    }
}

/*
 This Base64 encoding example originated at:
 http://ios-dev-blog.com/base64-encodingdecoding/
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 http://ios-dev-blog.com/about/
 
 */
static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const short _base64DecodingTable[256] = {
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
	52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
	-2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
	15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
	-2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
	41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};

+ (NSString *) base64EncodeString: (NSString *) strData {
	return [self base64EncodeData: [strData dataUsingEncoding: NSUTF8StringEncoding] ];
}

+ (NSString *) base64EncodeData: (NSData *) objData {
	const unsigned char * objRawData = [objData bytes];
	char * objPointer;
	char * strResult;
    
	// Get the Raw Data length and ensure we actually have data
	int intLength = [objData length];
	if (intLength == 0) return nil;
    
	// Setup the String-based Result placeholder and pointer within that placeholder
	strResult = (char *)calloc(((intLength + 2) / 3) * 4, sizeof(char));
	objPointer = strResult;
    
	// Iterate through everything
	while (intLength > 2) { // keep going until we have less than 24 bits
		*objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
		*objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
		*objPointer++ = _base64EncodingTable[((objRawData[1] & 0x0f) << 2) + (objRawData[2] >> 6)];
		*objPointer++ = _base64EncodingTable[objRawData[2] & 0x3f];
        
		// we just handled 3 octets (24 bits) of data
		objRawData += 3;
		intLength -= 3;
	}
    
	// now deal with the tail end of things
	if (intLength != 0) {
		*objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
		if (intLength > 1) {
			*objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
			*objPointer++ = _base64EncodingTable[(objRawData[1] & 0x0f) << 2];
			*objPointer++ = '=';
		} else {
			*objPointer++ = _base64EncodingTable[(objRawData[0] & 0x03) << 4];
			*objPointer++ = '=';
			*objPointer++ = '=';
		}
	}
    
	// Terminate the string-based result
	*objPointer = '\0';
    
	// Return the results as an NSString object
	return [NSString stringWithCString:strResult encoding:NSASCIIStringEncoding];
}

@end
