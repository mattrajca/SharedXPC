//
//  AppDelegate.m
//  SharedXPC
//
//  Created by Matt on 8/7/16.
//  Copyright © 2016 Matt Rajca. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (nonatomic, weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (NSURL *)_childProcessURL {
	return [[NSBundle mainBundle].executableURL.URLByDeletingLastPathComponent URLByAppendingPathComponent:@"process"];
}

- (void)_connectFromApp {
	xpc_connection_t connection = xpc_connection_create("com.MattRajca.XPCService", NULL);
	xpc_connection_set_event_handler(connection, ^(xpc_object_t object) {
		NSLog(@"Host received event");
	});
	xpc_connection_resume(connection);
	xpc_object_t data = xpc_dictionary_create(NULL, NULL, 0);
	xpc_dictionary_set_uint64(data, "process", 1);
	xpc_connection_send_message_with_reply(connection, data, dispatch_get_main_queue(), ^(xpc_object_t  _Nonnull object) {
		NSLog(@"%ld", (long)xpc_dictionary_get_uint64(object, "hi"));
	});
}

- (void)_launchProcess {
	NSTask *task = [[NSTask alloc] init];
	task.launchPath = self._childProcessURL.path;
	[task launch];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[self _connectFromApp];
	[self _launchProcess];
}

@end
