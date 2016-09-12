//
//  Server.m
//  Service
//
//  Created by Matt on 9/11/16.
//  Copyright © 2016 Matt Rajca. All rights reserved.
//

#import "Server.h"

@interface Server () <NSMachPortDelegate>
@end

@implementation Server

- (void)run {
	NSMachPort *serverPort = (NSMachPort *)[NSMachPort port];
	[serverPort setDelegate:self];
	[serverPort scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[[NSMachBootstrapServer sharedInstance] registerPort:serverPort name:@"RJKYY38TY2.com.MR.server"];

	[[NSRunLoop currentRunLoop] run];
}

- (void)handlePortMessage:(NSPortMessage *)message {
	NSError *error;
	NSDictionary *request = [NSJSONSerialization JSONObjectWithData:message.components[0] options:0 error:&error];

	if (request == nil) {
		NSLog(@"Could not parse the request: %@", error);
		return;
	}

	NSLog(@"Request: %@", request);

	NSDictionary *response = @{
		@"hi": @1
	};
	NSData *responseData = [NSJSONSerialization dataWithJSONObject:response options:0 error:&error];

	if (responseData == nil) {
		NSLog(@"Could not form the response: %@", error);
		return;
	}

	NSPortMessage *reply = [[NSPortMessage alloc] initWithSendPort:message.sendPort receivePort:nil components:@[responseData]];
	[reply sendBeforeDate:[NSDate distantFuture]];
}

@end
