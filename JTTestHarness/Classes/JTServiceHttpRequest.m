//
//  JTServiceHttpRequest.m
//  JTTestHarness1
//
//  Created by Ben Ford on 5/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "JTServiceHttpRequest.h"
#import "TouchJSON.h"

@implementation JTServiceHttpRequest
- (void) requestFinished
{
   NSDictionary *dict = [TouchJSON parseJson:[self responseString]];
    
    // if json error was detected, call didFail
    // webrequests with server errors respond successfully with error output, but it is not JSON formatted,
    // I'm using this fact to detect server errors
    if( [[dict allKeys] containsObject:@"error"] &&
       self.didFailSelector && 
       ![self isCancelled] && 
       [self.delegate respondsToSelector:self.didFailSelector]  ) {
        
        NSMutableDictionary *newData = [NSMutableDictionary dictionaryWithDictionary:dict];
        [newData setObject:[self responseString] forKey:@"responseString"];
        
        [self.delegate performSelectorOnMainThread:self.didFailSelector withObject:newData waitUntilDone:[NSThread isMainThread]];
        
    } else if (self.didFinishSelector && ![self isCancelled] && [self.delegate respondsToSelector:self.didFinishSelector]) 
    {
		[self.delegate performSelectorOnMainThread:self.didFinishSelector withObject:dict waitUntilDone:[NSThread isMainThread]];		
    }
}

- (void)requestFailed
{
    
}

@end
