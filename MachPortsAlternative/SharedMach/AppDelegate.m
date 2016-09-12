//
//  AppDelegate.m
//  SharedMach
//
//  Created by Matt on 8/7/16.
//  Copyright © 2016 Matt Rajca. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () <NSMachPortDelegate>
@property (nonatomic, weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (NSURL *)_childProcessURL {
	return [NSBundle.mainBundle.executableURL.URLByDeletingLastPathComponent URLByAppendingPathComponent:@"process"];
}

- (NSURL *)_serviceURL {
	return [NSBundle.mainBundle.executableURL.URLByDeletingLastPathComponent URLByAppendingPathComponent:@"Service"];
}

- (void)_launchProcess {
	NSTask *task = [[NSTask alloc] init];
	task.launchPath = self._childProcessURL.path;
	[task launch];
}

- (void)_connectFromApp {
	NSTask *task = [[NSTask alloc] init];
	task.launchPath = self._serviceURL.path;
	[task launch];

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
		@"process": @1
	} options:0 error:&error];

	if (data == nil) {
		NSLog(@"Could not form request: %@", error);
		return;
	}

	NSPortMessage *message = [[NSPortMessage alloc] initWithSendPort:sendPort receivePort:clientPort components:@[data]];
	[message sendBeforeDate:NSDate.distantFuture];
}

- (void)handlePortMessage:(NSPortMessage *)message {
	NSError *error;
	NSDictionary *response = [NSJSONSerialization JSONObjectWithData:message.components[0] options:0 error:&error];

	if (response == nil) {
		NSLog(@"Could not parse response: %@", error);
		return;
	}
	
	NSLog(@"Response: %@", response);
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[self _connectFromApp];
	[self _launchProcess];
}

@end
