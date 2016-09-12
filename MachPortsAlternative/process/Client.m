//
//  Client.m
//  process
//
//  Created by Matt on 9/12/16.
//  Copyright © 2016 Matt Rajca. All rights reserved.
//

#import "Client.h"

@interface Client () <NSMachPortDelegate>
@end

@implementation Client

- (void)handlePortMessage:(NSPortMessage *)message {
	NSError *error;
	NSDictionary *response = [NSJSONSerialization JSONObjectWithData:message.components[0] options:0 error:&error];

	if (response == nil) {
		NSLog(@"Could not parse response: %@", error);
		return;
	}

	NSLog(@"Response: %@", response);
}

- (void)run {
	NSMachPort *clientPort = (NSMachPort *)[NSMachPort port];
	clientPort.delegate = self;
	[clientPort scheduleInRunLoop:NSRunLoop.currentRunLoop forMode:NSDefaultRunLoopMode];

	// Wait for the server to be available.
	NSMachPort *sendPort = nil;
	while (sendPort == nil) {
		sendPort = (NSMachPort *)[NSMachBootstrapServer.sharedInstance portForName:@"RJKYY38TY2.com.MR.server"];
	}

	NSError *error;
	NSData *data = [NSJSONSerialization dataWithJSONObject:@{
		@"process": @2
	} options:0 error:&error];

	if (data == nil) {
		NSLog(@"Could not form request: %@", error);
		return;
	}

	NSPortMessage *message = [[NSPortMessage alloc] initWithSendPort:sendPort receivePort:clientPort components:@[data]];
	[message sendBeforeDate:NSDate.distantFuture];

	[NSRunLoop.currentRunLoop run];
}

@end
