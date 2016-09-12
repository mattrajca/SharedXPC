//
//  main.m
//  process
//
//  Created by Matt on 8/7/16.
//  Copyright © 2016 Matt Rajca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <xpc/xpc.h>

int main(int argc, const char * argv[]) {
	@autoreleasepool {
		xpc_connection_t connection = xpc_connection_create("com.MattRajca.XPCService", NULL);
		xpc_connection_set_event_handler(connection, ^(xpc_object_t object) {
			NSLog(@"Process received event");
		});
		xpc_connection_resume(connection);
		xpc_object_t data = xpc_dictionary_create(NULL, NULL, 0);
		xpc_dictionary_set_uint64(data, "process", 2);
		xpc_object_t result = xpc_connection_send_message_with_reply_sync(connection, data);
		NSLog(@"Obtained result: %ld", (long)xpc_dictionary_get_uint64(result, "hi"));
	}
    return 0;
}
